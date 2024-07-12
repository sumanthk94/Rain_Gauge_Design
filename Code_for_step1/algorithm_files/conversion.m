function [ind,index] = conversion(x,latlist,longlist,location_list)

% Input- x is vector contains lat and long list
% output- ind gives the locations considered for spatial average
% calculation.
% index - corresponding to indices in considered location list 

%% convert x into lat,lon list
x = reshape(x',[],2)'; % row1-latlist, row2-longlist
coordinates = [latlist,longlist]; % consists lat and lon list of location_list
lat_ran = max(latlist) - min(latlist); % range of the latitude
long_ran = max(longlist) - min(longlist); % range of the longitude
In_ran = [lat_ran,min(latlist);long_ran,min(longlist)]; % used to conversion

%% converting x into range of latitude and longitude
cir = (x.*In_ran(:,1) + In_ran(:,2))'; 
[r,~] = size(cir);
[row,~] = size(coordinates);
si = zeros(r,row);

%% get nearest Neighbours
parfor i=1:r
    [~,si(i,:)] = sort(sqrt(sum((coordinates-repmat(cir(i,:),row,1)).^2,2)));
end
[~,ui] = unique(si(:,1));
j=2;
while length(ui) ~= r
    temp = setdiff(1:r,ui);
    for i=1:length(temp)
        si(temp(i),1) = si(temp(i),j);
    end
    [~,ui] = unique(si(:,1));
    j = j+1;
end
index = si(:,1)';
ind = location_list(index);
end