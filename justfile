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
image_default := "golden/sample.png"
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
run image=image_default:
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

## Committit id quod iam "staged" est per instrumentum biblicum, quod
## phrasin Latinam eligit secundum naturam mutationis (creatio,
## purificatio, transfiguratio, apocalypsis, vel genesis generalis).
sic pool="":
    bash tools/biblical-commit.sh {{pool}}

## Ostendit omnes categorias phrasium biblicarum et numerum earum.
sic-list:
    bash tools/biblical-commit.sh --list

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