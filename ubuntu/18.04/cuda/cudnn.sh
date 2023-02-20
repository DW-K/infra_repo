# ubuntu 20.04
wget https://developer.nvidia.com/downloads/c118-cudnn-local-repo-ubuntu2004-88012110-1amd64deb

tar –xzvf cudnn-local-repo-ubuntu2004-8.8.0.121_1.0-1_amd64.deb

sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

cat /usr/local/cuda/include/cudnn_version.h | grep CUDNN_MAJOR -A 2
ldconfig -N -v $(sed 's/:/ /' <<< $LD_LIBRARY_PATH) 2>/dev/null | grep libcudnn