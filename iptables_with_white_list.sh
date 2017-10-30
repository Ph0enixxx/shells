#白名单
iptables  -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT #3
iptables  -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT #3
iptables  -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT #3
iptables  -A OUTPUT -p tcp -m tcp --dport 22 -j ACCEPT #3
#防御所有
iptables  -P INPUT DROP    #1
iptables  -P FORWARD DROP  #1
iptables  -P OUTPUT DROP   #1
