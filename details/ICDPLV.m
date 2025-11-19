function [G_pie,LC] = ICDPLV(G_pie,candidate,r,X,sig)
[can_L,~] = size(candidate);
del_List = [];
for i=1:can_L
    o = X(:,candidate(i,1));
    t = X(:,candidate(i,2));
    resi = computeR(o,t);
    resi2 = computeR(t,o);
    %p1<s1:0采用的方式为p和s对比
%     [p1,s1] = hsic(resi,t,sig);
%     [p2,s2] = hsic(resi2,o,sig);
%     if p1<s1 && p2>=s2
%         G_pie(candidate(i,2),candidate(i,1)) = 1;
%         del_List = [del_List;i];
%         continue; 
%     elseif p2<s2 && p1>=s1
%         G_pie(candidate(i,1),candidate(i,2)) = 1;
%         del_List = [del_List;i];
%         continue;
%     end
%原假设为独立
    [p1,~] = indtest_hsic(resi,t,[],[]);
    [p2,~] = indtest_hsic(resi2,o,[],[]);
    if p1>sig && p2<=sig
        G_pie(candidate(i,2),candidate(i,1)) = 1;
        del_List = [del_List;i];
        continue; 
    elseif p2>sig && p1<=sig
        G_pie(candidate(i,1),candidate(i,2)) = 1;
        del_List = [del_List;i];
        continue;
    end
end
candidate(del_List,:) = [];
LC = candidate;
[can_L,~] = size(candidate);
for i=1:can_L
    weight = orientation(X(:,[candidate(i,1),candidate(i,2)]),r);
    ori = judgeDirection(weight(1,:),weight(2,:));
    if ori==1
        G_pie(candidate(i,1),candidate(i,2)) = 1;
        if isThereARing(G_pie,candidate(i,1),candidate(i,2))
            G_pie(candidate(i,1),candidate(i,2)) = 0;
        end
    elseif ori==-1
        G_pie(candidate(i,2),candidate(i,1)) = 1;
        if isThereARing(G_pie,candidate(i,2),candidate(i,1))
            G_pie(candidate(i,2),candidate(i,1)) = 0;
        end
    end
end
end

function[reValue] = isThereARing(G,startIndex,endIndex)
  G_temp  = digraph(G);
  v = dfsearch(G_temp,endIndex);
  if find(v==startIndex)
      reValue = true;
  else
      reValue = false;
  end
end