#!/bin/bash

# mltypkg - Multi Package Manager CLI

# Function to detect the package manager
get_pkg_manager() {
    echo "Which package manager would you like to use?"
    echo "1) npx"
    echo "2) yarn"
    echo "3) pnpm"
    echo "4) npm"
    echo "5) bun"
    read -p "Enter the number corresponding to your choice: " choice

    case $choice in
        1)
            pkg_manager="npx";;
        2)
            pkg_manager="yarn";;
        3)
            pkg_manager="pnpm";;
        4)
            pkg_manager="npm";;
        5)
            pkg_manager="bun";;
        *)
            echo "Invalid choice. Defaulting to npx." >&2
            pkg_manager="npx";;
    esac

    # Check if the chosen package manager is installed
    if ! command -v $pkg_manager &> /dev/null; then
        echo "$pkg_manager is not installed. Installing..."
        if command -v npm &> /dev/null; then
            npm install -g $pkg_manager
        else
            echo "Error: npm is required to install $pkg_manager." >&2
            exit 1
        fi
    fi

    echo "$pkg_manager"
}

# Function to create a new project
create_project() {
    local cmd="$1"
    shift
    local pkg_manager=$(get_pkg_manager)

    echo "Using package manager: $pkg_manager"
    echo "Running a quick joke to lighten the mood..."
    echo "Why do programmers prefer dark mode? Because light attracts bugs!"

    case $pkg_manager in
        npx|npm)
            $pkg_manager $cmd "$@"
            ;;
        yarn)
            $pkg_manager create "$cmd" "$@"
            ;;
        pnpm)
            $pkg_manager create "$cmd" "$@"
            ;;
        bun)
            $pkg_manager create "$cmd" "$@"
            ;;
        *)
            echo "Unsupported package manager." >&2
            exit 1
            ;;
    esac
}

# Function to run project commands
development_mode() {
    local pkg_manager=$(get_pkg_manager)

    echo "Starting development mode with $pkg_manager"
    echo "Why do Java developers wear glasses? Because they don’t C#!"

    case $pkg_manager in
        npm|npx|pnpm|yarn|bun)
            $pkg_manager run dev
            ;;
        *)
            echo "Unsupported package manager." >&2
            exit 1
            ;;
    esac
}

build_project() {
    local pkg_manager=$(get_pkg_manager)

    echo "Building project with $pkg_manager"
    echo "There are 10 types of people in the world: those who understand binary and those who don’t."

    case $pkg_manager in
        npm|npx|pnpm|yarn|bun)
            $pkg_manager run build
            ;;
        *)
            echo "Unsupported package manager." >&2
            exit 1
            ;;
    esac
}

# Function to install additional packages
add_package() {
    local cmd="$1"
    shift
    local pkg_manager=$(get_pkg_manager)

    echo "Using package manager: $pkg_manager"
    echo "Here’s a quick one: Debugging is like being the detective in a crime movie where you are also the murderer."

    case $pkg_manager in
        npx|pnpm|bun)
            $pkg_manager dlx $cmd "$@"
            ;;
        yarn)
            $pkg_manager dlx $cmd "$@"
            ;;
        npm)
            npx $cmd "$@"
            ;;
        *)
            echo "Unsupported package manager." >&2
            exit 1
            ;;
    esac
}

# Function to install mltypkg itself
install_mlty() {
    echo "Installing mltypkg..."
    chmod +x "$0"
    cp "$0" /usr/local/bin/mlty
    echo "mltypkg installed successfully."
}

# CLI Argument Parsing
case $1 in
    create)
        shift
        create_project "$@"
        ;;
    add)
        shift
        add_package "$@"
        ;;
    dev)
        development_mode
        ;;
    build)
        build_project
        ;;
    install)
        install_mlty
        ;;
    *)
        echo "Unknown command. Available commands:"
        echo "  create    Create a new project"
        echo "  add       Add a package to the project"
        echo "  dev       Start the project in development mode"
        echo "  build     Build the project"
        echo "  install   Install mltypkg itself"
        exit 1
        ;;
esac
