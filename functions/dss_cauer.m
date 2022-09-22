function [Ad,Bd,C,D] = dss_cauer(rth,cth,ts)
%% Create State Space Model

    modelOrder = length(cth);
    
    % A
    A = zeros(modelOrder);
    for idx = 1:modelOrder-1

        coef1 = 1 /(cth(idx)*rth(idx));
        coef2 = coef1;
        coef3 = 1 /(cth(idx+1)*rth(idx));
        coef4 = coef3;

        k(:,:,idx) = [coef1 coef2; ...
                      coef3 coef4];     

    end

    for n=1:modelOrder-1

        i=n+[0 1];
        j=i;
        A(i,j)=A(i,j)+k(:,:,n);

    end

    A(end,end) = A(end,end) + 1 /(cth(end)*rth(end));
    A = A.* (ones(modelOrder)+(eye(modelOrder)*-2));

    % B
    B = [1/cth(1)     0;...
         0            0;...
         0            0;...
         0            0;...
         0            0;...
         0            0;...
         0            0;...
         0            1/(rth(end)*cth(end))];

    % C
    C = [1 0 0 0 0 0 0 0];
    % D
    D = [0 0];

    % Perform trick to compute Ad and Bd in one step
    % Source:
    % Raymond DeCarlo: Linear Systems: A State Variable 
    % Approach with Numerical Implementation, Prentice Hall, NJ, 1989
    if det(A) == 0
        error('System Matrix A has singularity');
    end
    temp = expm([A,B;zeros(2,modelOrder+2)]*ts);
    Ad = temp(1:modelOrder,1:modelOrder);
    Bd = temp(1:modelOrder,modelOrder+1:modelOrder+2);

end
