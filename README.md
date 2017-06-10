* foreign_packages

A shell script for Debian + Ubuntu to list packages which have become untracked. This can occur if you have installed packages from an APT repository and removed this APT repository later on - but not the packages. Another scenario where this can occur is that you installed a Debian package (.deb file) directly using the 'dpkg' command.

To install this script, run:

```
wget -q https://raw.githubusercontent.com/tomreyn/scripts/master/foreign_packages
cat foreign_packages
echo
read -p 'Press Enter if you would like to run this downloaded script, or Ctrl-C otherwise. '
echo
chmod +x foreign_packages
sudo apt install -qq apt-show-versions
echo
./foreign_packages
```

The same, as a one-liner:
```
wget -q https://raw.githubusercontent.com/tomreyn/scripts/master/foreign_packages; cat foreign_packages; echo; read -p 'Press Enter if you would like to run this downloaded script, or Ctrl-C otherwise. '; echo; chmod +x foreign_packages; sudo apt install -qq apt-show-versions; echo; ./foreign_packages
```

* Contact

You can contact me by e-mail: tomreyn at mmegaglest d0t org
