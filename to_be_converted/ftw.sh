#!/bin/sh

_ftw_evaluate() {
    if [ -f $HOME/.ftwrc ]; then
        source $HOME/.ftwrc
    fi

    REPO_FILE=${FTW_REPO_FILE:-$HOME/.ftw_repos}
    BASE_DIR=${FTW_BASE_DIR:-$HOME/src/4teamwork}
    PROTO=${FTW_PROTO:-"ssh"}
    API_TOKEN=${FTW_API_TOKEN}
    USERNAME=${FTW_USERNAME}
    INFER_FTW=${FTW_INFER_FTW}
}

_ftw_update() {
    echo "Updating repo cache..."

    my_curl="curl -ssL"
    if [ -n "$API_TOKEN" ] && [ -n "$USERNAME" ]; then
        my_curl="curl -u $USERNAME:$API_TOKEN -ssL"

        echo "Authenitcation with $USERNAME"
    fi

    printf "Get toal number of repos..."
    org_info=$($my_curl "https://api.github.com/orgs/4teamwork")
    public_total=$(echo "$org_info" | tr "\n" " " | sed -E 's/.*"public_repos": ?([[:digit:]]+).*/\1/g')
    case "$org_info" in
        *total_private_repos*)
            private_total=$(echo "$org_info" | tr "\n" " " | sed -E 's/.*"total_private_repos": ?([[:digit:]]+).*/\1/g')
            total=$(("$public_total" + "$private_total"))
            ;;
        *)
            total=$public_total
            echo "No authentication or authentication failed."
    esac
    printf "%s\n" "$total"

    echo "" > "$REPO_FILE"
    page=1
    while :; do
        printf "Getting page %s..." "$page"
        repos_names=$($my_curl "https://api.github.com/orgs/4teamwork/repos?sort=full_name&page=$page&per_page=100" | grep "^    \"name\"" | sed -E 's/ *"name":[^"]+"([^"]+).*/\1/g')
        if [ -z "$repos_names" ]; then
            printf "[END]\n"
            return 0
        fi

        page=$((page+1))

        echo "${repos_names}" >> "$REPO_FILE"
        printf "[OK]\n"
    done
}

_ftw_list() {
    cat "$REPO_FILE"
}

_ftw_goto() {
    repo="$1"

    infered="ftw.$(echo "$repo" | sed 's/^ftw\.//g')"
    if [ -n "$INFER_FTW" ] && _ftw_list | grep -q "^$infered$"; then
        repo="$infered"
    fi

    local_path="$BASE_DIR/$repo"

    if [ ! -d "$local_path" ]; then
        if [ "$PROTO" = "ssh" ]; then
            git clone "git@github.com:/4teamwork/$repo.git" "$local_path"
        else
            git clone "https://github.com/4teamwork/$repo.git" "$local_path"
        fi
    fi

    cd "$local_path" || return
}

_ftw_help() {
    cat <<EOM
FTW: Automatically clone repo and cd into it

Usage:
  ftw repo
  ftw -h | --help
  ftw -u | --update
  ftw -l | --list

Options:
 -h --help          Show this help message
 -u --update        Update repo cache
 -l --list          List repos from cache

Settings:
These settings can also be defined in "$\HOME/.ftwrc".

FTW_REPO_FILE       Cache file for the repos. Default: \$HOME/.ftw_repos
FTW_BASE_DIR        Where the repos are cloned to. Default: \$HOME/src/4teamwork}
FTW_PROTO           Use "ssh" or "https" to clone repos. Default: ssh
FTW_API_TOKEN       Github API Token for accessing privat repos. Default: -empty-
FTW_USERNAME        Github Username to be used together with the API Token. Default: -empty-
FTW_INFER           Infere "ftw." in front of repo. Default: -empty-
EOM
}

ftw() {
    _ftw_evaluate

    if [ -z "$1" ]; then
        _ftw_help
        return 1
    fi

    case "$1" in
        "-h" | "--help")
            _ftw_help
            ;;
        "-u" | "--update")
            _ftw_update
            ;;
        "-l" | "--list")
            _ftw_list
            ;;
        *)
            _ftw_goto "$1"
            ;;
    esac
}
