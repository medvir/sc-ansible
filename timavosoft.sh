#!/bin/bash

cd /tmp

# rmate standalone https://github.com/aurora/rmate
curl -Lo /usr/local/bin/rmate https://raw.githubusercontent.com/aurora/rmate/master/rmate
chmod a+x /usr/local/bin/rmate

# install samtools
if [ -x "$(command -v samtools)" ]; then
    echo "samtools installed"
else
    echo "installing samtools"
    wget -nv -O - https://github.com/samtools/samtools/releases/download/1.3/samtools-1.3.tar.bz2 | \
        tar -xj
    cd samtools-1.3 && make -j 8 && make install
    cd ..
fi

# install blast main tools
if [ -x "$(command -v blastn)" ]; then
    echo "blast installed"
else
    echo "installing blast"
    wget -nv -O - ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST//ncbi-blast-2.5.0+-x64-linux.tar.gz | \
        tar -xz
    install -t /usr/local/bin ncbi-blast-2.5.0+/bin/*
    rm -rf /tmp/ncbi-blast-2.5.0+/
fi

# install lofreq
if [ -x "$(command -v lofreq)" ]; then
    echo "lofreq installed"
else
    wget -nv -O - https://github.com/CSB5/lofreq/archive/v2.1.2.tar.gz | tar -xz
    cd lofreq-2.1.2
    wget -nv -O - http://downloads.sourceforge.net/project/samtools/samtools/1.1/samtools-1.1.tar.bz2 | tar -xj
    cd samtools-1.1
    make -j 8
    cd ..
    libtoolize
    ./bootstrap && ./configure SAMTOOLS=${PWD}/samtools-1.1/ HTSLIB=${PWD}/samtools-1.1/htslib-1.1/ && \
    make -j 8 && make install
    cd ..
fi

# install freebayes
if [ -x "$(command -v freebayes)" ]; then
    echo "freebayes installed"
else
    git clone --recursive git://github.com/ekg/freebayes.git
    cd freebayes
    make -j 8 && sudo make install
    cd vcflib && make -j 8
    cd ../..
fi

# prinseq
if [ ! -x "$(command -v prinseq)" ]; then
    echo "prinseq installed"
else
    wget -nv -O - http://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz | \
        tar -xz
    install -v prinseq-lite-0.20.4/prinseq-lite.pl /usr/local/bin/prinseq;
fi

# install edirect
if [ -x "$(command -v edirect)" ]; then
    echo "edirect installed"
else
    cd /usr/local
    echo "installing edirect"
    sudo perl -MNet::FTP -e \
      '$ftp = new Net::FTP("ftp.ncbi.nlm.nih.gov", Passive => 1); $ftp->login; \
       $ftp->binary; $ftp->get("/entrez/entrezdirect/edirect.zip");';
    unzip -u -q edirect.zip
    rm edirect.zip
    ./edirect/setup.sh
fi

# miniconda, Biopython...
if [ -x "/opt/miniconda/bin/conda" ]; then
    echo "miniconda installed"
else
    wget -nv https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b -p /opt/miniconda
    hash -r && \
        /opt/miniconda/bin/conda config --set always_yes yes --set changeps1 no && \
        /opt/miniconda/bin/conda update -q conda
    /opt/miniconda/bin/conda install -q Biopython pandas seaborn scipy
fi

# VirMet
if [ -x "/opt/miniconda/bin/virmet" ]; then
    echo "VirMet installed"
else
    cd /opt
    git clone --depth=50 --branch=master https://github.com/ozagordi/VirMet.git \
        && cd /opt/VirMet \
        && /opt/miniconda/bin/python3 setup.py install
fi
