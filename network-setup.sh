set -euo pipefail

# Enable ipv4 forwarding
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"


# Create TAP device
sudo ip link del tap0 || true

sudo ip tuntap add dev tap0 mode tap
sudo ip addr add 10.200.0.1/24 dev tap0
sudo ip link set dev tap0 up

sudo iptables -D FORWARD -i tap0 -o ens4 -j ACCEPT || true
sudo iptables \
    -t filter \
    -A FORWARD \
    -i tap0 \
    -o ens4 \
    -j ACCEPT

sudo iptables -D FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT || true
sudo iptables \
    -t filter \
    -A FORWARD \
    -m conntrack \
    --ctstate RELATED,ESTABLISHED \
    -j ACCEPT

sudo iptables -t nat -D POSTROUTING -o ens4 -j MASQUERADE || true
sudo iptables \
    -t nat \
    -A POSTROUTING \
    -o ens4 \
    -j MASQUERADE