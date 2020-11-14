function [ offset ] = get_offset2( para1, para2, minrange1 )
%GET_OFFSET2 Summary of this function goes here
%   Detailed explanation goes here

para1 = reshape(para1,[],1);
para2 = reshape(para2,[],1);

% [para1,ind] = sort(para1,'ascend');
% para2 = para2(ind);

mpara1 = sort(para1,'ascend');

while length(mpara1) > 1
    
    mcenter = length(mpara1);
    
    dpara1 = [];
    mpara1_new = mpara1;
    while 1
        mpara1 = mpara1_new;
        for k = 1:mcenter
            dpara1(:,k) = abs(para1-mpara1(k));
%             dpara12 = abs(para1-mpara1(k)-360);
%             mdpara1(:,k) = min([dpara1 dpara12],[],2);
        end

        [c,ind] = min(dpara1,[],2);

        for k = 1:mcenter
            mpara1_new(k,1) = mean(para1(ind==k));
        end

        if max(abs(mpara1_new-mpara1)) == 0
            break;
        end
    end

%     dpara1 = diff([mpara1;mpara1(1)+360]);
    dpara1 = abs(diff([mpara1;mpara1(1)]));
    [c2,ind2] = min(abs(dpara1));
    if c2 > minrange1
        break;
    else
        ind_tmp = 1:length(mpara1);
        mpara1 = mpara1(find(ind_tmp~=ind2));
        mpara1 = reshape(mpara1,[],1);
%         mcenter = length(mpara1);
    end
end

offset = para1;
if length(mpara1) > 1
    for k = 1:length(mpara1)
        ind3 = find(ind==k);
        para1_tmp = para1(ind3);
        para1_tmp = sort(para1_tmp,'ascend');
        para2_tmp = para2(ind3);
        [para2_tmp,ind4] = sort(para2_tmp,'ascend');
        offset(ind3(ind4)) = para1_tmp;
    end
end


end
