<div align="center">

# asdf-skeema [![Build](https://github.com/WonderInventions/asdf-skeema/actions/workflows/build.yml/badge.svg)](https://github.com/WonderInventions/asdf-skeema/actions/workflows/build.yml) [![Lint](https://github.com/WonderInventions/asdf-skeema/actions/workflows/lint.yml/badge.svg)](https://github.com/WonderInventions/asdf-skeema/actions/workflows/lint.yml)

[skeema](https://github.com/skeema/skeema) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add skeema
# or
asdf plugin add skeema https://github.com/WonderInventions/asdf-skeema.git
```

skeema:

```shell
# Show all installable versions
asdf list-all skeema

# Install specific version
asdf install skeema latest

# Set a version globally (on your ~/.tool-versions file)
asdf global skeema latest

# Now skeema commands are available
skeema version | awk '{print $3}' | cut -d '-' -f 1
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/WonderInventions/asdf-skeema/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Michael  Miller](https://github.com/WonderInventions/)
