function [Nkg]=kg_terms(Nvar, deg_kg)
%   Name:        kg_terms
%   Version:     1.0
%   Author:      Serhii M. Ivanov
%   Date:        2026
%% Description
% The kg_terms function calculates the total number of polynomial terms generated 
% from a given number of variables up to a specified maximum polynomial degree, 
% excluding the constant term.
%% Input:
% Nvar - number of variables;
% deg_kg - maximum polynomial degree
%% Otput
% Nkg - number of terms (w/o the constant term)
% Thus, Nkg gives the number of non-constant terms in a complete multivariate 
% polynomial of degree up to deg_kg.


    Nkg=0;
    for l=1:deg_kg
        Nkg=Nkg+nchoosek(Nvar+l-1,l);
    end
end