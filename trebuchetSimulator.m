% Define the parameters
counterweightMass = 500; % kg
beamLength = 10; % m
slingLength = 6; % m
projectileMass = 100; % kg
g = 9.81; % gravitational acceleration (m/s^2)
tMax = 10; % maximum simulation time (s)
dt = 0.001; % time step (s)

% Initialize the arrays
t = 0:dt:tMax;
theta = zeros(size(t));
omega = zeros(size(t));
alpha = zeros(size(t));
x = zeros(size(t));
y = zeros(size(t));

% Loop through the time steps
for i = 2:length(t)
    % Calculate angular acceleration
    if y(i-1) < 0 % releasing projectile phase
        alpha(i) = -counterweightMass*g*beamLength*sin(theta(i-1)) / ...
            (projectileMass + counterweightMass);
    else % winding up phase
        alpha(i) = -counterweightMass*g*beamLength*sin(theta(i-1)) / ...
            (projectileMass + counterweightMass + counterweightMass/3);
    end
    
    % Update the angular velocity and position
    omega(i) = omega(i-1) + alpha(i)*dt;
    theta(i) = theta(i-1) + omega(i)*dt;
    
    % Calculate the projectile velocity and position
    slingAngle = asin(beamLength*sind(theta(i))/slingLength);
    vx = -slingLength*omega(i)*cos(slingAngle);
    vy = -slingLength*omega(i)*sin(slingAngle);
    x(i) = x(i-1) + vx*dt;
    y(i) = y(i-1) + vy*dt - 0.5*g*dt^2;
    
    % Stop the simulation if projectile hits ground
    if y(i) < 0
        break
    end
end

% Plot the results
plot(x(1:i), y(1:i))
xlabel('Distance (m)')
ylabel('Height (m)')
title('Trebuchet Projectile Motion')
