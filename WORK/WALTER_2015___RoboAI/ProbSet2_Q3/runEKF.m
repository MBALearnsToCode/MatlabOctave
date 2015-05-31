function [XHat, Var] = runEKF(U,Z,XYT)

%R = [2.0 0 0; 0 2.0 0; 0 0 2.0*pi/180]*1E-4;
R = [2.0 0 0; 0 2.0 0; 0 0 2.0*pi/180]*1E-6;
%Q = [1.0 0.0; 0.0 1.0*pi/180]*1E-6;
Q = [1.0 0.0; 0.0 1.0*pi/180]*1E-8;

X0 = [-4.0; -4.0; pi/2];

[XHat,Var] = vacuum_ekf(X0,Z,U,Q,R);

figure;
plot(XYT(1,:),XYT(2,:),'k');
hold on;
plot(XHat(1,:),XHat(2,:),'g');


sigma = 3;
figure;
subplot(3,1,1);
plot(XYT(1,:)-XHat(1,:),'g');
hold on;
plot(sigma*sqrt(Var(1,:)),'r--');
plot(-sigma*sqrt(Var(1,:)),'r--');
xlabel('Time');
ylabel('Error (x)');
%
subplot(3,1,2);
plot(XYT(2,:)-XHat(2,:),'g');
hold on;
plot(sigma*sqrt(Var(2,:)),'r--');
plot(-sigma*sqrt(Var(2,:)),'r--');
xlabel('Time');
ylabel('Error (y)');
%
subplot(3,1,3);
plot(unwrap(XYT(3,:)-XHat(3,:)),'g');
hold on;
plot(sigma*sqrt(Var(3,:)),'r--');
plot(-sigma*sqrt(Var(3,:)),'r--');
xlabel('Time');
ylabel('Error (theta)');