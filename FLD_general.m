% =========================准备数据=============================
% 定义样本集合
n = 2;%初始样本维度
K = 2;%规定类别总数
N = [100 100];%样本总数数组

% 指定降维目标
d = 1;%指定降维后维度

% 初始化样本
rot = [1 2; 2 4.5];
X1 = randn(N(1), n)*rot; % 将随机点压缩到很窄的区域
X2 = randn(N(2), n)*rot + repmat([0 5],N(2),1); %将随机数据的第二个维度向上加5
X(1,:,:) = X1;%X(i,j,k):第i类第j个样本第k个维度
X(2,:,:) = X2;
% =============================================================

% 计算均值
m = zeros(K,n);%均值数组
for k =1:K
    m(k,:) = mean(X(k,:,:));
end
% 计算协方差矩阵
X_Cov = zeros(K,n,n);
for k =1:K
    X_Cov(k,:,:) = cov(squeeze(X(k,:,:)) - m(k));
end
% 计算类内散度矩阵Sw
Sw = zeros(n,n);
for k =1:K
    Sw = Sw + N(k)*squeeze(X_Cov(k,:,:));
end
% 计算类间散列矩阵Sb 
Sb = zeros(n,n);
x_means = squeeze(mean(X,[1,2]))';
for i =1:K
    Sb = Sb +  N(k) * ((m(k,:) - x_means)' * (m(k,:) - x_means));
end

% 计算广义特征值
[eigVec, eigVal] = eig(Sb, Sw);
[eigVal, index] = sort(diag(eigVal), 'descend');
eigVec = eigVec(:,index);

% 规范化投影方向
w = zeros(d,n);
for i =1:d
    w(i,:) = eigVec(:,i)' / norm(eigVec(:,i));
end

% 展示
% 绘制散点图
figure;
hold on;
plot(X(1,:, 1), X(1,:, 2),'.')
plot(X(2,:, 1), X(2,:, 2),'.')
plot(linspace(-20, 20, 100)*w(1,1), linspace(-20, 20, 100)*w(1,2), 'r-', 'LineWidth', 1);
xlabel('X-axis');
ylabel('Y-axis');
title('FLD');
legend('X1', 'X2','投影方向');
hold off;