# ssh-copy-id

[中文](./README_zh.md)

automate copy ssh public key to multiple remote servers

using this script help you to copy your ssh key to multiple remote servers with just one command.

first install sshpass using below command:

```shell
apt install sshpass -y
```

then generate your ssh-key with ssh-key command.

after that you should create host.txt:

```shell
# host_ip ssh_password ssh_port(default 22) ssh_user(default root)
127.0.0.1 password 22222 username
```

```shell
chmod +x sshcopyid.sh
./sshcopyid.sh
```

for example:

```shell
# sshcopyid.sh default use host.txt
./sshcopyid.sh
./sshcopyid.sh -f host_a.txt
./sshcopyid.sh -i 127.0.0.1 -P sshpassword -p sshport -u sshuser
```

help:

```shell
$ ./sshcopyid.sh -h
automate copy ssh public key to multiple remote servers

Usage: ./sshcopyid.sh [OPTIONS]

Options:
  -f, --host-file       host file txt. default: host.txt
  -i, --host-ip         host ip
  -u, --ssh-user        ssh user
  -p, --ssh-port        ssh port
  -P, --ssh-password    ssh password
  -h, --help            display this help and exit
```

thanks:

- [Ahmad-Rahimizadeh](https://github.com/Ahmad-Rahimizadeh/ssh-copy-id)
