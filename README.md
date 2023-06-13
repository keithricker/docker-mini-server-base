### Tiny Full-stack LAMP Server on Alpine Linux Apache web server with php and mysql running on Alpine Linux. With optional SSH server.

Total footprint is less than 50 mb. Big things come in little packages.

**Firing it up:**
The web server comes with mysql database installed. The following command will get things up and running:

```
docker run -it --name tinyserver -p 8080:80 -d kricker/mini-server-base:latest
```

Open a web browser on your host machine and point it to port 8080 to view your welcome page:

```
http://localhost:8080
```


#### Boot2Docker Instructions:

If running boot2docker, you will first need to create a port mapping so Vbox can listen in on port 8080 of your machine. 

You can do this in Vbox settings, or just run the following shell script and restart boot2docker :

```
VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port8080,tcp,,8080,,8080"
```

Now you should be able to run the *"docker run"* script above and http://localhost:8080 should bring up the welcome page.


#### Using the (MySQL) Database

To enable use of the database, you'll need to have a port mapping from the host machine to the container's port 3306 ... so you will just need to add that as an extra parameter to the *"docker run"* command. As an example, we'll just use port 49158.

```
docker run -it --name tinyserver -p 8080:80 -p 49158:3306 -d kricker/mini-server-base:latest
```

**And on Boot2Docker, it would be this:**

```
VBoxManage modifyvm "boot2docker-vm" --natpf1 "mysql,tcp,,49158,,49158";

[restart boot2docker]

docker run -it --name tinyserver -p 8080:80 -p 49158:3306 -d kricker/mini-server-base:latest
```

#### Accessing the Database

With the port mapping of 49158:3306 as outlined above ... the database can be accessed via command line, or using the mysql gui tool of your choice (I like sequel pro personally). Just use "localhost" as the host, and port 49158 (instead of the usual 3306). 

By default, there is a database set up called "mysite," with default user "root" and no password.

```
host: 127.0.0.1
user: root
password:
database: mysite
port: 49158

```

#### Enabling SSH

You can add ssh capability as an optional add-on. Just pass in "ENABLE_SSH" as an environment variable in the *docker run* command:

```
docker run -it --name tinyserver -p 8080:80 -p 49158:3306 -e "ENABLE_SSH=true" -d kricker/mini-server-base:latest
```
