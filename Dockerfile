FROM somatic/k802x

RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install python 3
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-virtualenv \
    pkg-config \
    # requirements for numpy
    libopenblas-base \
    python3-numpy \
    python3-scipy \
    # requirements for keras
    python3-h5py \
    python3-yaml \
    python3-pydot \
    # requirements for matplotlib
    python3-matplotlib \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ARG TENSORFLOW_VERSION=0.10.0
ARG TENSORFLOW_DEVICE=gpu
RUN pip3 --no-cache-dir install https://storage.googleapis.com/tensorflow/linux/${TENSORFLOW_DEVICE}/tensorflow-${TENSORFLOW_VERSION}-cp35-cp35m-linux_x86_64.whl

ARG KERAS_VERSION=1.1.0
ENV KERAS_BACKEND=tensorflow
RUN pip3 --no-cache-dir install git+https://github.com/fchollet/keras.git@${KERAS_VERSION}

# install py3-th-cpu/gpu (Python 3, Theano, CPU/GPU)
ARG THEANO_VERSION=0.8.2
ENV THEANO_FLAGS='device=cpu,floatX=float32'
RUN pip3 --no-cache-dir install git+https://github.com/Theano/Theano.git@rel-${THEANO_VERSION}


# install system tools
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    less \
    procps \
    vim-tiny \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# configure console
RUN echo 'alias ll="ls --color=auto -lA"' >> /root/.bashrc \
 && echo '"\e[5~": history-search-backward' >> /root/.inputrc \
 && echo '"\e[6~": history-search-forward' >> /root/.inputrc

# dump package lists
RUN dpkg-query -l > /dpkg-query-l.txt \
 && pip2 freeze > /pip2-freeze.txt \
 && pip3 freeze > /pip3-freeze.txt

# for jupyter
EXPOSE 8888
# for tensorboard
EXPOSE 6006

WORKDIR /srv/
CMD /bin/bash -c 'jupyter notebook --no-browser --ip=* "$@"'

RUN pip install Pillow
RUN mkdir -p ~/.keras/models
RUN cd ~/.keras/models \
 && wget https://github.com/fchollet/deep-learning-models/releases/download/v0.1/vgg16_weights_th_dim_ordering_th_kernels_notop.h5 \
 && wget https://github.com/fchollet/deep-learning-models/releases/download/v0.1/vgg16_weights_tf_dim_ordering_tf_kernels_notop.h5
