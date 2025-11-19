function [weight] = Identify_Zero(samples_rs, l_num)
[w,l] = size(samples_rs);
first = samples_rs(:,1:l_num);
statisc_value = reshape(first,1,w*l_num);
weight = zeros(1,w*l_num);
for i = 1:l/l_num-1
    second = samples_rs(:,i*l_num+1:(i+1)*l_num);
    dis = pdist2(first',second');
    [~,index] = sort(reshape(dis',1,l_num*l_num));
    rows = [];
    cols = [];
    rs = [];
    for j = 1:length(index)
        r = ceil(index(j)/l_num);
        c = mod(index(j),l_num);
        if c == 0
            c=l_num;
        end
        if ~isempty(find(rows==r, 1))
            continue;
        end
        if ~isempty(find(cols==c, 1))
            continue;
        end
        rows = [rows,r];
        cols = [cols,c];
        rs = [rs;r,c];
    end
     [col_index,~]=sortrows(rs,1);
     secondNew = second(:,col_index(:,2));
     statisc_value = [statisc_value;reshape(secondNew,1,w*l_num)];
end
statisc_value = abs(statisc_value);
statisc_value(statisc_value>=0.5) = 1;
statisc_value(statisc_value<0.5) = 0;
for k = 1:w*l_num
    if ttest(statisc_value(:,k), 0)==1
        weight(k)=1;
    end
end
weight = reshape(weight,w,l_num);
end