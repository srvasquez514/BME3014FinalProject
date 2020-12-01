function SSE = pressureerror(P,timex,voltage)
% Calculate model data
model = pressureeqn(P,timex);

% Calculate SSE

SSE = sum((voltage(:) - model(:)).^2);
end
