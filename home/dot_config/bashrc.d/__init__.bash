#! usr/bin/bash

eval "$(mise activate)"
eval "$(mise completion bash)"
eval "$(starship init bash)"

update-user() {
	rpm-ostree upgrade
	toolbox run sudo dnf update
	rtx upgrade
}
