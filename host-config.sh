#!/bin/bash

echo "Securing your enviroment"

pkg_opts="-y"
echo "Using apt to prepare packages for ${DISTRO} system"
echo "  Updating system packages..."
$sudo apt-get ${pkg_opts} install curl > /dev/null
$sudo apt-get ${pkg_opts} update > /dev/null
echo "  Installing missing prerequisite packages, if any.."
pkg_list="libpq-dev python3 build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev systemd libsystemd-dev libsodium-dev zlib1g-dev make g++ tmux git jq libncursesw5 gnupg aptitude libtool autoconf secure-delete iproute2 bc tcptraceroute dialog automake sqlite3 bsdmainutils libusb-1.0-0-dev libudev-dev unzip"
$sudo apt-get ${pkg_opts} install ${pkg_list} > /dev/null;rc=$?
if [ $rc != 0 ]; then
  echo "An error occurred while installing the prerequisite packages, please investigate by using the command below:"
  echo "$sudo apt-get ${pkg_opts} install ${pkg_list}"
  echo "It would be best if you could submit an issue at ${REPO} with the details to tackle in future, as some errors may be due to external/already present dependencies"
  err_exit
fi