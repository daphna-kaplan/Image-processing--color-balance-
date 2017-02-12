function [ Rimage ] = reduceLightColor( lightColor, image )
%reduceFlashColor Summary of this function goes here
%   Detailed explanation goes here
    
    Rimage(:,:,1) = image(:,:,1) /lightColor(1);
    Rimage(:,:,2) = image(:,:,2) /lightColor(2);
    Rimage(:,:,3) = image(:,:,3) /lightColor(3);

end


