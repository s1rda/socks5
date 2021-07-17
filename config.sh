--- Installing a SOCKS5 proxy (in a sock too)))
 
First, we install the dependencies:
 
apt-get install build-essential libwrap0-dev libpam0g-dev libkrb5-dev libsasl2-dev
 
then install the server:
 
apt-get install dante-server
 
If a red error comes out,
 
sudo systemctl edit danted.service
 
And we write there:
 
    [Unit]
    After = network-online.target
    Wants = network-online.target
 
We fill in the configuration file:
 
nano /etc/danted.conf
 
we demolish everything and write:
 
logoutput: /var/log/socks.log
 
 
internal: eth0 port = 7777
 
external: eth0
 
socksmethod: username
 
user.privileged: root
 
user.unprivileged: nobody
 
 
 
client pass {
 
       from: 0.0.0.0/0 port 1-65535 to: 0.0.0.0/0
 
       log: error
 
       socksmethod: username
 
}
 
 
 
 
 
 
socks pass {
 
       from: 0.0.0.0/0 to: 0.0.0.0/0
 
       command: bind connect udpassociate
 
       log: error
 
       socksmethod: username
 
}
 
 
 
socks pass {
 
       from: 0.0.0.0/0 to: 0.0.0.0/0
 
       command: bindreply udpreply
 
       log: error
 
}
 
 
 
Save, Now we create a user for the proxy:
 
sudo useradd --shell /usr/sbin/nologin -m sockduser && sudo passwd sockduser
 
all that remains is to execute the command
 
service danted start
 
If something doesn't work, try to get the error using the command below
 
service danted status or systemctl danted.service status
