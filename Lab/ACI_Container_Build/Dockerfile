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
FROM  ghoelzer2azure/a1day-python-cntk:latest
LABEL author="Greg Hoelzer <Greg.Hoelzer@microsoft.com>" \
      io.k8s.description="ACI Demo Python/Congitive Tool Kit Binary Classification Example" \
      io.k8s.display-name="a1day-python-cntk-aci" \
      io.k8s.expose-services="batch" \
      io.k8s.tags="demo,python,CNTK,MSDN"
USER root
# Run Python CNTK Model Training & Verification
CMD [ "python", "/opt/a1day-python-cntk/cleveland_bnn.py" ]


