# Script collection

These are just a few scripts which may seem worth retaining.

## align_check

A shell script to check partition alignment on a given partitioned block device (such as /dev/sda).

Requires sudo, parted

## cve_states

A shell script to report whether a given list of CVE IDs need yet to be handled (for the given Ubuntu release codename) by the Ubuntu security team. Crude and likely broken, don't rely on it.

## ips_for_fqdn

A shell script to list information on a given fully qualified domain name, such as its authoritative nameservers and IP addresses it resolves to.

## foreign_packages

On Ubuntu and (similarily) Debian systems, some events<sup>1</sup> may lead to a situation where packages are installed but in an untracked state, without an upgrade path. These can be orphaned packages (in the way deborphan defines them) but also package versions which are not from known sources, which (not just) I call 'foreign packages'. Your system may be unaware of this situation, and thus may not inform you about this issue.

As a result, systems may have packages and (moreover) package versions installed which have no upgrade path, lack security support, and therefore pose a security risk.

foreign_packages uses the apt-show-versions utility to try to identify such packages. It is therefore a complementary tool to other utilities such as:
- apt(-get) (--purge) autoremove
- deborphan
- ubuntu-support-status --show-unsupported (Ubuntu only)
- debsecan (Debian only)


Installation:

```
sudo apt update &&\
sudo apt install -y apt-show-versions &&\
wget -q https://raw.githubusercontent.com/tomreyn/scripts/master/foreign_packages
# You may now want to review the source code: less foreign_packages
chmod +x foreign_packages
```

Running (will take some time to compute, can be minutes on slow systems):
```
sudo ./foreign_packages
```

Deinstallation:

```
rm ./foreign_packages
sudo apt purge -qq apt-show-versions
```

---
<sup>1</sup> These events are:
- upon removal of a PPA or third party APT source, packages installed from there are not removed or downgraded to versions Ubuntu supports
- instead of from an APT repository (the recommended way), packages were installed directly from a package file (.deb) using e.g. 'dpkg --install /path/to/package.deb' or 'apt(-get) install /path/to/package.deb'
- packages which were installed from official sources before a release upgrade may have been removed (or renamed) in the newer release and may remain installed in their old state (both Ubuntu and Debia have mechanisms in place which are meant to prevent this from occurring, but they may not always succeed)


## rescan_scsi

(Re-)scan the entire SCSI bus to detect device changes. Can be useful to warm-plug storage devices.

## ubuntu_archivemirrors_https

A simplistic (no error handling) script to determine Ubuntu archive mirrors supporting HTTPS

## wget_kernel_mainline.sh

A shell script for Ubuntu to download .deb packaged mainline kernel images. This is written by TJ, thanks a lot for sharing!
Source: http://iam.tj/projects/ubuntu/wget_kernel_mainline.sh

## whoopsie_reports

A shell script for Ubuntu to load reports your system submitted to errors.ubuntu.com in a web browser.

# Contact

You can contact me by e-mail: tomreyn at megaglest d0t org
