FROM ubuntu:16.04

RUN apt-get update -y
RUN apt-get install -y sudo
RUN apt-get install -y curl
RUN apt-get install -y wget

RUN apt-get install -y protobuf-compiler python-pil python-lxml python-pip python-dev git
RUN pip install Flask==0.12.2 WTForms==2.1 Flask_WTF==0.14.2 Werkzeug==0.12.2
RUN pip install tensorflow

WORKDIR /opt
RUN git clone https://github.com/tensorflow/models
WORKDIR models/research
RUN protoc object_detection/protos/*.proto --python_out=.

RUN mkdir -p /opt/graph_def

WORKDIR /root
RUN git clone https://github.com/GoogleCloudPlatform/tensorflow-object-detection-example

WORKDIR /tmp

ENV MODEL="faster_rcnn_inception_resnet_v2_atrous_oid_2017_11_08"

RUN curl -OL http://download.tensorflow.org/models/object_detection/${MODEL}.tar.gz
RUN tar -xzf ${MODEL}.tar.gz ${MODEL}/frozen_inference_graph.pb
RUN cp -a ${MODEL} /opt/graph_def/
RUN ln -sf /opt/graph_def/${MODEL}/frozen_inference_graph.pb /opt/graph_def/frozen_inference_graph.pb


WORKDIR /root/tensorflow-object-detection-example/object_detection_app

ENTRYPOINT ["python", "app.py"]
