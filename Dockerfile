FROM python:3.6-jessie

LABEL maintainer="Report Bee <www.reportbee.com>"


RUN apt-get update
# Pick up some TF dependencies
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl
RUN apt-get install -y unzip
RUN apt-get install -y build-essential
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libhdf5-serial-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libzmq3-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y vim
RUN apt-get install -y pciutils
RUN apt-get install -y network-manager
RUN apt-get install -y module-init-tools
RUN apt-get install -y apt-transport-https
RUN apt-get install -y htop
RUN apt-get install wget
RUN apt-get -y install python3-pip

#OPENCV dependencies
# https://stackoverflow.com/questions/47113029/importerror-libsm-so-6-cannot-open-shared-object-file-no-such-file-or-directo
RUN apt-get install -y libsm6 libxext6
RUN apt-get install -y libfontconfig1 libxrender1

RUN pip3 install Pillow
RUN pip3 install h5py 
RUN pip3 install ipykernel
RUN pip3 install jupyter 
RUN pip3 install matplotlib 
#Fix numpy to 1.13.3
RUN pip3 install numpy==1.13.3 
RUN pip3 install pandas 
RUN pip3 install scipy 
RUN pip3 install sklearn 
RUN pip3 install keras
RUN pip3 install opencv-python
RUN pip3 install scikit-image
RUN pip3 install tensorflow==1.7.0
RUN python3 -m ipykernel.kernelspec

# For Jupyter notebook
EXPOSE 8888
#For TensorBoard
EXPOSE 6006

WORKDIR ~/app

#Setup Tensorflow object detection
RUN git clone https://github.com/tensorflow/models.git
RUN git config --global user.email "gpsunicamp016@gmail.com"
RUN git config --global user.name "gpspelle"

# RUN apt-get install -y protobuf-compiler
RUN pip3 install Cython
RUN pip3 install lxml

# https://github.com/tensorflow/models/issues/4002
# Installing Protobuf
RUN curl -OL https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip
RUN unzip protoc-3.2.0-linux-x86_64.zip -d protoc3
RUN mv protoc3/bin/* /usr/local/bin/
RUN mv protoc3/include/* /usr/local/include/
RUN rm protoc-3.2.0-linux-x86_64.zip
RUN rm -rf protoc3

# RUN cd models/research
# RUN protoc ./models/research/object_detection/protos/*.proto --python_out=.
RUN cd models/research && protoc ./object_detection/protos/*.proto --python_out=.

# # From tensorflow/models/research/
RUN echo 'export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim' >> ~/.bashrc

RUN git clone https://github.com/gpspelle/Fall_detection && cd Fall_detection && git pull origin master && cd ..
RUN git clone https://github.com/gpspelle/personal && cd personal && git pull origin master && cd ..
RUN cp personal/.vimrc ~/

#RUN wget us.download.nvidia.com/XFree86/Linux-x86_64/410.93/NVIDIA-Linux-x86_64-410.93.run \
#     && chmod +x NVIDIA-Linux-x86_64-410.93.run && ./NVIDIA-Linux-x86_64-410.93.run    

#RUN jupyter notebook --generate-config

#COPY .jupyter/jupyter_notebook_config.py ./app/jupyter-notebook-config.py 

#FROM ubuntu:18.04
#LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 10.0.130

ENV CUDA_PKG_VERSION 10-0=$CUDA_VERSION-1
# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION \
        cuda-compat-10-0=410.48-1 && \
    ln -s cuda-10.0 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -y htop

ENV PATH /usr/local/cuda/bin:${PATH}

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.0 brand=tesla,driver>=384,driver<385"

ENV PASSWORD 123

CMD ["jupyter", "notebook", "--allow-root"]

