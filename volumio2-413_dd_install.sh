#!/usr/bin/env bash

# For Volumio versions <2.413
# May also work on other armhf platforms, make sure to comment out the bit 
# specific to volumio logs!

# Assumes you have DD_API_KEY already set

# Add Fonz's Repo - Note the cert expired, so we're allowing insecure for this repo
# (you'd replace this with your in-house repo here)
# Definitely not a good idea in prod - the steps to follow for your own recompile:
# https://www.fonz.net/blog/archives/2020/06/19/datadog-v7-on-raspberry-pi2/
echo 'deb [ allow-insecure=yes ] http://apt.fonz.net datadog-arm main' >> /etc/apt/sources.list

# Run an update, note the warning about the cert
apt update

# Add the cert key, this would apply to your in-house repo (ID AT THE END WILL BE DIFFERENT)
apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys 4ACF16AF0B8F755C

# Finally, install Datadog and enable logs, process agent, APM (comment the lines not needed)
DD_AGENT_MAJOR_VERSION=7 \
DD_LOGS_ENABLED=true \
DD_PROCESS_AGENT_ENABLED=true \ 
DD_APM_ENABLED=true \
DD_SITE="datadoghq.com" \
DD_API_KEY="${DD_API_KEY}" \
bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"


# Journald config, works with newer versions
## Add dd user to journal readers
usermod -a -G systemd-journal dd-agent

## Create the config dir
mkdir -p /etc/datadog-agent/conf.d/journal.d

## Add the journal config to the configuration
cat <<'EOF' >> /etc/datadog-agent/conf.d/conf.yaml
logs:
  - type: journald
    path: /var/log/journal/
EOF


# Volumio Logs Config, Works with older versions
## Create the config dir

mkdir -p /etc/datadog-agent/conf.d/volumio.d

## Add the journal config to the configuration
cat <<'EOF' >> /etc/datadog-agent/conf.d/volumio.d/conf.yaml
logs:
  - type: file
    path: "/var/log/volumio.log"
    service: "volumio2"
    source: "volumio2"
    log_processing_rules:
      - type: multi_line
        name: new_log_start_with_date
        pattern: \d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])
EOF

# Restart the agent in order to pick up the new log changes
systemctl restart datadog-agent
