
## Task folder (`_coder/`)

- `_coder/` holds issues, plans, docs, reports, specs and benchmarks as `<folder>/NNN_<type>_<slug>.md`. Not source truth (code wins); read only when asked. "Issues" means `_coder/issues/` unless GitHub is named.
- `_coder/README.md` governs naming and frontmatter. `_coder/INDEX.md` is generated: run `node _coder/index.mjs` after any change there; `node _coder/index.mjs next <type>` prints the next number. Search with `node _coder/index.mjs find <word>…` or `open` instead of reading `INDEX.md`.
- Plans are written before the first code edit (`status: wip`), updated after each step or commit (decisions, results, commit hashes, what is open), and closed when done.
