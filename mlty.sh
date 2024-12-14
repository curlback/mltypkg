#!/bin/bash

# mltypkg - Multi Package Manager CLI

# Array of programmer-related jokes
jokes=(
    "Why do programmers prefer dark mode? Because light attracts bugs!"
    "How many programmers does it take to change a light bulb? None, that's a hardware problem."
    "Why do Java developers wear glasses? Because they don’t C#!"
    "What is a programmer's favorite hangout place? Foo Bar."
    "There are 10 types of people in the world: those who understand binary and those who don’t."
)

# Function to fetch a random joke
fetch_joke() {
    echo "${jokes[RANDOM % ${#jokes[@]}]}"
}

# Function to detect installed package managers
list_installed_pkg_managers() {
    local available_pkg_managers=()
    for manager in npx npm pnpm yarn bun; do
        if command -v $manager &> /dev/null; then
            available_pkg_managers+=("$manager")
        fi
    done
    echo "${available_pkg_managers[@]}"
}

# Function to ask the user for a package manager
get_pkg_manager() {
    echo "Which package manager would you like to use?"
    options=("npm" "pnpm" "yarn" "bun" "npx" "Default (first installed)")

    select choice in "${options[@]}"; do
        case $choice in
            "npm")
                echo "You chose npm!"
                pkg_manager="npm"
                break
                ;;
            "npx")
                echo "You chose npx!"
                pkg_manager="npx"
                break
                ;;
            "pnpm")
                echo "You chose pnpm!"
                pkg_manager="pnpm"
                break
                ;;
            "yarn")
                echo "You chose yarn!"
                pkg_manager="yarn"
                break
                ;;
            "bun")
                echo "You chose bun!"
                pkg_manager="bun"
                break
                ;;
            "Default (first installed)")
                # Detect installed package managers if "Default" is selected
                local installed_managers=( $(list_installed_pkg_managers) )

                if [ ${#installed_managers[@]} -eq 0 ]; then
                    echo "No package managers detected on your system. Exiting." >&2
                    exit 1
                fi

                echo "Defaulting to the first installed package manager: ${installed_managers[0]}"
                pkg_manager="${installed_managers[0]}"
                break
                ;;
            *)
                echo "Invalid choice. Please choose a valid option."
                ;;
        esac
    done

    # Always show a joke after the user's choice
    echo "Here's a joke to lighten the mood:"
    fetch_joke
}

# Function to create a new project
create_project() {
    get_pkg_manager

    echo "Using package manager: $pkg_manager"
    echo "Running a quick joke to lighten the mood..."
    fetch_joke

    local cmd="$1"
    shift

    case $pkg_manager in
        npx)
            # npx is used to execute commands directly
            $pkg_manager $cmd "$@"
            ;;
        npm)
            # npm create is used to create a project (npm init)
            $pkg_manager create "$cmd" "$@"
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
    get_pkg_manager

    echo "Starting development mode with $pkg_manager"
    fetch_joke

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
    get_pkg_manager

    echo "Building project with $pkg_manager"
    fetch_joke

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
    get_pkg_manager

    echo "Using package manager: $pkg_manager"
    fetch_joke

    case $pkg_manager in
        npx)
            # npx is used for executing binaries without installing them
            $pkg_manager $cmd "$@"
            ;;
        pnpm|bun|yarn)
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
