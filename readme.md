# Nano CI CD mono repo


- [Nano CI CD mono repo](#nano-ci-cd-mono-repo)
- [Build image](#build-image)
- [Build process](#build-process)
  - [Buildkit](#buildkit)
- [First steps](#first-steps)
- [Build commands](#build-commands)
  - [Initial setup](#initial-setup)
  - [Update submodules](#update-submodules)

# Build image

```bash
# build image (dev)
docker buildx build --progress plain -t aa/bb .
docker run -p 7000:8090 aa/bb

# onliner
git submodule update --recursive --remote &&  docker buildx build --progress plain -t aa/bb . && docker run -p 7000:8090 aa/bb
```

# Build process

## Buildkit

We are using docker with buildkit to speed up our build time

https://docs.docker.com/build/buildkit/



# First steps
```bash
sudo mkdir -p /var/cache/docker/go-build
sudo mkdir -p /var/cache/docker/node_modules
```

# Build commands

```bash
docker buildx build -t aa/bb .
docker buildx build \
--progress plain \
-t aa/bb .
```

## Initial setup

```bash
# commands used to connect the submodules
git submodule deinit --force frontend
git submodule deinit --force backend

rm -rf frontend
rm -rf backend

git submodule add git@github.com:NotNullDev/nano-management-mantine.git frontend

git submodule add git@github.com:NotNullDev/nano-management-backend.git backend
```

## Update submodules

```bash
# to update the submodules
git submodule update --recursive --remote
```