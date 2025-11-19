%比较两个网络的不同，多余的边，少的边，逆置的边，没有定向的边，总错误的边
function [miss,extra,reverse,missorient,correct,total,learned_Edge,graph_Edge,correctEdge,P,R,F1,P_pie,R_pie,F1_pie]=Compare_Dag(DAG_Com,G,hIndex)
numOfVar=size(G,1);
learnNum = size(DAG_Com,1);
reverse=0;
correct=0;
missorient=0;
missLatent=0;
latent = [];
%存在隐变量
if learnNum ~= numOfVar
    missLatent = numOfVar - learnNum;
    %保留后期查看
    from_latentV = G(hIndex,:);
    to_latentV = G(:,hIndex);
    G(hIndex,:) = [];
    G(:,hIndex) = [];
end
undi_graph = zeros(learnNum);
undi_graph(DAG_Com~=0) = 1;
%Converting directed edges into undirected edges, transforming the graph into a symmetric graph
for i = 1:learnNum
    for j = 1:learnNum
        if undi_graph(i,j)~=0 || undi_graph(j,i)~=0
            undi_graph(j,i) = 1;
            undi_graph(i,j) = 1;
        end
    end
end
sym_G = G + G';
undi_graph = triu(undi_graph);
sym_G = triu(sym_G);
rs_G = undi_graph-sym_G;
rs_G2 = undi_graph+sym_G;
extra = length(find(rs_G==1));
miss  = length(find(rs_G==-1));
[judgeR,judgeC] = find(rs_G2 ==2);
if ~isempty(judgeR)
    [L,~] = size(judgeR);
    for i = 1:L
        if DAG_Com(judgeR(i),judgeC(i))==1&&DAG_Com(judgeC(i),judgeR(i))==1
            missorient=missorient+1;
            continue;
        end
        if DAG_Com(judgeR(i),judgeC(i))~=G(judgeR(i),judgeC(i))
            reverse=reverse+1;
        else
            correct=correct+1;
        end
    end
end
%SHD
total=miss+extra+reverse+missorient;
correctEdge  = length(judgeR);
learned_Edge = length(find(undi_graph==1));
graph_Edge = length(find(sym_G==1));
P = correct/learned_Edge;
R = correct/graph_Edge;
F1 = 2*R*P/(P+R);
P_pie = correctEdge/learned_Edge;
R_pie = correctEdge/graph_Edge;
F1_pie = 2*R_pie*P_pie/(P_pie+R_pie);
end
