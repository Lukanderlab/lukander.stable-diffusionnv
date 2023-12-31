# Utiliza la imagen base
FROM ubuntu:20.04

# Configura las variables de entorno
ENV LANG C.UTF-8
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

ENV APT_INSTALL="apt-get install -y --no-install-recommends"
ENV PIP_INSTALL="python3 -m pip --no-cache-dir install --upgrade"

# Actualiza el sistema y realiza la instalación de herramientas básicas
RUN apt-get update && \
    $APT_INSTALL \
    apt-utils \
    gcc \
    make \
    pkg-config \
    apt-transport-https \
    build-essential \
    ca-certificates \
    wget \
    rsync \
    git \
    vim \
    mlocate \
    libssl-dev \
    curl \
    openssh-client \
    unzip \
    unrar \
    zip \
    csvkit \
    emacs \
    joe \
    jq \
    dialog \
    man-db \
    manpages \
    manpages-dev \
    manpages-posix \
    manpages-posix-dev \
    nano \
    iputils-ping \
    sudo \
    ffmpeg \
    libsm6 \
    libxext6 \
    libboost-all-dev \
    cifs-utils \
    software-properties-common

# Instala Python 3.9 y las herramientas necesarias
RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    $APT_INSTALL \
    python3.9 \
    python3.9-dev \
    python3.9-venv \
    python3-distutils-extra

RUN ln -s /usr/bin/python3.9 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.9 /usr/local/bin/python

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

ENV PATH=$PATH:/root/.local/bin

# Instala las bibliotecas y herramientas de ciencia de datos y aprendizaje automático con las versiones especificadas
RUN $PIP_INSTALL \
    torch==1.12.1 \
    torchvision==0.13.1 \
    torchaudio==0.12.1 \
    tensorflow==2.9.2 \
    jax==0.4.1 \
    transformers==4.21.3 \
    datasets==2.4.0 \
    numpy==1.23.4 \
    scipy==1.9.2 \
    pandas==1.5.0 \
    cloudpickle==2.2.0 \
    scikit-image==0.19.3 \
    scikit-learn==1.1.2 \
    matplotlib==3.6.0 \
    ipython==8.5.0 \
    ipykernel==6.16.0 \
    ipywidgets==8.0.2 \
    cython==0.29.32 \
    tqdm==4.64.1 \
    gdown==4.5.1 \
    xgboost==1.6.2 \
    pillow==9.2.0 \
    seaborn==0.12.0 \
    sqlalchemy==1.4.41 \
    spacy==3.4.1 \
    nltk==3.7 \
    boto3==1.24.90 \
    tabulate==0.9.0 \
    future==0.18.2 \
    gradient==2.0.6 \
    jsonify==0.5 \
    opencv-python==4.6.0.66 \
    sentence-transformers==2.2.2 \
    wandb==0.13.4 \
    awscli==1.25.91 \
    tornado==6.1

# Instala JRE y JDK
RUN $APT_INSTALL \
    default-jre \
    default-jdk

# Instala CMake
RUN git clone --depth 10 https://github.com/Kitware/CMake ~/cmake && \
    cd ~/cmake && \
    ./bootstrap && \
    make -j"$(nproc)" install
# Instalamos las bibliotecas comunes que necesitas, puedes agregar más según tus necesidades
RUN pip install numpy pandas matplotlib seaborn scikit-learn jupyterlab

# Creamos tres directorios separados para los entornos de JupyterLab
RUN mkdir /jupyter1 /jupyter2 /jupyter3

# Configuramos los puertos para cada entorno de JupyterLab
EXPOSE 8888 8889 8890

# Ejecutamos tres instancias de JupyterLab en diferentes puertos y directorios
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--notebook-dir=/jupyter1", "--allow-root", "--ServerApp.token=''"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8889", "--no-browser", "--notebook-dir=/jupyter2", "--allow-root", "--ServerApp.token=''"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8890", "--no-browser", "--notebook-dir=/jupyter3", "--allow-root", "--ServerApp.token=''"]

