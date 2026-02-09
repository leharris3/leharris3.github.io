# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal academic portfolio site for Levi Harris (CS MS student, UNC Chapel Hill). Built on the **al-folio** Jekyll theme (v0.12.1). Deployed to GitHub Pages at `leharris3.github.io`.

## Build & Development Commands

```bash
# Local development (Docker - preferred)
docker compose up                # serves on http://localhost:8080

# Local development (native Ruby)
bundle install
bundle exec jekyll serve         # serves on http://localhost:4000

# Production build
JEKYLL_ENV=production bundle exec jekyll build

# Code formatting
npx prettier --check .           # check formatting
npx prettier --write .           # fix formatting
```

The Docker entry point (`bin/entry_point.sh`) auto-restarts Jekyll when `_config.yml` changes.

## Content Architecture

**Blog posts** (`_posts/`): Named `YYYY-MM-DD-title.md`, use `layout: post`, rendered to `/blog/:year/:title/`.

**Projects** (`_projects/`): Named `YYYY-MM-DD-title.md`, use `layout: post`. Primarily used for Weekly-in-Review (WIR) and Year-in-Review (YIR) entries with tag `WIR`.

**Static pages** (`_pages/`): About (landing at `/`), blog index, projects grid, CV, publications, repositories.

**News** (`_news/`): Short announcements displayed on the homepage.

**Bibliography** (`_bibliography/papers.bib`): BibTeX entries rendered via jekyll-scholar.

**CV data**: `assets/json/resume.json` (JSON Resume format) or fallback `_data/cv.yml`.

## Key Configuration

- `_config.yml` (22KB): Main site config including social links, blog settings, plugin config, collections
- `_data/repositories.yml`: GitHub repos to display
- `_data/coauthors.yml`: Co-author metadata for publications
- `_sass/_themes.scss`: Theme colors (light/dark mode)
- `_sass/_variables.scss`: SCSS variables including max content width (930px)

## Front Matter Pattern

```yaml
---
layout: post          # or about, page, bib, distill, cv
title: Title Here
date: YYYY-MM-DD
description:          # optional
tags:                 # optional, e.g. WIR
categories:           # optional
---
```

## Custom Plugins (`_plugins/`)

- `cache-bust.rb`: MD5-based CSS cache invalidation
- `external-posts.rb`: Import posts from external RSS feeds
- `google-scholar-citations.rb`: Fetch citation counts
- `details.rb`: HTML5 `<details>` element support
- `hide-custom-bibtex.rb`: Bibliography field filtering

## Deployment

Automatic via GitHub Actions (`.github/workflows/deploy.yml`) on push to `main`. The workflow builds with Jekyll, runs PurgeCSS, then deploys to GitHub Pages. All changes should be made on the `main` branch; `gh-pages` is auto-generated.

## Notable Conventions

- Images go in `assets/img/<topic>/`
- Jupyter notebooks can be embedded via `jekyll-jupyter-notebook` plugin
- The site supports Distill.pub-style posts (`layout: distill`)
- MathJax is available for LaTeX equations in posts
- Comments use Giscus (configured in `_config.yml`)
- `_site/` is the generated output directory (gitignored behavior varies; currently has modified files in git status)
