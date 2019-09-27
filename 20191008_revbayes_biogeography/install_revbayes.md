# Installing RevBayes with Jupyter notebook kernel on OS X

Note: these instructions should mostly work for Linux as well, but skip the 'first some dependencies' section; Linux comes readily equipped with better equivalents.


## First some dependencies

Before installing RevBayes, we will need to install the so called ```command line tools``` and several homebrew packages. Install the ```command line tools``` with

```console
xcode-select --install
```

If you don't have homebrew yet, follow the instructions as here:  http://osxdaily.com/2018/03/07/how-install-homebrew-mac-os/. Install GCC and Cmake with:

```console
brew install GCC
brew install Cmake
```

## Install RevBayes

We mostly follow the official instructions: https://revbayes.github.io/download. Download the latest version of RevBayes from Github and compile it:

```console
git clone https://github.com/revbayes/revbayes.git revbayes
```

Once downloaded, compile the program and make it jupyter compatible:

```console
cd revbayes/projects/cmake
./build.sh -jupyter true
```

## Install Jupyter notebook revbayes_kernel

The full instructions are on the github: https://github.com/revbayes/revbayes_kernel. Download the full repository with:

```console
git clone https://github.com/revbayes/revbayes_kernel.git
```

Then follow the standard installation instructions;

```console
cd revbayes_kernel
sudo python3 setup.py install
python3 -m revbayes_kernel.install
pip3 install metakernel
```

Perfect. You are all set to start a jupyter notebook and select the revbayes kernel to run RevBayes scripts.