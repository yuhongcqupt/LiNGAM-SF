function [w] = orientation(data,r)
%ORIENTATION 此处显示有关此函数的摘要
%   此处显示详细说明
X =data';
[n,m] = size(X);
sample_num = round(m*r);
weights = zeros(n,5*n);
X = X-repmat(mean(X,2),1,size(X,2));%求的是每一行的均值
sigma = (1.0/m)*X*X';
[u,s,v] = svd(sigma);
epsilon = 0.1;
PCAWhite = diag(1./sqrt(diag(s)+epsilon))*u'*X;
for i=1:5
    idx= ceil(m*rand(1,sample_num)) ; %generate n random index between 1 and m
    xPCAWhite = PCAWhite(:,idx);% sampling
    %标记，此预处理放在前面
    %x = X(:,idx); % sampling
    %x = x-repmat(mean(x,2),1,size(x,2));%求的是每一行的均值
    %sigma = (1.0/m)*x*x';
    %[u,s,v] = svd(sigma);
    %epsilon = 0.1;
    %xPCAWhite = diag(1./sqrt(diag(s)+epsilon))*u'*x;
    %标记End
    Mdl = rica(xPCAWhite',n);
    %Mdl = rica(x',i,'Standardize',true);
    weight = u*diag(sqrt(diag(s)))*Mdl.TransformWeights;
    weight = weight./repmat(max(abs(weight),[],1),n,1);
    weights(:,(i-1)*n+1:n*i) = weight;
end
    w = Identify_Zero(weights,n);
    
end

