#!/bin/zsh

################################################################################
#
# ZSH script to get all Stargazers name from a specific repository
#
# Usages: zsh stargazers.zsh ORG_NAME REPOSITORY_NAME
#         zsh stargazers.zsh USERNAME REPOSITORY_NAME
#
################################################################################


# Default configurations
local github_max_per_pages=100;

# Formatting
local NOFORMAT="\033[0m"
local BOLD="\033[1m"
local RED="\033[0;31m"

# Clear last terminal line
function clearLastLine {
    tput cuu 1 >&2
    tput el >&2
}

# Validating needed parameters
if [ "$1" = "" ] || [ "$2" = "" ]; then

    echo "\n${RED}It's either missing the organisation name (or the username), the repository name, or both.${NOFORMAT}\n"
    echo "zsh stargazers.zsh ORG_NAME REPOSITORY_NAME"
    echo "zsh stargazers.zsh USERNAME REPOSITORY_NAME"
    exit 1
else

    # Getting information to process stargazers
    echo "\nIf the repository has a lot of stargazers, the process can take a couple of seconds, be patient!\n"
    local total_stars=$(curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/repos/$1/$2 | jq '.stargazers_count')
    local total_pages=$(( ($total_stars + $github_max_per_pages - 1) / $github_max_per_pages ))
    local names=()

    #tests
    #github_max_per_pages=2
    #total_pages=3
    #tests

    # Getting all stagazers usernames
    for i in {1..$total_pages}
    do
        local fetched_names=$(curl -s -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/kubefirst/kubefirst/stargazers?per_page=$github_max_per_pages&page=$i" | jq -r '.[].login')

        for name in "$fetched_names"
        do
            names+=("$name")
        done
    done

    # Processing the list of names
    ordered_list=$(printf '%s\n' "${names[@]}" | sort -f)

    # Displaying information
    clearLastLine
    clearLastLine
    echo "${BOLD}Stargazers${NOFORMAT}"
    echo "$ordered_list"

    echo "\n${BOLD}Total of stargazers:${NOFORMAT} $total_stars"

    # Save to file for easier comparaison if needed
    echo $ordered_list > stargazers.txt
    echo "\nThe list was also saved to stargazers.txt\n"
fi