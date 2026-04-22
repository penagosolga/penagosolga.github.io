# mylibrary.github.io template

[![English version](https://img.shields.io/badge/README-English-blue)](./README-en.md)

Template de biblioteca personal estatica para GitHub Pages.

## Ejemplo en accion

Puedes ver una biblioteca real basada en este enfoque en:

- https://jorgezuluaga.github.io/biblioteca.html

## Que incluye este template

- `index.html` como dashboard principal de la biblioteca.
- `all-books.html` para el listado completo.
- `info/library.json` como fuente de verdad.
- Resenas locales de ejemplo en `reviews/`.
- Scripts en `bin/` para importar datos de Goodreads y crear mirrors.
- `update/` para archivos descargados (staging).

## Inicio rapido

```bash
make start
```

Abre `http://127.0.0.1:8000`.

Detener servidor:

```bash
make stop
```

## Actualizar biblioteca desde Goodreads

### 1) Obtener la URL RSS de Goodreads

Formato esperado:

```text
https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23
```

Como obtenerla:
- Ve a tu perfil/lista de libros en Goodreads.
- Busca el enlace RSS de tu lista de resenas.
- Copia la URL completa (incluyendo `user_id` y `key`).

### 2) Obtener el COOKIE (opcional, recomendado para likes)

Sin cookie, Goodreads puede devolver paginas de login y los likes quedar en `0`.

Pasos:
1. Inicia sesion en Goodreads.
2. Abre una resena tuya (`https://www.goodreads.com/review/show/...`).
3. Abre DevTools (`F12`) y entra a Network.
4. Recarga la pagina.
5. Abre la peticion principal (`document`) de esa pagina.
6. En Request Headers, copia el valor completo de `cookie`.
7. Exportalo en terminal:

```bash
export GR_COOKIE='session-id=...; at-main=...; ccsid=...; locale=en; ...'
```

Tratalo como una contrasena y nunca lo subas al repo.

### 3) Construir `info/library.json`

```bash
make library-build \
  RSS_URL="https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23" \
  RSS_PAGES=20 \
  COOKIE="$GR_COOKIE"
```

Notas:
- Sube `RSS_PAGES` si faltan libros antiguos.
- Si no quieres scrapeo de likes, deja `COOKIE` vacio.

### 4) Generar estadisticas agregadas

```bash
make library-stats
```

Esto actualiza `info/library-stats.json`.

### 5) Crear mirror local de resenas

Primero una sola resena (prueba rapida):

```bash
make reviews-first COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

Luego todas las resenas:

```bash
make reviews-all COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

Forzar regeneracion completa:

```bash
make reviews-force COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

### 6) Flujo completo recomendado

```bash
make library-build RSS_URL="https://www.goodreads.com/review/list_rss/YOUR_USER_ID?key=YOUR_KEY&shelf=%23ALL%23" RSS_PAGES=40 COOKIE="$GR_COOKIE"
make library-stats
make reviews-all COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
```

Despues verifica:
- `index.html`
- `all-books.html`
- `reviews/*.html`

## Comandos Make

- `make start`: inicia servidor local en background.
- `make stop`: detiene servidor local por puerto.
- `make dev`: inicia servidor dev (`bin/dev_server.py`).
- `make library-build`: genera `info/library.json` desde RSS.
- `make library-stats`: genera `info/library-stats.json`.
- `make library-refresh`: corre `library-build` + `library-stats`.
- `make reviews-first`: mirror de la primera resena.
- `make reviews-all`: mirror de todas las resenas.
- `make reviews-force`: regenera todos los mirrors.

## Directorio `update/`

`update/` es un directorio de staging para archivos descargados/manuales.  
La web no lo consume directamente; los datos de runtime estan en `info/*.json`.

## Autor

**Jorge I. Zuluaga (2026-present)**  
Hoja de vida: https://jorgezuluaga.github.io/

## Creditos

Esta pagina/template fue hecha con **Cursor**.
