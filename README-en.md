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
