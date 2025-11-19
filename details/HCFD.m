function [LC] = HCFD(G,lantents,data,sig)
%去除观察变量中混淆因子的影响
%Input
%data
%G:Graph
%lantents:[[x1,y1];[x2,y2];[x3,y3];[x4,y4] , ...]默认序号(Graph的序号)的先后顺序,而非因果的先后顺序,ICDPLV子算法输出的备选
%Output
%LC:检测到的隐混淆因子，[[x1,y1];[x2,y2];[x3,y3];[x4,y4] , ...]
%%%%%%%%%%%%%
%test example
% Name = 'Problem\Case\';
% dataName = 'Case11';
% rootFile = ['G:\matlab\pointone\generateData\',Name];
% load([rootFile,dataName,'.mat']);
%
%
%
%
%%%%%%%%%%%%%
%候选集合的数量
[num_can,~] = size(lantents);
LC = [];
for i = 1:num_can
    calData = data;%后面判断
    x = lantents(i,1);
    y = lantents(i,2);
   parents  = intersect(find(G(:,x)),find(G(:,y)));
   %观察变量的混淆因子数量
   num_pa = length(parents);
   if num_pa>0
       for j = 1:num_pa
          %采用残差替代
          calData(:,x) = computeR(calData(:,x),calData(:,parents(j)));
          calData(:,y) = computeR(calData(:,y),calData(:,parents(j)));
          %[calData(:,x),calData(:,y)]= delConfider(calData,parents(j),x,y);
       end
       resi = computeR(calData(:,x),calData(:,y));
       resi2 = computeR(calData(:,y),calData(:,x));
       [p1,~] = indtest_hsic(resi,calData(:,y),[],[]);
       [p2,~] = indtest_hsic(resi2,calData(:,x),[],[]);
       if p1<=sig && p2<=sig
           LC = [LC;lantents(i,:)];
       elseif p1>sig && p2>sig
           if G(x,y) ==1 || G(y,x) ==1
               LC = [LC;lantents(i,:)];
           end
       else
           if G(x,y) ==0 && G(y,x) ==0
               LC = [LC;lantents(i,:)];
           end
       end
       p1
       p2
   else
       LC = [LC;lantents(i,:)];
   end
end

end

