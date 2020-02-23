function Xdot = SatAttDyn(t,x,moi,T)
Ix = moi(1);
Iy = moi(2);
Iz = moi(3);

Xdot(1,1) = x(4)*cos(x(3))-x(5)*sin(x(3));
Xdot(2,1) = x(4)*sin(x(3))+x(5)*cos(x(3));
Xdot(3,1) = (-x(4)*cos(x(3))+x(5)*sin(x(3)))*tan(x(2))+x(6);
Xdot(4,1) = (Iy-Iz)/Ix*x(5)*x(6)+T(1);
Xdot(5,1) = (Iz-Ix)/Iy*x(6)*x(4)+T(2);
Xdot(6,1) = (Ix-Iy)/Iz*x(4)*x(5)+T(3);
end
