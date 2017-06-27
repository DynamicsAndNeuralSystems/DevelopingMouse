cd 'D:\Data\DevelopingAllenMouseAPI-master\Allen annotation volume\Reference space\Atlas 2011'
clear all
% x=xlsread('structure_centers_annotation_mouse_2011_1.csv',1,'B2:B1931')
% y=xlsread('structure_centers_annotation_mouse_2011_1.csv',1,'C2:C1931')
% %%
% 
% z=xlsread('structure_centers_annotation_mouse_2011_1.csv',1,'D2:D1931')

%%
% extract those from reference atlas ID 9 only (for now)
x_9=x([1:2:1929]);
y_9=y([1:2:1929]);
z_9=z([1:2:1929]);

% extract those from reference atlas ID 10 only (for now)
x_10=x([2:2:1930]);
y_10=y([2:2:1930]);
z_10=z([2:2:1930]);

%%
ID=xlsread('structure_centers_annotation_mouse_2011_1.csv',1,'A2:A1931');

% extract only 1 set
ID=ID(1:2:1929);
%%
coord_9=horzcat(x_9,y_9,z_9);
coord_10=horzcat(x_10,y_10,z_10);
%%
csvwrite('centre.csv',coord_9)
%csvwrite('coordinatesfromAllenmouse2011_10.csv',coord_10)
%%
csvwrite('ID.csv',ID)

%%
% extract from atlas ID 9 only
is9 = (reference_space_id==9);
x_9 = x(is9);
y_9 = y(is9);
z_9 = z(is9);
reference_space_id_9 = reference_space_id(is9);


if ~all(reference_space_id_9==9)
    error('Error matching to id 9');
end

coord_9=horzcat(x_9,y_9,z_9);
%%
structure_id_9=structure_id(is9);
%%
csvwrite('centre.csv',coord_9)
%csvwrite('coordinatesfromAllenmouse2011_10.csv',coord_10)
%%
%csvwrite('ID.csv',structure_id_9)

dlmwrite('ID.csv', structure_id_9, 'precision', 10)