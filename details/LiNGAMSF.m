function [G,LC] = LiNGAMSF(G,data1,data2,r,sig1,sig2,option1,oldLC)
%MYALGORITHM 此处显示有关此函数的摘要
%   此处显示详细说明
[~,num] = size(data2); 
G_pie = zeros(num);
candidate = [];
choice = 0;
if isempty(G)
    [G_SK,~,~,~] = MBCS_SD(data2,sig1);
    
    %Results = parcelingam(data2', 1, nSample);
    %arrowG = Results.C;
    G_u = triu(G_SK);
    [row,col] = find(G_u);
    num = length(row);
    candidate = [];
    if num ~=0
        for i = 1:num
            candidate = [candidate;[row(i),col(i)]];
        end
    end
else
    %call the function UCSSF
    [G_pie,candidate] = UCSSF(G,data1,data2,sig1);
end
%test edgeNum
%testNum = [testNum;length(candidate)+length(find(G_pie))/2];
%delete the above code
if ~isempty(option1)
    A =  G_pie' + G_pie;
    [eN,] = size(candidate);
    for i = 1:eN
        A(candidate(i,1),candidate(i,2)) = 1;
        A(candidate(i,2),candidate(i,1)) = 1;
    end
    plotGraph(A,option1);
end
X = [data1,data2];
candidate = [oldLC;candidate];
[G,LC] = ICDPLV(G_pie,candidate,r,X,sig2);
LC =  HCFD(G,LC,X,sig2);
end



