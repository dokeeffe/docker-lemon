FROM ubuntu
RUN useradd -ms /bin/bash lemon

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y python-gtk2-dev
RUN apt-get install -y git python-pip csh
RUN apt-get -y build-dep python-matplotlib python-scipy
RUN apt-get install -y libopenmpi-dev
RUN easy_install -U distribute
RUN apt-get install -y astrometry.net

# install IRAF
RUN wget ftp://iraf.noao.edu/iraf/v216/PCIX/iraf.lnux.x86_64.tar.gz
RUN mkdir /iraf
RUN tar -zxf iraf.lnux.x86_64.tar.gz -C /iraf
WORKDIR /iraf
RUN ./install
ENV IRAF=/iraf
RUN ls /iraf -la

# Install Montage
WORKDIR /montage
RUN git clone https://github.com/dokeeffe/Montage.git
WORKDIR /montage/Montage
RUN sed -i "s|# MPICC  =	mpicc|MPICC  =	mpicc |g" Montage/Makefile.LINUX
RUN sed -i "s|# BINS = 	|BINS =  |g" Montage/Makefile.LINUX
RUN make
RUN echo 'PATH=$PATH:/montage/Montage/bin' >> ~/.bashrc

# Setup montage for the lemon user
USER lemon
RUN echo 'PATH=$PATH:/montage/Montage/bin' >> ~/.bashrc

# clone lemon and install
RUN git clone https://github.com/vterron/lemon.git /home/lemon/lemon
WORKDIR /home/lemon/lemon
RUN pip install "numpy>=1.7.1"
RUN pwd
RUN pip install -r pre-requirements.txt
RUN pip install -r requirements.txt
RUN python ./setup.py

# Add custom CCD-filters here. My 'V' filter is 'PV' in the fits headers
RUN echo 'PATH=$PATH:~/lemon' >> ~/.bashrc
RUN echo '[custom_filters]' >> ~/.lemonrc
RUN echo 'PV = V (BAADER V)' >> ~/.lemonrc
RUN echo 'PB = B (BAADER B)' >> ~/.lemonrc


# Reinstall matplotlib from ubuntu repos, otherwise it will not work with gtk
RUN pip uninstall -y matplotlib
USER root
RUN apt-get install -y python-gtk2 python-matplotlib
USER lemon