% =========================准备数据-以二分类,降到到一维为例=============================
% 定义样本集合
n = 2;%初始样本维度
N1 = 100;%正类样本总数
N2 = 100;%负类样本总数

% 指定降维目标
d = 1;%指定降维后维度

% 初始化样本
rot = [1 2; 2 4.5];
X1 = randn(N1, n)*rot; % 将随机点压缩到很窄的区域
X2 = randn(N2, n)*rot + repmat([0 5],N2,1); %将随机数据的第二个维度向上加5
% =============================================================

% 计算均值
m1 = mean(X1);
m2 = mean(X2);
% 计算协方差矩阵
X1_Centered = X1 - m1;
X2_Centered = X2 - m2;
X1_Cov = cov(X1_Centered);
X2_Cov = cov(X2_Centered);
% 计算类内散度矩阵Sw
Sw = N1*X1_Cov + N2*X2_Cov;
% 计算投影方向w
w = inv(Sw)*(m1 - m2)';
% 规范化投影方向
w = w / norm(w);
% 计算广义瑞利商

% 展示
% 绘制散点图
figure;
hold on;
plot(X1(:, 1), X1(:, 2),'.')
plot(X2(:, 1), X2(:, 2),'.')

plot(linspace(-20, 20, 100)*w(1), linspace(-20, 20, 100)*w(2), 'r-', 'LineWidth', 2);

xlabel('X-axis');
ylabel('Y-axis');
title('FLD');
legend('X1', 'X2','投影方向');
hold off;