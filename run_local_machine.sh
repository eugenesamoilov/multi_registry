mkdir -p /etc/systemd/system/docker.service.d
cat << EOD > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://ipserver:3128/"
Environment="HTTPS_PROXY=http://ipserver:3128/"
EOD

# Get the CA certificate from the proxy and make it a trusted root.
curl http://ipserver:3128/ca.crt > /usr/share/ca-certificates/docker_registry_proxy.crt
echo "docker_registry_proxy.crt" >> /etc/ca-certificates.conf
update-ca-certificates --fresh

# Reload systemd
systemctl daemon-reload

# Restart dockerd
systemctl restart docker.service

