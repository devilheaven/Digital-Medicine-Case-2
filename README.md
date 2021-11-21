# Digital-Medicine-Case-2

## problem
* Because we modify the class, DataFrameIterator, in Keras package to load DICOM image, we can not use all of training DICOM image to draw the confusion matrix. However, we can modify and fine-tuning the model according to the confusion matrix.
* The second verion model has high accuracy and low loss value in trainning dataset and validation dataset which is splited from trainning DICOM images. However, it has low accuracy in validation DICOM images.
* The seventh version model can not recognize the Atypical images.

-----

## version 2
### programming language
* python 3.7

#### packages
* tensorflow 2.7
* keras 2.7
* pydicom

#### enviroment
*  GeForce RTX 3090

### model 
<code>
Model: "sequential"

_________________________________________________________________
 Layer (type)                Output Shape              Param #   
________________________________________________________________

 conv2d (Conv2D)             (None, 128, 128, 32)      320       
                                                                 
 conv2d_1 (Conv2D)           (None, 128, 128, 32)      9248      
                                                                 
 batch_normalization (BatchN  (None, 128, 128, 32)     128       
 ormalization)                                                   
                                                                 
 max_pooling2d (MaxPooling2D  (None, 64, 64, 32)       0         
 )                                                               
                                                                 
 conv2d_2 (Conv2D)           (None, 64, 64, 64)        18496     
                                                                 
 conv2d_3 (Conv2D)           (None, 64, 64, 64)        36928     
                                                                 
 batch_normalization_1 (Batc  (None, 64, 64, 64)       256       
 hNormalization)                                                 
                                                                 
 max_pooling2d_1 (MaxPooling  (None, 32, 32, 64)       0         
 2D)                                                             
                                                                 
 conv2d_4 (Conv2D)           (None, 32, 32, 64)        36928     
                                                                 
 conv2d_5 (Conv2D)           (None, 32, 32, 64)        36928     
                                                                 
 batch_normalization_2 (Batc  (None, 32, 32, 64)       256       
 hNormalization)                                                 
                                                                 
 max_pooling2d_2 (MaxPooling  (None, 16, 16, 64)       0         
 2D)                                                             
                                                                 
 conv2d_6 (Conv2D)           (None, 16, 16, 32)        18464     
                                                                 
 conv2d_7 (Conv2D)           (None, 16, 16, 32)        9248      
                                                                 
 batch_normalization_3 (Batc  (None, 16, 16, 32)       128       
 hNormalization)                                                 
                                                                 
 max_pooling2d_3 (MaxPooling  (None, 8, 8, 32)         0         
 2D)                                                             
                                                                 
 flatten (Flatten)           (None, 2048)              0         
                                                                 
 dense (Dense)               (None, 1024)              2098176   
                                                                 
 dense_1 (Dense)             (None, 1024)              1049600   
                                                                 
 dropout (Dropout)           (None, 1024)              0         
                                                                 
 dense_2 (Dense)             (None, 3)                 3075      
                                                                 
_______________________________________________________________
Total params: 3,318,179
Trainable params: 3,317,795
Non-trainable params: 384
___________________________________________________
</code>
### data preprocessing
* normailization
* rescale=1.0/255.0
* validation_split = 0.2

### training parameters
* optimizers: SGD (learining rate:0.0001)
* early stopping: 10 patience with min delta = 1E-3
* loss function: categorical crossentropy

----

## version 7
### programming language
* python 3.7

#### packages
* tensorflow 2.7
* pydicom

#### enviroment
*  GeForce RTX 3090

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

