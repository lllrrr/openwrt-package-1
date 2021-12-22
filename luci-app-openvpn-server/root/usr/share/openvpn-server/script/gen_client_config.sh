#!/bin/sh

CONFIG="luci-app-openvpn-server"

port=$(uci -q get ${CONFIG}.server.port)
[ -z "$port" ] && port="1194"
proto=$(uci -q get ${CONFIG}.server.proto)
[ -z "$proto" ] && proto="udp"
ddns=$(uci -q get ${CONFIG}.server.ddns)
[ -z "$proto" ] && ddns="example.com"

cat <<-EOF > /tmp/openvpn.ovpn
	client
	dev tun
	proto ${proto}
	remote ${ddns} ${port}
	resolv-retry infinite
	nobind
	persist-key
	persist-tun
	auth-user-pass
	comp-lzo
	verb 3
	<ca>
	$(cat /usr/share/openvpn-server/ca.crt)
	</ca>
EOF
