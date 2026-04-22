# mylibrary.github.io template

[![Version en espanol](https://img.shields.io/badge/README-Espanol-blue)](./README.md)

Static personal library template for GitHub Pages.

## Live example

You can see a real library using this approach at:

- https://jorgezuluaga.github.io/biblioteca.html

## What this template includes

- `index.html` as the main library dashboard.
- `all-books.html` for the complete list.
- `info/library.json` as source of truth.
- Sample local review pages in `reviews/`.
- Scripts in `bin/` to import Goodreads data and build mirrors.
- `update/` as a staging folder for downloaded sources.

## Quick start

```bash
make start
```

Open `http://127.0.0.1:8000`.

Stop server:

```bash
make stop
```

## How to use this template in an empty repository

If you already created an empty repository in another account, this is the recommended flow.

### 1) Clone the empty repository

HTTPS example:

```bash
git clone https://github.com/YOUR_USER/YOUR_REPO.git
cd YOUR_REPO
```

SSH example:

```bash
git clone git@github.com:YOUR_USER/YOUR_REPO.git
cd YOUR_REPO
```

### 2) Copy template files

From the cloned repo folder, copy this template content (except `.git`) into that repo.

`rsync` example:

```bash
rsync -av --exclude ".git/" /path/to/mylibrary.github.io/ ./
```

### 3) Confirm files are in place

```bash
git status
```

You should see files such as:
- `index.html`
- `all-books.html`
- `assets/`
- `bin/`
- `info/`
- `reviews/`
- `Makefile`
- `README.md`

### 4) Test locally

```bash
make start
```

Open `http://127.0.0.1:8000` and verify everything loads.

### 5) Initial commit and push

```bash
git add .
git commit -m "Initialize personal library from template"
git push -u origin main
```

### 6) Enable GitHub Pages

In GitHub:
- `Settings` -> `Pages`
- `Deploy from a branch`
- Branch: `main`
- Folder: `/(root)`

Important:
- After saving the Pages configuration, wait 1-2 minutes for deployment.
- If GitHub shows **"Add a Jekyll theme"**, ignore it for this project: this template is static and does not require a Jekyll theme.

## Publish on GitHub Pages: two modes

There are two ways to publish this template on GitHub Pages. The final URL depends on the chosen mode.

### Mode A: account main site (root)

Final URL:

```text
https://YOUR_USER.github.io/
```

Requirements:
- Have a GitHub account.
- Create a repository named exactly: `YOUR_USER.github.io`.
- Copy template files into that repository root and publish.

### Mode B: project site (subdirectory)

Final URL:

```text
https://YOUR_USER.github.io/REPO_NAME/
```

Example:

```text
https://penagosolga.github.io/biblioteca/
```

In this mode:
- Your account can be `penagosolga`.
- You create a repo, for example `biblioteca`.
- Template files must be copied into that `biblioteca` repository root.
- Pages will publish it under `/biblioteca/`.

Important `rsync` note:
- If you want `https://penagosolga.github.io/biblioteca/`, run `rsync` inside the local `biblioteca/` repo.
- If you run `rsync` into a different repo (for example `olgapenagos.github.io`), GitHub will publish under that repo URL.

### Which mode should you choose?

- Use **Mode A** if this library should be your account's main site.
- Use **Mode B** if you already have a main site and want this library as an additional section/project.

## If you do not have a GitHub account yet

1. Go to https://github.com/signup
2. Create username, email, and password.
3. Verify your email.
4. Sign in and create a new repository (Mode A or Mode B).
5. Clone that repo locally and copy template files with `rsync`.
6. Commit, push, and enable Pages in `Settings` -> `Pages`.

## How to receive future template updates

If someone already has a customized library site, they can pull new template updates with a single rule:

```bash
make sync-template
```

### What `make sync-template` does

1. Configures/updates the `upstream` remote to the template repository.
2. Fetches upstream changes.
3. Creates or updates the `sync-template` branch.
4. Forces `sync-template` to match `upstream/main` exactly.
5. Cleans untracked files.
6. Pushes `sync-template` to `origin` with `--force`.

### Important (forced overwrite)

This workflow is intentionally aggressive to avoid interactive conflicts/editors:
- It overwrites local changes in `sync-template`.
- It can remove untracked files in that branch.
- Always review before merging `sync-template` into `main`.

### Recommended flow after sync

```bash
git checkout main
git merge sync-template
make start
git push
```

### Tip for custom content

If you maintain your own data/content, keep it in `main` and review carefully before merge:
- `info/library.json`
- `info/library-stats.json`
- `info/book_series.json`
- `reviews/`

## Update your library from Goodreads

### 1) Get your Goodreads RSS URL

Expected format:

```text
https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23
```

How to find it:
- Open your Goodreads profile/books list.
- Find the RSS link for your review list.
- Copy the full URL, including `user_id` and `key`.

### 2) Get COOKIE (optional, recommended for likes scraping)

Without cookie, Goodreads may return login pages and likes can stay at `0`.

Steps:
1. Sign in to Goodreads.
2. Open one of your review pages (`https://www.goodreads.com/review/show/...`).
3. Open DevTools (`F12`) and go to Network.
4. Reload the page.
5. Open the main document request.
6. In Request Headers, copy the full `cookie` value.
7. Export it in your shell:

```bash
export GR_COOKIE='session-id=...; at-main=...; ccsid=...; locale=en; ...'
```

Treat it as a password and never commit it.

### 3) Build `info/library.json`

```bash
make library-build \
  RSS_URL="https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23" \
  RSS_PAGES=20 \
  COOKIE="$GR_COOKIE"
```

Notes:
- Increase `RSS_PAGES` if older books are missing.
- Leave `COOKIE` empty if you do not want likes scraping.

### 4) Generate aggregated stats

```bash
make library-stats
```

This updates `info/library-stats.json`.

### 5) Mirror local review pages

First review (quick smoke test):

```bash
make reviews-first COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

All reviews:

```bash
make reviews-all COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

Force full regeneration:

```bash
make reviews-force COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

### 6) Recommended full refresh workflow

```bash
make library-build RSS_URL="https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23" RSS_PAGES=40 COOKIE="$GR_COOKIE"
make library-stats
make reviews-all COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

Then verify:
- `index.html`
- `all-books.html`
- `reviews/*.html`

## Make targets

- `make start`: start local server in background.
- `make stop`: stop local server by port.
- `make dev`: run dev server (`bin/dev_server.py`).
- `make library-build`: build `info/library.json` from RSS.
- `make library-stats`: build `info/library-stats.json`.
- `make library-refresh`: run `library-build` + `library-stats`.
- `make reviews-first`: mirror first review.
- `make reviews-all`: mirror all reviews.
- `make reviews-force`: regenerate all mirrors.

## `update/` directory

`update/` is a staging folder for downloaded/manual files.  
The website does not consume it directly; runtime data comes from `info/*.json`.

## Author

**Jorge I. Zuluaga (2026-present)**  
CV: https://jorgezuluaga.github.io/

## Credits

This template/page was built with **Cursor**.
