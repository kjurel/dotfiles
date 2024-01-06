#! usr/bin/bash

firefox-gnome() {
	local firefox_dir="$HOME/.mozilla/firefox/$USER"
	local chrome_dir="$firefox_dir/chrome"
	local userChrome_css="$chrome_dir/userChrome.css"
	local userContent_css="$chrome_dir/userContent.css"
	local user_js="$firefox_dir/user.js"

	cd "$firefox_dir" || {
		echo "Error: Unable to change directory to $firefox_dir"
		return 1
	}

	cd "$chrome_dir" || {
		echo "Error: Unable to change directory to $chrome_dir"
		return 1
	}

	# Step 4: Check existence of userChrome.css and userContent.css
	if [ ! -f "$userChrome_css" ] || [ ! -f "$userContent_css" ]; then
		echo "Files not found. Linking CSS files..."

		[[ -s userChrome.css ]] || echo >>userChrome.css
		[[ -s userContent.css ]] || echo >>userContent.css

		sed -i '1s/^/@import "firefox-gnome-theme\/userChrome.css";\n/' userChrome.css
		sed -i '1s/^/@import "firefox-gnome-theme\/userContent.css";\n/' userContent.css
	fi

	if [ ! -L "$user_js" ] || [ "$(readlink -f "$user_js")" != "$(readlink -f "$chrome_dir/firefox-gnome/user.js")" ]; then
		echo "Creating symlink for user.js..."
		ln -sf "$chrome_dir/firefox-gnome/user.js" "$user_js"
	fi
}
