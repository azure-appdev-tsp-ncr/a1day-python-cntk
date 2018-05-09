# a1day-python-cntk
Neural Binary Classification Example using CNTK Python Libraries, see MSDN 2018 March Article for full description of use case - https://msdn.microsoft.com/en-us/magazine/mt845655 

**To create a Docker Image of example, unit test locally, then run in Azure follow instructions** [here](https://github.com/azure-appdev-tsp-ncr/a1day-python-cntk/tree/master/Lab)

To run in a local python installation or from within a Docker Image:
- From CNTK Linux Install (CNTK only supported on Ubuntu 16.X)

If running example from base Docker Image:
```
docker run -it lepinkainen/ubuntu-python-base:latest bash
```
```
apt-get install openmpi-bin
pip install cntk
python -c "import cntk; print(cntk.__version__)"
```
git clone this repo, then run bash script "cleveland_bnn.sh" from base of git project, should get the following output
```
Begin binary classification (two-node technique)

Using CNTK version = 2.5.1

Creating a 18-20-2 tanh-softmax NN
Selected CPU as the process wide default device.
Creating a cross entropy batch=10 SGD LR=0.005 Trainer

Starting training

batch    0: mean loss = 0.6932, accuracy = 40.00%
batch  500: mean loss = 0.7084, accuracy = 30.00%
batch 1000: mean loss = 0.5456, accuracy = 90.00%
batch 1500: mean loss = 0.4894, accuracy = 80.00%
batch 2000: mean loss = 0.4164, accuracy = 80.00%
batch 2500: mean loss = 0.7000, accuracy = 80.00%
batch 3000: mean loss = 0.2024, accuracy = 100.00%
batch 3500: mean loss = 0.1493, accuracy = 100.00%
batch 4000: mean loss = 0.2583, accuracy = 90.00%
batch 4500: mean loss = 0.3860, accuracy = 90.00%

Training complete

Evaluating accuracy using built-in test_minibatch()

Classification accuracy on the 297 data items = 84.18%

End Cleveland Heart Disease classification
```


