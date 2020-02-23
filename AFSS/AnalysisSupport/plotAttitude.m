function plotAttitude(r)
%% Plot Attitude Pointing Vector

figure
hold on
rotate3d on
axis equal
grid on
plot3(0,0,0,'.','MarkerSize',10,'Color','k','HandleVisibility','off')
plot3(r(1,:),r(2,:),r(3,:),'Color','r','HandleVisibility','off')
plot3(r(1,1),r(2,1),r(3,1),'.','Color','b','HandleVisibility','off')
plot3(r(1,end),r(2,end),r(3,end),'.','Color',[0.494,0.184,0.5560],'HandleVisibility','off')
quiver3(0,0,0,r(1,1),r(2,1),r(3,1),'Color','b')
quiver3(0,0,0,r(1,end),r(2,end),r(3,end),'Color',[0.494,0.184,0.5560])
title('Satellite Attitude')
xlabel('X')
ylabel('Y')
zlabel('Z')
legend({'Initial Ponting','Final Pointing'})
end
