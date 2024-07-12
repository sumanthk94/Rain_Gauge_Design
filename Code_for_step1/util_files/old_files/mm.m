function Mmplan=mm(X1,X2)

% if~exist('p','var')
%     p=1;
% end

if sortrows(X1)==sortrows(X2)
    Mmplan=0;
else  
    [J1,d1] = jd(X1);
    m1=length(d1);
    [J2,d2] = jd(X2);
    m2=length(d2);
    
    V1(1:2:2*m1-1)=d1;
    V1(2:2:2*m1)=-J1;
    
    
    V2(1:2:2*m2-1)=d2;
    V2(2:2:2*m2)=-J2;
    
    m=2*min(m1,m2);
    V1=V1(1:m); V2=V2(1:m);
    
    c=(V1>V2)+2*(V1<V2);
    
    if sum(c)==0
        Mmplan=0;
    else
        a = c(c~=0);
        Mmplan = a(1);
%         i=1;
%         while c(i)==0
%             i=i+1;
%         end
%         Mmplan=c(i);

    end
end
    
end