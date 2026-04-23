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

## Requisitos de software

Para preparar/actualizar esta biblioteca necesitas:

- `git` (clonar, commit y push).
- `python3` (ejecutar scripts de `bin/`).
- `make` (atajos como `make start`, `make library-build`, `make reviews-all`).
- Opcional: navegador moderno (para validar el sitio local).

Versiones recomendadas:

- Python 3.10+ (ideal 3.11 o 3.12).
- GNU Make 4.x o compatible.
- Git 2.30+.

### Verificar que ya están instalados

```bash
git --version
python3 --version
make --version
```

### Instalación en Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y git python3 python3-pip make
```

En Fedora:

```bash
sudo dnf install -y git python3 python3-pip make
```

### Instalación en macOS

1. Instala Homebrew: [https://brew.sh/](https://brew.sh/)
2. Luego:

```bash
brew install git python make
```

Nota: macOS ya trae `python3`/`git` en muchos casos, pero conviene mantenerlos actualizados con Homebrew.

### Instalación en Windows

Opción recomendada (más simple): **WSL + Ubuntu** y usar los pasos de Linux.

Alternativa nativa en PowerShell:

- Instala `Git for Windows`: [https://git-scm.com/download/win](https://git-scm.com/download/win)
- Instala Python: [https://www.python.org/downloads/windows/](https://www.python.org/downloads/windows/)
- Instala `make`:
  - con Chocolatey: `choco install make`
  - o con Scoop: `scoop install make`

### Cómo usarlo en cada sistema

Con `make` (Linux/macOS/Windows con WSL o make instalado):

```bash
make start
make library-build RSS_URL="..." RSS_PAGES=40 COOKIE="$GR_COOKIE"
make library-stats
make reviews-all COOKIE="$GR_COOKIE" REVIEW_RSS_PAGES=40
make stop
```

Sin `make` (por ejemplo, Windows sin make), ejecuta scripts directos:

```bash
python3 -m http.server 8000 --bind 127.0.0.1
python3 bin/build_library_from_goodreads.py --rss-url "..." --out info/library.json --rss-pages 40 --scrape-likes --cookie "TU_COOKIE"
python3 bin/update_library_stats.py info/library.json --out info/library-stats.json
python3 bin/mirror_all_reviews.py --library-json info/library.json --reviews-dir reviews --cookie "TU_COOKIE" --rss-pages 40
```

## Foto de perfil

En la cabecera de la biblioteca se muestra un avatar. Por defecto el template usa `assets/profile-placeholder.svg`.

Para que aparezca tu propia imagen:

1. Obtén una foto tuya: descárgala o expórtala desde tu cámara o red social (cópiala a tu carpeta de trabajo; conviene una imagen cuadrada o fácil de recortar).
2. Guárdala en `assets/` con **uno** de estos nombres: `profile.jpg`, `profile.png` o `profile.webp` (solo un archivo, según el formato).
3. Abre `index.html` y `all-books.html`. En el bloque con clase `library-identity__avatar`, en la etiqueta `<img>`, cambia `src` de `./assets/profile-placeholder.svg` a la ruta de tu archivo, por ejemplo `./assets/profile.jpg`.
4. Ajusta el atributo `alt` con tu nombre o una descripción breve.
5. Añade el archivo al repositorio (`git add assets/profile.jpg`, etc.), haz commit y push. Tras unos minutos, GitHub Pages mostrará la foto en el sitio publicado.

Si no añades ninguna imagen propia, se seguirá viendo el placeholder.

## Texto de presentación de la biblioteca

Después de cambiar la foto de perfil, actualiza también el texto de presentación en:

- `info/intro.html`

Ese archivo puede contener uno o varios párrafos HTML (`<p>...</p>`) con la descripción personal de quien use la biblioteca.

Flujo recomendado:

1. Cambia la foto (`assets/profile.jpg|png|webp`).
2. Edita `info/intro.html` con tu descripción.
3. Haz `git add`, `commit` y `push`.

## Como usar este template en un repo vacio

Si ya creaste un repositorio vacio en otra cuenta, este es el flujo recomendado.

### 1) Clonar el repo vacio

Ejemplo con HTTPS:

```bash
git clone https://github.com/TU_USUARIO/TU_REPO.git
cd TU_REPO
```

Ejemplo con SSH:

```bash
git clone git@github.com:TU_USUARIO/TU_REPO.git
cd TU_REPO
```

### 2) Copiar los archivos del template

Desde la carpeta del repo clonado, copia el contenido de este template (excepto `.git`) al repo vacio.

Ejemplo usando `rsync`:

```bash
rsync -av --exclude ".git/" /ruta/a/mylibrary.github.io/ ./
```

### 3) Confirmar que los archivos llegaron

```bash
git status
```

Debes ver archivos como:
- `index.html`
- `all-books.html`
- `assets/`
- `bin/`
- `info/`
- `reviews/`
- `Makefile`
- `README.md`

### 4) Probar localmente

```bash
make start
```

Abre `http://127.0.0.1:8000` y valida que carga bien.

### 5) Commit y push inicial

```bash
git add .
git commit -m "Initialize personal library from template"
git push -u origin main
```

### 6) Activar GitHub Pages

En GitHub:
- `Settings` -> `Pages`
- `Deploy from a branch`
- Branch: `main`
- Folder: `/(root)`

Importante:
- Despues de guardar la configuracion, espera 1-2 minutos para que GitHub publique el sitio.
- Si GitHub muestra el mensaje **"Add a Jekyll theme"**, puedes ignorarlo en este proyecto: este template es un sitio estatico y no necesita tema de Jekyll.

## Publicar en GitHub Pages: dos modos

Hay dos formas de publicar este template en GitHub Pages. La URL final cambia segun el modo elegido.

### Modo A: sitio principal de la cuenta (raiz)

URL final:

```text
https://TU_USUARIO.github.io/
```

Requisitos:
- Tener una cuenta de GitHub.
- Crear un repositorio con nombre exacto: `TU_USUARIO.github.io`.
- Copiar el template en la raiz de ese repo y publicarlo.

### Modo B: sitio como subdirectorio (proyecto)

URL final:

```text
https://TU_USUARIO.github.io/NOMBRE_REPO/
```

Ejemplo:

```text
https://penagosolga.github.io/biblioteca/
```

En este modo:
- Tu cuenta puede llamarse `penagosolga`.
- Creas un repo, por ejemplo `biblioteca`.
- El contenido del template debe copiarse en ese repo `biblioteca` (raiz del repo), no en otro.
- Luego Pages lo publicara bajo `/biblioteca/`.

Nota importante sobre `rsync`:
- Si quieres `https://penagosolga.github.io/biblioteca/`, el `rsync` debe hacerse dentro del repo local `biblioteca/`.
- Si haces `rsync` dentro de otro repo (por ejemplo `olgapenagos.github.io`), la URL publicada sera la de ese repo.

### Que modo conviene elegir

- Usa **Modo A** si quieres que esta biblioteca sea tu sitio principal de cuenta.
- Usa **Modo B** si ya tienes un sitio principal y quieres esta biblioteca como una seccion/proyecto adicional.

## Si aun no tienes cuenta en GitHub

1. Ve a https://github.com/signup
2. Crea usuario, correo y contrasena.
3. Verifica tu correo.
4. Inicia sesion y crea un repositorio nuevo (segun Modo A o Modo B).
5. Clona ese repo en local y copia el template con `rsync`.
6. Haz commit, push y activa Pages en `Settings` -> `Pages`.

## Como recibir mejoras futuras del template

Si alguien ya tiene su biblioteca personalizada, puede traer cambios nuevos del template con una sola regla:

```bash
make sync-template
```

### Que hace `make sync-template`

1. Configura/actualiza el remoto `upstream` apuntando al repo del template.
2. Hace `fetch` de cambios remotos.
3. Crea o actualiza la rama `sync-template`.
4. Fuerza el contenido de `sync-template` para que coincida exactamente con `upstream/main`.
5. Limpia archivos no trackeados.
6. Hace `push --force` de `sync-template` a `origin`.

### Importante (sobrescritura forzada)

Este flujo es deliberadamente agresivo para evitar conflictos y editores interactivos:
- Sobrescribe cambios locales de la rama `sync-template`.
- Puede eliminar archivos no trackeados en esa rama.
- Siempre revisa antes de fusionar `sync-template` en `main`.

### Flujo recomendado despues del sync

```bash
git checkout main
git merge sync-template
make start
git push
```

### Consejo para personalizaciones propias

Si tienes datos propios, mantenlos en `main` y revisa cuidadosamente antes de fusionar:
- `info/library.json`
- `info/library-stats.json`
- `info/book_series.json`
- `reviews/`

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
