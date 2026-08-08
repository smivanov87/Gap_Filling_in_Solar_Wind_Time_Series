function [gaps] = gaps_stat(k)
j=0; %gaps=1:4;
gaps(1,1:3)=0;
for i=1:length(k)-1
    if k(i+1)-k(i)>1
        j=j+1;
        gaps(j,1)=k(i+1)-k(i)-1; gaps(j,2)=k(i); gaps(j,3)=k(i+1);
    end
end

for j=1:length(gaps(:,1))
        if (gaps(j,1)>=25)
            gaps(j,4)=25;
        % elseif (gaps(j,1)>12) && (gaps(j,1)<25)
        %     gaps(j,4)=13;
        else
             gaps(j,4)=gaps(j,1);
        end
end



end