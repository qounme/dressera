# Show available recipes and usage instructions
@default:
    echo 'Usage: just [recipe]'
    echo ''
    just --list --unsorted

# Container recipes

image := "dressera-dev"
mount_option := "type=bind,source=" + justfile_directory() + ",target=/rails"

# Run the development container
@run:
    docker run -it --rm -p 3000:3000 --mount {{ mount_option }} --name dressera {{ image }}

# Build the Docker image for development
@build:
    docker build -f {{ join(justfile_directory(), "Dockerfile.dev") }} -t {{ image }} {{ justfile_directory() }}

# Run command in container
[positional-arguments]
@container +args:
    docker run --rm --mount {{ mount_option }} {{ image }} "$@"

# Run rails command in container
[positional-arguments]
@container-rails +args:
    just container bin/rails "$@"
