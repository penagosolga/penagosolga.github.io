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

## Software requirements

To prepare/update this library, install:

- `git` (clone, commit, push).
- `python3` (run scripts from `bin/`).
- `make` (shortcuts like `make start`, `make library-build`, `make reviews-all`).
- Optional: a modern browser (for local verification).

Recommended versions:

- Python 3.10+ (preferably 3.11 or 3.12).
- GNU Make 4.x (or compatible).
- Git 2.30+.

### Check what is already installed

```bash
git --version
python3 --version
make --version
```

### Install on Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y git python3 python3-pip make
```

On Fedora:

```bash
sudo dnf install -y git python3 python3-pip make
```

### Install on macOS

1. Install Homebrew: [https://brew.sh/](https://brew.sh/)
2. Then run:

```bash
brew install git python make
```

Note: macOS often includes `python3`/`git`, but Homebrew is still recommended to keep them current.

### Install on Windows

Recommended option (simplest): use **WSL + Ubuntu** and follow the Linux steps.

Native PowerShell option:

- Install `Git for Windows`: [https://git-scm.com/download/win](https://git-scm.com/download/win)
- Install Python: [https://www.python.org/downloads/windows/](https://www.python.org/downloads/windows/)
- Install `make`:
  - with Chocolatey: `choco install make`
  - or with Scoop: `scoop install make`

### How to use on each OS

Using `make` (Linux/macOS/Windows with WSL or make installed):

```bash
make start
make library-build RSS_URL="..." RSS_PAGES=40 COOKIE="$GR_COOKIE"
make library-stats
make reviews-all COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
make stop
```

Without `make` (for example, Windows without make), run scripts directly:

```bash
python3 -m http.server 8000 --bind 127.0.0.1
python3 bin/build_library_from_goodreads.py --rss-url "..." --out info/library.json --rss-pages 40 --scrape-likes --cookie "YOUR_COOKIE"
python3 bin/update_library_stats.py info/library.json --out info/library-stats.json
python3 bin/mirror_all_reviews.py --library-json info/library.json --reviews-dir reviews --cookie "YOUR_COOKIE" --rss-pages 40
```

## Profile photo

The library header shows an avatar. By default the template uses `assets/profile-placeholder.svg`.

To use your own picture:

1. Get a photo: download or export it from your camera or social profile (copy it into your project folder; a square image or one that is easy to crop works best).
2. Save it under `assets/` as **one** of: `profile.jpg`, `profile.png`, or `profile.webp` (a single file, matching the format you chose).
3. Open `index.html` and `all-books.html`. In the block with class `library-identity__avatar`, on the `<img>` tag, change `src` from `./assets/profile-placeholder.svg` to your file, for example `./assets/profile.jpg`.
4. Set the `alt` text to your name or a short description.
5. Add the file to git (`git add assets/profile.jpg`, etc.), commit, and push. After a few minutes, GitHub Pages will show the image on the live site.

If you skip this step, the placeholder remains.

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
