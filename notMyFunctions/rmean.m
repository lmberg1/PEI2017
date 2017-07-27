% https://iescoders.com/2016/10/19/some-utilities-to-deal-with-sac-data-format/
% rmean.m
% function replicate the rmean command in sac
% usage:
% demeaned=rmean(original)
% returns the mean removed data in demeaned array

function a=rmean(b)
    a=zeros(1,length(b));
    c=mean(b);
    for j=1:length(b)
        a(j)=b(j)-c;
    end
