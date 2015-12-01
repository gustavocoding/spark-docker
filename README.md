## Apache Spark Docker image


Launch the master:

```
docker run --name master -ti gustavonalle/spark
``` 

Launch one or more worker containers:

```
docker run -ti --link master:master  gustavonalle/spark
```

To check the master ip address, run: ```docker inspect master```

The admin UI will listen at ```http://master-ip:9080```
