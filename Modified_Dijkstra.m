clear all
clc
n=10;
m=10;
sr=1;
sc=10;
er=6;
ec=5;
presdestcost=10000;
heu=zeros(n,m);
cost=10000.*ones(n,m);
cost(sr,sc)=0;
f=10000.*ones(n,m);
f(sr,sc)=0;
map=zeros(n,m);
map(1,1)=1;
moves=zeros(n,m,10);
moveslist=ones(n,m);
digcur=zeros(n,m);
list=zeros(n*m,2);
list(1,1)=sr;
list(1,2)=sc;
countlist=1;
presentboard=zeros(n,m);
oblist=zeros(n*m,2);
hori=[0 1 1 1 1 1 1 1 1 1; 1 1 0 0 0 0 0 1 1 1; 1 1 0 0 0 0 0 1 1 1; 1 0 0 0 1 1 1 1 1 1; 1 0 0 0 1 1 1 1 1 1; 1 1 1 1 1 0 0 1 1 1; 1 1 1 1 1 0 0 1 1 1; 1 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 0 1 1 0];
vert=[0 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1 1; 1 1 1 1 0 0 0 1 1 1; 1 1 1 1 0 0 0 1 1 1; 1 0 0 0 1 1 1 1 1 1; 1 0 0 0 1 1 1 1 1 1; 1 1 0 0 1 0 0 1 1 1; 1 1 1 1 1 1 0 1 1 1; 1 1 1 1 1 1 0 1 1 0];
for i=1:n
    for j=1:m
        heu(i,j)=10*sqrt((abs(er-i)^2)+(abs(ec-j)^2));
    end
end
vertflag=0;
for i=1:n %vertical
    for j=1:m
        if(vert(i,j)==0)
            if (vertflag==0)
                vertup=i-1;
                vertflag=1;
            end
            vertdown=n-i;
        end
    end
end
horiflag=0;
for i=1:m %hrizontal
    for j=1:n
        if(hori(j,i)==0)
            if (horiflag==0)
                horileft=i-1;
                horiflag=1;
            end
            horiright=m-i;
        end
    end
end
if(vertup>0)
    x='u';
else
    x='d';
end
if(horileft>0)
    y='l';
else
    y='r';
end
moveno=0;
iterationleft=100;
mincost=sqrt(10^2+10^2)*min(abs(er-sr),abs(ec-sc))+10*(max(abs(er-sr),abs(ec-sc))-min(abs(er-sr),abs(ec-sc)));
while (iterationleft>0)
    obstaclecount=0;
    moveno=moveno+1;
    if(x=='u')
        for i=1:n-1
            for j=1:m
                vert(i,j)=vert(i+1,j);
                if(i==n-1 && vert(i+1,j)==0)
                    vert(i+1,j)=1;
                end
            end
        end
        vertup=vertup-1;
        vertdown=vertdown+1;
    elseif(x=='d')
        for i=n:-1:2
            for j=1:m
                vert(i,j)=vert(i-1,j);
                if(i==2 && vert(1,j)==0)
                    vert(1,j)=1;
                end
            end
        end
        vertup=vertup+1;
        vertdown=vertdown-1;
    end
    if(vertup==0)
        x='d';
    elseif(vertdown==0)
        x='u';
    end
    if(y=='l')
        for i=1:m-1
            for j=1:n
                hori(j,i)=hori(j,i+1);
                if(i==m-1 && hori(j,i+1)==0)
                    hori(j,i+1)=1;
                end
            end
        end
        horileft=horileft-1;
        horiright=horiright+1;
    elseif(y=='r')
        for i=m-1:-1:1
            for j=1:n
                hori(j,i+1)=hori(j,i);
                if(i==1 && hori(j,i)==0)
                    hori(j,i)=1;
                end
            end
        end
        horileft=horileft+1;
        horiright=horiright-1;
    end
    if(horileft==0)
        y='r';
    elseif(horiright==0)
        y='l';
    end
    for i=1:n
        for j=1:m
            presentboard(i,j)=vert(i,j)*hori(i,j);
            if(presentboard(i,j)==0)
                obstaclecount=obstaclecount+1;
                oblist(obstaclecount,1)=i;
                oblist(obstaclecount,2)=j;
            end
        end
    end
    b=countlist;
    while(b~=0)
        presr=list(b,1);
        presc=list(b,2);
        b=b-1;
        for i=-1:1
            for j=-1:1
                if(presr+i>0 && presc+j>0 && presr+i<=n && presc+j<=m && presentboard(presr+i,presc+j)==1 && (f(presr+i,presc+j)>cost(presr,presc)+10*sqrt(abs(i)+abs(j))+heu(presr+i,presc+j)))
                    map(presr+i,presc+j)=1;
                    cost(presr+i,presc+j)=cost(presr,presc)+10*sqrt(abs(i)+abs(j));
                    f(presr+i,presc+j)=cost(presr+i,presc+j)+heu(presr+i,presc+j);
                    for k=1:(moveslist(presr,presc)-1)
                        moves(presr+i,presc+j,k)=moves(presr,presc,k);
                    end
                    moves(presr+i,presc+j,moveslist(presr,presc))=moves(presr,presc,moveslist(presr,presc))*10000+100*presr+presc;
                    moves(presr+i,presc+j,moveslist(presr,presc)+1:10)=0;
                    digcur(presr+i,presc+j)=digcur(presr,presc)+4;
                    if(digcur(presr+i,presc+j)==12)
                       moveslist(presr+i,presc+j)=moveslist(presr,presc)+1;
                       digcur(presr+i,presc+j)=0;
                    else
                        moveslist(presr+i,presc+j)=moveslist(presr,presc);
                    end
                    flag=1;
                    for k=1:countlist
                        if(list(k,1)==(presr+i) && list(k,2)==(presc+j))
                            flag=0;
                            break;
                        end
                    end 
                    if(flag==1)
                        countlist=countlist+1;
                        list(countlist,1)=presr+i;
                        list(countlist,2)=presc+j;
                    end
                end
            end
        end
        minflag=0;
        if(presr==er && presc==ec && cost(presr,presc)<presdestcost)
            disp('Moves');
            presdestcost=cost(presr,presc);
            fprintf('%12.f',moves(presr,presc,1:moveslist(presr,presc)));
            fprintf('\nCost:%.0f\n',presdestcost);
            fprintf('Time taken to complete (no. of moves required):%d\n',moveno);
            if(cost(er,ec)==mincost)
                minflag=1;
                break;
            end
        end
    end
    if(minflag==1)
        disp('iterationleft');
        disp(iterationleft);
        break;
    end
    for i=1:obstaclecount
        if(map(oblist(i,1),oblist(i,2))==1)
            moves(oblist(i,1),oblist(i,2),:)=0;
            map(oblist(i,1),oblist(i,2))=0;
            cost(oblist(i,1),oblist(i,2))=10000;
            f(oblist(i,1),oblist(i,2))=10000;
            for j=1:countlist
                if(list(j,1)==oblist(i,1) && list(j,2)==oblist(i,2))
                    for k=j:countlist-1
                        list(k,1)=list(k+1,1);
                        list(k,2)=list(k+1,2);
                    end
                end
            end
            list(countlist,1)=0;
            list(countlist,2)=0;
            countlist=countlist-1;
        end
    end
    iterationleft=iterationleft-1;
end
