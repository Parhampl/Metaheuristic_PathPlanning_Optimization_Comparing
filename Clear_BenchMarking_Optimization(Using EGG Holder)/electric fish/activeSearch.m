function newSolution = activeSearch(newIndividual, neighborIndividual, lowerBound, upperBound)
%%  Active Electrolocation Phase

activeRange = (upperBound - lowerBound) * newIndividual.amplitude;    %   Calculates active search range
parameter = randi(size(newIndividual.solution, 2)); %   Determines jth parameter to modify
dist = getDistance(newIndividual.solution, [neighborIndividual(:).solution]);   %   Obtains cartesian distance between ith individual and its neighbors ( i.e., N \ {i} )
index = find(dist < activeRange);   %   Determines if at least a neighbor exists in the active search range
if isempty(index)   %   If no neighbor exists in the search range (see Eq. 7)
    newIndividual.solution(parameter) = newIndividual.solution(parameter) + (2 * rand - 1) * activeRange;
else    %   If at least one neighbor exists in the search range (see Eq. 6)
    selectedNeighbor = index(randi(size(index, 1))); %   Randomly selects one neighbor individual (k) among those inside active range area
    newIndividual.solution(parameter) = newIndividual.solution(parameter) + ...
        (neighborIndividual(selectedNeighbor).solution(parameter) - ...
        newIndividual.solution(parameter)) * (2 * rand - 1); 
end
newSolution = newIndividual.solution;
end