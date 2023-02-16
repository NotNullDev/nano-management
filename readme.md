# Nano CI CD mono repo


```bash
# command used to connect the submodules
git submodule deinit --force frontend
git submodule deinit --force backend

rm -rf frontend
rm -rf backend

git submodule add git@github.com:NotNullDev/nano-management-mantine.git frontend

git submodule add git@github.com:NotNullDev/nano-management-backend.git backend
```

```bash
# to update the submodules
git submodule update --recursive --remote
git pull --recurse-submodules --jobs=10
```


```bash
# build image (dev)
docker build -t aa/bb .
docker run -p 7000:8090 aa/bb

```