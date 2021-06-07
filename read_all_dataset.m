function trainTable = read_all_dataset(Listfilename)
%  read_all_dataset Summary of this function goes here
%   Detailed explanation goes here
    function data = parseLabel(filename)
        fid = fopen(filename);
        data = textscan(fid,"%f%f%f%f%f%f%f%f%s",'delimiter',',');
        fclose(fid);
    end
    fid = fopen(Listfilename);
    ListArray = textscan(fid,'%s%s','delimiter',' ');
    fclose(fid);
    [imageFilename , labelFilename] = ListArray{:};
    fds = fileDatastore(labelFilename,'ReadFcn',@parseLabel);
    numObservations = numel(fds.Files);
    for i = 1:numObservations
        [data , info ]= read(fds); %%data為內容 info為路徑
        bbox = horzcat( data{1:8} );%將每個小單位合成一個大矩陣
        label = horzcat( data{9} );%取得label
        bboxes{1,i} = bbox;
        labels{1,i} = label;
        
        % change to rantangle label
        bbox =bboxes{1,i};
        x = bbox(:,1:2:end);%取得txt中的x座標
        y = bbox(:,2:2:end);%取得txt中的y座標
        xMin = min(x,[],2);%在x中找最小的
        xMax = max(x,[],2);%在x中找最大的
        yMin = min(y,[],2);%在y中找最小的
        yMax = max(y,[],2);%在y中找最大的
        bboxes{1,i} = [xMin,yMin,xMax-xMin,yMax-yMin];%存左上的點 與長寬
        
        %座標為 左下 左上 右上 右下
    end
    BBoxes = bboxes;
    Labels = labels;
    NumClasses = 105;
    
    for i=1:NumClasses
        class{1,i}= strcat( 'B' , num2str(i) );%有B1~B105這幾種
    end
    imageTable = table(imageFilename);%將所有圖片(路徑)存成table
    labelsTable  = cell2table(cell(numObservations,NumClasses), 'VariableNames', class);
%     Labels{1,1}{2}
    for i = 1:numObservations
        for j = 1:size(Labels{1,i})%查看是幾乘幾
            tidx = find(string(labelsTable.Properties.VariableNames) == Labels{1,i}{j} );
            %tidx為查看為B幾
            labelsTable{ i , tidx } = mat2cell(BBoxes{1,i}(j,:),1);
        end
    end
    trainTable = [imageTable labelsTable];%合併
    
    for i=1:2462
        
        disp(BBoxes{1,i}(1,3:4));
    end
end


