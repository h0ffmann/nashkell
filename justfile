# Iustfile -- Nashcellum
#
# Omnia mandata huius operis, ab instructione Nix usque ad missionem
# in GitHub, in uno loco collecta. Vide `just --list` pro conspectu
# omnium mandatorum.
#
# NOTANDUM: hoc iustfile non fuit contra verum ligamentum "just"
# probatum in ambitu quo scriptum est (rete deerat). Structura et
# syntaxis diligenter secundum documenta scripta sunt, sed prius quam
# huic fidas, roga `just --list` et `just --dry-run <mandatum>`.

set shell := ["bash", "-euo", "pipefail", "-c"]

# Variabiles: mutabiles secundum tuum systema, si necesse est.
tessdata_lang := "eng"
repo_name := "nashkell"

# ---------------------------------------------------------------------------
# Mandatum primarium: si `just` sine argumentis vocatur, index ostenditur.
# ---------------------------------------------------------------------------

default:
    @just --list

# ---------------------------------------------------------------------------
# Gradus I -- Praeparatio systematis: Nix
# ---------------------------------------------------------------------------

## Instruit Nix per programma "Determinate Systems", sine confirmatione
## interactiva (necessarium in terminalibus non-interactivis).
install-nix:
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    @echo "Nix instructus est. Novum terminal aperi, deinde 'just check-nix' voca."

## Verificat num Nix recte instructus sit et in via (PATH) praesto sit.
check-nix:
    nix --version

## Activat "flakes", functionem experimentalem quam iustfile huius
## operis requirit.
enable-flakes:
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
    @echo "Flakes activati. Configuratio in ~/.config/nix/nix.conf scripta est."

# ---------------------------------------------------------------------------
# Gradus II -- Ambitus evolutionis (dev shell) et aedificatio
# ---------------------------------------------------------------------------

## Aperit interactive shell Nix cum GHC, Cabal, HLS, Tesseract omnibus
## fixis secundum flake.nix. Vocandum manu, non ex alio mandato iustfile,
## quia shell interactivum est.
shell:
    nix develop

## Aedificat bibliothecam et programma exsequibile intra ambitum Nix.
build:
    nix develop --command cabal build

## Purgat omnia artefacta aedificationis prioris -- utile post errores
## compilationis obscuros, ube cache vetus suspecta est.
clean:
    rm -rf dist-newstyle
    @echo "dist-newstyle deletum est."

## Exsequitur programma nashkell super imaginem datam. Clavis API
## Anthropic ex re systematis (ANTHROPIC_API_KEY) legitur -- videndum
## prius quam hoc mandatum vocatur.
run image:
    nix develop --command cabal run nashkell -- {{image}}

# ---------------------------------------------------------------------------
# Gradus III -- Instrumentum Latinizationis (git clean/smudge filter)
# ---------------------------------------------------------------------------

## Instruit filtrum "latinize" localiter (in .git/config huius clonis).
## Necessarium semel per clonem -- nunquam per Git ipsum communicatur.
setup-latinize:
    chmod +x setup-latinize.sh tools/latinize.py
    ./setup-latinize.sh

## Probat manu translationem: monstrat versionem Anglicam (in disco)
## iuxta versionem Latinam (quae in obiecto Git servaretur).
latinize-preview file:
    @echo "--- Anglice (in disco) ---"
    @head -8 {{file}}
    @echo ""
    @echo "--- Latine (quod in Git servaretur) ---"
    @python3 tools/latinize.py clean {{file}} | head -8

# ---------------------------------------------------------------------------
# Gradus IV -- Repositorium Git: initium, hooks, primum commit
# ---------------------------------------------------------------------------

## Initiat repositorium Git novum, si nondum exsistit, et definit
## auctorem localem huius clonis.
git-init email name:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -d .git ]; then
      echo "Repositorium iam exsistit -- nihil actum est."
    else
      git init
      git config user.email "{{email}}"
      git config user.name "{{name}}"
      echo "Repositorium initiatum est."
    fi

## Instruit hooks pre-commit (probatio commentariorum Latinorum) in
## .githooks/, quia .git/hooks/ ipsum numquam per Git communicatur.
setup-hooks:
    chmod +x .githooks/pre-commit .githooks/check-latin.sh
    git config core.hooksPath .githooks
    @echo "core.hooksPath -> .githooks. Hooks activati sunt."

## Committit primum: "Sic Mundus Creatus Est", secundum consuetudinem
## huius operis. Requirit .gitattributes et filtrum iam instructa esse.
first-commit:
    git add .
    git commit -m "Sic Mundus Creatus Est"
    @echo "Primum commit factum est."


# ---------------------------------------------------------------------------
# Gradus V -- GitHub: creatio repositorii et missio (push)
# ---------------------------------------------------------------------------

## Creat repositorium privatum in GitHub per "gh" CLI, et addit
## "origin" automatice. Requirit "gh auth login" iam factum esse.
gh-create-repo:
    gh repo create {{repo_name}} --private --source=. --remote=origin
    @echo "Repositorium creatum: https://github.com/$(gh api user --jq .login)/{{repo_name}}"

## Renominat ramum principalem in "main" (si adhuc "master" est) et
## mittit ad "origin", constituens "upstream" pro futuris push simplicibus.
push:
    git branch -M main
    git push -u origin main

## Gradus V totus, in ordine: crea repositorium, deinde mitte.
publish: gh-create-repo push

# ---------------------------------------------------------------------------
# Gradus VI -- Repomix: colligit totum codicem in unum tabularium,
# aptum ad contextum magnorum exemplarium linguae (LLM).
# ---------------------------------------------------------------------------

## Exsequitur "repomix" per npx (nullam instructionem permanentem
## requirit), excludendo artefacta aedificationis et res Nix.
repomix:
    npx --yes repomix@latest \
        --output repomix-output.md \
        --ignore "dist-newstyle/**,.direnv/**,result,result-*,*.jsonl"
    @echo "repomix-output.md creatum est -- aptum ad LLM tradendum."

# ---------------------------------------------------------------------------
# Gradus VII -- Series tota, ab initio, uno mandato
# ---------------------------------------------------------------------------

## Totam seriem instructionis exsequitur, ab Nix usque ad GitHub --
## PRAETER install-nix, enable-flakes, et git-init, quae terminal novum
## vel argumenta propria (email, nomen) requirunt et ideo seorsum
## vocanda sunt prius quam hoc mandatum.
##
## NOTANDUM: hoc mandatum praesupponit git-init iam factum esse.
bootstrap: build setup-latinize setup-hooks first-commit gh-create-repo push
    @echo "Bootstrap completus est. Sic Mundus Creatus Est."

# ---------------------------------------------------------------------------
# Gradus VIII -- Situs (site/): pagina una, in Gleam scripta
# ---------------------------------------------------------------------------

## Aedificat situm in site/dist: formam codicis probat, probationes
## exsequitur, deinde paginam scribit. Instrumenta ex site/flake.nix
## veniunt (h0ffmann/picasso, labs/gleam-website), in site/flake.lock fixa.
site:
    nix develop --extra-experimental-features 'nix-command flakes' --no-update-lock-file ./site --command just _site

_site:
    cd site && gleam format --check src test && gleam test
    cd site && rm -rf dist && mkdir -p dist && gleam run -m nashkell_site/prerender --no-print-progress > dist/index.html && cp -R static/. dist/
    cp book/nashkell.pdf site/dist/nashkell.pdf
    @echo "site: site/dist"

# ---------------------------------------------------------------------------
# Gradus IX -- Probationes (eaedem in CI): textus, notae, licentiae
# ---------------------------------------------------------------------------

md := "nix develop --extra-experimental-features 'nix-command flakes' --no-update-lock-file ./site#md --command"

## Tres analysatores super omnia tabularia Markdown: structura, verba, nexus.
## `just md-quality --online` etiam nexus interretiales probat.
md-quality *args:
    {{md}} scripts/md-quality.sh {{args}}

## Notae (notes/) suas regulas servant.
notes:
    scripts/notes-check.sh

## Omne tabularium licentiam et auctorem habet (REUSE.toml).
reuse:
    {{md}} reuse lint

## Quod CI exsequitur, ante petitionem (pull request) vocandum.
check:
    just refs
    just md-quality --self-test
    just md-quality
    just notes
    just reuse

# ---------------------------------------------------------------------------
# Gradus X -- Liber apertus (book/): "Nashkell: Rizomatic experiments"
# ---------------------------------------------------------------------------

paper := "nix develop --extra-experimental-features 'nix-command flakes' --no-update-lock-file ./site#paper --command"

## Librum in book/nashkell.pdf scribit, per pandoc et XeLaTeX ex officina "paper"
## operis picasso. Pictura frontis ex site/static/drawings/matrix.svg fit.
book:
    {{paper}} just _book book/nashkell.pdf

_book out:
    mkdir -p build/book "$(dirname "{{out}}")"
    rsvg-convert -f pdf -o build/book/cover.pdf site/static/drawings/matrix.svg
    cd book && TEXINPUTS="../build/book:" pandoc book.md \
      --from markdown --citeproc --bibliography refs.bib --metadata link-citations=true \
      --lua-filter ../format/title.lua --pdf-engine=xelatex --fail-if-warnings \
      -H ../format/header.tex -V geometry:margin=2.6cm -V fontsize=11pt -V colorlinks=true \
      -V linkcolor=bookred -V urlcolor=bookred -V citecolor=bookred \
      --resource-path=.:../build/book -o "$OLDPWD/{{out}}"
    @echo "book: {{out}}"

## Omnis clavis refs.bib lineam in book/REFERENCES.md habet, et liber eam citat.
refs:
    for k in $(grep -oE '^@[a-z]+\{[^,]+' book/refs.bib | cut -d'{' -f2); do grep -q "\`$k\`" book/REFERENCES.md || { echo "refs: $k has no row in book/REFERENCES.md" >&2; exit 1; }; done
    for k in $(grep -oE '^@[a-z]+\{[^,]+' book/refs.bib | cut -d'{' -f2); do grep -q "@$k\b" book/book.md || { echo "refs: $k is in refs.bib and the book does not cite it" >&2; exit 1; }; done
    @echo "refs: every entry of book/refs.bib has a row and is cited"

## Liber commissus idem est ac quem textus facit: verba duorum comparantur.
current:
    {{paper}} just _current

_current:
    [ -f book/nashkell.pdf ] || { echo "current: book/nashkell.pdf is not committed; run just book" >&2; exit 1; }
    just _book build/book/nashkell.pdf
    diff <(pdftotext book/nashkell.pdf -) <(pdftotext build/book/nashkell.pdf -) >/dev/null || { echo "current: book/nashkell.pdf was not made from this text; run just book and commit it" >&2; exit 1; }
    @echo "current: book/nashkell.pdf is the one its text makes"
