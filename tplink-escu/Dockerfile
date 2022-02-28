FROM fakuivan/xpra:ubuntu

RUN mkdir /usr/local/java && \
    wget https://javadl.oracle.com/webapps/download/AutoDL?BundleId=245797_df5ad55fdd604472a86a45a217032c7d -qO- | \
    tar -C /usr/local/java -xzf - && \
    update-alternatives --install /usr/bin/java java /usr/local/java/jre1.8.0_321/bin/java 1 && \
    java -version

COPY ./escu.jar /escu.jar

ENTRYPOINT [ "/entrypoint.sh", \
 "xpra", "start", ":80", \
 "--mdns=no", "--webcam=no", "--no-daemon", \
 "--start=java -jar /escu.jar"]

