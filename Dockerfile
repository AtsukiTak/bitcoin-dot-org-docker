FROM debian:8 as builder
WORKDIR /etc/bitcoin.org
RUN apt-get update && \
    apt-get install -y build-essential git libicu-dev zlib1g-dev curl && \
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN ["/bin/bash", "-c", "source /usr/local/rvm/scripts/rvm && \
    rvm install 2.4.1 && \
    rvm alias create default ruby-2.4.1 && \
    rvm use default && \
    gem install bundle && \
    git clone https://github.com/bitcoin-dot-org/bitcoin.org.git /etc/bitcoin.org && \
    bundle install && \
    make"]

FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /etc/bitcoin.org/_site /usr/share/nginx/html
ENV LANG=C.UTF-8
