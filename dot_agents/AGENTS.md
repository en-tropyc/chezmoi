# Git

- Never add "Co-Authored-By" lines to commit messages
- Keep commit messages short and succinct — one line, no body unless explicitly requested

# GWS CLI

- Before any GWS API call, run `gws schema <service>.<resource>.<method>` (dot notation, e.g., `gmail.users.messages.list`)
- CLI commands use spaces, not dots: `gws gmail users messages list`
- All API parameters go via `--params '{JSON}'`, never as individual flags
- Gmail resources are nested under `users`: `gws gmail users messages list`, not `gws gmail messages list`
