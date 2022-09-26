function [cth] = calc_cth_frustum(roh,cp,x,h,angle)

    % Calculate thermal capacity of a square pyramid frustum.
    % x = length of top square area.
    % h  = height.
    % angle = angle between h and pyramids sides.
    cth = roh*cp*h* ( x^2 + 2*h*x*tan(angle) + 4/3*h^2*tan(angle));

end
