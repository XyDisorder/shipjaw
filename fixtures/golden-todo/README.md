# Golden fixture — Shipjaw output shape

This tree is a **structural golden** of what a Shipjaw-built (or
fully-adopted) todo app should look like: committed `documentation/`,
continuation contract, ports + composition + thin action, handoff file.

It is **not** a runnable Next install (no `node_modules`, no full App
Router). Maintainers assert shape via:

```sh
./scripts/smoke-fixture.sh
```

When changing skill templates or architecture rules, update this fixture
in the same PR so smoke stays the source of truth for “what good looks like.”
