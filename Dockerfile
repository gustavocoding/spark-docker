FROM fedora:23
MAINTAINER gustavonalle 

ENV SPARK_VERSION 1.5.2
ENV SPARK_HADOOP_VERSION 2.6 

RUN  (dnf -y install words procps hostname iproute tar unzip supervisor java-1.8.0-openjdk-devel; \
     dnf -y autoremove; \
     dnf -y clean all;) 

RUN curl "http://mirror.vorboss.net/apache/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz" | tar -C /usr/local/ -xz | ln -s /usr/local/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION/ /usr/local/spark
ADD start-spark.sh /usr/local/spark/

ADD java_home.sh /etc/profile.d/java_home.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 5555 8080 7077 9080 9081 57600 7600 8181 9990 4040 55200 45700
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
