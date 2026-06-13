# rust-cli

Rust CLI tool — part of the unified-reference-stack.

## Quick start

```bash
pixi run run    # cargo run
pixi run test   # cargo test
pixi run lint   # cargo clippy -D warnings
pixi run format # cargo fmt
```

## Notes

- `cargo-watch` is not on conda-forge. Install it separately after activating the environment:
  ```bash
  pixi shell
  cargo install cargo-watch
  cargo-watch -x run
  ```
