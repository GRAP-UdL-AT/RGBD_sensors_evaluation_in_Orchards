function [p1, p2, p3, Rsq] = quadratic_fitting_eval(x,y)
    p = polyfit(x,y,2);
    fit = polyval(p,x);
    yresid =  y - fit;
    SSresid = sum(yresid.^2);
    SStotal = (length(y)-1) * var(y); 
    Rsq = 1 - SSresid/SStotal;
    p1 = p(1);
    p2 = p(2);
    p3 = p(3);
end
