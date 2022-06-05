<span class="badge-opencollective"><a href="https://github.com/ZarTek-Creole/DONATE" title="Donate to this project"><img src="https://img.shields.io/badge/open%20collective-donate-yellow.svg" alt="Open Collective donate button" /></a></span>
[![CC BY 4.0][cc-by-shield]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg
# EggNet Vs eggdrop docker
Why use eggnet instead of eggdrop docker?

EggNet is designed for the use of multiple robots automatically linking together.
Eggdrop is for the use of a robot only for its simple use.

EggNet allows you to add additional system packages easily during its build, like tcllib, tcl-tls, mysqltcl, ..

EggNet compiles only eggdrop modules necessary for space saving and increased performance.

EggNet allows you to customize the ./configuration command during compilation.

EggNet makes it easy for you to load scripts with a structure designed for multi-robot use

EggNet uses a screen in its image that allows you to access from your host machine to enrich the use in addition to access to the partyline.

EggNet offers you logs of different types: script error, usual logfile, screen
..

[The comparative](github.com/ZarTek-Creole/EggNet-Docker/wiki/Comparative)

# Support
If you have any remarks, suggestions, ideas, bugs, you can send them to me via the issue form:

Si vous avez des remarques, des suggestions, des idées, des bogues vous pouvez me les faire parvenir via le formulaire issues:
* github.com/ZarTek-Creole/EggNet-Docker/issues

# Prerequisites
* [Docker](https://docs.docker.com/get-docker)
* [Docker Compose](https://docs.docker.com/compose/install)


# Docs
* [Frequently Asked Questions](github.com/ZarTek-Creole/EggNet-Docker/wiki/FAQ)
* [Pre-requisites](github.com/ZarTek-Creole/EggNet-Docker/wiki/Prerequisites)
* [Installation](github.com/ZarTek-Creole/EggNet-Docker/wiki/Installation)
* [Configuration](github.com/ZarTek-Creole/EggNet-Docker/wiki/Configuration)
* [Usage](github.com/ZarTek-Creole/EggNet-Docker/wiki/Usage)
* [Contributions](github.com/ZarTek-Creole/EggNet-Docker/wiki/Contributions)

# Download | Téléchargement
## With GIT | Avec GIT:
`git clone github.com/ZarTek-Creole/EggNet-Docker.git /path/to/install`

## With WGET | Avec WGET :
```bash
wget github.com/ZarTek-Creole/EggNet-Docker/archive/refs/heads/master.zip -O /path/to/install/EggNet-Docker.zip
cd /path/to/install/
unzip -x EggNet-Docker.zip
rm EggNet-Docker.zip
```

# How to try it? | Comment l'essayer?
```bash
cd EggNet-Docker
cp examples/develop/docker-compose.yml .
docker-compose up -d
```

# Donation
If you like the code or the work done, you can make a donation to encourage:

Si le code ou le travail accomplit vous plaît, vous pouvez faire une donation pour m'encourager :
* https://ko-fi.com/ZarTek
* github.com/ZarTek-Creole/DONATE

# Thank's | Merci
Thanks to the various people who made the script possible

Merci aux différentes personnes qui ont permis la réalisation du script


# Contributions
All contributions are welcome!

Toute contribution est la bienvenue!

# Website
Official website of the EggNet-Docker script:

Site internet officiel du script EggNet-Docker:
* github.com/ZarTek-Creole/EggNet-Docker


# Author | Auteur
ZarTek @ github.com/ZarTek-Creole
