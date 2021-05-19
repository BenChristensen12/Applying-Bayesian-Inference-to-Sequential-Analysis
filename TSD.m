function [Dprime,Zc,Beta] = TSD(FAR,HR)
%Takes inputs of single value of False Alarm Rate (FAR) and a single value
%of Hit Rate (HR) and outputs Dprime (discrimination), Zc (Z-score for
%decision bias cut off), and Beta (Likelihood Ratio cut off point)

%%%%%%%%%%%%%%%%%
%This function does not allow inputs of 1 or 0, these are rescaled.
if FAR == 1
    FAR = .999;
end
if FAR == 0
    FAR = .001;
end
if HR == 1
    HR = .999;
end
if HR == 0
    HR = .001;
end
%%%%%%%%%%%%%%%%%

% Set Parameters to Standard Normal: mu to 0, sigma to 1;
mu = 0;
sigma = 1;
%Compute Z-scores for noise and signal based on normal model
Zn = norminv((1-FAR),mu,sigma);     %Turns area under curve into a Z-score
Zs = norminv((1-HR),mu,sigma);
%Compute Dprime from Z-scores
Dprime = Zn - Zs;
%Set Z-score cut off as Z-score from noise distribution
Zc = Zn;
%Compute Beta as the height of the normal curve for signal divided by
%height of normal curve for noise at their Z-score values.
Beta = normpdf(Zs,mu,sigma)/normpdf(Zn,mu,sigma);

end %of main function

