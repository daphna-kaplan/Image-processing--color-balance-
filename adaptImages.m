function [ card,noFlash,withFlash, LMSnoFlash ] = adaptImages( gray_card, original, originalWithFlash, adaptation )
%adaptImages turn the images from tiff XYZ to tiff double images


    card = imread(gray_card);
    noFlash = imread(original);
    withFlash = imread(originalWithFlash);
    
    if (size(card ,3) == 4);
        card3(:,:,1) = card(:,:,1);
        card3(:,:,2) = card(:,:,2);
        card3(:,:,3) = card(:,:,3);
        card = card3;
       
      
        no3(:,:,1) = noFlash(:,:,1);
        no3(:,:,2) = noFlash(:,:,2);
        no3(:,:,3) = noFlash(:,:,3);
        noFlash = no3;
       
        with3(:,:,1) = withFlash(:,:,1);
        with3(:,:,2) = withFlash(:,:,2);
        with3(:,:,3) = withFlash(:,:,3);
        withFlash = with3;
    end
    card = double(card) ./ (2^8 - 1);
    %card = uint8(card);
    card = im2double(card) ;

    noFlash = double(noFlash) ./ (2^8 - 1);
    noFlash = uint8(noFlash);
    noFlash = im2double(noFlash);

    withFlash = double(withFlash)./ (2^8 - 1);
    withFlash = uint8(withFlash);
    withFlash = im2double(withFlash) ;

    originSize = size(noFlash);
    reOrigin = reshape(noFlash, originSize(1) * originSize(2), 3);
    reOrigin = reOrigin * adaptation;
    LMSnoFlash = reshape(reOrigin, originSize(1), originSize(2), 3);


end

