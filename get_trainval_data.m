function [x_train,y_train,x_val,y_val] = get_trainval_data(img,scale,set_size,train_ratio,inp_chan_num)

mu = 127.5;
sigma = 1.2;

im_size = size(img);

y = zeros(im_size(1),im_size(2),im_size(3),set_size);
x = zeros(im_size(1)*scale,im_size(2)*scale,inp_chan_num,set_size);

for k=1:set_size
    
    mask = get_mask(im_size(1),im_size(2));

    y_img = img.*uint8(mask);
    y(:,:,:,k) = y_img;

    x_img = rgb2gray(imresize(y_img,scale));
    x_full = x_img;
    for l=1:inp_chan_num-1
        x_full = cat(3,x_full,x_img);
    end
    
    x_noise = normrnd(mu,sigma,[im_size(1)*scale im_size(2)*scale inp_chan_num]);
    x_full = double(x_full)+x_noise;
    x(:,:,:,k) = x_full;
end

x_train = x(:,:,:,1:ceil(train_ratio*set_size));
y_train = y(:,:,:,1:ceil(train_ratio*set_size));

x_val = x(:,:,:,ceil(train_ratio*set_size)+1:set_size);
y_val = y(:,:,:,ceil(train_ratio*set_size)+1:set_size);

end

