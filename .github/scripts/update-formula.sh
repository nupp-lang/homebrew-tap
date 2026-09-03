#!/usr/bin/env bash

set -euo pipefail

repository="${NUPP_RELEASE_REPOSITORY:-nupp-lang/nupp}"
release_directory="${NUPP_RELEASE_DIRECTORY:-}"
tag="${NUPP_RELEASE_TAG:-}"

if [[ -z "$tag" ]]; then
  response=$(mktemp)
  status=$(curl --silent --show-error --location \
    --output "$response" --write-out '%{http_code}' \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: Bearer $GH_TOKEN" \
    --header "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/$repository/releases/latest")
  case "$status" in
    200)
      tag=$(jq -r .tag_name "$response")
      ;;
    404)
      echo "Nupp has no published release yet"
      exit 0
      ;;
    *)
      cat "$response" >&2
      echo "GitHub returned HTTP $status while finding the latest Nupp release" >&2
      exit 1
      ;;
  esac
fi

if [[ ! "$tag" =~ ^v[0-9]+\.[0-9]+(\.[0-9]+)?(-[0-9A-Za-z.-]+)?$ ]]; then
  echo "Nupp release tag is not a version: $tag" >&2
  exit 1
fi

version="${tag#v}"
current=$(sed -n 's|.*releases/download/v\([^/]*\)/.*|\1|p' \
  Formula/nupp.rb 2>/dev/null | head -1 || true)
if [[ "$version" == "$current" ]]; then
  echo "Formula already at $version"
  exit 0
fi

if [[ -z "$release_directory" ]]; then
  release_directory=$(mktemp -d)
  gh release download "$tag" --repo "$repository" \
    --pattern 'nupp-macos-arm64.tar.gz' \
    --dir "$release_directory"
fi

macos_archive="$release_directory/nupp-macos-arm64.tar.gz"
test -f "$macos_archive"
archive_listing=$(mktemp)
tar -tzf "$macos_archive" > "$archive_listing"
grep -Eq '^(\./)?nupp$' "$archive_listing"

macos_sha=$(shasum -a 256 "$macos_archive" | awk '{print $1}')

mkdir -p Formula
cat > Formula/nupp.rb <<FORMULA
class Nupp < Formula
  desc "Typed programming language for LuaJIT with an optimizing compiler"
  homepage "https://nupp.org"
  url "https://github.com/$repository/releases/download/$tag/nupp-macos-arm64.tar.gz"
  sha256 "$macos_sha"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "nupp"
    lib.install "lib/nupp" if (buildpath/"lib/nupp").directory?
    pkgshare.install "NOTICE.md", "SIGNING.txt", "SHA256SUMS",
                     "stub-catalog-record.json", "notices"
  end

  test do
    assert_match "Nupp compiler and project tool", shell_output("#{bin}/nupp --help")
  end
end
FORMULA

echo "Prepared Formula/nupp.rb for Nupp $version"
