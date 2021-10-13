function [S_rel] = PhotoDiodeSensitivity(lambda_d);
x = lambda_d/921-1;
S_rel = exp(-88*(-0.335504885993485)^2*(x.^2)+41*(-0.335504885993485)^3*(x.^3)).*100;%sensitivity eqn proposed by Agarwal
end