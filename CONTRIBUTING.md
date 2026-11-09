# Contributing to CORTEX

## Adding a new tool wrapper

1. Pick the right module under `modules/` (or create a new category file
   if it genuinely doesn't fit an existing one).
2. Write a function that:
   - prompts for whatever the tool needs with `prompt("label")`
   - builds the command as a **list**, never a string (`run(["tool", "-x", val])`)
   - calls `run([...])` from `modules/__init__.py`
3. Register it in that module's `MENU` dict: `"N": ("Label shown in menu", your_fn, "binary_name")`.
   The third item is the binary CORTEX checks with `shutil.which()` to show
   `[not installed]` — pass `None` if there's nothing meaningful to check.
4. If the tool needs an apt package, add it to the `PACKAGES` array in
   `install.sh` with a one-line comment saying which category it's for.

## Rules

- No `shell=True`, no f-string-built shell commands. Lists only — it's the
  difference between a tool and a shell-injection vector.
- No install scripts that pipe a remote URL straight into bash. If it needs
  external setup, say so in `install.sh` and let the user read it first.
- Keep each module focused on one category. Don't cram unrelated tools into
  `exploitation.py` because it was already open.

## Testing

Before opening a PR, at minimum run:

```bash
python3 -c "from modules import recon, password_attacks, wireless, exploitation, sniffing_spoofing, web_hacking, post_exploitation"
```

to confirm nothing you added breaks imports.

## Pull requests

Describe what the tool does and link its upstream repo/docs. Keep PRs scoped
to one tool or one fix at a time.
