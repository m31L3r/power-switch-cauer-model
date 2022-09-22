function [volume] = volumeSquareFrustum(x1,h,angle)
    
    % Calculate the volume of a square pyramid frustum.
    % x1 = length of the top square area.
    % x2 = length of the bottom square area.
    % h  = height.
    % angle = angle between h and pyramids sides.
    x2 = x1 + 2*h*tan(angle);
    volume = h/3 * (x1^2 + x1*x2 + x2^2);
    
end