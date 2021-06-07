[imageFileName,labelFileName] = textread('AllList.txt','%s%s','delimiter',' ');
sampleLength = min( numel(imageFileName),numel(labelFileName) );
% sequential read
for i=1:sampleLength
    image = imread(imageFileName{i} );
    label = parseLabel(labelFileName{i} );
    disp(label);
end
% read all in cell matrix , it will take long time.
% need over 10G , if the mount of your memory is less than 10G , there are some problem.
%{
images={};
labels={};
for i = 1:sampleLength
     images= [ images ; imread(imageFileName{i})];
     labels=[ labels ; {parseLabel(labelFileName{i})}];
     %disp(labels);
end
%}

function output = parseLabel(filename)
    [x1,y1,x2,y2,x3,y3,x4,y4,label] = textread(filename,"%d%d%d%d%d%d%d%d%s",'delimiter',',');
    output=[x1 y1 x2 y2 x3 y3 x4 y4 label] ;
end
