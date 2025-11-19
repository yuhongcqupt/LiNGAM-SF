function [colliderSet,spouseSet] = serchCollider(Mb, Data, sig)
%Mb: Markov blanket, nfeatur * nfeature
%Data: Observational data for independent testing
%Step 1. find all fully connnected triangle
%triangleSet = [];
[n_s,n_f] = size(Data);
rows = n_f*(n_f-1)/2;
triangleIndex = zeros(n_f,n_f);
triangleSet = zeros(rows,n_f);
for i= 1:n_f
    if sum(Mb(:,i)) < 2
        continue;
    end
    %The alternate side of the triangle
    alterIndex = find(Mb(:,i));
    alterIndex = alterIndex(alterIndex>=i);
    alterSides  = nchoosek(alterIndex,2);
    [possL,temp] = size(alterSides);
    if temp ~= 2
        continue;
    end
    for j =1:possL
       if Mb(alterSides(j,1),alterSides(j,2)) == 1
           rowIndex = n_f*(alterSides(j,1)-1)+alterSides(j,2)-(1+alterSides(j,1))*alterSides(j,1)/2;
           triangleIndex(alterSides(j,1),alterSides(j,2))=1;
           triangleSet(rowIndex,i) = 1;
           rowIndex2 =  n_f*(i-1)+alterSides(j,2)-(1+i)*i/2;
           triangleIndex(i,alterSides(j,2))=1;
           triangleSet(rowIndex2,alterSides(j,1)) = 1;
           rowIndex3 =  n_f*(i-1)+alterSides(j,1)-(1+i)*i/2;
           triangleIndex(i,alterSides(j,1))=1;
           triangleSet(rowIndex3,alterSides(j,2)) = 1;           
           %triangleSet = [triangleSet;i,alterSides(j,1),alterSides(j,2)];
       end
    end
end
%Test colliderSet->triangleSet
%colliderSet = triangleSet;

%triangleIndex:Mark the sides (or two vertices) that form the triangle
%triangleSet:The point to which the side corresponds
%Step 2. find d-sperate
%2.1 Take all triangles
[x,y] = find(triangleIndex);
nums = length(x);
%2.2 Iterating over the edges of a triangle
flag = 0;
spouseSet = [];
S_xySet = [];
colliderSet = {};
for i=1:nums
    %Close neighbours
    Bd_x = find(Mb(x(i),:));
    Bd_y = find(Mb(y(i),:));
    
    triPot = find(triangleSet(n_f*(x(i)-1)+y(i)-(1+x(i))*x(i)/2,:));
    B1 = setdiff(Bd_x, triPot);
    B1 = setdiff(B1, y(i));
    B2 = setdiff(Bd_y, triPot);
    B2 = setdiff(B2, x(i));
    S_xy = [-1];
   if length(B1)<length(B2)
       B = B1;
   else
       B = B2;
   end
   n = length(triPot);
   ind=ff2n(n)>0;
   S = arrayfun(@(i)triPot(:,ind(i,:)),1:2^n-1,'un',0);
   S{1} = [];
   for j =1:2^n-1
       Z = union(B, S{j});
       %与空集取并集，行向量会转换为列向量
       Z = reshape(Z,[1,length(Z)]);
       [CI]=my_fisherz_test(x(i),y(i),Z,Data,n_s,sig);
            %CI=indtest_corr(Data(:,i), Data(:,j), Data(:,givenS),[]);
        if isnan(CI)
            CI=0;
        end
       if CI
          S_xy = Z;
          break;
       end
       %delete the descendant of colloder
       W = setdiff(triPot,S{j});
       [~,W_reachable] = find(Mb(W,:));
       %delete x and y in W_reachable
       W_reachable = setdiff(W_reachable,[x(i),y(i)]);
       D = intersect(B,W_reachable);
       [row_1,~] = size(D);
       if row_1 ~= 1
           D = D';
       end
       B_ = setdiff(B,D);
       n_ = length(D);
       ind=ff2n(n_)>0;
       S_ = arrayfun(@(temp)D(:,ind(temp,:)),1:2^n_-1,'un',0);
       for k = 1:2^n_-1
           Z_ = union(union(B_, S_{k}),S{j});
           Z_ = reshape(Z_,[1,length(Z_)]);
           [CI]=my_fisherz_test(x(i),y(i),Z_,Data,n_s,sig);
            %CI=indtest_corr(Data(:,i), Data(:,j), Data(:,givenS),[]);
           if isnan(CI)
              CI=0;
           end
           if CI
               S_xy = Z;
               flag = 1;
               break;
           end
       end
       if flag
           break;
       end
   end
   %mark spouse link(-1)
   if ~isequal(S_xy, [-1])
       spouseSet = [spouseSet;[x(i),y(i)]];
       C = setdiff(triPot,S_xy);
       colliderSet{end+1} = C;
   end
end
%remove spouse link

end