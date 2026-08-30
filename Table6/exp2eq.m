function eq = exp2eq(E,coef,var)
%exp2eq Convert exponent matrix to LaTeX monomials.
%%  Name:        exp2eq
%   Version:     1.0
%   Author:      Serhii M. Ivanov
%   Date:        2026
%% Description:
% exp2eq converts an exponent matrix into a set of LaTeX monomial expressions. 
% Each row of the exponent matrix defines one monomial, with the columns 
% representing the exponents of the corresponding variables. The function 
% optionally includes coefficient and variable names in the generated expressions.
%% Syntax:
% Eq = exp2eq(E)
% Eq = exp2eq(E,'x')
% Eq = exp2eq(E,'c','x')
% E    : exponent matrix (M x p)
% coef : coefficient names, e.g. "c"
% var  : variable names, e.g. "x"
%% Inputs:
% E — exponent matrix of size M x p, where each row represents a monomial and each column corresponds to a variable.
% coef — optional name or symbol used for the coefficients of the polynomial terms (e.g., 'c').
% var — optional name or symbol used for the variables (e.g., 'x').
%% Output:
% Eq — string array containing the corresponding monomial expressions in LaTeX format.
%% Example:
% For the exponent matrix
% E =
% \begin{bmatrix}
% 0 & 0\\
% 1 & 0\\
% 0 & 1\\
% 2 & 0\\
% 1 & 1\\
% 0 & 2
% \end{bmatrix},

% the function can generate monomials such as
% c_1+ c_2x_1+ c_3x_2+ c_4x_1^2+ c_5x_1x_2+ c_6x_2^2.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

if nargin < 2
    coef = "c";
end

if nargin < 3
    var = "x";
end

[M,p] = size(E);

terms = strings(M,1);

for k = 1:M

    term = coef + "_{" + k + "}";

    for j = 1:p

        e = E(k,j);

        if e == 0
            continue
        elseif e == 1
            term = term + var + "_{" + j + "}";
        else
            term = term + var + "_{" + j + "}^{" + e + "}";
        end

    end

    terms(k) = term;

end

eq = strjoin(terms," + ");

end