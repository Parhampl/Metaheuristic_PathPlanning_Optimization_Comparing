clc;
clear;

% Source
xs = -400;
ys = -400;

% Target (Destination)
xt = 500;
yt = 200;

xobs = [-142.8150, -119.8318, -493.5311,  27.1833,  -20.5996, -427.7995, -308.3251, -106.6312, -62.5280, 497.2782];
yobs = [-204.4902,  -43.7162, -381.3250, -357.8582,  50.0318, -271.6420, -185.9180,  104.1066, -263.2235, -395.8582];
robs = [100, 29.7448, 26.9412, 27.7449, 19.0991, 19.5069, 30.3737, 10.0943, 18.6221, 45.0099];

n = 3;

xmin = -512;
xmax =  512;

ymin = -512;
ymax =  512;

model.xs = xs;
model.ys = ys;
model.xt = xt;
model.yt = yt;
model.xobs = xobs;
model.yobs = yobs;
model.robs = robs;
model.n = n;
model.xmin = xmin;
model.xmax = xmax;
model.ymin = ymin;
model.ymax = ymax;

LB = [xmin * ones(1, n), ymin * ones(1, n)]; 
UB = [xmax * ones(1, n), ymax * ones(1, n)];

nvar = 2 * n;

save data
