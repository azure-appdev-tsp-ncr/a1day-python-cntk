# Example Python/CNTK for Training Neural Binary Classification Model:
#
#   From CNTK Linux Install Pre-req's: CNTK only fully supported on Ubuntu 16.x
#
#   apt-get install openmpi-bin
#   pip install cntk
#   python -c "import cntk; print(cntk.__version__)"
#
#   Build/Testing Notes:
#
#   Update "Docker Build Interation" on line 28 to force install of new python source
#   Local Unit Test Example: docker run -it -e 'APP_ROOT=/opt/a1day-python-cntk' a1day-python-cntk:latest
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
    cd  /opt/a1day-python-cntk && echo "Docker Build Iteration 10"
# Expose /env as Volume
VOLUME [ "/env" ]
# Set App Data Root for Volume Mount
ENV APP_ROOT="/env"
ENV MODEL_RUN="local01"
# Run code with default, Non-Root User
RUN chown -R 1001:1001 /opt/a1day-python-cntk && chown -R 1001:1001 /env
# Add Python & System Libraries to Root Group
RUN chgrp -R 0 /usr/local 
RUN chmod -R g+rw /usr/local 
RUN find /usr/local -type d -exec chmod g+x {} + 
USER 1001
# Run Python CNTK Model Training & Verification
CMD [ "python", "/opt/a1day-python-cntk/cleveland_bnn.py" ]


