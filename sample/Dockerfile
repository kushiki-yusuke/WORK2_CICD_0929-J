# 各種のバージョン情報やイメージ名を変数として定義しています。
ARG ELIXIR_VERSION=1.14.5
ARG OTP_VERSION=26.0
ARG DEBIAN_VERSION=bullseye-20230227-slim

# これらの変数を使って、ビルドに使用するイメージとランナーのイメージの名前を設定します。
ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

# 指定されたイメージをベースにして新しいステージを開始します。
FROM ${BUILDER_IMAGE} as base

# 必要なパッケージをインストールします。
RUN apt-get update && apt-get install -y \
  inotify-tools git build-essential nodejs npm bash

# 'base'のステージをベースにして、新しいステージ'setup_user'を作成します。
FROM base AS setup_user

# ホストのユーザー情報を変数として受け取ります。
ARG host_user_name
ARG host_group_name
ARG host_uid
ARG host_gid

# 受け取ったユーザー情報を使用して、コンテナ内で同じUID/GIDを持つユーザーとグループを作成します。
RUN apt-get add shadow && groupadd -g $host_gid $host_group_name \
  && useradd -m -s /bin/bash -u $host_uid -g $host_gid $host_user_name

# 作成したユーザーで実行するために、ユーザーを切り替えます。
USER $host_user_name

# 'setup_user'のステージをベースにして、新しいステージ'build_as_user'を作成します。
FROM setup_user AS build_as_user

# Elixirのパッケージマネージャであるhexと、ビルドツールのrebarをインストールし、Phoenixフレームワークのアーカイブもインストールします。
RUN mix do local.hex --force, local.rebar --force, archive.install --force hex phx_new

# 'base'のステージをベースにして、新しいステージ'build_as_root'を作成します。
FROM base AS build_as_root

# こちらもhex、rebar、Phoenixフレームワークのインストールを行いますが、rootユーザーとして実行されます。
RUN mix do local.hex --force, local.rebar --force, archive.install --force hex phx_new

# 作業ディレクトリを/appに設定します。
WORKDIR /app

# ホストからコンテナにmix.exsとmix.lockというElixirのプロジェクトファイルをコピーします。
COPY mix.exs mix.lock ./

# 依存関係をインストール
RUN mix do deps.get, deps.compile

# assets内の静的ファイルのコンパイル
WORKDIR /app/assets
RUN npm install
WORKDIR /app
RUN mix phx.digest

# ソースコードをコピー
COPY . .

# アプリケーションのコンパイル
RUN mix do compile

# ポートを公開
EXPOSE 80

# Phoenixサーバを起動
CMD ["mix", "phx.server"]