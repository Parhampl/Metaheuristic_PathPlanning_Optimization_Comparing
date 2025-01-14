function z=egg_holder(v)
x=v(1);
y=v(2);
z=-((y+47) * sin(sqrt(abs(y+(x/2)+47))))-(x* sin(sqrt(abs(x-(y+47)))));
end