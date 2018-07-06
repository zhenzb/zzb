<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/member/huiyuan_menu.jsp"%>
<html>
<head>
    <title>会员等级管理</title>
    <script src="../code/highcharts.js"></script>
    <script src="../code/modules/exporting.js"></script>
    <script>
        var member, outsider;
        //查询会员人数
        window.onload = function() {
            $.ajax({
                //几个参数需要注意一下
                type: "get",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/member?method=selectCountMember" ,//url
                async : false,
                data: {type:1},
                success:function(res1){
                    var obj=res1.rs[0].count;
                    member =obj;
                    console.log(member);
                    document.getElementById("Selectpending").innerHTML=(obj);
                },
            });

            $.ajax({
                //几个参数需要注意一下
                type: "get",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/member?method=selectCountMember" ,//url
                async : false,
                data: {type:0},
                success:function(res1){
                    var obj=res1.rs[0].count;
                    outsider =obj;
                    document.getElementById("Selectpending2").innerHTML=(obj);
                },
            });
            //饼状图
            Highcharts.chart('container', {

                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text:null,
                },
                credits: {
                    enabled: false
                },
                exporting:{
                    enabled:false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                            style: {
                                color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                            }
                        }
                    }
                },
                series: [{
                    name: '数据分析',
                    colorByPoint: true,
                    data: [{
                        name: '会员',
                        y: eval(member)
                    }, {
                        name: '非会员',
                        y: eval(outsider),
                        sliced: true,
                        selected: true
                    }]
                }]
            });
        };
        //JavaScript代码区域
        layui.use('element', function(){
            var element = layui.element;
        });
        /*点击 添加会员按钮弹出对会框*/
        layui.use('layer', function(){
            var $ = layui.jquery, layer = layui.layer;
            //触发事件
            var active = {
                offset: function(othis){
                    var type = othis.data('type')
                        ,text = othis.text();

                    layer.open({
                        type: 1
                        ,offset: type
                        ,title:'添加会员分销等级'
                        ,id: 'layerDemo'+type
                        ,content: '<div style="padding: 20px 100px;height:100px;">'
                        + '<input id="ranktext" type="text" style="height:30px;width:200px" placeholder="请输入会员等级">'
                        +'</div>'
                        ,btn: '保存'
                        ,btnAlign: 'r' //按钮居中
                        ,shade: 0 //不显示遮罩
                        ,yes: function(){
                            layer.closeAll();
                        }
                    });
                }
            };

            $('#layerDemo .layui-btn').on('click', function(){
                var othis = $(this), method = othis.data('method');
                active[method] ? active[method].call(this, othis) : '';
            });

        });
        /* 表格数据查询*/
        layui.use('table', function(){
            var table = layui.table;
            var table2 = layui.table;
            var table3 = layui.table;
            table.render({
                elem: '#getMemberList'
                ,url:'${pageContext.request.contextPath}/member?method=getMemberListPage'
                //,width:1250
                ,height: 485
                ,cols: [[
                    {field:'id',align: 'center', width:60, title: 'id'}
                    ,{field:'nick_name',align: 'center', width:127, title: '名称'}
                    ,{field:'phone', width:150, title: '手机号',align: 'center',templet:'#telPhoneTpl'}
                    ,{field:'Invitation_code1', width: 150, title: '邀请码',align: 'center',templet:'#Invitation_code'}
                    ,{field:'sup_member_name', width:150, title: '上级会员',align: 'center',templet:'#sup_memberTpl'}
                    ,{field:'self_num', width:150, title: '下级会员人数',align: 'center',templet:function(d){
                            return Number(d.self_num)+Number(d.pare_num);
                        }}
                    ,{field:'registration_time', width:200, title: '注册时间',align: 'center',templet: '#create_timeTpl'}
                    ,{field:'status', width:100, title: '状态',align: 'center',templet:"#statusTpl"}
                    ,{field:'wealth', width:500, title: '操作',align: 'center',toolbar: '#barDemo1',fixed: 'right'}
                ]]
                ,limit:20
                ,limits:[20,30,50,100]
                ,page: true
                ,response: {
                    statusName: 'success'
                    ,statusCode: 1
                    ,msgName: 'errorMessage'
                    ,countName: 'total'
                    ,dataName: 'rs'
                }
                ,id:'getMemberListSreach'
            });
            table2.render({
                elem: '#search1'
                ,url:'${pageContext.request.contextPath}/member?method=getMembersList&member_level='+1
                ,width:1440
                ,height: 485
                ,cols: [[
                    {field:'id', width:80, title: 'id'}
                    ,{field:'nick_name', width:150, title: '名称'}
                    ,{field:'phone', width:150, title: '手机号' }
                    ,{field:'phone', width:150, title: '邀请码' }
                    ,{field:'sup_member_name', width:130, title: '上级会员',templet:'#sup_memberTpl'}
                    ,{field:'self_num', width:130, title: '下级会员人数',templet:function(d){
                            return Number(d.self_num)+Number(d.pare_num);
                        }}
                    ,{field:'registration_time', width:230, title: '注册时间',templet: '#create_timeTpl'}
                    ,{field:'status', width:100, title: '状态',templet:"#statusTpl"}
                    ,{field:'wealth', width:600, title: '操作',toolbar: '#barDemo1'}
                ]]
                ,page: true
                ,response: {
                    statusName: 'success'
                    ,statusCode: 1
                    ,msgName: 'errorMessage'
                    ,countName: 'total'
                    ,dataName: 'rs'
                }
            });
            table3.render({
                elem: '#search2'
                ,url:'${pageContext.request.contextPath}/member?method=getMembersList&member_level='+0
                ,width:1440
                ,height: 485
                ,cols: [[
                    {field:'id', width:80, title: ''}
                    ,{field:'nick_name', width:150, title: '名称'}
                    ,{field:'phone', width:150, title: '手机号',templet:'#telPhoneTpl'}
                    ,{field:'phone', width: 150, title: '邀请码',templet:'#Invitation_code'}
                    ,{field:'sup_member_name', width:130, title: '上级会员',templet:'#sup_memberTpl'}
                    ,{field:'self_num', width:130, title: '下级会员人数',templet:function(d){
                            return Number(d.self_num)+Number(d.pare_num);
                        }}
                    ,{field:'registration_time', width:200, title: '注册时间',templet: '#create_timeTpl'}
                    ,{field:'status', width:100, title: '状态',templet:"#statusTpl"}
                    ,{field:'wealth', width:500, title: '操作',toolbar: '#barDemo1'}
                ]]
                ,page: true
                ,response: {
                    statusName: 'success'
                    ,statusCode: 1
                    ,msgName: 'errorMessage'
                    ,countName: 'total'
                    ,dataName: 'rs'
                }
            });
            //点击按钮 搜索
            $('#searchBtn').on('click', function(){
                var keywordTep = $('#status').val();
                var phone =$("#phone").val();
                table.reload('getMemberListSreach', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    ,where: {
                        status: keywordTep,
                        phone:phone
                    }
                });
                return false;
            });
        });
        //点击查看按钮弹出信息框
        function aClick(){
            var layer = layui.layer;
            layer.open({
                type: 1,
                area: ['1000px', '500px'],
                shade: [0.8, '#393D49'],
                title: '会员信息表',
                content: $('#dialog'),
                btn: ['确认', '取消'],
                yes: function(index, layero) {
                    // tstjgl.save();
                    layer.closeAll();
                },
                btn2: function(index, layero) {},
                cancel: function() {

                }
            });
        };
        //点击查看非会员按钮弹出信息框
        function aClick2(){
            var layer = layui.layer;
            layer.open({
                type: 1,
                area: ['1000px', '500px'],
                shade: [0.8, '#393D49'],
                title: '会员信息表',
                content: $('#dialog2'),
                btn: ['确认', '取消'],
                yes: function(index, layero) {
                    // tstjgl.save();
                    layer.closeAll();
                },
                btn2: function(index, layero) {},
                cancel: function() {

                }
            });
        };
        //搜索功能
        /*        function search(){
                    var table = layui.table;
                    var keywordTep = $('#status').val();
                    var phone =$("#phone").val();
                    table.reload('getMemberListSreach', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        ,where: {
                            status: keywordTep,
                            phone:phone
                        }
                    });
                    console.log(status);

                }*/
        //点击禁用按钮
        function disable(obj){
            var table = layui.table;
            layer.confirm('确定要禁用选中的项吗？',function(index){
                layer.close(index);
                var status =0;
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${pageContext.request.contextPath}/member",
                    data : "method=updateStatus&status=" + status +"&id="+obj,
                    dataType : "json",
                    success : function(data){
                        if (data.success) {
                            layer.msg("操作成功");
                            table.reload("test1");
                            table.reload("search1")
                            table.reload("search2")

                        } else {
                            layer.msg("异常");
                        }
                    }
                })
            });
        };
        //查看上级人员列表
        function look_member_top(ids){
            //alert(ids);
            layer.open({
                type: 1
                ,title:'上级人员列表'
                ,id: '111111'
                ,area: ['1000px', '320px']
                ,content:$('#look_member_top_select')
                ,shade: 0 //不显示遮罩
                , btn: ['取消', '确认']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,yes: function(){
                    layer.closeAll();
                }
                ,success: function(data, index){
                    var table = layui.table;
                    table.render({
                        elem: '#look_member_t'
                        ,url:'${pageContext.request.contextPath}/member?method=selectMember&id='+ids
                        ,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
                        ,cols: [[
                            {field:'nick_name',  title: '姓名'}
                            ,{field:'phone', title: '手机号'}
                            ,{field:'beInvite_date',  title: '邀请成功时间', align: 'right',templet: '#beInvite_timeTpl' }
                            ,{field:'registration_time', title: '注册时间',templet: '#create_timeTpl'}
                            ,{field:'status',  title: '状态',templet:'#statusTpl'}
                            ,{field:'wealth',  title: '操作',toolbar:"#barDemo1"}
                        ]]
                        ,response: {
                            statusName: 'success'
                            ,statusCode: 1
                            ,msgName: 'errorMessage'
                            ,countName: 'total'
                            ,dataName: 'rs'
                        }
                    });
                }
            })
        };
        //查看下级人员列表
        function look_member_bo(id){
            alert(id);
            layer.open({
                type: 1
                ,title:'下级人员列表'
                ,id: '22222'
                ,area: ['1000px', '500px']
                ,content:$('#look_member_bo_select')
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                , btn: ['取消', '确认']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,yes: function(){
                    layer.closeAll();
                }
                ,success: function(data, index){
                    var table = layui.table;
                    table.render({
                        elem: '#selectMemberDown1'
                        ,url:'${pageContext.request.contextPath}/member?method=selectMembers&id='+id
                        ,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
                        ,cols: [[
                            {field:'nick_name',align: 'right',  title: '姓名'}
                            ,{field:'phone',align: 'right', title: '手机号'}
                            ,{field:'beInvite_date',  title: '邀请成功时间', align: 'right',templet: '#beInvite_timeTpl' }
                            ,{field:'registration_time', title: '注册时间',templet: '#create_timeTpl'}
                            ,{field:'status',align: 'right',  title: '状态',templet:'#statusTpl'}
                            ,{field:'wealth', align: 'right', title: '操作',toolbar:"#barDemo1"}
                        ]]
                        ,response: {
                            statusName: 'success'
                            ,statusCode: 1
                            ,msgName: 'errorMessage'
                            ,countName: 'total'
                            ,dataName: 'rs'
                        }
                    });
                }
            });
        };
        //点击启用按钮
        function enable(obj){
            var table = layui.table;
            layer.confirm('确定要启用选中的项吗？',function(index){
                layer.close(index);
                var status =1;
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${pageContext.request.contextPath}/member",
                    data : "method=updateStatus&status=" + status +"&id="+obj,
                    dataType : "json",
                    success : function(data){
                        if (data.success) {
                            layer.msg("操作成功");
                            table.reload("test1")
                            table.reload("search1")
                            table.reload("search2")
                        } else {
                            layer.msg("异常");
                        }
                    }
                })
            });
        }
    </script>
    <script type="text/html" id="usernameTpl">
        <a href="javascript:void(0)" onclick="Foo('{{d.experience}}')" class="a" style="color: #003399">{{d.experience}}</a>
    </script>
    <script type="text/html" id="barDemo1">
        <a class="layui-btn layui-btn-primary layui-btn-xs" onclick="disable({{d.id}})">禁用</a>
        <a class="layui-btn layui-btn-xs" onclick="enable({{d.id}})">启用</a>
        <a class="layui-btn layui-btn-primary layui-btn-xs"  onclick="look_member_top({{d.id}})">查看上级会员</a>
        <a class="layui-btn layui-btn-xs"  onclick="look_member_bo({{d.id}})">查看下级会员</a>
    </script>
    <%--改变状态--%>
    <script type="text/html" id="statusTpl">
        {{# if(d.status =='0'){}}
        <span style="color:#FF0000; ">禁用</span>
        {{# }else if(d.status =='1'){ }}
        启用
        {{# } }}
    </script>
    <%-- 转时间 --%>
    <script id="create_timeTpl" type="text/html">
        {{#  if(d.registration_time !== ''){ }}
        <%--<span style="color: rgba(10,10,10,0.46);">{{ d.registration_time.substr(0,2) }}</span>--%>
        <span style="color: rgba(10,10,10,0.46);">20{{ d.registration_time.substr(0,2) }}-{{ d.registration_time.substr(2,2) }}-{{ d.registration_time.substr(4,2) }} {{ d.registration_time.substr(6,2) }}:{{ d.registration_time.substr(8,2) }}:{{ d.registration_time.substr(10,2) }}</span>
        {{#  } else { }}
        <span style="color: rgba(10,10,10,0.46);">---</span>
        {{#  } }}
    </script>
    <%--邀请码--%>
    <script type="text/html" id="Invitation_code">
        {{# if(d.phone ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.phone}}
        {{# } }}
    </script>
    <%--上级会员--%>
    <script type="text/html" id="sup_memberTpl">
        {{# if(d.sup_member_name ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.sup_member_name}}
        {{# } }}
    </script>
    <%-- 手机号--%>
    <script type="text/html" id="telPhoneTpl">
        {{# if(d.phone ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.phone}}
        {{# } }}
    </script>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 内容主体区域 -->
    <div class="layui-body">
        <!-- 会员等级查询-->
        <div class="main-top" style="height: 122px;margin:0px">
            <%-- <div class="layui-inline" style=" margin-top:10px;margin-left:10px;font-size:14px;">当前位置：分销系统>分销等级 >会员信息表</div>--%>
            <div class="layui-elem-quote" style="margin-top:10px;margin-left:15px;">
                会员信息表
            </div>
            <div class="layui-form-item" style=" margin-top:10px;margin-left:10px;"><img src="image/1.png" /></div>
            <div class="site-demo-button" id="layerDemo" style="margin-bottom: 0;  position: relative; left:490px;">
                <button data-method="offset" data-type="auto" class="layui-btn layui-btn-sm"><i class="layui-icon">&#xe61f;</i>添加会员等级</button>
            </div>
        </div>
        <!-- 中部表格 -->
        <div class="main-top" style="margin-top:25px;margin-left: 15px;">
            <table class="layui-table" lay-filter="test" style="width:610px;">
                <thead>
                <tr>
                    <th></th>
                    <th>会员等级</th>
                    <th>人数</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td >1</td>
                    <td >会员</td>
                    <td ><span id="Selectpending"></span></td>
                    <td ><a hre  f="javascript:void(0)" onclick="aClick()" style="color:blue">查看</a></td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>非会员</td>
                    <td><span id="Selectpending2"></span></td>
                    <td ><a href="javascript:void(0)" style="color:blue" data-method="offset" id="layerDemo" onclick="aClick2()" >查看</a></td>
                </tr>
                </tbody>
            </table>
        </div>

        <%-- 数据分布图--%>
        <div class="layui-form-item" style=" margin-top:10px;margin-left:10px;"><img src="image/2.png" /></div>
        <div id="container" style="min-width: 310px; height: 400px; max-width: 600px;margin-left:150px;"></div>

        <%-- 会员信息表--%>
        <div class="layui-form-item" style=" margin-top:10px;margin-left:10px;"><img src="image/3.png" /></div>
        <div class="bb">
            <form class="layui-form">
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-block">
                        <select name="status" id="status">
                            <option value=""></option>
                            <option value="0">禁用</option>
                            <option value="1">启用</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">名称/手机号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="phone" id="phone" placeholder="请输入名称和手机号" autocomplete="off"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <div class="layui-input-block">
                        <button class="layui-btn layui-btn-sm"  style="margin-top:10px" id="searchBtn"><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button class="layui-btn layui-btn-sm" style="margin-top:10px " type="reset"><i class="layui-icon">&#x2746;</i>重置</button>
                    </div>
                </div>
                <%--搜索查询信息显示--%>
                <table class="layui-hide" id="getMemberList"></table>
            </form>
        </div>
        <%--查看上级会员信息--%>
        <div id="look_member_top_select" style="margin-top:0;display: none;">
            <table class="layui-hide" id="look_member_t"></table>
        </div>
        <%--查看下级会员信息--%>
        <div id="look_member_bo_select" style="display: none;">
            <form class="layui-form" action="">
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-block">
                        <select name="city" lay-verify="required">
                            <option value=""></option>
                            <option value="0">禁用</option>
                            <option value="1">启用</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">名称/手机号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="nick_name" id="nick_name"  placeholder="请输入名称和手机号" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <div class="layui-input-block">
                        <button class="layui-btn layui-btn-sm"  style=" margin-top:10px;margin-left:10px;" onclick="search1()"><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button type="reset" class="layui-btn layui-btn-sm" style=" margin-top:10px;margin-left:10px;"><i class="layui-icon">&#x2746;</i>重置</button>
                    </div>
                </div>
                <%--搜索查询信息显示--%>
                <table class="layui-hide" id="selectMemberDown1"></table>
            </form>
            <%--   <script>
                   //Demo
                   layui.use('form', function(){
                       var form = layui.form;
                       //监听提交
                       form.on('submit(formDemo)', function(data){
                           layer.msg(JSON.stringify(data.field));
                           return false;
                       });
                   });
               </script>--%>
        </div>
    </div>

    <%--点击查看按钮弹出对话框--%>
    <div id="dialog" style="display: none;">
        <div class="layui-inline" style=" margin-top:10px;margin-left:10px;font-size:14px;">当前位置：分销系统>分销等级 >会员信息表</div>
        <%--查询的表单--%>

        <form class="layui-form">

            <div class="layui-inline">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-block">
                    <select name="city" lay-verify="required">
                        <option value=""></option>
                        <option value="0">启用</option>
                        <option value="1">禁用</option>
                    </select>
                </div>
            </div>


            <div class="layui-inline">
                <label class="layui-form-label">名称/手机</label>
                <div class="layui-inline">
                    <div class="layui-input-inline">
                        <input type="text" name="date" id="date" lay-verify="date" placeholder="请输入名称和手机号" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <div class="layui-input-block">
                        <button class="layui-btn layui-btn-sm" id="search" onclick="search()" style="margin-top:10px" ><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button class="layui-btn layui-btn-sm" style="margin-top:10px " type="reset"><i class="layui-icon">&#x2746;</i>重置</button>
                    </div>
                </div>
            </div>
            <%--搜索查询信息显示--%>
            <table class="layui-hide" id="search1"></table>
        </form>

    </div>

    <%--点击查看按钮弹出对话框--%>
    <div id="dialog2" style="display: none;">
        <div class="layui-inline" style=" margin-top:10px;margin-left:10px;font-size:14px;">当前位置：分销系统>分销等级 >会员信息表</div>
        <%--查询的表单--%>
        <div class="">
            <form class="layui-form">

                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-block">
                        <select name="city" lay-verify="required">
                            <option value=""></option>
                            <option value="0">启用</option>
                            <option value="1">禁用</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">手机/手机号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="date" id="date" lay-verify="date" placeholder="请输入名称和手机号" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <div class="layui-input-block">
                        <button class="layui-btn layui-btn-sm " id="search" onclick="searchForm()" style="margin-top:10px" ><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button class="layui-btn layui-btn-sm" style="margin-top:10px " type="reset"><i class="layui-icon">&#x2746;</i>重置</button>
                    </div>
                </div>
                <%--搜索查询信息显示--%>
                <table class="layui-hide" id="search2"></table>
            </form>
        </div>
    </div>
    <%@ include file="/common/footer.jsp"%>
</div>

</body>
</html>