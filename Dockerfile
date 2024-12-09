# # A dockerfile must always start by importing the base image.
# # We use the keyword 'FROM' to do that.
# # In our example, we want import the python image.
# # So we write 'python' for the image name and 'latest' for the version.
# FROM pymesh/pymesh

# # In order to launch our python code, we must import it into our image.
# # We use the keyword 'COPY' to do that.
# # The first parameter 'main.py' is the name of the file on the host.
# # The second parameter '/' is the path where to put the file on the image.
# # Here we put the file at the image root folder.

# #RUN git clone --single-branch https://github.com/LPDI-EPFL/masif

# # install necessary dependencies
# RUN apt-get update && \
# 	apt-get install -y wget git unzip cmake vim libgl1-mesa-glx dssp
	
# # DOWNLOAD/INSTALL APBS
# RUN mkdir /install
# WORKDIR /install
# RUN git clone https://github.com/Electrostatics/apbs-pdb2pqr
# WORKDIR /install/apbs-pdb2pqr
# RUN ls
# RUN git checkout b3bfeec
# RUN git submodule init
# RUN git submodule update
# RUN ls
# RUN cmake -DGET_MSMS=ON apbs
# RUN make
# RUN make install
# RUN cp -r /install/apbs-pdb2pqr/apbs/externals/mesh_routines/msms/msms_i86_64Linux2_2.6.1 /root/msms/
# RUN curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py
# RUN python get-pip.py

# # INSTALL PDB2PQR
# WORKDIR /install/apbs-pdb2pqr/pdb2pqr
# RUN git checkout b3bfeec
# RUN python2.7 scons/scons.py install

# # Setup environment variables 
# ENV MSMS_BIN /usr/local/bin/msms
# ENV APBS_BIN /usr/local/bin/apbs
# ENV MULTIVALUE_BIN /usr/local/share/apbs/tools/bin/multivalue
# ENV PDB2PQR_BIN /root/pdb2pqr/pdb2pqr.py

# # DOWNLOAD reduce (for protonation)
# WORKDIR /install
# RUN git clone https://github.com/rlabduke/reduce.git
# WORKDIR /install/reduce
# RUN make install
# RUN mkdir -p /install/reduce/build/reduce
# WORKDIR /install/reduce/build/reduce
# RUN cmake /install/reduce/reduce_src
# WORKDIR /install/reduce/reduce_src
# RUN make
# RUN make install

# # Install python libraries
# RUN pip3 install matplotlib 
# RUN pip3 install ipython Biopython scikit-learn tensorflow==1.12 networkx open3d==0.8.0.0 dask==1.2.2 packaging
# #RUN pip install StrBioInfo 

# # Clone masif
# WORKDIR /

# # We need to define the command to launch when we are going to run the image.
# # We use the keyword 'CMD' to do that.
# CMD [ "bash" ]


# 使用官方的Python基础镜像
FROM python:3.8-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖项
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        git \
        unzip \
        cmake \
        vim \
        libgl1-mesa-glx \
        dssp && \
    rm -rf /var/lib/apt/lists/*

# 安装APBS和PDB2PQR（这里需要简化，因为原始过程很复杂）
# 注意：下面的步骤可能需要调整，因为APBS和PDB2PQR的安装通常不是这么直接的
RUN mkdir /install && \
    cd /install && \
    git clone https://github.com/Electrostatics/apbs-pdb2pqr.git && \
    cd /install/apbs-pdb2pqr && \
    git checkout b3bfeec && \
    git submodule init && \
    git submodule update && \
    mkdir build && \
    cd build && \
    cmake .. -DGET_MSMS=ON && \
    make && \
    make install && \
    cd / && \
    rm -rf /install

# 由于msms的安装不是标准的，我们可能需要手动处理它
# 这里假设msms已经被正确安装到/usr/local/bin/msms（这可能需要您手动调整）

# 安装Python库
RUN pip install --no-cache-dir \
    matplotlib \
    ipython \
    biopython \
    scikit-learn \
    tensorflow==1.12 \
    networkx \
    open3d==0.8.0.0 \
    dask==1.2.2 \
    packaging

# 克隆masif仓库
RUN git clone https://github.com/LPDI-EPFL/masif.git

# 设置环境变量（如果需要的话）
# ENV MSMS_BIN /usr/local/bin/msms
# ENV APBS_BIN /usr/local/bin/apbs
# ENV MULTIVALUE_BIN /usr/local/share/apbs/tools/bin/multivalue
# ENV PDB2PQR_BIN /root/pdb2pqr/pdb2pqr.py
# 注意：上面的环境变量可能需要根据您的实际安装路径进行调整

# 指定容器启动时运行的命令
# 这里我们假设masif有一个可执行的入口点，比如一个Python脚本
# 如果masif没有提供，您可能需要创建一个脚本来运行您的应用程序
# CMD ["python", "/app/masif/some_script.py"]
# 由于我们不知道masif的确切入口点，这里我们先保留bash作为默认shell
CMD ["bash"]
