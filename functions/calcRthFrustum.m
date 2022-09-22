function [thermalRes] = calcRthFrustum(lambda,x,h,beta)

    % Calculate thermal resistance of a square pyramid frustum.
    % h = height.
    % x = length of top square area.
    thermalRes = 1/lambda * h/(2*h*x*tan(beta)+x^2);

end
