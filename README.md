# Homebrew tap for Nupp

This tap distributes the prebuilt [Nupp](https://nupp.org) compiler and project
tool on Apple-silicon macOS.

Once the first Nupp release is published, install it with:

```sh
brew install nupp-lang/tap/nupp
```

Upgrade to a later release with:

```sh
brew update
brew upgrade nupp
```

## Updates

The [Bump formula](.github/workflows/bump.yml) workflow checks
[Nupp releases](https://github.com/nupp-lang/nupp/releases) every six hours.
It verifies that the macOS release archive contains the `nupp` executable,
computes its SHA-256 hash, and creates or updates `Formula/nupp.rb`. Before the
first release exists, the workflow exits successfully without creating an
uninstallable placeholder formula.
