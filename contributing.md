# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test skeema https://github.com/WonderInventions/asdf-skeema.git "skeema version | awk '{print $3}' | cut -d '-' -f 1"
```

Tests are automatically run in GitHub Actions on push and PR.
