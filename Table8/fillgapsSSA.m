function [TS]=fillgapsSSA(TS,gaps_mask)
% https://uk.mathworks.com/matlabcentral/fileexchange/66277-jorsorokin-singularspectrum?s_tid=srchtitle_site_search_1_Jorsorokin%252FSingular%25E2%2580%258BSpectrum
% https://github.com/Jorsorokin/SingularSpectrum
% Singular spectrum analysis (SSA) is a non-parametric spectral decomposition technique for 
% time series, akin to fourier or wavelet analysis, in which a time-series is decomposed 
% into a time-frequency matrix. However, SSA does not rely on strict parametric forms and 
% is able to pull out non-stationary and complex components from time-series in a data-dependent manner. 
%
%   Name:        fillgapsSSA
%   Version:     1.0
%   Author:      Serhii M. Ivanov
%   Date:        2026 
%% Description:
% fillgapsSSA reconstructs missing values in a time series using Singular Spectrum Analysis (SSA). 
% The gaps are initially filled using linear interpolation, which provides starting values for 
% the iterative SSA reconstruction. The function then repeatedly decomposes and reconstructs 
% the time series using SSA and updates only the originally missing points. The iterations 
% continue until the change in the reconstructed values falls below the specified tolerance 
% or the maximum number of iterations is reached.
% 
% The function uses a fixed SSA window length of 250 samples and retains components 
% explaining 90% of the variance. The reconstructed values are updated for a maximum of 
% 50 iterations with a convergence tolerance of 10^{-6}. If the original time series contains 
% only non-negative values, negative reconstructed values are set to zero.
%% Syntax:
% 
% [TS] = fillgapsSSA(TS, gaps_mask)
% 
%% Inputs:
% TS — input time series containing the original data and missing values.
% gaps_mask — value used to identify the missing data points in TS.
%% Output:
% TS — time series with the missing values reconstructed using the SSA method.
%% Method:
% The function identifies the locations of the gaps in TS.
% The missing values are initially filled using linear interpolation.
% SSA decomposition is performed using a window length of 250 samples.
% The SSA reconstruction is used to update only the originally missing values.
% Steps 3–4 are repeated until convergence or until the maximum number of iterations is reached.
% For time series whose original minimum value is non-negative, negative reconstructed values are set to zero.
%% References:
% The function uses the MATLAB implementation of Singular Spectrum Analysis by Jorsorokin, 
% available at the following GitHub repository: https://github.com/Jorsorokin/SingularSpectrum.

currentFolder = pwd;
% strcat(currentFolder,'/SSA/')
addpath(strcat(currentFolder,'/SSA/'));
addpath(strcat(currentFolder,'/SSA/functions'));
% TS(isnan(TS))=gaps_mask;
minTS=min(TS);
k=find(TS==gaps_mask);
if ~any(TS == gaps_mask)
    disp('No gaps were found.');
    return;
end

% initially linearly interpolated gaps
met='lin'; 
TS=fillgaps(TS,gaps_mask,met);

L = 250;      % SSA window length 250
% K = 174;       % number of SSA modes
percVar = 0.9;
maxIter = 50;
tol = 1e-6;

for i = 1:maxIter

    % SSA decomposition
    ssa = SSA(TS);
    ssa.embed(L);
    ssa.decompose(percVar);

    % SSA reconstruction
    K=length(ssa.S); % number of SSA modes
    R = ssa.reconstruct(1:K);

    % Update only missing points
    TSold = TS;
    TS(k) = R(k);

    % convergence test
    ct = max(abs(TS(k)-TSold(k)));

    fprintf('Iteration %d, change = %.3e\n',i,ct);

    if ct < tol
        break
    end
end
            if minTS>=0
                TS(TS< 0) = 0;
            end

rmpath(strcat(currentFolder,'/SSA/'));
rmpath(strcat(currentFolder,'/SSA/functions'));

end %function




