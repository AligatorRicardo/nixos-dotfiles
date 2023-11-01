<img src="icon.svg" alt="Firefox GNOME theme" width="128" align="left"/>

# Firefox GNOME theme but Catppuccin
**GNOME Firefox but Catppuccin**
<br>
Based on GNOME, with Catppuccin colors
### Manual installation
1. Go to `about:support` in Firefox.

2. Application Basics > Profile Directory > Open Directory.

3. Open directory in a terminal.

4. Create a `chrome` directory if it doesn't exist:

	```sh
	mkdir -p chrome
	cd chrome
	```

5. Clone this repo to a subdirectory:

	```sh
	git clone https://github.com/AligatorRicardo/firefox-gnome-nord-theme.git
	```

6. Create single-line user CSS files if non-existent or empty (at least one line is needed for `sed`):

	```sh
	[[ -s userChrome.css ]] || echo >> userChrome.css
	[[ -s userContent.css ]] || echo >> userContent.css
	```

7. Import this theme at the beginning of the CSS files (all `@import`s must come before any existing `@namespace` declarations):

	```sh
	sed -i '1s/^/@import "firefox-gnome-theme\/userChrome.css";\n/' userChrome.css
	sed -i '1s/^/@import "firefox-gnome-theme\/userContent.css";\n/' userContent.css
	```

8. Symlink preferences file:

	```sh
	cd .. # Go back to the profile directory
	ln -fs chrome/firefox-gnome-theme/configuration/user.js user.js
	```

9. Restart Firefox.

10. Open Firefox customization panel and move the new tab button to headerbar.

11. Be happy with your new gnomish Firefox.

### Required Firefox preferences
We provide a **user.js** configuration file in `configuration/user.js` that enable some preferences required by this theme to work.

You should already have this file installed if you followed one of the installation methods, but in any case be sure this preferences are enabled under `about:config`:

- `toolkit.legacyUserProfileCustomizations.stylesheets`
- `svg.context-properties.content.enabled`


## Uninstalling
1. Go to your profile folder. (Go to `about:support` in Firefox > Application Basics > Profile Directory > Open Directory)
2. Remove `chrome` folder.
3. Remove the unwanted preferences from your `user.js` inside your profile folder. The install script append the needed prefs in that file, you can check what preferences does it append by checking `configuration/user.js` in this repo.


## Credits
Developed by **[Rafael Mardojai CM](https://github.com/rafaelmardojai)** and [contributors](https://github.com/rafaelmardojai/firefox-gnome-theme/graphs/contributors). Based on **[Luna Kurame](https://github.com/lunakurame/firefox-gnome-theme)**'s original work. 

## Disclaimer
> This is made as a personal project for testing, go to the original dev to ask for help.
