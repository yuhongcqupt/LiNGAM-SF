function [newG,nodeNames,hVarriable,index_HVarriable] = evaluatedG(G,nodeNames,hVarriable)
%EVALUATEDG 此处显示有关此函数的摘要
%   此处显示详细说明
index_HVarriable = getIndex(hVarriable,nodeNames);
[index_HVarriable,sortindex] = sort(index_HVarriable,'descend');
%delete the leaf node
L = length(hVarriable);
deleteIndex = [];
newNodes = [];
hvIndex = [];
hVarriable = hVarriable(sortindex);
newG = G;
for i=1:L
    judgeValue = find(newG(index_HVarriable(i),:), 1);
    if isempty(judgeValue)
        deleteIndex = [deleteIndex,index_HVarriable(i)];
        newG(:,index_HVarriable(i)) = 0;
        newNodes = [newNodes,index_HVarriable(i)];
        hvIndex = [hvIndex,i];
    end
end
newG(deleteIndex,:) = [];
newG(:,deleteIndex) = [];
nodeNames(newNodes) = [];
hVarriable(hvIndex) = [];
%one child
index_HVarriable = getIndex(hVarriable,nodeNames);
L2 = length(hVarriable);
deleteIndex = [];
newNodes = [];
hvIndex = [];
%The reason for the reverse order is that index_HVariable is sorted in descending order. 
%The larger the index number, the closer it is to the leaf node, and the smaller the index number, the closer it is to the exogenous variable.
for i=L2:-1:1
    % identifying a variable as an exogenous variable
    if isempty(find(newG(:,index_HVarriable(i)), 1))
        num = length(find(newG(index_HVarriable(i),:)));
        if num == 1
            deleteIndex = [deleteIndex,index_HVarriable(i)];
            newG(index_HVarriable(i),:) = 0;
            newNodes = [newNodes,index_HVarriable(i)];
            hvIndex = [hvIndex,i];
        end
    end 
end
newG(deleteIndex,:) = [];
newG(:,deleteIndex) = [];
nodeNames(newNodes) = [];
hVarriable(hvIndex) = [];
%intermediate node
index_HVarriable = getIndex(hVarriable,nodeNames);
L3 = length(hVarriable);
deleteIndex = [];
newNodes = [];
hvIndex = [];
for i=L3:-1:1
    if ~isempty(find(newG(:,index_HVarriable(i)), 1)) %
        %error: p_node = find(newG(:,index_HVarriable(i)),1);
        %error: c_node = find(newG(index_HVarriable(i),:),1);
        p_node = find(newG(:,index_HVarriable(i))==1);
        c_node = find(newG(index_HVarriable(i),:)==1);  
        newG(index_HVarriable(i),:) = 0;
        newG(:,index_HVarriable(i)) = 0;
        newG(p_node,c_node) = 1;
        deleteIndex = [deleteIndex,index_HVarriable(i)];
        newNodes = [newNodes,index_HVarriable(i)];
        hvIndex = [hvIndex,i];
    end
end
newG(deleteIndex,:) = [];
newG(:,deleteIndex) = [];
nodeNames(newNodes) = [];
hVarriable(hvIndex) = [];
index_HVarriable = getIndex(hVarriable,nodeNames);
end

