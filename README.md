# Digital-Medicine-Case-2

## version 7
### programming language
* python 3.7

#### packages
* tensorflow 2.7
* pydicom

### model (transfer learning)
* base model: inception_v3(lock parameters)
* add layers: 
   * global average pooling layer
   * dropout(0.7)
   * Dense(3)

### data preprocessing
* normailization
* rotation_range=10
* zoom_range=0.2
* horizontal_flip=True
* fill_mode='nearest'
* brightness_range = [0.5, 1.5]
* validation_split = 0.2

### training parameters
* optimizers: SGD (learining rate:0.0001)
* early stopping: 10 patience with min delta = 1E-5
* loss function: categorical crossentropy

