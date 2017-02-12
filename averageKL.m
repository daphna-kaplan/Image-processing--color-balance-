
function [average] = averageKL( gray_card)
%averageKL get the avrage color of the gray card to help us find the
%bias color of flash, the k is constant, so the average is really the
%ration between L(1)/L(2) and so on..
    card = double(gray_card);
    x = mean(mean(card(:,:,1))) ;
    y = mean(mean(card(:,:,2)));
    z = mean(mean(card(:,:,3))) ;
    average = [x y z];
    average = average./average(2);
    
end