function Index=mmsort(X3D)
if ~exist('p','var') 
    p=1;
end

Index=(1:size(X3D,3));

% Bubble-sort
swap_flag = 1;

while swap_flag == 1
    swap_flag=0;
    i=1;
    while i<=length(Index)-1
        if mm(X3D(:,:,Index(i)),X3D(:,:,Index(i+1)))==2
            buffer=Index(i);
            Index(i)=Index(i+1);
            Index(i+1)=buffer;
            swap_flag=1;
        end
        i=i+1;
    end
end
end