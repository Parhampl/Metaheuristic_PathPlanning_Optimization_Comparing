function egg_holder_plotting(x11, y11, ns, n, f_tot, mins, e)
    x1min = -512;
    x1max = 512;
    x2min = -512;
    x2max = 512;
    R = 1500; % Steps resolution
    x1 = x1min:(x1max - x1min) / R:x1max;
    x2 = x2min:(x2max - x2min) / R:x2max;

    for j = 1:length(x1)
        for i = 1:length(x2)
            f(i) = -x1(j) * sin(sqrt(abs(x1(j) - x2(i) - 47))) - (x2(i) + 47) * sin(sqrt(abs(0.5 * x1(j) + x2(i) + 47)));
        end
        f_tot(j, :) = f;
    end

    figure(1)
    nexttile
    mesh(x1, x2, f_tot); view(0, 90); colorbar; set(gca, 'FontSize', 12);
    xlabel('x_2', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    ylabel('x_1', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    zlabel('f(X)', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    title('X-Y Plane View', 'FontName', 'Times', 'FontSize', 24, 'FontWeight', 'bold');
    hold on
    z11 = 1000 * ones(n, 1);
    scatter3(x11, y11, z11, 'filled');
    title('Initial Condition');
    hold off

    nexttile
    mesh(x1, x2, f_tot); view(0, 90); colorbar; set(gca, 'FontSize', 12);
    xlabel('x_2', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    ylabel('x_1', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    zlabel('f(X)', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    title('X-Y Plane View', 'FontName', 'Times', 'FontSize', 24, 'FontWeight', 'bold');
    hold on
    for i = 1:n
        x22(i, 1) = ns(i, 1);
        y22(i, 1) = ns(i, 2);
    end
    z22 = 1000 * ones(n, 1);
    scatter3(x22, y22, z22, 'filled');
    title('Final Condition');
    hold off

    figure(2)
    t = 1:e;
    plot(t, mins, '-');
    xlabel('iterations');
    ylabel('optimum');
    grid
end
