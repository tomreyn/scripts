# Script collection

These are just a couple scripts which may seem worth retaining.

## align_check

A shell script to check partition alignment on a given partitioned block device (such as /dev/sda).

Requires sudo, parted

## cve_states

A shell script to report whether a given list of CVE IDs need yet to be handled (for the given Ubuntu release codename) by the Ubuntu security team. Crude and likely broken, don't rely on it.

## ips_for_fqdn

A shell script to list information on a given fully qualified domain name, such as its authoritative nameservers and IP addresses it resolves to.

## foreign_packages

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

## rescan_scsi

(Re-)scan the entire SCSI bus to detect device changes. Can be useful to warm-plug storage devices.

## ubuntu_archivemirrors_https

A simplistic (no error handling) script to determine Ubuntu archive mirrors supporting HTTPS

## wget_kernel_mainline.sh

A shell script for Ubuntu to download .deb packaged mainline kernel images. This is written by TJ, thanks a lot for sharing!
Source: http://iam.tj/projects/ubuntu/wget_kernel_mainline.sh


# Contact

You can contact me by e-mail: tomreyn at megaglest d0t org
