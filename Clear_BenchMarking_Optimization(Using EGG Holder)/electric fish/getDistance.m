%   Returns the cartesian distance between individual 'newIndividualSol' and
%   its neigbors 'solutionSet' (see Eq. 5)
function dist = getDistance(newIndividualSol, solutionSet)
%%  Distance Calculator
parameterSize = size(newIndividualSol, 2);
popSize = size(solutionSet, 2) / parameterSize;
solutionSet = reshape(solutionSet, parameterSize, popSize)'; %sorting the solutionset for dimensions
dist = sqrt(sum((solutionSet - repmat(newIndividualSol, popSize, 1)) .^2, 2));
end