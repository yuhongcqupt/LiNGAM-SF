function [adjMatrix,nodeNames] = getDAGToy()
nodeNames{1} = 'v1';
nodeNames{2} = 'v2';
nodeNames{3} = 'v3';
nodeNames{4} = 'v4';
nodeNames{5} = 'v5';
nodeNames{6} = 'v6';
nodeNames{7} = 'v7';
nodeNames{8} = 'v8';
adjMatrix = zeros(length(nodeNames));
adjMatrix(3,8)= 1;
adjMatrix(3,2)= 1;
adjMatrix(7,1)= 1;
adjMatrix(7,2)= 1;
adjMatrix(8,1)= 1;
adjMatrix(6,4)= 1;
adjMatrix(6,5)= 1;
adjMatrix(6,1)= 1;
adjMatrix(4,5)= 1;

P = topologicalPermutation(adjMatrix);
adjMatrix = adjMatrix(P,P);
nodeNames = nodeNames(P);
end