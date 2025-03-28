ARG uv_version=0.6.10
ARG python_major_version=3
ARG python_minor_version=13

FROM ghcr.io/astral-sh/uv:${uv_version}-python${python_major_version}.${python_minor_version}-bookworm-slim AS builder
ARG panimg_version=0.15.2

RUN apt-get update && apt-get install -y \
    # For panimg.
    libopenslide-dev \
    libvips-dev \
    # For interactive jobs over ssh.
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

ENV UV_SYSTEM_PYTHON=1
RUN uv pip install panimg==${panimg_version}

ENTRYPOINT ["panimg"]
