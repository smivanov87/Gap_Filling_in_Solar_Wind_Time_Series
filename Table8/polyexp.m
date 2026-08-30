function E = polyexp(n,d)
%polyexp Generate exponent matrix for multivariate polynomials.
%%  Name:        polyexp
%   Version:     1.0
%   Author:      Serhii M. Ivanov
%   Date:        2026
%% E = polyexp(n,d)
%
% Returns a matrix E where each row contains the exponents of one monomial
% in n variables with total degree <= d.
%
% Example:
%   E = polyexp(5,3);

%% Description
% polyexp generates the exponent matrix for a multivariate polynomial with n variables 
% and a maximum total degree of d. Each row of the output matrix represents one polynomial 
% term, while each column corresponds to one of the input variables. The exponents in each 
%     row define the powers of the variables in the corresponding polynomial term.
% Syntax:
% 
% E = polyexp(n, d)
% 
% Inputs:
% n — number of variables in the multivariate polynomial.
% d — maximum total degree of the polynomial.
% Output:
% E — exponent matrix, where each row represents a polynomial term and each column corresponds 
% to a variable. The sum of the exponents in each row does not exceed d.
% Example:
% For n = 2 and d = 2, the matrix contains the exponent combinations corresponding to terms such as 
% 1 + x_1 + x_2 + x_1^2 + x_1x_2 + x_2^2
% The corresponding exponent matrix is
% E =
% \begin{bmatrix}
% 0 & 0\\
% 1 & 0\\
% 0 & 1\\
% 2 & 0\\
% 1 & 1\\
% 0 & 2
% \end{bmatrix}


Nterms = nchoosek(n+d,d);
if Nterms>250000
    error(['The number of terms (' num2str(Nterms) ') is too large. Reduce the number of variables or the polynomial degree!']);
    
end

E = [];

for deg = 0:d
    E = [E; exponentsFixedDegree(n,deg)];
end

end

function A = exponentsFixedDegree(n,deg)

if n == 1
    A = deg;
    return
end

A = [];

for k = deg:-1:0
    B = exponentsFixedDegree(n-1,deg-k);
    A = [A; [k*ones(size(B,1),1) B]];
end

end