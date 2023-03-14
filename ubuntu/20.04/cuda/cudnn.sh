# after download cudnn : https://developer.nvidia.com/rdp/cudnn-archive
#tar xvzf cudnn-11.3-linux-x64-v8.2.1.32.tgz
sudo cp cuda/include/cudnn* /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

sudo ln -sf /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_adv_train.so.8.2.1 /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_adv_train.so.8
sudo ln -sf /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_ops_infer.so.8.2.1  /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_ops_infer.so.8
sudo ln -sf /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_cnn_train.so.8.2.1  /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_cnn_train.so.8
sudo ln -sf /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_adv_infer.so.8.2.1  /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_adv_infer.so.8
sudo ln -sf /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_ops_train.so.8.2.1  /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_ops_train.so.8
sudo ln -sf /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_cnn_infer.so.8.2.1 /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn_cnn_infer.so.8
sudo ln -sf /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn.so.8.2.1 /usr/local/cuda-11.3/targets/x86_64-linux/lib/libcudnn.so.8
sudo ldconfig
ldconfig -N -v $(sed 's/:/ /' <<< $LD_LIBRARY_PATH) 2>/dev/null | grep libcudnn
