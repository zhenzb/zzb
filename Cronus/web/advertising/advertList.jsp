<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../common/header.jsp"%>
<%@include file="advertising_memu.jsp"%>


<%
//    String id = request.getParameter("id");
    String adverts_id = request.getParameter("adverts_id");
//    String page_location = request.getParameter("page_location");
//    String position = request.getParameter("position");
%>

<script>

    <%--var pid = <%=id%>;--%>
    <%--var advert_id = <%=adverts_id%>;--%>
    <%--var page_location = <%=page_location%>;--%>
    <%--var position = <%=position%>;--%>

    //JavaScript代码区域
    layui.use(['element','laydate','table'], function(){
        var element = layui.element;
        var laydate = layui.laydate;
        var table = layui.table;
        laydate.render({
            elem: '#start_time'
            ,type: 'datetime'
        });
        laydate.render({
            elem: '#end_time'
            ,type: 'datetime'
        });
        var advert_id = <%=adverts_id%>;
        table.render({
            elem: '#test'
            ,url:'${pageContext.request.contextPath}/advertising?method=getAdvertList&advert_id'+ advert_id
            //,width: 1900
            ,height: 580
            ,cols: [[
                {type:'checkbox', fixed: 'left'}
                ,{field:'id', width:60, title: 'ID',  fixed: 'left'}
                ,{field:'advert_id', width:150, title: '广告编号',align:'center',fixed: 'left'}
                ,{field:'advert_name', width:150, title: '广告名称',align:'center',fixed: 'left'}
                ,{field:'status', width:150, title: '状态',align:'center',fixed: 'left',templet: '#StatusAdvertising'}

//                ,{field:'advertlink_name', width:150, title: '广告位链接名称',align:'center',fixed: 'left'}
//                ,{field:'page_location', width:150, title: '所属页面',align:'center',fixed: 'left'}
                ,{field:'position', width:150, title: '广告位名称',align:'center',fixed: 'left'}
                ,{field:'add_time', width:180, title: '添加时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.add_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.add_time.substr(0, 2) + "-" + d.add_time.substr(2, 2) + "-" + d.add_time.substr(4, 2) + " " + d.add_time.substr(6, 2) + ":" + d.add_time.substr(8, 2) + ":" + d.add_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'start_time', width:180, title: '有效开始时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.start_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.start_time.substr(0, 2) + "-" + d.start_time.substr(2, 2) + "-" + d.start_time.substr(4, 2) + " " + d.start_time.substr(6, 2) + ":" + d.start_time.substr(8, 2) + ":" + d.start_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'end_time', width:180, title: '有效结束时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.end_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.end_time.substr(0, 2) + "-" + d.end_time.substr(2, 2) + "-" + d.end_time.substr(4, 2) + " " + d.end_time.substr(6, 2) + ":" + d.end_time.substr(8, 2) + ":" + d.end_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'clicks', width:150, title: '点击数',align:'center'}
                ,{field:'size', width:150, title: '广告尺寸',align:'center'}
                ,{field:'playback_length', width:150, title: '播放时长',align:'center',templet:function (d) {
                    var index="";
                    if(d.playback_length==""){
                        index="----";
                    }else {
                        var index = d.playback_length+"s" ;
                    }
                    return index;
                }}
                ,{fixed:'right',title:'操作', width:250,align:'center', toolbar: "#barDemo"}
            ]]
            ,id: 'listTable'
            ,limit:20
            ,limits:[20,30,40,50,100]
            ,page: true
            ,response: {
                statusName: 'success'
                ,statusCode: 1
                ,msgName: 'errorMessage'
                ,countName: 'total'
                ,dataName: 'rs'
            }
        });

    });

    layui.use('laydate', function(){
        var laydate = layui.laydate;
        //时间选择器
        laydate.render({
            elem: '#price_min'
            ,type: 'datetime'
        });
        //时间选择器
        laydate.render({
            elem: '#price_max'
            ,type: 'datetime'
        });

    });

</script>

<%--广告状态--%>
<script type="text/html" id="StatusAdvertising">
    {{# if(d.status ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.status =='1'){}}
    启用
    {{# }else if(d.status =='2'){ }}
    停用
    {{# }else if(d.status =='3'){ }}
    排期中
    {{# } }}
    {{# } }}
</script>

<!-- 内容主体区域 -->
<div class="layui-body">
    <!-- 上部分查询表单-->
    <div class="main-top" style="padding:5px 5px 0px 5px">

        <div class="layui-elem-quote">
            广告区域设置>>广告位列表>>广告列表
        </div>
        <form class="layui-form layui-form-pane" >

            <div style="background-color: #f2f2f2;padding:5px 0">

                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label">状态：</label>
                    <div class="layui-input-inline" >
                        <select id="status" name="status">
                            <option value="">全部</option>
                            <option value="1">启用</option>
                            <option value="2">停用</option>
                            <option value="3">排期中</option>
                        </select>
                    </div>


                    <label class="layui-form-label">有效时间</label>
                    <div class="layui-input-inline">
                        <input name="start_time" id="start_time" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>

                    <div class="layui-input-inline">
                        <input name="end_time" id="end_time" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" data-type="sreach" id="searchBtn"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px" data-type="reset" ><i class="layui-icon">&#x2746;</i>重置</button>

                </div>


            </div>

        </form>
        <!-- 表格显示-->
        <table class="layui-hide" id="test" lay-filter="positionList"></table>

    </div>
</div>

<%@ include file="/common/footer.jsp"%>