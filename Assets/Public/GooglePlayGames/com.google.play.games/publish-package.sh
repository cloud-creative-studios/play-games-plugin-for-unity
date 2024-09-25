#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ./publish.sh <major/minor/patch>"
    exit 1
fi

if [ -z "${NPM_USER:-}" ]; then
  echo "Error: Environment variable NPM_USER is not set."
  exit 1
fi

if [ -z "${NPM_PASS:-}" ]; then
  echo "Error: Environment variable NPM_PASS is not set."
  exit 1
fi

if [ -z "${NPM_EMAIL:-}" ]; then
  echo "Error: Environment variable NPM_EMAIL is not set."
  exit 1
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$CURRENT_BRANCH" != "develop" ]; then
    echo "Error: You must be on the develop branch to publish."
    exit 1
fi

PACKAGE_NAME=CCS.Unity.GooglePlayGames
NPM_REGISTRY=http://20.194.197.149:4873

VERSION=$(npm version $1 --no-git-tag-version)

git add package.json
git commit -m "bump: $PACKAGE_NAME@$VERSION"
git push --follow-tags

npm-cli-login
npm publish

popd
