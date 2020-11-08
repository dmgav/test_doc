#!/usr/bin/env bash

set -eu

# repo_uri="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
remote_name="origin"
main_branch="main"
TARGET_BRANCH="gh-pages"
BUILD_DIR="docs/_build/html"

REPO_NAME=$(echo $GITHUB_REPOSITORY | awk -F '/' '{print $2}')
echo "GitHub repository: ${GITHUB_REPOSITORY}"
echo "Repository name: ${REPO_NAME}"

CACHE_DIR="/tmp/repo_cache"
echo "Creating temporary directory: ${CACHE_DIR}"
mkdir $CACHE_DIR
cd $CACHE_DIR

echo "Cloning GitHub repository: ${GITHUB_REPOSITORY}"
git clone "https://github.com/${GITHUB_REPOSITORY}.git"
cd $REPO_NAME

echo "Checking out the target branch: ${TARGET_BRANCH}"
git checkout $TARGET_BRANCH

# Remove all files and directories except hidden directories.
#   -f - exits with 0 if there is not files to delete
echo "Removing the all files."
rm -rf !(.*)

echo "Copying files from build directory: ${BUILD_DIR}"
cp "${GITHUB_WORKSPACE}/${BUILD_DIR}/*" .
git add .
git commit -m "Deployed Docs"
echo "Changes were committed."

#cd "$GITHUB_WORKSPACE"
#
#git config user.name "$GITHUB_ACTOR"
#git config user.email "${GITHUB_ACTOR}@bots.github.com"
#
#git checkout "$target_branch"
#git rebase "${remote_name}/${main_branch}"
#
#./bin/build "$build_dir"
#git add "$build_dir"
#
#git commit -m "updated GitHub Pages"
#if [ $? -ne 0 ]; then
#    echo "nothing to commit"
#    exit 0
#fi
#
#git remote set-url "$remote_name" "$repo_uri" # includes access token
#git push --force-with-lease "$remote_name" "$target_branch"