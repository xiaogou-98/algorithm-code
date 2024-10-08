
%% 解码
%输入：route_k             蚂蚁k的路径记录数组
%输入：cap                 最大载重量
%输入：demands             需求量
%输入：a                   顾客时间窗开始时间[a[i],b[i]]
%输入：b                   顾客时间窗结束时间[a[i],b[i]]
%输入：L                   配送中心时间窗结束时间
%输入：s                   客户点的服务时间
%输入：dist                距离矩阵，满足三角关系，暂用距离表示花费c[i][j]=dist[i][j]
%输出：VC                  每辆车所经过的顾客，是一个cell数组
%输出：NV                  车辆使用数目
%输出：TD                  车辆行驶总距离
%
function [VC,NV,TD]=decode(route_k,cap,demands,a,b,L,s,dist)
route_k(route_k==0)=[];                             %将0从蚂蚁k的路径记录数组中删除
cusnum=size(route_k,2);                             %已服务的顾客数目
VC=cell(cusnum,1);                                  %每辆车所经过的顾客
count=1;                                            %车辆计数器，表示当前车辆使用数目
preroute=[];                                        %存放某一条路径
for i=1:cusnum
    preroute=[preroute,route_k(i)];                 %将第route_k(i)添加到路径中
    flag=JudgeRoute(preroute,cap,demands,a,b,L,s,dist);%判断当前路径是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
    if flag==1
        %如果满足约束，则更新车辆配送方案VC
        VC{count}=preroute;               
    else
        %如果满足约束，则清空preroute，并使count加1
        preroute=route_k(i);     
        count=count+1;
        VC{count}=preroute;     
    end
end
[VC,NV]=deal_vehicles_customer(VC);                     %将VC中空的数组移除
TD=travel_distance(VC,dist);
end