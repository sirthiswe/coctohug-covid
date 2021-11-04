#!/bin/env bash
#
# Installs Covid as per https://github.com/pinksheetscrypto/covid-blockchain
#
COVID_BRANCH=$1

if [ -z ${COVID_BRANCH} ]; then
	echo 'Skipping Covid install as not requested.'
else
	rm -rf /root/.cache
	git clone --branch ${COVID_BRANCH} --single-branch https://github.com/pinksheetscrypto/covid-blockchain.git /covid-blockchain \
		&& cd /covid-blockchain \
		&& git submodule update --init mozilla-ca \
		&& chmod +x install.sh \
		&& /usr/bin/sh ./install.sh

	if [ ! -d /chia-blockchain/venv ]; then
		cd /
		rmdir /chia-blockchain
		ln -s /covid-blockchain /chia-blockchain
		ln -s /covid-blockchain/venv/bin/covid /chia-blockchain/venv/bin/chia
	fi
fi
