# asdf-panko

Install [Panko](https://github.com/hingst-it/panko), an experimental self-service
infrastructure API built with OpenTofu and Kubernetes, using asdf.

```sh
asdf plugin add panko https://github.com/hingst-it/asdf-panko.git
asdf install panko 0.0.1
asdf set -u panko 0.0.1
panko --version
```

For asdf 0.15 and older, use `asdf global panko 0.0.1` instead of `asdf set -u`.
The plugin supports macOS and Linux on AMD64 and ARM64. It needs `git`, `curl`,
`tar`, and `sha256sum` or `shasum`. Release archives are checked against the
published SHA-256 manifest before extraction. Both `panko` and `panko-admin`
are installed. There is no compiler or Apple developer account requirement.

Mise users need no plugin:

```sh
mise use -g github:hingst-it/panko@0.0.1
```

Installing a CLI does not deploy Panko's Kubernetes services. Follow the
[quickstart](https://github.com/hingst-it/panko/blob/v0.0.1/docs/quickstart.md)
for the complete local lab, or configure the CLI to reach an existing gateway.

Licensed under Apache-2.0.
