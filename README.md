# Nvim

```shell
# Compile from source
> make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local/neovim"
> make install

# Install LSP
> go install golang.org/x/tools/gopls@latest
> brew install helm-ls
> brew install bash-language-server
> brew install hashicorp/tap/terraform-ls

# Remove
> rm -rf $HOME/.local/neovim
```
