# Research: Markdown completion popup in Neovim 0.12.2

## Summary

The popup labeled **Text [Buffer]** / **[LSP]** is **blink.cmp**, not Neovim 0.12 native `vim.lsp.completion` and not `'autocomplete'`. The existing `enabled` guard only checks `filetype == "markdown"`, but **vimwiki** (from `extras.lua`) sets most `.md` buffers to **`filetype=vimwiki`**, so blink stays active. On true `markdown` buffers blink is already off; marksman LSP may still attach there, but native LSP autocompletion is not enabled anywhere in this config.

## Root cause

### 1. Popup source is blink.cmp (not native LSP completion)

| Candidate | Verdict | Evidence |
|-----------|---------|----------|
| **blink.cmp** | **Yes — primary source** | Menu labels match blink config: kind `Text` from buffer source + `source_name` column rendering `[Buffer]` / `[LSP]` in `blink.lua`. Buffer source sets `kind = CompletionItemKind.Text` ([blink buffer source](file:///Users/shoe/.local/share/nvim/lazy/blink.cmp/lua/blink/cmp/sources/buffer/init.lua)). |
| **vim.lsp.completion** | **No** | Neovim requires explicit `vim.lsp.completion.enable(..., { autotrigger = true })` on `LspAttach` (`:help lsp-attach`, `:help vim.lsp.completion.enable()`). Not present in `lsp.lua` or elsewhere in dotfiles. LSP attach only sets `omnifunc` via `vim.lsp._set_defaults()` (`:help lsp-faq`). |
| **'autocomplete' (ins-autocompletion)** | **No in repo config** | `'autocomplete'` defaults off (`:help 'autocomplete'`). Not set in `opts.lua`. Verified in loaded config: `autocomplete=false`. |
| **marksman alone** | **Partial** | marksman provides completion when attached, but only surfaces automatically through blink (here) or explicit native LSP completion enable. Trigger chars are `[`, `#`, `(` — not newline (`:help lsp-autocompletion`). |

### 2. Why blink disable for `markdown` does not apply

`blink.lua` disables only the exact filetype `markdown`:

```11:13:nvim/.config/nvim/lua/plugins/blink.lua
			enabled = function()
				return vim.bo.filetype ~= "markdown"
			end,
```

**vimwiki** is loaded in `extras.lua` and rewrites `.md` buffers to **`vimwiki`** filetype:

- Opening `/Users/shoe/dotfiles/README.md` → `filetype=vimwiki`, `blink_enabled=true`, `lsp_clients=0`
- Opening `/tmp/foo.md` → same (`vimwiki`, blink on)
- Forcing `filetype=markdown` → `blink_enabled=false` (guard works)

So the user’s “markdown buffers” are often **`vimwiki` buffers** where blink is still enabled. blink docs recommend either broadening `enabled` or setting `vim.b.completion = false` per buffer/filetype (`blink.cmp:docs` recipes — disable per filetype/buffer).

### 3. Why it appears around newlines

With blink active on vimwiki buffers:

- blink **blocks** `\n` as a trigger character by default (`completion.trigger.show_on_blocked_trigger_characters = { ' ', '\n', '\t' }` — blink.cmp:docs configuration/completion.md). A bare Enter should not open the menu from a trigger char.
- After Enter, **vimwiki** runs list continuation via `VimwikiReturn` (insert `<CR>` mapping in `vimwiki.vim` ftplugin). vimwiki explicitly checks `pumvisible()` to avoid breaking completion (#813).
- blink **`show_on_keyword = true`** (default) re-opens the menu when the next character on the new line is keyword-like (letters, `-`, `_`).
- Buffer source then offers prior words as **Text [Buffer]**; if marksman were attached on a true `markdown` buffer, **[LSP]** items would appear too.

Net: “popup on every newline” is the combined effect of **blink still enabled (vimwiki filetype)** + **list/paragraph editing on Enter** + **keyword-triggered menu auto_show** — not a failure of the markdown-only disable rule itself.

### 4. marksman role

```95:97:nvim/.config/nvim/lua/plugins/lsp.lua
				marksman = {
					filetypes = { "markdown" },
				},
```

marksman attaches only to `markdown`, not `vimwiki`. On typical vimwiki `.md` files, marksman does not run; popups are buffer-only from blink. On rare `markdown` buffers (non-wiki paths or forced filetype), marksman can attach and contribute LSP items **through blink in other filetypes** or via omnifunc if native completion were enabled later.

**Recommendation:** keep marksman for diagnostics/links; disable **completion only** if needed, not the whole server.

---

## Recommended fix

### Primary (recommended): harden blink disable for all markdown-like / wiki buffers

**File:** `nvim/.config/nvim/lua/plugins/blink.lua`

```lua
enabled = function()
  local ft = vim.bo.filetype
  if ft == "vimwiki" or ft == "markdown" or ft:match("^markdown%.") then
    return false
  end
  return true
end,
```

### Belt-and-suspenders: buffer-local flag (blink docs pattern)

**File:** `nvim/.config/nvim/init.lua` (or new small autocmd file)

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.*", "vimwiki" },
  callback = function()
    vim.b.completion = false
  end,
})
```

blink treats `vim.b.completion = false` as an unconditional disable (`blink.cmp:docs` configuration/general.md — default conditions).

### Optional: disable marksman completion only (keep diagnostics)

**File:** `nvim/.config/nvim/lua/plugins/lsp.lua`

If marksman should attach to wiki/markdown but never offer completion items:

```lua
marksman = {
  filetypes = { "markdown", "vimwiki" }, -- only if you want LSP on wiki files
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    textDocument = { completion = nil },
  }),
},
```

Or on attach:

```lua
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = { "markdown", "markdown.*", "vimwiki" },
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "marksman" and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(false, client.id, ev.buf)
    end
  end,
})
```

**Do not** remove marksman entirely unless you also want to lose diagnostics, cross-references, and rename for Markdown.

### Not needed unless you add native LSP autocompletion later

`completeopt = 'menuone,noselect'` in `opts.lua` is fine; it does not by itself trigger popups (`:help 'completeopt'`). No change required there.

---

## Alternative fixes considered

| Alternative | Why not primary |
|-------------|-----------------|
| Disable `completion.menu.auto_show` for markdown only | blink docs recipe; still leaves keymaps/ghost text active; doesn’t fix vimwiki filetype mismatch |
| Clear `show_on_blocked_trigger_characters` (show on newline) | Opposite of desired behavior; blink docs warn this is problematic |
| Enable Neovim `'autocomplete'` + tune `'complete'` | Unrelated; not enabled today; different UI (no `[Buffer]` suffix) |
| Remove vimwiki | Fixes filetype hijack but drops wiki features |
| Disable marksman completely | Overkill; loses non-completion LSP value on true markdown buffers |
| Rely on `vim.lsp.completion.enable(false, ...)` alone | Insufficient while blink remains enabled on `vimwiki` |

---

## Verification steps

1. **Identify actual filetype** in the offending buffer:
   ```vim
   :echo &filetype
   :lua print(require('blink.cmp.config').enabled())
   ```
   Expect `vimwiki` + `true` before fix; `false` after.

2. **Confirm popup source** while menu is open:
   ```vim
   :lua print(vim.inspect(vim.api.nvim__ins_get_completion_items and 'native' or 'unknown'))
   ```
   If labels show `[Buffer]` / `[LSP]` in blink’s custom columns, it is blink.

3. **Check LSP clients**:
   ```vim
   :lua print(vim.inspect(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({buf=0}))))
   ```
   vimwiki buffers: likely no marksman. Pure markdown: may show `marksman`.

4. **Reproduce newline behavior** in insert mode on a list item (`- foo`), press Enter:
   - Before fix: menu may appear on next typed char or linger from context
   - After fix: no blink menu; normal newline/list continuation

5. **Sanity-check options**:
   ```vim
   :set autocomplete? complete? completeopt?
   ```
   Expect `autocomplete` off unless you enable it elsewhere.

---

## Sources (kept)

- **neovim:help `lsp.txt`** — `vim.lsp.completion.enable()` is opt-in on `LspAttach`; `autotrigger` uses server `triggerCharacters`
- **neovim:help `options.txt`** — `'autocomplete'` default off; `'complete'` default `.,w,b,u,t` (no `o`/omnifunc)
- **neovim:help `insert.txt`** — `ins-autocompletion` requires `'autocomplete'`
- **blink.cmp:docs** — disable per filetype via `enabled` or `vim.b.completion`; newline blocked by default in `show_on_blocked_trigger_characters`
- **dotfiles:nvim-plugins** — `blink.lua`, `lsp.lua`, `extras.lua` (vimwiki), `opts.lua`
- **Runtime verification** — `README.md` → `filetype=vimwiki`, `blink=true`; forced `markdown` → `blink=false`

## Gaps

- Exact wiki path patterns depend on vimwiki config (not overridden in dotfiles); all tested `.md` files became `vimwiki`.
- Live marksman `triggerCharacters` not queried from a running server in this research run; secondary sources report `[`, `#`, `(`.
- If popup persists after fix on `filetype=markdown`, check for local `set autocomplete` or another completion plugin outside this repo.

---

## Acceptance report

```acceptance-report
{
  "criteriaSatisfied": [
    {
      "id": "criterion-1",
      "status": "satisfied",
      "evidence": "Research-only deliverable completed: root cause, fixes, alternatives, and verification written to .pi-subagents/artifacts/outputs/e214c218/research.md without widening scope into config edits"
    }
  ],
  "changedFiles": [
    ".pi-subagents/artifacts/outputs/e214c218/research.md"
  ],
  "testsAddedOrUpdated": [],
  "commandsRun": [
    {
      "command": "context-mode cli search against neovim:help, blink.cmp:docs, dotfiles:nvim-plugins",
      "result": "passed",
      "summary": "Retrieved LSP completion, autocomplete, and blink disable/trigger documentation"
    },
    {
      "command": "nvim --headless buffer inspection (filetype, blink.enabled, omnifunc, LSP clients)",
      "result": "passed",
      "summary": "Confirmed vimwiki filetype leaves blink enabled; markdown filetype disables blink"
    },
    {
      "command": "grep/read dotfiles nvim config and blink/neovim runtime sources",
      "result": "passed",
      "summary": "Mapped menu labels to blink buffer/LSP sources and ruled out native vim.lsp.completion.enable in config"
    }
  ],
  "validationOutput": [
    "README.md loads as filetype=vimwiki with blink_enabled=true and 0 LSP clients",
    "Forced filetype=markdown yields blink_enabled=false",
    "User config has autocomplete=false, no vim.lsp.completion.enable calls"
  ],
  "residualRisks": [
    "If user edits non-vimwiki markdown.mdx or other compound filetypes, broaden enabled pattern may still need tuning",
    "Enabling marksman for vimwiki without disabling completion capabilities could reintroduce LSP menu items"
  ],
  "noStagedFiles": true,
  "diffSummary": "Added research brief artifact only; no nvim config changes applied",
  "reviewFindings": [
    "no blockers: research artifact matches acceptance contract"
  ],
  "manualNotes": "Most .md files in this setup are vimwiki, not markdown — that is the main reason the markdown-only blink disable does not match user-visible behavior. Apply recommended blink.lua + optional autocmd fix in a follow-up implementation task if desired."
}
```
