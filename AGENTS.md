# Agents Context

## Project Overview

dbt project with Lightdash BI layer. Source data: BigQuery public dataset `bigquery-public-data.cms_medicare`.

## Key Commands

```bash
dbt deps                         # Install dbt packages (dbt_utils)
dbt compile                      # Compile dbt project
lightdash lint                   # Validate Lightdash YAML
lightdash deploy                 # Deploy semantic layer (metrics/dimensions)
lightdash upload                 # Upload charts/dashboards
lightdash download --charts <slug>   # Download chart as YAML
lightdash download --dashboards <slug>  # Download dashboard as YAML
lightdash sql "SELECT ..." -o out.csv  # Run SQL queries
```

## Directory Structure

- `models/` — dbt models: `staging/` (sources) → `prod/` (fact/dim)
- `models/sources.yml` — BigQuery source definitions
- `lightdash/charts/` — Chart YAML definitions
- `lightdash/dashboards/` — Dashboard YAML definitions
- `macros/` — Jinja macros (e.g., `assign_region.sql`)
- `target/`, `dbt_packages/`, `logs/` — Generated/gitignored

## Lightdash Conventions (Critical)

- **Project type**: dbt — metadata goes under `meta:` in model YAML files
- **Required chart YAML fields**: `contentType`, `tableName`, `metricQuery.tableCalculations: []` (even empty)
- **Cartesian charts**: `xAxis` must be array format (`xAxis: [{ name: "..." }]`)
- **Chart configs**: Must include `encode` property with `xRef`/`yRef`
- **Dashboard tiles**: `title` and `chartName` are independent — manually update when chart is renamed
- **Space slug**: `hospital-management`
- **Lint before upload**: Always run `lightdash lint` first

## CI/CD Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `lightdash-validate.yml` | PR/push to main | Validates YAML + dbt |
| `lightdash-compile.yml` | PR/push to main | Compiles dbt |
| `start-preview.yml` | Push to non-main branch | Creates temp preview project |
| `close-preview.yml` | PR closed/merged | Stops preview |

DBT_VERSION: 1.9.0
