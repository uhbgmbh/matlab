% Hybrid Automata Test Script

% Simulation time parameters
dt = 0.1; tMax = 10; NumTimeUpdates = (tMax-dt)/dt + 1;
time = [0,dt:dt:tMax]';
NumExpTerms = 3;    % Number of matrix exponential terms

% Initialize PositionState and ModeState
x_o = [1;1];    % Initial position
PositionState = zeros(NumTimeUpdates+1,2); PositionState(1,:) = x_o';
ModeState = zeros(NumTimeUpdates+1,1); ModeState(1,1) = 1;

% Plotting State Space
figure; hold on;
plot(x_o(1),x_o(2),'ko-')

for i = 1:NumTimeUpdates
    % Get Current State and Mode
    x = PositionState(i,:)'; q = ModeState(i,:);
    % Check Guard Condition
    q = CheckGuardCondition(x,q);
    % Get A Matrix corresponding to correct mode
    A = GetModeAMatrix(q);
    % Perform time step
    x = MatExp(A,dt,NumExpTerms)*x;
    % Update State and Mode
    PositionState(i+1,:)=x';ModeState(i+1,:)=q;
    % Add new state to state space plot
    plot(x(1),x(2),'ko-');
end

% Plot Modestate vs. Time
figure; plot(time,ModeState); axis([0 tMax -1 3]);
xlabel('Time (s)');
ylabel('Switch State - q');
% Plot State X1 vs. Time
figure; plot(time,PositionState(:,1));
xlabel('Time (s)');
ylabel('X1 Position');
% Plot State X2 vs. Time
figure; plot(time,PositionState(:,2));
xlabel('Time (s)');
ylabel('X2 Position');
