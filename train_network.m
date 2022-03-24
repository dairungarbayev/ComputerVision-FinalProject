clear

obj_name = 'cat';
im = imread(strcat('images/',obj_name,'.jpg'));

im_size = size(im);
min_side = min(im_size(1:2));

im_square = imcrop(im,[1,1,min_side-1,min_side-1]);
im_size = [100, 100];
im_resized = imresize(im_square,[100 100]);
scale = 0.1;
im_small = imresize(im_resized,scale);

[x_train,y_train,x_val,y_val] = get_trainval_data(im_resized,scale,1000,0.75,512);

% scale pixel values to [0,1] range
x_train = x_train/255;
y_train = y_train/255;
x_val = x_val/255;
y_val = y_val/255;


layers = [
  imageInputLayer(size(x_train(:,:,:,1)),'Normalization','none')
  transposedConv2dLayer(3,256)
  reluLayer
  transposedConv2dLayer(3,128,'Stride',2,'Cropping',[1 1 1 1])
  reluLayer
  transposedConv2dLayer(3,64)
  reluLayer
  transposedConv2dLayer(3,32,'Stride',2,'Cropping',[1 1 1 1])
  reluLayer
  transposedConv2dLayer(3,8)
  reluLayer
  transposedConv2dLayer(3,3,'Stride',2,'Cropping',[2 1 1 2])
  sigmoidLayer
  regressionLayer
];

options = trainingOptions('adam', ...
    'MiniBatchSize',50, ...
    'MaxEpochs',500, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{x_val,y_val}, ...
    'ValidationFrequency',1, ...
    'Plots','training-progress', ...
    'Verbose',false);

net = trainNetwork(x_train,y_train,layers,options);

% save trained network in the same folder
save net

% visualize some validation images and outputs
preds = predict(net,x_val);

preds_size = size(preds);
figure
for l=1:2:8
    k = randi(preds_size(4));
    subplot(4,2,l)
    imshow(preds(:,:,:,k))
    subplot(4,2,l+1)
    imshow(y_val(:,:,:,k))
end