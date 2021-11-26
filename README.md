| ⚠ **WARNING**: This image is obsolete as [rubensa/ubuntu-tini-dev](https://github.com/rubensa/docker-ubuntu-tini-dev) now includes [nvm](https://github.com/nvm-sh/nvm). |
| --- |

# Node Version Manager image for local development

This image provides a [Node Version Manager](https://github.com/nvm-sh/nvm) environment useful for local development purposes.
This image is based on [rubensa/ubuntu-dev](https://github.com/rubensa/docker-ubuntu-dev) so you can set internal user (developer) UID and internal group (developers) GUID to your current UID and GUID by providing that info means of "-u" docker running option.

## Running

You can interactively run the container by mapping current user UID:GUID and working directory.

```
docker run --rm -it \
	--name "nvm-dev" \
	-v $(pwd):/home/developer/work \
	-w /home/developer/work \
	-u $(id -u $USERNAME):$(id -g $USERNAME) \
	--group-add nvm \
	rubensa/nvm-dev
```

This way, any file created in the container initial working directory is written and owned by current host user:group launching the container (and the internal "nvm" group is added to keep access to shared "/opt/nvm" folder where nvm is installed).
