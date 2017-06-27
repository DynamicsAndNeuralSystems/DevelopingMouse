cd 'D:\Data\DevelopingAllenMouseAPI-master\Allen annotation volume\Reference space\Atlas 2011'

x=xlsread('Mouse_2011_coordinates.xlsx');
%%
y=xlsread('Mouse_2011_coordinates.xlsx','B:B');

z=xlsread('Mouse_2011_coordinates.xlsx','C:C');

% extract those from reference atlas ID 9 only (for now)
x_9=x([1:2:1929]);
y_9=x([1:2:1929]);
z_9=z([1:2:1929]);

% extract those from reference atlas ID 10 only (for now)
x_10=x([2:2:1930]);
y_10=x([2:2:1930]);
z_10=z([2:2:1930]);

%%
f=figure('color','w')
scatter3(x_9,y_9,z_9)
%%
f=figure('color','w')
scatter3(x_10,y_10,z_10)
