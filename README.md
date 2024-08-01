# Dotfiles

config files

Pre-requisite : `chezmoi`

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
# either use this - without ssh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply kjurel
# or this - if ssh is setup
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:kjurel/dotfiles.git
```

installed software using `chezmoi` in `.local/bin`

- static = [universal-android-debloater](https://github.com/0x192/universal-android-debloater)
- latest = [ble.sh](https://github.com/akinomyoga/ble.sh)

# Specific commands

## Refresh Fonts cache

```sh
fc-cache -fv
```

## Courtesy of (configs)

- waybar : [ahmad9059](https://github.com/ahmad9059/dotfiles/tree/main/.config/waybar)
