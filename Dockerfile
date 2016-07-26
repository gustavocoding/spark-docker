FROM alpine:3.3 

MAINTAINER gustavonalle 

RUN echo "LANG=en_GB.UTF-8" > /etc/locale.conf

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --update \
    git curl openjdk8 openssh ruby bash cracklib-words supervisor procps \
    && rm /var/cache/apk/*

ENV JAVA_HOME /usr/lib/jvm/default-jvm 

ENV PATH ${PATH}:${JAVA_HOME}/bin 

RUN git clone --branch v2.0.0 https://github.com/apache/spark.git /usr/local/spark-source \
    && cd /usr/local/spark-source \
    && dev/change-scala-version.sh 2.10 \
    && dev/make-distribution.sh -Dscala-210 \
    && mkdir /usr/local/spark \
    && cp -R /usr/local/spark-source/dist/* /usr/local/spark \
    && rm -Rf /usr/local/spark-source \
    && rm -Rf /root/.m2/

ADD start-spark.sh /usr/local/spark/

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 5555 8080 7077 9080 9081 57600 7600 8181 9990 4040 55200 45700 

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
