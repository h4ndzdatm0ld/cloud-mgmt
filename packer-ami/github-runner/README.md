# Packer Builds

The packer builds are ran by a docker container. The plugin location is specified as an `env` variable which is on a mounted directory.

## Creating Build Example

- Init

`docker-compose run packer init packer-ami/github-runner/`

- Build

`docker-compose run packer build packer-ami/github-runner/`

## Scripts

Scripts will be located in a `scripts` directory in their corresponding build folder.
