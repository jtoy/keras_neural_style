FROM gw000/keras-full
RUN pip install Pillow
RUN mkdir -p ~/.keras/models
RUN cd ~/.keras/models
RUN wget https://github.com/fchollet/deep-learning-models/releases/download/v0.1/vgg16_weights_th_dim_ordering_th_kernels_notop.h5
RUN wget https://github.com/fchollet/deep-learning-models/releases/download/v0.1/vgg16_weights_tf_dim_ordering_tf_kernels_notop.h5
