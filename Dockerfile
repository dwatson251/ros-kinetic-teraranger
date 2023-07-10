FROM ros:kinetic
LABEL authors="Daniel Watson"
SHELL ["/bin/bash", "-c"]

RUN sed -i 's/htt[p|ps]:\/\/archive.ubuntu.com\/ubuntu\//mirror:\/\/mirrors.ubuntu.com\/mirrors.txt/g' /etc/apt/sources.list

# Install teraranger and dependencies
RUN \
    apt update \
    && apt install -y ros-kinetic-serial \
    && apt install -y ros-kinetic-catkin python-catkin-tools \
    && apt install -y python-serial python-opencv python-crcmod python-cv-bridge

WORKDIR /ros_teraranger_build
ENTRYPOINT ["/ros_entrypoint.sh"]
# Install teraranger scripts and launch shell
CMD \
    mkdir src; \
    # Or use git@github.com:Terabee/teraranger.git if you got a SSH key
    git -C src clone --depth 1 --branch 2.1.0 https://github.com/Terabee/teraranger.git; \
    . /opt/ros/kinetic/setup.bash; \
    catkin_make; \
    . devel/setup.bash; \
    nohup roscore & bash