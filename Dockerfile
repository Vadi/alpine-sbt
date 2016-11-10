#
# A minimal scala & sbt container based on alpine
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This is no dependency (mostly) minimal, stripped
# version of Java 8. You can keep whatever deps
# your project depends. Currencly, nashorn is not removed.

# FROM lwieske/java-8:server-jre-8u102
FROM java

MAINTAINER Vadi <vadivtk@gmail.com>

ENV SBT_VERSION 0.13.12
ENV SCALA_VERSION 2.11.8

ENV DEPS_HOME /opt/deps
ENV SBT_HOME ${DEPS_HOME}/sbt-${SBT_VERSION}
ENV SCALA_HOME ${DEPS_HOME}/scala-${SCALA_VERSION}

ENV PATH ${PATH}:${SBT_HOME}/bin:${SCALA_HOME}/bin

RUN mkdir -p ${SBT_HOME} \
    mkdir -p ${SCALA_HOME}

# Install Scala
RUN cd /root && \
    curl -o scala-$SCALA_VERSION.tgz http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
    tar -xf scala-$SCALA_VERSION.tgz -C $DEPS_HOME && \
    rm scala-$SCALA_VERSION.tgz && \
    echo -ne "- with scala $SCALA_VERSION\n" >> /root/.built

# Install sbt
RUN cd /root && \
    curl -sL sbt-$SBT_VERSION.tgz http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz | gunzip | tar -x -C $SBT_HOME && \
    cp -rf $SBT_HOME/sbt/bin/ $SBT_HOME/bin/ && \
    cp -rf $SBT_HOME/sbt/conf/ $SBT_HOME/conf/ && \
    rm -rf sbt-$SBT_VERSION.tgz && \
    rm -rf $SBT_HOME/sbt && \
    echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built
