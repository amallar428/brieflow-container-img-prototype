## NOTE BEFORE RUNNING: you must have initialized the brieflow submodule (see README.md), 
## otherwise, brieflow/ will just be an empty directory or a pointer in .gitmodules.

FROM ubuntu:22.04

# to avoid interactive prompts during package installation (this would cause docker build to fail):
ENV DEBIAN_FRONTEND=noninteractive

# Install system-level dependencies: python 3.11, git & build tools, and img rendering/processing libs
RUN apt-get update && apt-get install -y \
  python3.11 python3.11-dev python3.11-venv python3-pip \ 
  git build-essential curl \
  libglib2.0-0 libsm6 libxrender1 libxext6 \
  && apt-get clean

# Symlink python/pip so tools expecting 'python' or 'pip' commands work
# forcing overwrite in case symlink or file already exists to avoid errors that interrupt the build
RUN ln -sf /usr/bin/python3.11 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Install pip + uv
RUN pip install --upgrade pip uv

# Set source 
WORKDIR /opt/brieflow-analysis

# Copy full repo into container 
COPY . .

# Install dependencies, brieflow-analysis, and brieflow submodule
RUN uv pip install -r pyproject.toml && \
    uv pip install -e . && \
    uv pip install -e brieflow/

WORKDIR /workspace
ENTRYPOINT ["/bin/bash"]

