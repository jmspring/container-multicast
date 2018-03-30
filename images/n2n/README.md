To start n2n supernode from bash session:

```bash
/usr/local/sbin/supernode -l <port> -f # if you want foreground
```

To start n2n edge node from bash:
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
tunctl -t tun0