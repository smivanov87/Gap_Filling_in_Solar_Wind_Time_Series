function [T,Eq,T1,ia] = Kpoly2(Xt,d)
% [T, Eq, T1, ia] = Kpoly2(Xt, d) generates a multivariate polynomial design matrix for the input data Xt up to the specified polynomial degree d.

%   Name:        Kpoly2
%   Version:     1.0
%   Author:      Serhii M. Ivanov
%   Date:        2026

% Inputs:
% Xt — input data matrix, where rows represent observations and columns represent variables.
% d — maximum degree of the multivariate polynomial.

% Outputs:
% T — polynomial design matrix, where each column corresponds to a polynomial term generated from the variables in Xt.
% Eq — symbolic representation of the generated multivariate polynomial terms.
% T1 — design matrix containing only the unique rows of T.
% ia — indices of the rows retained in T1, corresponding to the unique rows of T.
% The function first generates the exponent matrix for all multivariate polynomial terms up to degree d and then uses it to construct the polynomial design matrix. Duplicate rows of the resulting matrix are removed to obtain T1.
% d - degree of polinomial
% Xt : input matrix (observations x variables)

% E  : exponent matrix (terms x variables)

[nObser,nVar] = size(Xt);
E = polyexp(nVar,d); %exponent matrix for multivariate polynomials
Eq = exp2eq(E,'c','x'); %Latex equation

if size(E,2) ~= nVar
    error('Number of variables in Xt and E do not match.')
end

nTerms = size(E,1);

T = ones(nObser,nTerms);

for k = 1:nTerms
    
    for j = 1:nVar
        
        p = E(k,j);
        
        % multiply by x_j, power times
        for m = 1:p
            T(:,k) = T(:,k).*Xt(:,j);
        end
        
    end
    
end
% unique rows
 [T1, ia]=unique(T,'rows','stable'); 

end



