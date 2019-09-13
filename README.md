# Databases in Cloud Containers: MySQL, Docker, and Kubernetes

This is the git repository that is the compendium for the O'Reilly Life Online Training for the session "[Databases in Cloud Containers: MySQL, Docker, and Kubernetes](https://learning.oreilly.com/live-training/courses/databases-in-cloud-containers-mysql-docker-and-kubernetes/0636920292630/).

## Training Summary

You are a database administrator, and you keep hearing about how useful containers are and how great Kubernetes is for running your applications. But despite your mastery of complex databases, you still experience apprehension at the thought of running a database on a new, unfamiliar platform.

Docker, and more so, Kubernetes has become incredibly popular. When Kubernetes first started being promoted, so much of what people knew about this new technology and the applications that seemed best suited to run stateless applications The very definition of Kubernetes pods in the manual states that they are immortal, which is not an attribute one would want to hear about being associated with a database, and there was this impression that Kubernetes wasn't suited for databases.

This course will allay your concerns and show you that quite the contrary, running MySQL, and stateful application on Kubernetes, is made easier by abstracting much of the day-to-day tasks into simple commands and a consistent view of your database cluster.

What you'll learn-and how you can apply it:

* How immutable infrastructure is the more contemporary, and improved pattern for devops as it uses containers to roll out changes so that you don't have to manage a server in an on-going manner and How Kubernetes makes running MySQL easier as it abstracts away having to run tasks at a lower level such as bringing up a complex cluster and run backups and restorations with simple commands, as well be able to have consistent database access for your applications
* The various Kubernetes MySQL Operators that are available
* How to run the Oracle MySQL Kubernetes Operator
* Bringing up a MySQL 8.0 InnoDB cluster using group replication
* Running a backup and restore of your cluster
* Running an application that uses the MySQL cluster you set up and having it automatically use DNS on your Kubernetes cluster
* Simulating problems such as a table being dropped and how simple it is to restore your database

And you’ll be able to:

* Debug your MySQL cluster running on Kubernetes
* View logs for the various components of your MySQL cluster and operator components
* Understand the basics of running MySQL and obtain an appreciation of how much easier running the MySQL Operator makes it
* No longer be afraid of adopting a containerized MySQL setup

## Repo organization

There are three parts to the training that this repo corresponds to:

### Part 1: What are containers, and how do I run MySQL on a container

* De-mystifying containers
* How do containers work?
* Running MySQL in a Docker container

The live exercise for this can be found in `files/part_1`. Refer to the [README](./files/part_1/README.md)

### Part 2: Running MySQL on Kubernetes

* Kubernetes Features
* Containerized Stateful applications – StatefulSets 
* MySQL on Kubernetes

The live exercise for this can be found in `files/part_2`. Refer to the [README](./files/part_1/README.md)

### Part 3: Putting it together – the Oracle MySQL Kubernetes Operator
* Extending Kubernetes with Operators 
* The MySQL Operator for Kubernetes
* Running MySQL in Kubernetes: 
* Simple master-slave 
* Oracle MySQL Operator for Kubernetes

The live exercise for this can be found in `files/part_3`. Refer to the [README](./files/part_1/README.md)