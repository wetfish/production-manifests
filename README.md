# production-manifests
contains traefik config and submodules for docker compose based deployments

This branch of the repo helps you setup a devopment enviroment \
that is a close replica of the production setup.

## How do I get started?

```bash
# install docker and docker-compose-plugin
# create traefik backend network
docker network create traefik-backend

# clone the repo (recursivly)

mkdir ~/repos
cd ~/repos

export REPO_DIR="$(cd "$HOME/repos" || exit 1; pwd)/production-manifests"

git clone \
  --branch development_environment_setup \
  --single-branch \
  --recursive \
  --recurse-submodules \
  https://github.com/wetfish/production-manifests.git \
  $REPO_DIR

# hack at the code
cd $REPO_DIR/blog
$EDITOR README.md

# test your changes
# first bring up traefik
cd $REPO_DIR/traefik
docker compose up -d

# then bring up whichever project you just edited
cd $REPO_DIR/blog
docker compose up -d --build --force-recreate && docker compose logs -f

# commit your changes
cd $REPO_DIR/blog
git commit -m "herp derp"
git push

# once accepted upstream, update the metarepo
cd $REPO_DIR
git commit -am "bump blog"
git push
```

## How is this structured:
```yaml
# ingress proxy
# config local to this repo
services/traefik:
  - traefik

# https://github.com/wetfish/blog
services/blog:
  - blog-web
  - blog-db

```