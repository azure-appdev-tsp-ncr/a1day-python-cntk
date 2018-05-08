# bash script to run python script locally, setting required environment variables
# assumes script is run from base of project
#
APP_ROOT="./"; export APP_ROOT
MODEL_RUN="local01"; export MODEL_RUN
# Run Example
python ./cleveland_bnn.py