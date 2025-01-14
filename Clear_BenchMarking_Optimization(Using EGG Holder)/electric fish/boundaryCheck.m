%   Controls if a parameter value exceeds the space limits, if so it is
%   relocated into the bound where it exceeds
function newIndividualSol = boundaryCheck(newIndividualSol, lowerBound, upperBound)
%%  Boundary Controller

newIndividualSol = min(newIndividualSol, upperBound);
newIndividualSol = max(newIndividualSol, lowerBound);

end