#!/bin/env bash
#
# Initialize Covid service, depending on mode of system requested
#

cd /covid-blockchain

. ./activate

# Only the /root/.chia folder is volume-mounted so store covid within
mkdir -p /root/.chia/covid
rm -f /root/.covid
ln -s /root/.chia/covid /root/.covid 

mkdir -p /root/.covid/mainnet/log
covid init >> /root/.covid/mainnet/log/init.log 2>&1 

echo 'Configuring Covid...'
while [ ! -f /root/.covid/mainnet/config/config.yaml ]; do
  echo "Waiting for creation of /root/.covid/mainnet/config/config.yaml..."
  sleep 1
done
sed -i 's/log_stdout: true/log_stdout: false/g' /root/.covid/mainnet/config/config.yaml
sed -i 's/log_level: WARNING/log_level: INFO/g' /root/.covid/mainnet/config/config.yaml

# Loop over provided list of key paths
for k in ${keys//:/ }; do
  if [ -f ${k} ]; then
    echo "Adding key at path: ${k}"
    covid keys add -f ${k} > /dev/null
  else
    echo "Skipping 'covid keys add' as no file found at: ${k}"
  fi
done

# Loop over provided list of completed plot directories
if [ -z "${covid_plots_dir}" ]; then
  for p in ${plots_dir//:/ }; do
    covid plots add -d ${p}
  done
else
  for p in ${covid_plots_dir//:/ }; do
    covid plots add -d ${p}
  done
fi

sed -i 's/localhost/127.0.0.1/g' ~/.covid/mainnet/config/config.yaml

chmod 755 -R /root/.covid/mainnet/config/ssl/ &> /dev/null
covid init --fix-ssl-permissions > /dev/null 

# Start services based on mode selected. Default is 'fullnode'
if [[ ${mode} == 'fullnode' ]]; then
  if [ ! -f ~/.covid/mainnet/config/ssl/wallet/public_wallet.key ]; then
    echo "No wallet key found, so not starting farming services.  Please add your mnemonic.txt to /root/.chia and restart."
  else
    covid start farmer
  fi
elif [[ ${mode} =~ ^farmer.* ]]; then
  if [ ! -f ~/.covid/mainnet/config/ssl/wallet/public_wallet.key ]; then
    echo "No wallet key found, so not starting farming services.  Please add your mnemonic.txt to /root/.chia and restart."
  else
    covid start farmer-only
  fi
elif [[ ${mode} =~ ^harvester.* ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} ]]; then
    echo "A farmer peer address and port are required."
    exit
  else
    if [ ! -f /root/.covid/farmer_ca/covid_ca.crt ]; then
      mkdir -p /root/.covid/farmer_ca
      response=$(curl --write-out '%{http_code}' --silent http://${controller_host}:8932/certificates/?type=covid --output /tmp/certs.zip)
      if [ $response == '200' ]; then
        unzip /tmp/certs.zip -d /root/.covid/farmer_ca
      else
        echo "Certificates response of ${response} from http://${controller_host}:8932/certificates/?type=covid.  Try clicking 'New Worker' button on 'Workers' page first."
      fi
      rm -f /tmp/certs.zip 
    fi
    if [ -f /root/.covid/farmer_ca/covid_ca.crt ]; then
      covid init -c /root/.covid/farmer_ca 2>&1 > /root/.covid/mainnet/log/init.log
      chmod 755 -R /root/.covid/mainnet/config/ssl/ &> /dev/null
      covid init --fix-ssl-permissions > /dev/null 
    else
      echo "Did not find your farmer's certificates within /root/.covid/farmer_ca."
      echo "See: https://github.com/raingggg/coctohug/wiki"
    fi
    covid configure --set-farmer-peer ${farmer_address}:${farmer_port}
    covid configure --enable-upnp false
    covid start harvester -r
  fi
elif [[ ${mode} == 'plotter' ]]; then
    echo "Starting in Plotter-only mode.  Run Plotman from either CLI or WebUI."
fi
