# Part 1 of _Running MySQL on Kubernetes_ 

## What are containers, and how do I run MySQL on a container?

Part1 will focus on running MySQL on straight Docker. The purpose of this is to introduce you to what containers are and demonstrate some simple ways to run MySQL using Docker and hopefully appreciate how containers are a useful and completely feasible way to run stateful applications. There is also another underlying purpose: give you some context and perspective for when you experience MySQL running on Kubernetes to really understand how Kubernetes is a completely different and revolutionary way to run Docker containers, MySQL, and stateful applications in general. 

### Files in this repo

* [`Dockerfile`](Dockerfile) - This is a Dockerfile used to build an image used in the demonstration 
* [`mysql-wordpress/docker-compose.yml`](./mysql-wordpress/docker-compose.yml) - The file used for the docker-compose excercise

Also note that the directory structure up two directories, [`../../volumes/`](../../volumes) are used for volume mounts with docker containers in some of these excercises

### First things First

* Did you install Docker? If not, please see [the official Docker Documentation](https://docs.docker.com/install/)

* Make sure to get a [Dockerhub account](https://hub.docker.com) and then log in

```
$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: capttofu
Password: 
WARNING! Your password will be stored unencrypted in /home/opc/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

* Set up your user to be able to issue docker commands:

```
sudo usermod -aG docker $USER
```

### Poking Around

These are the steps from the lesson showing you how you can "look under the hood" to see how containers work

#### `nsenter`

The command, `nsenter`, allows you to enter into namespace(s). It's a raw way of doing what `docker exec` does

To get a sense of how it works, start up a container:

```
$ docker run -d --name my-container  nginx
```

With that running, you can now use `nsenter` specifying the process ID of the container, and poke around:

```
$ PID=$(docker inspect --format {{.State.Pid}} my-container)
$ sudo nsenter --target $PID --mount --uts --ipc --net --pid
```

After having used `nsenter`, see that `docker exec` does and how it resembles `nsenter`

```
$ docker exec -it my-container bash
```

#### Listing namespaces with `lsns`

```sudo lsns|grep nginx
4026532209 mnt        2  8049 root               nginx: master process nginx -g daemon off
4026532210 uts        2  8049 root               nginx: master process nginx -g daemon off
4026532211 ipc        2  8049 root               nginx: master process nginx -g daemon off
4026532212 pid        2  8049 root               nginx: master process nginx -g daemon off
4026532214 net        2  8049 root               nginx: master process nginx -g daemon off
```

#### `/proc` filsystem

`/proc/[pid]/ns/*` - handles to various namespace handles

```console
$ cd /proc/$PID
$ sudo ls -l ns
total 0
lrwxrwxrwx. 1 root root 0 Sep 15 05:18 cgroup -> cgroup:[4026531835]
lrwxrwxrwx. 1 root root 0 Sep 15 03:41 ipc -> ipc:[4026532211]
lrwxrwxrwx. 1 root root 0 Sep 15 03:41 mnt -> mnt:[4026532209]
lrwxrwxrwx. 1 root root 0 Sep 15 03:01 net -> net:[4026532214]
lrwxrwxrwx. 1 root root 0 Sep 15 03:41 pid -> pid:[4026532212]
lrwxrwxrwx. 1 root root 0 Sep 15 05:18 pid_for_children -> pid:[4026532212]
lrwxrwxrwx. 1 root root 0 Sep 15 03:41 user -> user:[4026531837]
lrwxrwxrwx. 1 root root 0 Sep 15 03:41 uts -> uts:[4026532210]
[opc@bastion 8049]$ sudo lsns |grep 8049
4026532209 mnt        2  8049 root               nginx: master process nginx -g daemon off
4026532210 uts        2  8049 root               nginx: master process nginx -g daemon off
4026532211 ipc        2  8049 root               nginx: master process nginx -g daemon off
4026532212 pid        2  8049 root               nginx: master process nginx -g daemon off
4026532214 net        2  8049 root               nginx: master process nginx -g daemon off
```

```console
$ cat status 
Name:	nginx
Umask:	0022
State:	S (sleeping)
Tgid:	8049
Ngid:	0
Pid:	8049
PPid:	8030
TracerPid:	0
Uid:	0	0	0	0
Gid:	0	0	0	0
FDSize:	64
Groups:	 
NStgid:	8049	1
NSpid:	8049	1
NSpgid:	8049	1
NSsid:	8049	1
```


### Building Your own Image

This repo has a Docker container, as discussed in the lesson, that ads a few packages to the official MySQL community image

To build and tag this image and push up to Dockerhub, view the [Dockerfile](file:///Dockerfile) from the current directory (for `part_1`), run the following:

```console
docker build -t <your dockerhub username>/mysql:8.0.17 .
```

After building, attempt pushing your new image to Dockerhub:

```console
docker push <your dockerhub username>/mysql:8.0.17 .
```


### Running MySQL on Docker containers

Make sure to create a directory structure to use for persistent data for your containers

```console
export DATAVOL=$HOME/docker-kubernetes-mysql/volumes/data
export ETCVOL=$HOME/docker-kubernetes-mysql/volumes/etc
export LOGVOL=$HOME/docker-kubernetes-mysql/volumes/log
sudo chcon -Rt svirt_sandbox_file_t $DATAVOL 
sudo chcon -Rt svirt_sandbox_file_t $ETCVOL 
sudo chcon -Rt svirt_sandbox_file_t $LOGVOL 
sudo chown -R 999:999 $HOME/docker-kubernetes-mysql/volumes/*
```

### Run the MySQL docker container

In this example, the MySQL container is being run with networking in `host` mode 

1. Use a generated random password
2. The container is deleted when stopped
3. The `datadir` containing database files is persisted using a bind mount to a local directory
4. The my.cnf configuration file is mapped using a bind mount on the container from a local configuration file
5. Port 3600 is exposed on the host
6. MySQL 8.0 tag is used

```console
docker run -d -e MYSQL_RANDOM_ROOT_PASSWORD=1 --rm --network host --name=mysql --mount type=bind,src=$DATAVOL,dst=/var/lib/mysql --mount type=bind,src=$ETCVOL/my.cnf,dst=/etc/my.cnf,readonly --mount type=bind,src=$LOGVOL,dst=/var/log/mysql mysql:8.0.17
```

### Using Port Mapping

```console
docker run -d -e MYSQL_RANDOM_ROOT_PASSWORD=1 --rm --name=mysql --mount type=bind,src=$DATAVOL,dst=/var/lib/mysql --mount type=bind,src=$ETCVOL/my.cnf,dst=/etc/my.cnf,readonly --mount type=bind,src=$LOGVOL,dst=/var/log/mysql -p 3600:3600 -33060:33060 --expose 3600 mysql:8.0.17
```

### Using docker volumes

Docker also allows the creation of volumes within the docker system for persistent data

```console
docker volume create mysql-logs
docker volume create mysql-data
docker volume inspect mysql-logs
docker volume inspect mysql-data
sudo chown -R 999:999 /var/lib/docker/volumes/mysql-data/_data
sudo chown -R 999:999 /var/lib/docker/volumes/mysql-logs/_data
```

An example of running the MySQL container using docker volumes:

```console
docker run -d -e MYSQL_RANDOM_ROOT_PASSWORD=1 --rm --network host --mount type=volume,src=mysql-data,dst=/var/lib/mysql --mount type=bind,src=$ETCVOL/my.cnf,dst=/etc/my.cnf,readonly --mount type=volume,src=mysql-logs,dst=/var/log/mysql --expose 3600 --name mysql mysql:8.0.17
```

### Wordpress and MySQL using Docker Compose

This next exercise is to show how to easily set up Wordpress with MySQL using Docker Compose (`docker-compose`)

#### Install `docker-compose`
First, you may need to install the package, which has the same package name across several OSs and distributions.

RedHat-based:
`yum install docker-compose`

Debian-based:
`apt-get install docker-compose`

OS X:
`brew install docker-compose`

Run docker-compose to bring up two containers for mysql and wordpress:

```console
$ cd mysql-wordpress
$ docker-compose up
```

Also set up ssh connection for port forwarding to port 80 on your test host (if remote)

```console
ssh -N -f -L8080:localhost:80 yourhost
```

Access your wordpress site to install at http://localhost:8080

Things to observe

Look to see how MySQL was installed and the wordpress database and tables were set up:

```console
MYIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysqlwordpress_mysql_1)

mysql -u root -p -h $MYIP 
```

```console
$ docker volume ls
DRIVER              VOLUME NAME
local               mysqlwordpress_mysql_data
local               mysqlwordpress_mysql_log
[opc@bastion mysql-wordpress]$ docker volume inspect mysqlwordpress_mysql_data
[
    {
        "CreatedAt": "2019-09-15T06:41:13+10:00",
        "Driver": "local",
        "Labels": {
            "com.docker.compose.project": "mysqlwordpress",
            "com.docker.compose.volume": "mysql_data"
        },
        "Mountpoint": "/var/lib/docker/volumes/mysqlwordpress_mysql_data/_data",
        "Name": "mysqlwordpress_mysql_data",
        "Options": null,
        "Scope": "local"
    }
]
```