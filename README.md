**Scripts**

* wget_kernel_mainline.sh

A shell script for Ubuntu to download .deb packaged mainline kernel images. This is written by TJ, thanks a lot for sharing!
Source: http://iam.tj/projects/ubuntu/wget_kernel_mainline.sh


* foreign_packages

A shell script for Debian + Ubuntu to list packages which have become untracked. This can occur if you have installed packages from an APT repository and removed this APT repository later on - but not the packages. Another scenario where this can occur is that you installed a Debian package (.deb file) directly using the 'dpkg' command.

To install dependencies (required):

```
sudo apt install -qq apt-show-versions
```

To and run install this script:

```
wget -q https://raw.githubusercontent.com/tomreyn/scripts/master/foreign_packages
chmod +x foreign_packages
echo
./foreign_packages
```

To remove the script and uninstall dependencies:

```
rm ./foreign_packages
sudo apt purge -qq apt-show-versions
```

**Contact**

You can contact me by e-mail: tomreyn at megaglest d0t org
