function z=egg_holder(x,y)
z=-((y+47) * sin(sqrt(abs(y+(x/2)+47))))-(x* sin(sqrt(abs(x-(y+47)))));
end
