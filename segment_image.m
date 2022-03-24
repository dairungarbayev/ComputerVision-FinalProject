clear

obj_name = 'cat';

mu = 127.5;
sigma = 1.2;
inp_chan_num = 256; % for cat and dog
%inp_chan_num = 512; % for car

net = load(strcat('trained_nets/net_',obj_name,'.mat'),'net');
net = net.net;

im = imread(strcat('images/',obj_name,'.jpg'));

im_size = size(im);
min_side = min(im_size(1:2));

im_square = imcrop(im,[1,1,min_side-1,min_side-1]);
im_size = [100, 100];
im_resized = imresize(im_square,[100 100]);

scale = 0.1;
im_small = imresize(im_resized,scale);

num_outputs = 3;
outputs = zeros(im_size(1),im_size(2),3,num_outputs);
inputs = outputs;
user_scribbles = outputs;

for k=1:num_outputs
    
    imshow(im_resized);
    
    hold on
    im_interface = imresize(im_small,1/scale,"nearest");
    h = imshow(im_interface);
    alpha = 0.5*ones(im_size(1:2));
    set(h,'AlphaData',alpha);
    hold off
    
    fg = drawfreehand;
    mask_fg = createMask(fg,h);
    im_input = im_small.*imresize(uint8(mask_fg),scale);

    user_scribbles(:,:,:,k) = uint8(im_resized.*uint8(mask_fg));
    
    inputs(:,:,:,k)=uint8(imresize(im_input,1/scale,"nearest"));

    x_img = rgb2gray(im_input);
    x_full = x_img;
    for l=1:inp_chan_num-1
        x_full = cat(3,x_full,x_img);
    end
    x_noise = normrnd(mu,sigma,[im_size(1)*scale im_size(2)*scale inp_chan_num]);
    x_full = double(x_full)+x_noise;
    x_full = x_full/255;
    
    prediction = predict(net,x_full);
    imwrite(prediction,strcat('results/',obj_name,'_',int2str(k),'.jpg'));
    outputs(:,:,:,k)=uint8(prediction*255);
end

figure
for k=1:num_outputs
    subplot(num_outputs,1,k)
    image_ = cat(2,user_scribbles(:,:,:,k),inputs(:,:,:,k),outputs(:,:,:,k));
    imshow(uint8(image_))
end