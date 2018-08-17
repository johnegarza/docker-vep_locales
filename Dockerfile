FROM ubuntu:xenial
MAINTAINER John Garza <johnegarza@wustl.edu>

LABEL \
    description="VEP image with the locale bugfix applied"i

RUN apt-get update

RUN mkdir /opt/vep/
WORKDIR /opt/vep

RUN git clone https://github.com/Ensembl/ensembl-vep.git
WORKDIR /opt/vep/ensembl-vep
RUN git checkout postreleasefix/90

RUN perl INSTALL.pl --NO_UPDATE

WORKDIR /
RUN ln -s /opt/vep/ensembl-vep/vep /usr/bin/variant_effect_predictor.pl

RUN mkdir -p /opt/lib/perl/VEP/Plugins
COPY Downstream.pm /opt/lib/perl/VEP/Plugins/Downstream.pm
COPY Wildtype.pm /opt/lib/perl/VEP/Plugins/Wildtype.pm

COPY add_annotations_to_table_helper.py /usr/bin/add_annotations_to_table_helper.py
COPY docm_and_coding_indel_selection.pl /usr/bin/docm_and_coding_indel_selection.pl

#fix ubuntu locale bug- other suggestions at
#https://stackoverflow.com/questions/8671308/non-interactive-method-for-dpkg-reconfigure-tzdata

#RUN apt-get update -y && apt-get install -y libnss-sss tzdata
#RUN ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

#RUN echo "America/Chicago" > /etc/timezone
#RUN dpkg-reconfigure --frontend noninteractive tzdata

#RUN ln -s /opt/vep/ensembl-vep/vep /usr/bin/variant_effect_predictor.pl
