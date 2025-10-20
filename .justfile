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

# Linting recipes

# Lint code using RuboCop
[positional-arguments]
@lint-rubocop *args=justfile_directory():
    bundle exec rubocop -S "$@"

# Lint code using Herb
[positional-arguments]
@lint-herb *args=justfile_directory():
    npm run herb:lint "$@"
    npm run herb:format -- --check --indent-width 3 --max-line-length 120 "$@"

# Lint code using Biome
[positional-arguments]
@lint-biome *args=justfile_directory():
    npm run biome:check "$@"

# Lint code using Prettier
@lint-prettier:
    npm run prettier -- --check "**/*.md" "**/*.toml" "**/*.yml"

# Formatting recipes

# Format code using RuboCop
[positional-arguments]
@format-rubocop *args=justfile_directory():
    bundle exec rubocop -S -a "$@"

# Format code using Herb
[positional-arguments]
@format-herb *args=justfile_directory():
    npm run herb:format -- --indent-width 3 --max-line-length 120 "$@"

# Format code using Biome
[positional-arguments]
@format-biome *args=justfile_directory():
    npm run biome:check -- --fix "$@"

# Format code using Prettier
@format-prettier:
    npm run prettier -- --write "**/*.md" "**/*.toml" "**/*.yml"
