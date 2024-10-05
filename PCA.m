% =========================准备数据=============================
% 定义样本集合
n = 2;%初始样本维度
N = 1000;%初始样本总数

% 指定降维目标
d = 1;%指定降维后维度

% 初始化样本
X = zeros(N, n);% 创建样本矩阵
X(:, 1) = randn(N, 1);
X(:, 2) = 12+X(:,1)*0.2656;
sigma = 0.01; % 噪声标准差
X = X + sigma * randn(N, n);% 为第二个维度添加噪声
% =============================================================

% 计算均值
X_mean = mean(X);
% 计算协方差矩阵
X_Cov = zeros(n,n);
X_Centered = X-X_mean;
for i = 1:n
    for j = 1:n
        X_Cov(i, j) = 1/N* sum(X_Centered(:, i) .* X_Centered(:, j));
    end
end
% 计算协方差矩阵的特征值和特征向量
[eigenvectors, eigenvalues] = eig(X_Cov);
eigenvalue_list = diag(eigenvalues);
[eigenvalues, index] = sort(eigenvalue_list, 'descend'); % 第i个特征值eigenvalues(i, i);
eigenvectors = eigenvectors(:,index);% 第i个特征向量eigenvectors(:,i)

% 求出降维表示
X_reduced = zeros(N,d);
for i=1:N
    x_reduced = zeros(1,d);
    for j=1:d
        x_reduced(1,j) = dot(eigenvectors(:,j)',X_Centered(i,:));
    end
    X_reduced(i,:) = x_reduced;
end

% 求出近似值
X_appro = zeros(N,n);
for i=1:N
    bias = zeros(1,n);
    for j=1:d
        bias = bias + X_reduced(i,j)*eigenvectors(:,j)';
    end
    X_appro(i,:) = X_mean + bias;
end

% 求出近似值与实际值之差
X_error = X_appro - X;

% 绘制原始数据和添加噪声后的数据
figure;
plot(X(:,1), X(:,2),'.'); % 原始数据
hold on;
plot(X_appro(:,1), X_appro(:,2), '-'); % 添加噪声后的数据点
legend('原始样本', '近似值');
xlabel('维度1');
ylabel('维度2');
title('PCA');
grid on;

% 绘制各维度相对误差
% figure
% plot((1:N),(X_error(:,1) ./ X(:,1))')
% hold on
% plot((1:N),(X_error(:,2) ./ X(:,2))')
% hold on
% plot((1:N),(X_error(:,3) ./ X(:,3))')
% legend("维度1","维度2","维度3")
% xlabel("样本")
% ylabel("相对误差")
% title("各维度相对误差")
% grid on;