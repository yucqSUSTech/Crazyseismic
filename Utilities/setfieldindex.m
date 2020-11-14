function [ s2 ] = setfieldindex( s1, idx )

% change the index of all fields in a struct

names = fieldnames(s1);
s2 = [];
for i = 1:length(names)
    values = getfield(s1,names{i});
    
    if max(idx)>length(values)
        return;
    end
    
    s1 = setfield(s1,names{i},values(idx));
end

s2 = s1;


end

