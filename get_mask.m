function mask = get_mask(im_h,im_w)

NUM_MASK_TYPES = 2;

k = randi(NUM_MASK_TYPES);

if k==1 % generate rectangular mask

    y_cor = randi(int8(im_h*3/4));
    x_cor = randi(int8(im_w*3/4));
    
    if y_cor~=im_h
        h = randi([int8((im_h-y_cor)*3/4) (im_h-y_cor)]);
    else
        h = 0;
    end
    if x_cor~=im_w
        w = randi([int8((im_w-x_cor)*3/4) (im_w-x_cor)]);
    else
        w = 0;
    end
    
    mask = zeros(im_h,im_w);
    mask(y_cor:y_cor+h,x_cor:x_cor+w) = 1;

elseif k==2 % generate circular mask
    
    y_c = randi([int8(im_h/4) int8(im_h*3/4)]);
    x_c = randi([int8(im_w/4) int8(im_w*3/4)]);

    min_dist = min([x_c im_w-x_c y_c im_h-y_c]);
    radius = randi([int8(min_dist*3/4) min_dist]);

    [grid_x,grid_y] = ndgrid((1:im_h)-y_c,(1:im_w)-x_c);
    mask = (grid_x.^2 + grid_y.^2)<radius^2;
end

end

