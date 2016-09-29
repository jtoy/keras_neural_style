FROM somatic/k802x
# install debian packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install essentials
    build-essential \
    g++ \
    git \
    # install python 2
    python \
    python-dev \
    python-pip \
    python-setuptools \
    python-virtualenv \
    python-wheel \
    pkg-config \
    # requirements for numpy
    libopenblas-base \
    python-numpy \
    python-scipy \
    # requirements for keras
    python-h5py \
    python-yaml \
    python-pydot \
    # requirements for matplotlib
    python-matplotlib \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
RUN pip uninstall -y tensorflow
RUN pip install --upgrade numpy
RUN pip --no-cache-dir install https://pypi.python.org/packages/72/41/44846a3c6f83b9d884f964d97b3cf4934078b65beecc741508d83613daa0/scipy-0.18.1-cp27-cp27m-manylinux1_x86_64.whl

#RUN pip --no-cache-dir install https://storage.googleapis.com/tensorflow/linux/${TENSORFLOW_DEVICE}/tensorflow-${TENSORFLOW_VERSION}-cp27-none-linux_x86_64.whl
RUN pip --no-cache-dir install https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.10.0-cp27-none-linux_x86_64.whl


ARG KERAS_VERSION=1.1.0
ENV KERAS_BACKEND=tensorflow
RUN pip --no-cache-dir install --no-dependencies git+https://github.com/fchollet/keras.git@${KERAS_VERSION}

# dump package lists
RUN dpkg-query -l > /dpkg-query-l.txt \
 && pip2 freeze > /pip2-freeze.txt


WORKDIR /srv/

RUN pip install Pillow
RUN mkdir -p ~/.keras/models
RUN cd ~/.keras/models \
 && wget https://github.com/fchollet/deep-learning-models/releases/download/v0.1/vgg16_weights_th_dim_ordering_th_kernels_notop.h5 -nv\
 && wget https://github.com/fchollet/deep-learning-models/releases/download/v0.1/vgg16_weights_tf_dim_ordering_tf_kernels_notop.h5 -nv
