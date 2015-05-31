function [XHat,Var] = vacuum_ekf(X0,Z,U,Q,R)

mu = X0;
Sigma = zeros(3,3);

XHat = mu;
Var = [diag(Sigma)];
size(U)
length(U)
for i=1:length(U)
    
    % Prediction step
    mux = mu(1) + U(1,i)*cos(mu(3));
    muy = mu(2) + U(1,i)*sin(mu(3));
    mut = mu(3) + U(2,i);
    
    F = [1 0 -U(1,i)*sin(mu(3)); 0 1 U(1,i)*cos(mu(3)); 0 0 1];
    Sigma = F*Sigma*F' + R;
    
    mu = [mux; muy; mut];
    
    
    % Update step
    zhat = [mu(1)^2 + mu(2)^2; mu(3)];
    H = [2*mu(1) 2*mu(2) 0; 0 0 1];
    K = Sigma*H'*inv(H*Sigma*H' + Q);
    mu = mu + K*(Z(:,i) - zhat);
    Sigma = (eye(3)-K*H)*Sigma;
    
    XHat = [XHat mu];
    Var = [Var diag(Sigma)];
    
end;