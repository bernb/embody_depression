function data=load_subj(folder,option)
    N=length(dir(folder+"/*.csv"));
    if(option==0)
        disp('here')
        for n=0:N-1
            file=[folder '/' num2str(n) '.csv'];
            fid = fopen(file);
            line=textscan(fid,'%s','CollectOutput',1,'Delimiter',';');
            data(:,n+1)=line{1};
        end
        data=data';
    end
    if(option==1)
        disp('option 1 not implemented')
    end
    if(option>=2)
        for n=0:N-1
            file=[folder '/' num2str(n) '.csv'];
            
            line=dlmread(file,',');
            delim=find(-1==line(:,1));
            data(n+1).mouse=line(1:delim(1)-1,:);
            data(n+1).paint=line((delim(1)+1):(delim(2)-1),:);
            data(n+1).mousedown=line((delim(2)+1):(delim(3)-1),:);
            data(n+1).mouseup=line((delim(3)+1):end,:);
        end
    end