function [G_pag,noneSet,colliderSet,spouseSet] = MBCS_SD(Data,sig)
%MBCS 此处显示有关此函数的摘要
%Data 模拟的数据
%   此处显示详细说明
% 。-。：矩阵中1表示
[n_s,n_f] = size(Data);
G_pag = zeros(n_f,n_f);
f_i = 1:n_f;
%阶段1：求解每个变量的马尔科夫毯
%目前独立分析可能出现错误。两个变量可能本来关联，但在add过程中就独立。
%出现的奇怪现象：在变量1和变量2在变量3条件下不独立，在变量1和变量2在变量4条件下不独立，但是在变量3，4下条件独立
for i= f_i
    %add
    temp = f_i(~ismember(f_i,i));%其余元素是否属于i马尔科夫毯
    diffValue = find(G_pag(i,:));
    [~,i_temp] = setdiff(temp,diffValue);
    temp = temp(i_temp);
    state = cell(n_f,1);
    while ~isempty(temp)
        givenS = find(G_pag(i,:));
        j = temp(1);
        if isequal(state{j,1},givenS)
            break;
        else
            state{j,1} = givenS;
            [CI]=my_fisherz_test(i,j,givenS,Data,n_s,sig);
            %CI=indtest_corr(Data(:,i), Data(:,j), Data(:,givenS),[]);
            if isnan(CI)
                    CI=0;
            end
            if ~CI
                G_pag(i,j) = 1;
                G_pag(j,i) = 1;
            else
                temp = [temp,j];
            end
            if length(temp) ~= 1
                temp = temp(2:end);
            else
                temp = [];
            end
        end
    end
    %remove
    givenS = find(G_pag(i,:));
    for j = givenS
        [CI]=my_fisherz_test(i,j,givenS(~ismember(givenS,j)),Data,n_s,sig);
            %CI=indtest_corr(Data(:,i), Data(:,j), Data(:,givenS),[]);
        if isnan(CI)
            CI=0;
        end
        %CI=indtest_corr(Data(:,i), Data(:,j), Data(:,givenS(~ismember(givenS,j))),[]);
        if CI
            G_pag(i,j) = 0;
            G_pag(j,i) = 0;
        end
    end
end
%阶段2：非冲撞结构标记
%优化位置：标记优化位置，同三角形标记一起优化。
noneSet = cell(n_f,1);
for i= f_i
    index = find(G_pag(i,:));
    if length(index) <2
      continue
    end
    judge_index = nchoosek(index,2);
    [L,~] = size(judge_index);
    for j = 1:L
        if G_pag(judge_index(j,1),judge_index(j,2)) == 0
            if isempty(noneSet{i,1})
                noneSet{i,1} = [judge_index(j,:)];
            else
                noneSet{i,1} = [noneSet{i,1};judge_index(j,:)];
            end
        end
    end
end 

%阶段3：search for collider set and spous link et al.
[colliderSet,spouseSet] = serchCollider(G_pag,Data,sig);
%Step4: delete spous links et al.
[setL,~] = size(spouseSet);
for i = 1:setL
    G_pag(spouseSet(i,1),spouseSet(i,2)) = 0;
    G_pag(spouseSet(i,2),spouseSet(i,1)) = 0;
end

end

