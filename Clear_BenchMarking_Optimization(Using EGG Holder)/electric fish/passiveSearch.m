function newSolution = passiveSearch(newIndividual, activePopulation, activeIndSize)
%%  Passive Electrolocation Phase

e = 1e-6;   %   A small constant used in distance calculation
D = size(newIndividual.solution, 2);    %   Parameter size of the problem
if size(activePopulation, 2) < activeIndSize   %   If the number of active individuals is less than that of predetermined neighbor, (K)
    activeIndSize = size(activePopulation, 2);  %   Set K as the number of active individuals  
end

dist = getDistance(newIndividual.solution, [activePopulation(:).solution]); %   Obtains cartesian distance between ith individual and those in active modes
p = cumsum([activePopulation(:).amplitude] ./ (dist' + e));   %   The probability values of active mode individuals (see Eq. 8)
selectedNeighbor = zeros(1, activeIndSize);
for i = 1 : activeIndSize  %   K individuals are selected through fitness proportionate (or roulette wheel) selection (see Eq. 8)
    I = find (rand*p(end) < p); 
    selectedNeighbor(i) = I(1);
end
neighbor = activePopulation(selectedNeighbor);
solutionSet = reshape([neighbor.solution], D, activeIndSize)';
xReference = sum(repmat([neighbor.amplitude]', 1, D) .* solutionSet) ./ sum(repmat([neighbor.amplitude]', 1, D));    %   A reference point is created (see Eq. 9)
newSolution = newIndividual.solution + (xReference - newIndividual.solution) .* (2 * rand(1, D) - 1);    %   Generates new location (see Eq. 10)
I = find(rand(1, D) > newIndividual.frequency); %   Determines which modified parameters will be accepted
newIndividual.solution(I) = newSolution(I);
newSolution = newIndividual.solution;
end