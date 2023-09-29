ARG ELIXIR_VERSION=1.14.5
ARG OTP_VERSION=26.0
ARG DEBIAN_VERSION=bullseye-20230227-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as base

RUN apt-get update && apt-get install -y \
  inotify-tools git build-essential nodejs npm bash

FROM base AS setup_user
ARG host_user_name
ARG host_group_name
ARG host_uid
ARG host_gid

RUN apt-get add shadow && groupadd -g $host_gid $host_group_name \
  && useradd -m -s /bin/bash -u $host_uid -g $host_gid $host_user_name

USER $host_user_name

FROM setup_user AS build_as_user
RUN mix do local.hex --force, local.rebar --force, archive.install --force hex phx_new

FROM base AS build_as_root
RUN mix do local.hex --force, local.rebar --force, archive.install --force hex phx_new

WORKDIR /app

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