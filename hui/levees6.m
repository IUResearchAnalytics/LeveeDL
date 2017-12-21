%Filtering is applied from levees4.m
fprintf('Hello levees\n')
filename='31681560';

load(filename);
fprintf('LiDAR data loaded to matrix of\n')

maxx = max(x);
minx = min(x);
maxy = max(y);
miny = min(y);
maxz = max(z);
minz = min(z);

%intensity histogram
h = figure;
hist(i,20);
print(h, '-dpng', 'ihist.png');
close(h);

%z axis histogram
h5 = figure(5);
hist(z,20);
print(h5, '-dpng', 'zhist.png');
close(h5);

% scatter plot
h2 = figure(2);
scatter3(x,y,z,1,z);
print(h2, '-dpng', 'scatter.png');
close(h2);

%gridding with 1 sqft
rijx = minx:1:maxx;
rijy = miny:1:maxy;

[XI,YI] = meshgrid(rijx,rijy);
ZI = griddata(x,y,z,XI,YI);

%Filter
FI = medfilt2(ZI);

%2ft contour
h4=figure(4)
mesh(XI,YI,FI);
contour(XI,YI,FI,2);
colorbar
axis equal
print(h4, '-dpng', 'contourwfilter.png');
close(h4);
