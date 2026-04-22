.PHONY: help start dev stop \
	library-build library-stats library-refresh \
	reviews-first reviews-all reviews-force \
	sync-template

PORT ?= 8000
HOST ?= 127.0.0.1
LIBRARY_JSON ?= info/library.json
LIBRARY_STATS_JSON ?= info/library-stats.json
RSS_URL ?=
COOKIE ?=
RSS_PAGES ?= 1
REVIEW_RSS_PAGES ?= 40
TEMPLATE_UPSTREAM ?= https://github.com/JorgeZuluaga/mylibrary.github.io.git
TEMPLATE_BRANCH ?= main
SYNC_BRANCH ?= sync-template

help:
	@echo "make start|stop|dev|library-build|library-stats|reviews-all"
	@echo "make sync-template            # full sync from template (setup+fetch+merge+auto-resolve+push)"

start:
	@echo "Starting server on http://$(HOST):$(PORT)"
	@nohup python3 -m http.server "$(PORT)" --bind "$(HOST)" >/dev/null 2>&1 &
	@sleep 0.2
	@echo "Started. Stop with: make stop"

dev:
	@python3 bin/dev_server.py --host "$(HOST)" --port "$(PORT)" --root "."

stop:
	@echo "Stopping server on port $(PORT) (best-effort)"
	@PID="$$(lsof -tiTCP:$(PORT) -sTCP:LISTEN 2>/dev/null | head -n 1)"; 	if [ -n "$$PID" ]; then 		echo "Killing pid $$PID"; 		kill "$$PID" 2>/dev/null || true; 		sleep 0.2; 		if kill -0 "$$PID" 2>/dev/null; then 			echo "Still running, forcing stop (SIGKILL)"; 			kill -9 "$$PID" 2>/dev/null || true; 		fi; 	else 		echo "No process listening on $(PORT)."; 	fi

library-build:
	@if [ -z "$(RSS_URL)" ]; then 		echo "RSS_URL is required."; 		exit 1; 	fi
	@python3 bin/build_library_from_goodreads.py --rss-url "$(RSS_URL)" --out "$(LIBRARY_JSON)" --rss-pages "$(RSS_PAGES)" --scrape-likes --cookie "$(COOKIE)" --verbose

library-stats:
	@python3 bin/update_library_stats.py "$(LIBRARY_JSON)" --out "$(LIBRARY_STATS_JSON)"

library-refresh: library-build library-stats
	@echo "Library refresh completed."

reviews-first:
	@python3 bin/mirror_first_review.py --library-json "$(LIBRARY_JSON)" --reviews-dir reviews --cookie "$(COOKIE)" --rss-pages "$(REVIEW_RSS_PAGES)"

reviews-all:
	@python3 bin/mirror_all_reviews.py --library-json "$(LIBRARY_JSON)" --reviews-dir reviews --cookie "$(COOKIE)" --rss-pages "$(REVIEW_RSS_PAGES)"

reviews-force:
	@python3 bin/mirror_all_reviews.py --library-json "$(LIBRARY_JSON)" --reviews-dir reviews --cookie "$(COOKIE)" --rss-pages "$(REVIEW_RSS_PAGES)" --force

sync-template:
	@set -e; \
	echo "[1/6] Configurando remoto upstream..."; \
	if git remote get-url upstream >/dev/null 2>&1; then \
		git remote set-url upstream "$(TEMPLATE_UPSTREAM)"; \
		echo "Updated upstream -> $(TEMPLATE_UPSTREAM)"; \
	else \
		git remote add upstream "$(TEMPLATE_UPSTREAM)"; \
		echo "Added upstream -> $(TEMPLATE_UPSTREAM)"; \
	fi; \
	echo "[2/6] Descargando cambios del template..."; \
	git fetch upstream; \
	echo "[3/6] Cambiando/creando rama $(SYNC_BRANCH)..."; \
	CURRENT="$$(git branch --show-current)"; \
	if [ "$$CURRENT" != "$(SYNC_BRANCH)" ]; then \
		git checkout -b "$(SYNC_BRANCH)" 2>/dev/null || git checkout "$(SYNC_BRANCH)"; \
	fi; \
	echo "[4/6] Haciendo merge desde upstream/$(TEMPLATE_BRANCH)..."; \
	if git merge "upstream/$(TEMPLATE_BRANCH)" --allow-unrelated-histories; then \
		echo "Merge limpio."; \
	else \
		echo "Conflictos detectados. Tomando version remota (theirs)..."; \
		git checkout --theirs .; \
		git add -A; \
		git commit -m "Resolve merge taking upstream template content"; \
	fi; \
	echo "[5/6] Subiendo rama al remoto origin..."; \
	CURRENT="$$(git branch --show-current)"; \
	git push -u origin "$$CURRENT"; \
	echo "[6/6] Listo. Revisa cambios y, si aplica, mergea $(SYNC_BRANCH) a main."
