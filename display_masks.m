
im_height = 100;
im_width = 100;

figure
title('Sampled masks')
for k=1:16
    subplot(4,4,k)
    mask = get_mask(im_height,im_width);
    imshow(mask);
end