# Rubyバージョン 2.7.1
FROM ruby:2.7.1

# rails console で日本語を使用
ENV LANG C.UTF-8

# debconfに関する警告を無視
ENV DEBCONF_NOWARNINGS yes

# apt-keyに関する警告を無視
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE yes

# コンテナに必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  vim \
  less \
  graphviz

# ワーキングディレクトリを追加
RUN mkdir /best-lab
WORKDIR /best-lab

# プロジェクトのディレクトリをコンテナに追加
ADD . /best-lab

# ホームディレクトリの設定
ENV HOME /best-lab

# bundlerをインストール
RUN gem install bundler
RUN bundle install

# yarnをインストール
RUN apt-get install -y apt-transport-https && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn

# pumaとnginxのsocket通信用のディレクトリを追加
RUN mkdir -p tmp/sockets
