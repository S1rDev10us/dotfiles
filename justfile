set shell := ["sh", "-c"]
set quiet

currentUser := `whoami`
currentHost := `hostname`

default:
    just --choose || just --list

switch host=currentHost user=currentUser: (rebuild "switch" host user)

rebuild method="switch" host="{{ currentHost }}" user="{{ currentUser }}": (rebuild-system method host) (rebuild-home user host)

rebuild-system method="switch" host=currentHost: format
    sudo nixos-rebuild {{method}} --flake '.#{{ host  }}'

rebuild-home user=currentUser host=currentHost: format
    home-manager switch --flake '.#{{ user }}@{{ host }}'

# Update specific inputs and rebuild
update: update-all && rebuild

# Update only some specific flake inputs
update-only:
    @nix flake update nixpkgs home-manager nixpkgs-unstable firefox-extensions

# Update all flake inputs
update-all: && rebuild
    @nix flake update

format:
    echo "Formatting ..."
    alejandra . &> alejandra.log || (echo "Formatting failed! Error:"; cat alejandra.log | sed 's/^/  /'; exit 1)

check: format
   nix flake check 

clean-light:
    nix-collect-garbage
    nix-store --optimise -v

clean: && clean-light
    nix-env --delete-generations +10
    home-manager expire-generations 5d

# contains various subcommands for manipulating rc2nix and plasma manager
plasma operation="help":
    #! /usr/bin/env nix
    #! nix shell github:nix-community/plasma-manager#rc2nix --command bash

    CONFIG=$(rc2nix)

    exclusions=(
        'kate/anonymous\.katesession'
        '"spectaclerc"\."ImageSave"\."lastImageSaveLocation"'
        '"spectaclerc"\."ImageSave"\."lastImageSaveAsLocation"'
        "plasmanotifyrc.*Seen"
        "LastVirtualDesktop"
        "katerc"
        "kcminputrc"
        "Latitude"
        "Longitude"
        baloofilerc
        '"kwinrc"\."Tiling'
        '"kdeglobals"\."DirSelect Dialog"'
        '"kdeglobals"\."KScreen"\."ScreenScaleFactors"'
    )

    for exclusion in "${exclusions[@]}"; do
        CONFIG=$(echo "$CONFIG" | grep -v "$exclusion")
    done

    OLD_CONFIG_FD="/dev/null"
    if [[ -f ./.plasmaconfig-cache.nix ]]; then
        OLD_CONFIG_FD="./.plasmaconfig-cache.nix"
    fi

    show_diff()
    {
        echo "$CONFIG" | diff "$OLD_CONFIG_FD" - -u -s --color --ignore-all-space
    }
    
    case '{{ operation }}' in
        "diff")
            show_diff
            ;;
        "commit")
            show_diff
            echo "$CONFIG" > ./.plasmaconfig-cache.nix
            ;;
        "diff-applied")
            OLD_CONFIG_FD=<(echo "$CONFIG") CONFIG=$(cat modules/home/windowManager/KDE.nix) show_diff
            echo "This is showing the difference between the applied and the current system config"
            ;;
        "diff-applied-cached")
            CONFIG=$(cat modules/home/windowManager/KDE.nix) show_diff
            echo "This is showing the difference between the applied and .plasmaconfig-cache.nix"
            ;;
        "help")
            cat <<EOF
    > just plasma help

    Usage: just plasma SUBCOMMAND
    Contains various subcommands for manipulating rc2nix and plasma manager

    \`> just plasma diff\` shows the diff between the current system config and a cached config
    \`> just plasma commit\` updates the current cached config
    \`> just plasma diff-applied\` shows the diff between the current system config and the manually managed \`modules/home/windowManager/KDE.nix\`
    \`> just plasma diff-applied-cached\` shows the diff between the cached config and the manually managed \`modules/home/windowManager/KDE.nix\`
    EOF
            ;;
        *)
            echo 'operation "{{ operation }}" is invalid. please use diff or commit'
            echo
            just plasma help
            exit 1
            ;; 
    esac
    exit 0
