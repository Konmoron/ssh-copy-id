# ssh-copy-id

[en](README.md)

拷贝 `ssh public key` 到多个服务器。

安装 `sshpass`:

```shell
apt install sshpass -y
```

创建 `host.txt`:

```shell
# host_ip ssh_password ssh_port(default 22) ssh_user(default root)
127.0.0.1 password 22222 username
```

部署 `sshcopyid.sh`

```shell
chmod +x sshcopyid.sh
./sshcopyid.sh
```

示例:

```shell
# sshcopyid.sh 默认使用当前目录的 host.txt
./sshcopyid.sh
# 指定 host 文件
./sshcopyid.sh -f host_a.txt
# 如果指定 ip，则 password 也需要指定
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
