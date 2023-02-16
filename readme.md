# Nano CI CD mono repo


```bash
# command used to connect the submodules
git submodule add git@github.com:NotNullDev/nano-management-svelte.git frontend

git submodule add git@github.com:NotNullDev/nano-management-backend.git backend
```

```bash
# to update the submodules
git pull --recurse-submodules --jobs=10
```