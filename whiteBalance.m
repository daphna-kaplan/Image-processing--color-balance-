%algorithm for white balancing an image with the given infp:
%gray_card - an image of a gray card being pictured in a dark room with
%flash light
%original - an image of a scene with no flash, the image is steady and is 
%affected by mainly one light source
%originalWithFlash - the same scene with flash light
%adaptationType - the method to adapt the image from xyz to lms


function [ whiteBalancedImage,flashimage,noflashimage ] = whiteBalance( gray_card, original, originalWithFlash, adaptationType, mask )
    
    %chose the adaptation matrix
    if (strcmp(adaptationType, 'bradford'));
            adaptationMatrix = [0.8951 0.2664 -0.1614; -0.7502 1.7135 0.0367; ...
        0.0389 -0.0685 1.0296];
    elseif (strcmp(adaptationType, 'vonKries'));
             adaptationMatrix = [0.40024 0.7076 -0.08081; -0.2263 1.16532 0.0457; ...
        0 0 0.91822];
    else
            adaptationMatrix = eye(3);
    end
    inverseAdapt = inv(adaptationMatrix);
    
     %prepare the images to be a valid double uint8 images in LMS color space
    [card, noFlash, withFlash, adaptedOrigin] = adaptImages(gray_card, original, originalWithFlash, adaptationMatrix);

    %the flash chromatic
    flash = averageKL(card);

    %the flash image minus the noflash image give RK2L2 meaning the 
    %"affect of the flash on R"
    flashAffect = withFlash - noFlash ;
    flashAffect(flashAffect<0) = 0;
    RK2 = reduceLightColor(flash, flashAffect);
    L1Ratio = noFlash./RK2;
    
    %calculate the ratio so can isolate pixels were the ratio of k1/k2
    %so we can extract L1
    if strcmp(mask, 'R');

        ratio = flashAffect(:,:,2)./ noFlash(:,:,2);
        maskR = (ratio < 1.1) .* (ratio > 0.9);
        mask = logical(maskR);
    else
        middle = (max(flashAffect(:)) + min(flashAffect(:))) / 2;
        mask1 = (flashAffect(:,:,1) > middle -0.15).* (flashAffect (:,:,1)< middle + 0.15);
        mask2 = (flashAffect(:,:,2) > middle -0.15).* (flashAffect (:,:,2)< middle + 0.15);
        mask3 = (flashAffect(:,:,3) > middle -0.15).* (flashAffect (:,:,3)< middle + 0.15);

        mask = logical(mask1 .* mask2 .* mask3);
    end
    %ignore nan and infinite values in the image
    X = L1Ratio(:,:,1);
    Xmask = isnan(X) | isinf(X);
    Xmask = ~Xmask;
    Y = L1Ratio(:,:,2);
    Ymask = isnan(Y) | isinf(Y);
    Ymask = ~Ymask;
    Z = L1Ratio(:,:,3);
    Zmask = isnan(Z) | isinf(Z);
    Zmask = ~Zmask;
    maskValid =  logical(Xmask .* Ymask .* Zmask);
    
    %use both masks 
    mask = logical(maskValid.*mask);
    Light = [mean(X(mask)) mean(Y(mask)) mean(Z(mask))];
    
    %we define L1 : L1 = L1Ratio(mask)
    Light = Light./Light(2);
    
    sizeImage = size(adaptedOrigin);
    
    %reduce the L1 chromatic from the original image, use the illumination 
    % trasformation
    noChrome = reduceLightColor(Light, adaptedOrigin);
    reNoChrome = reshape(noChrome, sizeImage(1) * sizeImage(2), 3);
    reNoChrome = reNoChrome * inverseAdapt ;
    reAdaptedNoChrome = reshape(reNoChrome, sizeImage(1), sizeImage(2), 3);
    whiteBalancedImage = reAdaptedNoChrome;
    
    % gamma correction
     whiteBalancedImage = im2double(whiteBalancedImage);
%     whiteBalancedImage = whiteBalancedImage.^0.4545;
%     flashimage = withFlash.^0.4545;
%     noflashimage = noFlash.^0.4545;

   hgamma = ...
   vision.GammaCorrector(18,'Correction','Gamma');
   whiteBalancedImage = step(hgamma, whiteBalancedImage);
   flashimage = step(hgamma, withFlash);
   noflashimage = step(hgamma, noFlash);

end



