# nix-lefthook-git-conflict-markers

[![CI](https://github.com/pr0d1r2/nix-lefthook-git-conflict-markers/actions/workflows/ci.yml/badge.svg)](https://github.com/pr0d1r2/nix-lefthook-git-conflict-markers/actions/workflows/ci.yml)

> This code is LLM-generated and validated through an automated integration process using [lefthook](https://github.com/evilmartians/lefthook) git hooks, [bats](https://github.com/bats-core/bats-core) unit tests, and GitHub Actions CI.

Lefthook-compatible git conflict marker checker, packaged as a Nix flake.

Detects unresolved git conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in files. Filters non-existent files from staged arguments and checks the rest. Exits 0 when no files are found or no conflict markers are detected.

## Usage

### Option A: Lefthook remote (recommended)

Add to your `lefthook.yml` — no flake input needed, the wrapper only uses `grep`:

```yaml
remotes:
  - git_url: https://github.com/pr0d1r2/nix-lefthook-git-conflict-markers
    ref: main
    configs:
      - lefthook-remote.yml
```

### Option B: Flake input

Add as a flake input:

```nix
inputs.nix-lefthook-git-conflict-markers = {
  url = "github:pr0d1r2/nix-lefthook-git-conflict-markers";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Add to your devShell:

```nix
nix-lefthook-git-conflict-markers.packages.${pkgs.stdenv.hostPlatform.system}.default
```

Add to `lefthook.yml`:

```yaml
pre-commit:
  commands:
    git-conflict-markers:
      run: timeout ${LEFTHOOK_GIT_CONFLICT_MARKERS_TIMEOUT:-30} lefthook-git-conflict-markers {staged_files}
```

### Configuring timeout

The default timeout is 30 seconds. Override per-repo via environment variable:

```bash
export LEFTHOOK_GIT_CONFLICT_MARKERS_TIMEOUT=60
```

## Development

The repo includes an `.envrc` for [direnv](https://direnv.net/) — entering the directory automatically loads the devShell with all dependencies:

```bash
cd nix-lefthook-git-conflict-markers  # direnv loads the flake
bats tests/unit/
```

If not using direnv, enter the shell manually:

```bash
nix develop
bats tests/unit/
```

## License

MIT
