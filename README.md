# Readme

Code samples for https://hans-pistor.tech/posts/getting-started-with-firecracker/

Make sure your host & user have access to KVM
```sh
./download-files.sh
rm -f /tmp/firecracker.socket \
&& firecracker \
--api-sock /tmp/firecracker.socket \
--config-file ./vmconfig.json
```