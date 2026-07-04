# Task for researcher

Investigate why markdown buffers in Neovim 0.12.2 show a completion popup on every newline despite blink.cmp being disabled for markdown.

MANDATORY: Use ctx_search extensively against these indexed sources:
- neovim:help (Neovim 0.12 help manual)
- blink.cmp:docs
- dotfiles:nvim-plugins

Also read these files directly:
- /Users/shoe/dotfiles/nvim/.config/nvim/lua/plugins/blink.lua
- /Users/shoe/dotfiles/nvim/.config/nvim/lua/plugins/lsp.lua
- /Users/shoe/dotfiles/nvim/.config/nvim/lua/shoe/opts.lua

Context from prior investigation:
- User sees popup labeled like Text [Buffer] or LSP completion on every newline in markdown
- blink.cmp already has: enabled = function() return vim.bo.filetype ~= "markdown" end
- marksman LSP is configured for markdown filetype
- completeopt = 'menuone,noselect'
- Neovim 0.12 has vim.lsp.completion.enable() native LSP autocompletion separate from blink

Your job:
1. Determine the ACTUAL source of the popup (blink vs native vim.lsp.completion vs marksman vs autocomplete option vs something else)
2. Find the exact fix with evidence from neovim:help and/or blink.cmp docs
3. Provide concrete lua config changes (file paths + exact code) to stop popup on Enter/newline in markdown while keeping normal editing
4. Note if marksman should be disabled for completion only vs fully

Return a structured brief:
- Root cause (with doc citations from ctx_search)
- Recommended fix (exact code diff locations)
- Alternative fixes considered
- Verification steps

---
**Output:**
Write your findings to exactly this path: /Users/shoe/dotfiles/.pi-subagents/artifacts/outputs/e214c218/research.md
This path is authoritative for this run.
Ignore any other output filename or output path mentioned elsewhere, including output destinations in the base agent prompt, system prompt, or task instructions.

## Acceptance Contract
Acceptance level: checked
Completion is not accepted from prose alone. End with a structured acceptance report.

Criteria:
- criterion-1: Implement the requested change without widening scope

Required evidence: changed-files, tests-added, commands-run, residual-risks, no-staged-files

Finish with a fenced JSON block tagged `acceptance-report` in this shape:
Use empty arrays when no items apply; array fields contain strings unless object entries are shown.
```acceptance-report
{
  "criteriaSatisfied": [
    {
      "id": "criterion-1",
      "status": "satisfied",
      "evidence": "specific proof"
    }
  ],
  "changedFiles": [
    "src/file.ts"
  ],
  "testsAddedOrUpdated": [
    "test/file.test.ts"
  ],
  "commandsRun": [
    {
      "command": "command",
      "result": "passed",
      "summary": "short result"
    }
  ],
  "validationOutput": [
    "validation output or concise summary"
  ],
  "residualRisks": [
    "none"
  ],
  "noStagedFiles": true,
  "diffSummary": "short description of the diff",
  "reviewFindings": [
    "blocker: file.ts:12 - issue found, or no blockers"
  ],
  "manualNotes": "anything else the parent should know"
}
```