%% mutation
% Input - offsprings before mutation (obm)
% Output - offsprings after mutation (oam)
function oam = mutation(obm)
[row,col] = size(obm);
% fval = optimal_placement(obm,betamse,latlist,lonlist,ld);
mcf = rand(row,col);
Pm = 0.2;
lat = rand(row,col/2);
lon = rand(row,col/2);
temp = [lat,lon];
oam = obm.*(mcf>Pm) + temp.*(mcf<Pm);
end
