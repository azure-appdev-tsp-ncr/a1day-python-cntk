#Current testing/prototyping used to successfully run training of Model:
#
#   Used Docker Image: docker pull lepinkainen/ubuntu-python-base
#   From CNTK Linux Install
#
# apt-get install openmpi-bin
# pip install cntk
# python -c "import cntk; print(cntk.__version__)"
#
FROM  lepinkainen/ubuntu-python-base:latest
LABEL author="Greg Hoelzer <Greg.Hoelzer@microsoft.com>" \
      io.k8s.description="Demo Python/Congitive Tool Kit Binary Classification Example" \
      io.k8s.display-name="a1day-python-cntk" \
      io.k8s.expose-services="batch" \
      io.k8s.tags="demo,python,CNTK,MSDN"
# Additional Base OS Python Packages required
RUN apt-get -y install openmpi-bin && pip install cntk
# Validate CNTK install
RUN python -c "import cntk; print(cntk.__version__)"

# Clone project onto image
RUN mkdir -p /opt/a1day-python-cntk && mkdir /env && \ 
    git clone https://github.com/azure-appdev-tsp-ncr/a1day-python-cntk.git /opt/a1day-python-cntk && \
    cd  /opt/a1day-python-cntk && echo "Docker Build Iteration 3"
# Expose /env as Volume
VOLUME [ "/env" ]
# Set App Data Root for Volume Mount
ENV APP_ROOT="/env"
# Run code with default, Non-Root User
RUN chown -R 1001:1001 /opt/a1day-python-cntk && chown -R 1001:1001 /env
# Add Python & System Libraries to Root Group
RUN chgrp -R 0 /usr/local 
RUN chmod -R g+rw /usr/local 
RUN find /usr/local -type d -exec chmod g+x {} + 
USER 1001
# Run Python CNTK Model Training & Verification
CMD [ "python", "/opt/a1day-python-cntk/cleveland_bnn.py" ]


