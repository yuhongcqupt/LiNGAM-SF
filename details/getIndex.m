function [index_HVarriable] = getIndex(hVarriable,nodeNames)
%GETINDEX 此处显示有关此函数的摘要
%   此处显示详细说明
L = length(hVarriable);
indexRow = length(nodeNames);
%nodeNames 2 the index of G
index_HVarriable = zeros(1,L);
for i=1:L
    for j=1:indexRow
        if strcmp(nodeNames{j},hVarriable{i})
            index_HVarriable(i) = j;
        end
    end
end
end

