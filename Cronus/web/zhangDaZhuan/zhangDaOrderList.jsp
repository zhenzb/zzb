<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/common.jsp" %>
<%@ include file="/common/zhangdazhuan_menu.jsp" %>

<script>
    layui.use(['laydate', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate; //日期
        var table = layui.table;
        var element = layui.element;
        table.render({
            elem: '#orderList'
            , height: 710
            , url: '${ctx}/order?method=getzhangdzOrder'
            , cols: [[
                {type:'numbers',fixed: 'true',align:'center'}
                ,{type: 'checkbox', fixed: 'left', field: "id"}
                , {field: 'order_no', width: 300, title: '录入订单号',align:'center', templet: '#idTpl'}
                , {field: 'phone', width: 300, title: '注册手机号',align:'center',templet: '#phoneTpl'}
                , {field: 'create_date', width: 300, title: '用户下单时间',align:'center',templet: '#create_timeTpl'}
                , {field: 'remark', width: 500, title: '用户备注',align:'center',templet: '#remark'}
            ]]
            , id: 'testReload'
            , page: true
            , limit: 100
            , limits: [50,100, 500, 100]
            , response: {
                statusName: 'success'
                , statusCode: 1
                , msgName: 'errorMessage'
                , countName: 'total'
                , dataName: 'rs'
            },
        });
        $('.demoTable .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        //日期时间选择器
        laydate.render({
            elem: '#price_min'
            ,type: 'datetime'
        });
        //日期时间选择器
        laydate.render({
            elem: '#price_max'
            ,type: 'datetime'
        });
    });

    //提交
    function exportOrder() {
        var exportData = "";
        var order_no = $('#order_no').val();
        var phone = $('#phone').val();
        var price_min = $('#price_min').val();
        var price_max = $('#price_max').val();
        if(order_no!=""){
            exportData = "&order_no="+order_no
        }
        if(phone!=""){
            exportData = exportData+"&phone="+phone
        }
        if(price_min!=""){
            exportData =exportData+ "&price_min="+price_min
        }
        if(price_max!=""){
            exportData =exportData+ "&price_max="+price_max
        }
        var url = "${ctx}/createSimpleExcelToDisk?method=exportZhangDZOrderExcel";
        if(exportData != "")
            url =url+exportData;
        window.location.href= url;
    }

</script>
<script id="create_timeTpl" type="text/html">
    {{#  if(d.create_date !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.create_date.substr(0,2) }}-{{ d.create_date.substr(2,2) }}-{{ d.create_date.substr(4,2) }} {{ d.create_date.substr(6,2) }}:{{ d.create_date.substr(8,2) }}:{{ d.create_date.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;">----</span>
    {{#  } }}
</script>

<script type="text/html" id="phoneTpl">
    {{# if(d.phone ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    {{d.phone}}
    {{# } }}
</script>

<script>
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        //常规用法
        laydate.render({
            elem: '#submission_time'
        });
        //常规用法
        laydate.render({
            elem: '#created_date'
        });
    });

</script>
<script type="text/html" id="idTpl">
    <a href="#" onclick="Foo('{{d.order_no}}','{{d.id}}')" class="a" style="color: #003399">{{ d.order_no }}</a>
</script>
    <div class="layui-body">
        <div style="padding:5px 5px 0px 5px">
            <div class="layui-elem-quote">掌达赚订单管理</div>
            <form class="layui-form layui-form-pane">
                <div style="background-color: #f2f2f2;padding:5px 0">
                    <div class="layui-form-item" style="margin-bottom:5px">
                        <label class="layui-form-label">录入订单号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="order_no" id="order_no">
                        </div>

                        <label class="layui-form-label">手机号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="phone" id="phone">
                        </div>

                        <label class="layui-form-label" style="width: 150px">下单起止时间</label>

                        <div class="layui-input-inline" style="width: 150px" >
                            <input lay-verify="date" name="price_min" id="price_min" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                        </div>

                        <div class="layui-form-mid">-</div>
                        <div class="layui-input-inline" style="width: 150px" >
                            <input lay-verify="date" name="price_max" id="price_max" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                        </div>
                        <button id="searchBtn"  class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button  class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" type="reset"><i class="layui-icon">&#x2746;</i>重置</button>
                    </div>
                </div>
            </form>
            <div style="margin-top: 5px">
                <button id="exportSearch" onclick="exportOrder()" class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe67c;</i>导出</button>
            </div>
            <table class="layui-table" id="orderList" lay-filter="orderlist"></table>
        </div>
    </div>

    <%@ include file="/common/footer.jsp" %>