function pressure = pressureeqn(P,timex)
% P(1) = Po
% P(2) = P1
% P(3) = tau

pressure = (P(1) - P(2)) * exp((-timex/P(3)) + P(2));

end
