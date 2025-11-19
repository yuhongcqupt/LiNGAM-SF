function [G_pie,candidate] = UCSSF(G,data1,data2,sig)

[nSample,feateursNum_O] = size(data1);
data = [data1,data2];
[~,totalNum] = size(data);
mb = {};
if feateursNum_O ~=0
    A = G+G';
    %Find the adjacent nodes for each variable
    for i = 1:feateursNum_O
        mb{i} = find(A(i,:)==1);
    end
end

%record the directed edges
di_edges = [];
for j = feateursNum_O+1:totalNum
    mb{j} = [];
    can_mb = zeros(1,j-1);
    for k = 1:j-1
        %[CI] = my_cond_indep_chisquare(data(:,1:j),k, j, []);
        [CI] = my_cond_indep_fisher_z(data(:,1:j),k, j, [],nSample);
        if CI==0
            can_mb(k) = 1;
        end
    end
    can_mbIndex = find(can_mb~=0);
    if any(can_mb)
        for k = 1:length(can_mbIndex)
            v_k = can_mbIndex(k);
            kofmb_Set = mb{v_k};
            update_kofmb_Set = kofmb_Set;
            L_set = length(kofmb_Set);
            if L_set==0
                mb{v_k} = j;
                mb{j} = [mb{j},v_k];
            else
                %judge j(new feature)
                [CI]=compter_dep_2(update_kofmb_Set,j,v_k,3, 0, sig, 'g2',data(:,1:j));
                if CI == 0
                    update_kofmb_Set = [kofmb_Set,j];
                    mb{j} = [mb{j},v_k];
                    %update G_pie
                    for s = 1:L_set
                      v_s = kofmb_Set(s);
                      in_j_Set = setdiff(update_kofmb_Set,v_s);
                      if ~isempty(in_j_Set)
                          [CI]=optimal_compter_dep_2(in_j_Set,v_s,v_k,3, 0, sig, 'g2',data(:,1:j));
                      else
                          CI = 0;
                      end
                      if CI==1
                          update_kofmb_Set = in_j_Set;
                          mb{v_s} = setdiff(mb{v_s},v_k);
%                           if v_s<feateursNum_O && v_k<feateursNum_O
%                               if xor(G(v_s,v_k),G(v_k,v_s))
%                                   if G(v_s,v_k)==1
%                                       di_edges = [di_edges;[v_s,v_k,j]];
%                                   end
%                                   if G(v_k,v_s)==1
%                                       di_edges = [di_edges;[v_k,v_s,j]];
%                                   end
%                               end
%                           end
                      end
                    end
                end
                mb{v_k} = update_kofmb_Set;
            end
        end
        if length(mb{j})>1
            jofmb_Set = mb{j};
            update_jofmb_Set = jofmb_Set;
            L_set = length(jofmb_Set);
            for h=1:L_set
                v_h = jofmb_Set(h);
                set_hpie = setdiff(update_jofmb_Set,v_h);
                if ~isempty(set_hpie)
                    [CI] = compter_dep_2(set_hpie,v_h,j,3, 0, sig, 'g2',data(:,1:j));
                else
                    CI = 0;
                end
                if CI ==1
                    update_jofmb_Set = set_hpie;
                    mb{v_h} = setdiff(mb{v_h},j);
                end
            end
            mb{j} = update_jofmb_Set;
        end
    end
end
[G_pie,candidate] = mb2graph(mb,G,di_edges,feateursNum_O,totalNum);
end

function [G_pie,candidate] = mb2graph(mb,G,di_set,feateursNum_O,totalNum)
G_pie = zeros(totalNum,totalNum);
G_pie([1:feateursNum_O],[1:feateursNum_O]) = G;
for i = 1:feateursNum_O
    old_mb = [find(G(i,:)==1),find(G(:,i)==1)'];
    del_v = setdiff(old_mb,mb{i});
    if ~isempty(del_v)
        for j = 1:length(del_v)
            G_pie(i,del_v(j)) = 0;
            G_pie(del_v(j),i) = 0;
        end
    end
end
for i = 1:length(mb)
    item = mb{i};
    if i<=feateursNum_O
        colItem = item(find(item>feateursNum_O));
        for j = 1:length(colItem)
            G_pie(i,colItem(j)) = 1;
        end
    else
        for j = 1:length(item)
            G_pie(i,item(j)) = 1;
        end
    end
end
[L_diset,~] = size(di_set);
for i = 1:L_diset
    orient_s = di_set(i,:);
    G_pie(orient_s(1),orient_s(3)) = 1;
    G_pie(orient_s(3),orient_s(1)) = 0;
    G_pie(orient_s(3),orient_s(2)) = 1;
    G_pie(orient_s(2),orient_s(3)) = 0;
end
candidate = [];
for i = feateursNum_O+1:totalNum
   edgeIndex = intersect(find(G_pie(i,:)==1),find(G_pie(:,i)==1));
   if ~isempty(edgeIndex)
       edgeNum = length(edgeIndex);
       for j = 1:edgeNum
           G_pie(i,edgeIndex(j))=0;
           G_pie(edgeIndex(j),i)=0;
           candidate = [candidate;[i,edgeIndex(j)]];
       end
   end
end
end
