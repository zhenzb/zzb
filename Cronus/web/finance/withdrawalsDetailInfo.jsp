<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/finance/menu_finance.jsp"%>
<%
    String order_id = request.getParameter("order_id");
    String user_id = request.getParameter("user_id");
    String id = request.getParameter("id");

%>


<script>
    var id = <%=id%>
    var order_id = <%=order_id%>

    layui.config({

        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    layui.use('table', function(){
        var table = layui.table;
        table.render({
            elem: '#withdrawalsList'
            ,url:'${ctx}/finance?method=WithdrawShowdetail&id='+id+'&order_id='+order_id
            ,cellMinWidth: 200 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,height: 530
            ,page:true
            ,cols: [[
                {type:'numbers',fixed: 'true'}
                ,{field:'operation_time', title: '申请时间', align: 'center',width:'150',templet:'#create_date'}
                ,{field:'status', title: '处理状态',align: 'center',width:'150',templet:'#state'}
                ,{field:'rental', title: '可提现账户总金额(元)',align: 'center',width:'150'}
                ,{field:'num', title: '当前预估总金额（元）', width:150, templet:function(d){
                        var num=Number(d.rental)+Number(d.commimoney);
                        return num;
                    }}
                ,{field:'money', title: '申请提现金额(元)',align: 'center',width:'150'}
                ,{field:'order_no', title: '提现单号',align:'center',width:'150'}
                ,{field:'status', title: '提现状态',align:'center',templet: '#titleTpl',templet: '#statu'}
                ,{field:'payment_way_key', title: '打款方式', align:'center'}
                ,{field:'reason', title: '决绝原因',align:'center',width:'150'}
                ,{field:'firmReason', title: '最后操作时间',align:'center',width:'150'}
                ,{field:'firmReason', title: '最后处理人',align:'center',width:'150'}
                ,{fixed:'right',title:'操作', width:250,align:'center',toolbar:"#barDemo"}
            ]]
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1 //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
        });

        var $ = layui.$, active = {
            reload: function(){
                //执行重载
                table.reload('listReload', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    ,where: {
                        key: {
                            username: userName.val()
                        }
                    }
                });
            }
        };

        $("#phone").val("11111");


        var user_id = <%=user_id%>
            $(document).ready(function(){
                $.ajax({
                    //几个参数需要注意一下
                    type: "post",//方法类型
                    dataType: "json",//预期服务器返回的数据类型
                    url: "${ctx}/finance?method=Getpeople" ,//url
                    async : true,
                    data: {user_id:user_id},
                    success:function(res){
                        var nick_name=res.rs[0].nick_name;
                        var member_level=res.rs[0].member_level;
                        var phone=res.rs[0].phone;
                        document.getElementById("nick_name").innerHTML=(nick_name);
                        if(member_level==1){
                            document.getElementById("member_level").innerHTML=("会员");
                        }else{
                            document.getElementById("member_level").innerHTML=("非会员");
                        }

                        document.getElementById("phone").innerHTML=(phone);
                    },
                    error:function(){
                        alert("获取该用户信息失败，该用户不存在");
                        layer.closeAll();
                    },
                });
            });
    });

</script>
</script>
<script type="text/html" id="statu">
{{# if(d.status=='1'){}}
<span style="color:#FF0000; ">已提现</span>

{{# }else if(d.status=='2'){ }}
<span style="color:green; ">已拒绝</span>
{{# } }}
</script>

<script type="text/html" id="state">
    {{# if(d.status=='0'){}}
    <span style="color:#FF0000; ">未处理</span>

    {{# }else if(d.status!='0'){ }}
    <span style="color:green; ">已处理</span>
    {{# } }}
</script>
<%-- 转时间 --%>
<script id="create_date" type="text/html">
    {{#  if(d.operation_time !== ''){ }}
    <%--<span style="color: rgba(10,10,10,0.46);">{{ d.registration_time.substr(0,2) }}</span>--%>
    <span style="color: rgba(10,10,10,0.46);">20{{ d.operation_time.substr(0,2) }}-{{ d.operation_time.substr(2,2) }}-{{ d.operation_time.substr(4,2) }} {{ d.operation_time.substr(6,2) }}:{{ d.operation_time.substr(8,2) }}:{{ d.operation_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">---</span>
    {{#  } }}
</script>
<!-- 内容主体区域 -->
<div class="layui-body">
    <div class="layui-row">
        <div style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px">
            <label style="font-size: 18px;margin-left: 3% ; line-height: 50px" >提现信息详情</label>
            <button class="layui-btn layui-btn-radius" style=" margin-left: 75%" onclick="history.go(-1)">返回</button>
        </div>
        <br>
        <div>
            <label style="font-size: 15px;margin-left: 3% ; line-height: 30px" >联系人信息</label>
            <hr class="layui-bg-gray">
        </div>
        <div style=" height: 50px;margin-top: 10px;margin-left: 100px">

            <div class="layui-inline" >
                姓名：
                <span style="color: red; " id="nick_name" />
            </div>
            <div class="layui-inline" style="position: relative;left:500px;">
                手机号：
                <span style="color: red; " id="phone"/>
            </div>
        </div>
        <div style=" height: 50px;margin-top: 10px;margin-left: 100px">
            会员类型：
            <span style="color: red; " id="member_level"/>
        </div>
    </div>

    <div>
        <div>
            <label style="font-size: 15px;margin-left: 3% ; line-height: 30px" >提现信息</label>
            <hr class="layui-bg-gray">
        </div>
        <div style="margin-left: 20px">
            <table class="layui-table" id="withdrawalsList"  style="visibility: hidden" lay-filter="demo" ></table>
        </div>
    </div>
</div>

