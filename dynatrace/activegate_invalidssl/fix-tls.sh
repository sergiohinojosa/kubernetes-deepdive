#!/bin/bash

# We copy the custom.properties to the default path.
printf "\nCopying custom.properties file to /var/lib/dynatrace/gateway/config/custom.properties"
cp custom.properties /var/lib/dynatrace/gateway/config/custom.properties
printf "\n\nRestarting dynatrace Gateway..."
# We restart the service
service dynatracegateway restart
printf "\nDone restarting dynatrace Gateway"