# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dbt + Snowflake CI/CD demo project. It uses [uv](https://github.com/astral-sh/uv) for Python dependency management and contains a dbt project (`tasty_bytes_demo/`) that models Snowflake data for the Tasty Bytes food truck dataset.

## Commands

### Python / uv

```bash
uv sync                  # Install dependencies from uv.lock
uv run python main.py    # Run the main Python entry point
```

### dbt (run from inside `tasty_bytes_demo/`)

```bash
cd tasty_bytes_demo

dbt run                  # Build all models
dbt test                 # Run all data tests
dbt run --select <model> # Build a single model
dbt test --select <model> # Test a single model
dbt compile              # Compile without running
dbt clean                # Remove target/ and dbt_packages/
```

## Architecture

### Repository Layout

```
snowflake_dbt_cicd_demo/
├── .github/workflows/deploy_dbt_project.yaml  # CI/CD pipeline (GitHub Actions)
├── tasty_bytes_demo/                          # dbt project root
│   ├── dbt_project.yml                        # Project config; profile = tasty_bytes_demo
│   ├── models/example/                        # dbt models (views by default)
│   ├── setup/tasty_bytes_setup.sql            # One-time Snowflake setup script
│   └── target/                                # Compiled artifacts (gitignored)
├── pyproject.toml                             # Python project; depends on dbt-snowflake
├── uv.lock                                    # Locked dependency graph
└── .python-version                            # Python 3.13
```

### dbt Project

- **Profile**: `tasty_bytes_demo` — connection config lives in `~/.dbt/profiles.yml` (not committed).
- **Source database**: `tb_101` on Snowflake, schema `raw`. Tables are loaded from S3 via Snowflake stage using `setup/tasty_bytes_setup.sql` (run once manually).
- **Models** under `models/example/` are materialized as **views** by default (`dbt_project.yml`), except `my_first_dbt_model` which overrides to `table`.
- `my_second_dbt_model` selects from `my_first_dbt_model` via `{{ ref() }}`, demonstrating dbt's DAG-based dependency resolution.
- Data tests (unique, not_null) are defined in `models/example/schema.yml`.

### CI/CD

The GitHub Actions workflow (`.github/workflows/deploy_dbt_project.yaml`) is the deployment pipeline. Snowflake credentials are expected to be provided as GitHub Actions secrets and consumed by dbt via environment variables or a generated `profiles.yml`.
