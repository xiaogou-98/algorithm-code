
%% 计算一条路线上车辆到达各顾客的时间，对各顾客的开始服务时间，以及返回配送中心的时间
%输入route：       一条配送路线
%输入a：           最早开始服务的时间窗
%输入s：           对每个点的服务时间
%输入dist：        距离矩阵
%输出arr：         车辆到达各顾客的时间
%输出bs：          车辆对各顾客的开始服务时间
%输出wait：        车辆对各顾客的等待时间
%输出back：        车辆返回配送中心的时间
function [arr,bs,wait,back]=begin_s(route,a,s,dist)
n=length(route);                        %配送路线上经过顾客的总数量
arr=zeros(1,n);                         %车辆到达各顾客的时间
bs=zeros(1,n);                          %车辆对顾客的开始服务时间
wait=zeros(1,n);                        %车辆对各顾客的等待时间
arr(1)=dist(1,route(1)+1);
bs(1)=max(a(route(1)),dist(1,route(1)+1));
wait(1)=bs(1)-arr(1);
for i=1:n
    if i~=1
        arr(i)=bs(i-1)+s(route(i-1))+dist(route(i-1)+1,route(i)+1);
        bs(i)=max(a(route(i)),bs(i-1)+s(route(i-1))+dist(route(i-1)+1,route(i)+1));
        wait(i)=bs(i)-arr(i);
    end
end
back=bs(end)+s(route(end))+dist(route(end)+1,1);
end