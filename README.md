# Dressera

A Ruby on Rails application for managing wardrobe and outfit coordination.

## Requirements

* Docker
* just (optional, but recommended for easier command execution)

## Ruby and Rails Version

* Ruby 3.3.9
* Rails 8.0.3

## Development Environment Setup

This project uses Docker for development to ensure a consistent environment across different machines.

### Quick Start

#### Using just (Recommended)

1. Clone the repository
```bash
git clone <repository-url>
cd dressera
```

2. Build the Docker image
```bash
just build
```

3. Run the application
```bash
just run
```

4. Access the application at http://localhost:3000

#### Using Docker directly

1. Clone the repository
```bash
git clone <repository-url>
cd dressera
```

2. Build the Docker image
```bash
docker build -f Dockerfile.dev -t dressera-dev .
```

3. Run the application
```bash
docker run -it --rm -p 3000:3000 --mount type=bind,source=$(pwd),target=/rails --name dressera dressera-dev
```

4. Access the application at http://localhost:3000

### Configuration Files

* `.railsrc` - Rails application generator options
* `Dockerfile.dev` - Development environment Docker configuration
* `Procfile.dev` - Development processes (Rails server and Tailwind CSS watcher)

## Database

This project uses SQLite3 for development. The database is automatically created and initialized when the Docker container starts via the `bin/docker-entrypoint` script.

## Services

* **Tailwind CSS** - Utility-first CSS framework with automatic compilation via `bin/rails tailwindcss:watch`
* **Importmap** - JavaScript module management without bundling
* **Turbo & Stimulus** - Hotwire framework for building modern web applications

## Development

The development server runs with live reloading for both Ruby code and CSS changes. The `bin/dev` command starts both the Rails server and the Tailwind CSS watcher using Foreman.

### Adding New Gems

If you need to add new gems, you'll need to rebuild the Docker image after updating the Gemfile:

```bash
docker build -f Dockerfile.dev -t dressera-dev .
```
