function waitTime = waitTimeVanStralen(wallSuperheatI)

    growthTime = calcGrowthTime(wallSuperheatI);

    waitTime = 3 * growthTime;

end
% Van Stralen, S.J.D. et al. "Bubble growth rates in pure and binary
% systems." Int. J. Heat Mass Transfer (1975).
