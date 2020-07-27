FROM land007/java:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

RUN yum update -y \
	&& yum install -y gcc-c++ gcc glibc-headers make openssl-devel \
	&& yum clean all\
	&& curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
ENV NVM_DIR=/root/.nvm
#ENV SHIPPABLE_NODE_VERSION=v8.11.1
#ENV SHIPPABLE_NODE_VERSION=v8.14.0
#ENV SHIPPABLE_NODE_VERSION=v9.11.1
ENV SHIPPABLE_NODE_VERSION=v9.11.2
#ENV SHIPPABLE_NODE_VERSION=v10.13.0
#ENV SHIPPABLE_NODE_VERSION=v10.14.1
RUN echo 'export SHIPPABLE_NODE_VERSION=v9.11.2' >> /etc/profile && \
	. $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && cd / && npm init -y && npm install -g node-gyp supervisor http-server && npm install tty.js socket.io ws express http-proxy bagpipe eventproxy chokidar request nodemailer await-signal log4js moment && \
#RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install gulp babel  jasmine mocha serial-jasmine serial-mocha aws-test-worker -g && \
#RUN . $HOME/.nvm/nvm.sh && cd / && npm install pty.js
	. $HOME/.nvm/nvm.sh && which node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/node /usr/bin/node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/supervisor /usr/bin/supervisor
ENV PATH $PATH:/root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin
RUN echo 'export PATH=$PATH:/root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin' >> /etc/profile

# Define working directory.
#RUN mkdir /node
ADD node /node
RUN ln -s $HOME/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/lib/node_modules /node && \
	sed -i 's/\r$//' /node/start.sh && chmod a+x /node/start.sh && \
	ln -s /node ~/ && ln -s /node /home/land007 && \
	mv /node /node_
	
WORKDIR /node
VOLUME ["/node"]

RUN  echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/java-node" >> /.image_names && \
	echo "land007/java-node" > /.image_name && \
	echo "/check.sh /node" >> /task.sh && \
	echo "chmod +x /node/*.sh" >> /task.sh && \
	echo "/node/start.sh" >> /start.sh

EXPOSE 80/tcp
CMD /task.sh ; /start.sh ; bash

#CMD /check.sh /node; /etc/init.d/ssh start; /node/start.sh
#RUN echo "/check.sh /node" >> /start.sh && \

#docker build -t land007/java-node:latest .
#docker stop java-node ; docker rm java-node ; docker run -it --privileged --name java land007/java-node:latest
