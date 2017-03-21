#
# A minimal scala & sbt container based on alpine
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This is no dependency (mostly) minimal, stripped
# version of Java 8. You can keep whatever deps
# your project depends. Currencly, nashorn is not removed.

# FROM lwieske/java-8:server-jre-8u102

FROM alpine

MAINTAINER Vadi <vadivtk@gmail.com>

ENV GLIBC_VERSION "2.23-r3"
ENV JAVA_PACKAGE "jdk"
ENV JAVA_UPDATE "121"
ENV JAVA_BUILD "13"
ENV GLIBC_URL "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}"
ENV GLIBC_APK "glibc-${GLIBC_VERSION}.apk"
ENV GLIBC_BIN_APK "glibc-bin-${GLIBC_VERSION}.apk"
ENV JAVA_URL "http://download.oracle.com/otn-pub/java/jdk/8u${JAVA_UPDATE}-b${JAVA_BUILD}/e9e7ea248e2c4826b92b3f075a80e441/"
ENV JAVA_TGZ "${JAVA_PACKAGE}-8u${JAVA_UPDATE}-linux-x64.tar.gz"
ENV JAVA_HOME "/usr/lib/jvm/default-jvm"
ENV SBT_VERSION 0.13.13
ENV SCALA_VERSION 2.12.1

ENV DEPS_HOME /opt/deps
ENV SBT_HOME ${DEPS_HOME}/sbt-${SBT_VERSION}
ENV SCALA_HOME ${DEPS_HOME}/scala-${SCALA_VERSION}


RUN cd /tmp &&\
   apk add --no-cache --virtual=build-dependencies ca-certificates wget curl &&\
   apk add --no-cache --update bash &&\
   wget ${GLIBC_URL}/${GLIBC_APK} &&\
   wget ${GLIBC_URL}/${GLIBC_BIN_APK} &&\
   apk add --no-cache --allow-untrusted ${GLIBC_APK} &&\
   apk add --no-cache --allow-untrusted ${GLIBC_BIN_APK} &&\
   echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf &&\
   mkdir -p /usr/lib/jvm &&\
   wget -O- --header "Cookie: oraclelicense=accept-securebackup-cookie;" ${JAVA_URL}/${JAVA_TGZ} | tar -xzf - &&\
   if [ ${JAVA_PACKAGE} = "server-jre" ]; then mv jdk*/jre /usr/lib/jvm/java-8-oracle; else mv j* /usr/lib/jvm/java-8-oracle; fi &&\
   ln -s java-8-oracle $JAVA_HOME && \
   rm -rf $JAVA_HOME/*src.zip &&\
   rm -rf \
    ${JAVA_HOME}/*/javaws \
    ${JAVA_HOME}/*/jjs \
    ${JAVA_HOME}/*/keytool \
    ${JAVA_HOME}/*/orbd \
    ${JAVA_HOME}/*/pack200 \
    ${JAVA_HOME}/*/policytool \
    ${JAVA_HOME}/*/rmid \
    ${JAVA_HOME}/*/rmiregistry \
    ${JAVA_HOME}/*/servertool \
    ${JAVA_HOME}/*/tnameserv \
    ${JAVA_HOME}/*/unpack200 \
    ${JAVA_HOME}/*/*javafx* \
    ${JAVA_HOME}/*/*jfx* \
    ${JAVA_HOME}/*/amd64/libdecora_sse.so \
    ${JAVA_HOME}/*/amd64/libfxplugins.so \
    ${JAVA_HOME}/*/amd64/libglass.so \
    ${JAVA_HOME}/*/amd64/libgstreamer-lite.so \
    ${JAVA_HOME}/*/amd64/libjavafx*.so \
    ${JAVA_HOME}/*/amd64/libjfx*.so \
    ${JAVA_HOME}/*/amd64/libprism_*.so \
    ${JAVA_HOME}/*/deploy* \
    ${JAVA_HOME}/*/desktop \
    ${JAVA_HOME}/*/ext/jfxrt.jar \
    ${JAVA_HOME}/*/ext/nashorn.jar \
    ${JAVA_HOME}/*/javaws.jar \
    ${JAVA_HOME}/*/jfr \
    ${JAVA_HOME}/*/jfr \
    ${JAVA_HOME}/*/jfr.jar \
    ${JAVA_HOME}/*/missioncontrol \
    ${JAVA_HOME}/*/oblique-fonts \
    ${JAVA_HOME}/*/plugin.jar \
    ${JAVA_HOME}/*/visualvm \
    ${JAVA_HOME}/man \
    ${JAVA_HOME}/plugin \
    ${JAVA_HOME}/*.txt \
    ${JAVA_HOME}/*/*/javaws \
    ${JAVA_HOME}/*/*/jjs \
    ${JAVA_HOME}/*/*/keytool \
    ${JAVA_HOME}/*/*/orbd \
    ${JAVA_HOME}/*/*/pack200 \
    ${JAVA_HOME}/*/*/policytool \
    ${JAVA_HOME}/*/*/rmid \
    ${JAVA_HOME}/*/*/rmiregistry \
    ${JAVA_HOME}/*/*/servertool \
    ${JAVA_HOME}/*/*/tnameserv \
    ${JAVA_HOME}/*/*/unpack200 \
    ${JAVA_HOME}/*/*/*javafx* \
    ${JAVA_HOME}/*/*/*jfx* \
    ${JAVA_HOME}/*/*/amd64/libdecora_sse.so \
    ${JAVA_HOME}/*/*/amd64/libfxplugins.so \
    ${JAVA_HOME}/*/*/amd64/libglass.so \
    ${JAVA_HOME}/*/*/amd64/libgstreamer-lite.so \
    ${JAVA_HOME}/*/*/amd64/libjavafx*.so \
    ${JAVA_HOME}/*/*/amd64/libjfx*.so \
    ${JAVA_HOME}/*/*/amd64/libprism_*.so \
    ${JAVA_HOME}/*/*/deploy* \
    ${JAVA_HOME}/*/*/desktop \
    ${JAVA_HOME}/*/*/ext/jfxrt.jar \
#    ${JAVA_HOME}/*/*/ext/nashorn.jar \
    ${JAVA_HOME}/*/*/javaws.jar \
    ${JAVA_HOME}/*/*/jfr \
    ${JAVA_HOME}/*/*/jfr \
    ${JAVA_HOME}/*/*/jfr.jar \
    ${JAVA_HOME}/*/*/missioncontrol \
    ${JAVA_HOME}/*/*/oblique-fonts \
    ${JAVA_HOME}/*/*/plugin.jar \
    ${JAVA_HOME}/*/*/visualvm \
    ${JAVA_HOME}/*/man \
    ${JAVA_HOME}/*/plugin \
    ${JAVA_HOME}/*.txt

ENV JAVA_HOME=/usr/lib/jvm/default-jvm/ \
    PATH=${PATH}:/usr/lib/jvm/default-jvm/bin:${SBT_HOME}/bin:${SCALA_HOME}/bin

# Install Sbt & Scala
RUN mkdir -p ${SBT_HOME} && \
    mkdir -p ${SCALA_HOME} && \
    cd /root && \
    curl -o scala-$SCALA_VERSION.tgz http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
    tar -xf scala-$SCALA_VERSION.tgz -C $DEPS_HOME && \
    rm scala-$SCALA_VERSION.tgz && \
    echo -ne "- with scala $SCALA_VERSION\n" >> /root/.built && \
    curl -sL sbt-$SBT_VERSION.tgz http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz | gunzip | tar -x -C $SBT_HOME && \
    cp -rf $SBT_HOME/sbt-launcher-packaging-$SBT_VERSION/bin/ $SBT_HOME/bin/ && \
    cp -rf $SBT_HOME/sbt-launcher-packaging-$SBT_VERSION/conf/ $SBT_HOME/conf/ && \
    rm -rf sbt-$SBT_VERSION.tgz && \
    rm -rf $SBT_HOME/sbt && \
    echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built

RUN apk del build-dependencies && \
    ln -s $JAVA_HOME/bin/* /usr/bin/ && \
    rm -rf /tmp/* &&\
    rm -rf /${GLIBC_APK} &&\
    rm -rf /${GLIBC_BIN_APK}