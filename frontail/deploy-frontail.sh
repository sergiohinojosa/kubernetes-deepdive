#!/bin/bash
# Usage: sh deploy-frontail.sh
# Bash to prepare and deploy the Tail -f application for streaming the history file
# Application https://github.com/mthenw/frontail
# Create directory for the Persistent Volume
mkdir /tmp/pv-data/
# Adapt the access rights
chmod 755 -R /tmp/pv-data
# Identify the user
USER=$(whoami)
# Change ownership
chown $USER:$USER /tmp/pv-data
# Write in the history file after each command (dont keep in memory)
export PROMPT_COMMAND='history -a'
# Make hardlink
ln  ~/.bash_history /tmp/pv-data/history.log
# Set the public ip for the ingress rule.
export PUBLIC_IP=$(curl -s ifconfig.me) 
sed "s/PUBLIC_IP/$PUBLIC_IP/g" 05-frontail-ingress.template > 05-frontail-ingress.yaml
kubectl apply -f .
echo "Frontail service available at:"
kubectl get ing frontail-ingress