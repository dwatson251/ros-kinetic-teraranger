FROM ros:kinetic
LABEL authors="Daniel Watson"
SHELL ["/bin/bash", "-c"]
WORKDIR /ros_teraranger_build

COPY patches/evo_thermal.py/correct_cv2_image_map.patch /ros_teraranger_build/patches/evo_thermal.py/correct_cv2_image_map.patch

RUN sed -i 's/htt[p|ps]:\/\/archive.ubuntu.com\/ubuntu\//mirror:\/\/mirrors.ubuntu.com\/mirrors.txt/g' /etc/apt/sources.list

# Install teraranger and dependencies
RUN \
    apt update \
    && apt install -y ros-kinetic-serial \
    && apt install -y ros-kinetic-catkin python-catkin-tools \
    && apt install -y python-serial python-opencv python-crcmod python-cv-bridge

# Install teraranger scripts and launch shell
RUN \
    mkdir src; \
    # Or use git@github.com:Terabee/teraranger.git if you got a SSH key
    git -C /ros_teraranger_build/src clone --depth 1 --branch 2.1.0 https://github.com/Terabee/teraranger.git; \
    git -C /ros_teraranger_build/src/teraranger apply /ros_teraranger_build/patches/evo_thermal.py/correct_cv2_image_map.patch; \
    . /opt/ros/kinetic/setup.bash; \
    catkin_make;

RUN \
    echo '. /ros_teraranger_build/devel/setup.bash;' >> /root/.bashrc; \
    echo 'nohup roscore & echo "Roscore is running."' >> /root/.bashrc;

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["/bin/bash"]