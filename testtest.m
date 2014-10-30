dim=5;
h = figure();
axis([-dim dim -dim dim]);

hold on
index = 1;
data = zeros(1,2);
while(1)
    [x,y,b] = ginput(1);
    if( length(b) == 0 )
        break;
    endif
    plot(x, y, "b+");
    data(index, :) = [x y];
    index++;
endwhile

y = data(:, 2);
m = length(y);
X = data(:, 1);
X = [ones(m, 1), data(:,1), data(:,1).^2, data(:,1).^3 ];

theta = zeros(4, 1);

iterations = 100;
alpha = 0.001;
J = zeros(1,iterations);
for iter = 1:iterations
    theta -= ( (1/m) * ((X * theta) - y)' * X)' * alpha;

    plot(-dim:0.01:dim, theta(1) + (-dim:0.01:dim).*theta(2) + (-dim:0.01:dim).^2.*theta(3) + (-dim:0.01:dim).^3.*theta(4), "g-");

    J(iter) = sum( (1/m) * ((X * theta) - y)' * X);
end

plot(-dim:0.01:dim, theta(1) + (-dim:0.01:dim).*theta(2) + (-dim:0.01:dim).^2.*theta(3) + (-dim:0.01:dim).^3.*theta(4), "r-");

figure()
plot(1:iter, J);