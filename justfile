set shell := ["bash", "-c"]
set quiet

currentUser := `whoami`
currentHost := `hostname`

default:
    just --choose || just --list

switch host=currentHost user=currentUser: (rebuild "switch" host user)

rebuild method="switch" host=currentHost user=currentUser: format && (rebuild-system method host) (rebuild-home user host)
    #!/usr/bin/env bash
    isolate_command "\
        echo 'ensuring home manager has no issues before switching nixos';\
        echo 'home-manager instantiate';\
        home-manager switch -n --flake '.#{{ user }}@{{ host }}'\
    "
    exit_code="${PIPESTATUS[0]}"
    mv isolated.log home-manager-instantiate.log

    test "$exit_code" -eq 0 || exit $exit_code

rebuild-system method="switch" host=currentHost: format
    #!/usr/bin/env bash
    echo "Rebuilding NixOS..."
    
    if command -v "isolate_command" &> /dev/null; then 
        isolate_command "\
            echo 'sudo nixos-rebuild {{method}}';\
            sudo nixos-rebuild {{method}} --flake '.#{{ host }}' \
        "
        exit_code="${PIPESTATUS[0]}"
        mv isolated.log nixos.log
    else
        # Fallback if isolate_command is not present (i.e. on first install)
        echo "sudo nixos-rebuild {{method}}"
        sudo nixos-rebuild {{method}} --flake '.#{{ host }}' 2>&1 | tee nixos.log
        exit_code="${PIPESTATUS[0]}"
    fi
    
    if [[ $(cat nixos.log) =~ "authentification failed" ]]; then
        echo "Authentification failed!"
        exit 1
    fi

    if [[ $(cat nixos.log) =~ "Exited due to user input" ]]; then
        # Error message handled by isolate_command
        exit 1
    fi
    
    if [[ $exit_code != 0 ]]; then
        echo "NixOS rebuild failed with exit code \`$exit_code\` (log in nixos.log)"
        cat nixos.log | less
        exit $exit_code
    fi

rebuild-home user=currentUser host=currentHost: format
    #!/usr/bin/env bash
    echo "Rebuilding Home Manager..."
    
    if command -v "isolate_command" &> /dev/null; then 
        isolate_command "\
            echo 'home-manager switch';\
            home-manager switch --flake '.#{{ user }}@{{ host }}'\
        "
        exit_code="${PIPESTATUS[0]}"
        mv isolated.log home-manager.log
    else
        # Fallback if isolate_command is not present (i.e. on first install)
        echo 'home-manager switch'
        home-manager switch --flake '.#{{ user }}@{{ host }}' 2>&1 | tee home-manager.log
        exit_code="${PIPESTATUS[0]}"
    fi

    # Check output
    if [[ $(cat home-manager.log) =~ "Suggested commands:" ]]; then
        echo "Additional actions may be required"
        cat home-manager.log | grep -i '^systemctl' | sed 's/^/• /'
    fi

    if [[ $(cat home-manager.log) =~ "Exited due to user input" ]]; then
        # Error message handled by isolate_command
        exit 1
    fi
    
    if [[ $exit_code != 0 ]]; then
        echo "Home Manager switch failed with exit code \`$exit_code\` (log in home-manager.log)"
        cat home-manager.log | less
        exit $exit_code
    fi

# Update specific inputs and rebuild
update: update-all && rebuild

# Update only some specific flake inputs
update-only:
    @nix flake update nixpkgs home-manager nixpkgs-unstable firefox-extensions

# Update all flake inputs
update-all:
    @nix flake update

format:
    echo "Formatting ..."
    alejandra . &> alejandra.log || (echo "Formatting failed! Error:"; cat alejandra.log | sed 's/^/  /'; exit 1)

check: format
   nix flake check 

# Collect store garbage
clean-light:
    sudo nix-collect-garbage
    nix-collect-garbage
    nix-store --optimise -v

# Delete generations then collect garbage
clean: && clean-light
    nix-env --delete-generations +10
    home-manager expire-generations 5d

# contains various subcommands for manipulating rc2nix and plasma manager
plasma operation="help":
    #! /usr/bin/env nix
    #! nix shell github:nix-community/plasma-manager#rc2nix nixpkgs#alejandra --command bash
    
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
    
    format_config()
    {
        TEXT_INNER="[[:alpha:]_][[:alnum:]_-]*?"
        cat - \
          | sed -E 's/"('"$TEXT_INNER"')"(\.)/\1\2/g' \
          | sed -E 's/(\.)"('"$TEXT_INNER"')"/\1\2/g' \
          | alejandra --quiet
    }
    
    OLD_CONFIG_FD="/dev/null"
    if [[ -f ./.plasmaconfig-cache.nix ]]; then
        OLD_CONFIG_FD=<(cat "./.plasmaconfig-cache.nix" | format_config)
    fi
    
    
    CONFIG=$(echo "$CONFIG" | format_config)
    
    show_diff()
    {
        echo "$CONFIG" | diff "$OLD_CONFIG_FD" - -u -s --color -b
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
            echo "This is showing the difference between .plasmaconfig-cache.nix and the applied config"
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
