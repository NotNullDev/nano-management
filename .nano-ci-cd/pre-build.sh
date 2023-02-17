mkdir /root/.ssh/

cat <<eof > /test
echo $SSH_PRIVATE_KEY | base64 -d > /root/.ssh/id_rsa
eof

chmod 400 /root/.ssh/id_rsa
ssh-keyscan github.com >> /root/.ssh/known_hosts

git submodule update --recursive --remote

echo $CONTAINER_REGISTRY_PASSWORD | docker login -u $CONTAINER_REGISTRY_USERNAME --password-stdin $CONTAINER_REGISTRY_URL