%% Fitness Function
function sol = fitness(sol, data)
global NFE
load data

if NFE == 0
    xx = linspace(data.xs, data.xt, data.n + 2);
    yy = linspace(data.ys, data.yt, data.n + 2);
    sol.x = [xx(2:end-1) yy(2:end-1)];
end

NFE = NFE + 1;

x = sol.x(1:data.n);
y = sol.x(data.n+1:end);

XS = [data.xs x data.xt];
YS = [data.ys y data.yt];
k = numel(XS);
TS = linspace(0, 1, k);

tt = linspace(0, 1, 100);
xx = spline(TS, XS, tt);
yy = spline(TS, YS, tt);

dx = diff(xx);
dy = diff(yy);

L = sum(sqrt(dx.^2 + dy.^2));

nobs = numel(data.xobs); % Number of Obstacles
Violation = 0;
for k = 1:nobs
    d = sqrt((xx - data.xobs(k)).^2 + (yy - data.yobs(k)).^2);
    v = max(1 - d / data.robs(k), 0);
    Violation = Violation + mean(v);
end

z = L;

CH = Violation;
SCH = 1e9 * sum(CH);

fit0 = z;

sol.fit = fit0 * (1 + SCH);
sol.info.x = sol.x;
sol.SCH = SCH;
sol.info.SCH = SCH;
sol.info.CH = CH;
sol.info.fit0 = fit0;
sol.info.fit = sol.fit;
sol.info.TS = TS;
sol.info.XS = XS;
sol.info.YS = YS;
sol.info.tt = tt;
sol.info.xx = xx;
sol.info.yy = yy;
sol.info.dx = dx;
sol.info.dy = dy;
sol.info.L = L;

end