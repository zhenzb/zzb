<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common/header.jsp" %>
<%@include file="/recommen/menu_recommen.jsp" %>

<script>
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    layui.use(['laydate', 'upload', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate //日期
            , layer = layui.layer //弹层
            , table = layui.table //表格
            , upload = layui.upload
            , element = layui.element; //元素操作
        var form = layui.form;

        //日期时间选择器
        laydate.render({
            elem: '#start_usefultime'
            , type: 'datetime'
        });
        //日期时间选择器
        laydate.render({
            elem: '#end_usefultime'
            , type: 'datetime'
        });

        //列表加载
        table.render({
            elem: '#columnList'
            , url: '${ctx}/recommen?method=getColumnList'
            , limit: 100
            , limits: [50, 100, 500, 1000]
            , height: 690
            , cols: [[
                 {field: 'cposition', width: 120, title: '栏目位置', align: 'center'}
                , {
                    field: 'cstatus', width: 120, title: '栏目状态', align: 'center', templet: function (d) {
                        switch (d.cstatus) {
                            case "1":
                                return "<font color='red'>正常</font>";
                            case "0":
                                return "禁用";
                            default:
                                return "状态未表明";
                        }
                    }
                }
                , {
                    field: 'cname', width: 150, title: '栏目名称', align: 'center', templet: function (d) {
                        return d.cname;
                    }
                }
                , {
                    field: 'cpicture', width: 150, title: '栏目图片', align: 'center', templet: function (d) {
                        return d.cpicture;
                    }
                }
                , {field: 'shape_size', width: 100, title: '图片尺寸', align: 'center'}
                , {
                    field: 'column_lid', width: 150, title: '栏目外链接', align: 'center', templet: function (d) {
                        if (d.column_lid == "") {
                            return "无连接"
                        } else {
                            return d.column_lid;
                        }
                    }
                }
                , {
                    field: 'cproduct_link_flag', width: 150, title: '商品链接', align: 'center', templet: function (d) {
                        if (d.cproduct_link_flag == "1") {
                            return "开"
                        } else {
                            return "关";
                        }
                    }
                }
                , {field: 'column_limits_products', width: 200, title: '栏目商品数量', align: 'center' ,templet:function (d) {
                        return d.columnProductSum+"/"+d.column_limits_products;
                    }}
                , {
                    field: 'start_usefultime', width: 170, title: '投放开始时间', align: 'center', templet: function (d) {
                        var index = "";
                        if (d.start_usefultime == "") {
                            index = "----";
                        } else {
                            index = "20" + d.start_usefultime.substr(0, 2) + "-" + d.start_usefultime.substr(2, 2) + "-" + d.start_usefultime.substr(4, 2) + " " + d.start_usefultime.substr(6, 2) + ":" + d.start_usefultime.substr(8, 2) + ":" + d.start_usefultime.substr(10, 2);
                        }
                        return index;
                    }
                }
                , {
                    field: 'end_usefultime', width: 170, title: '投放结束时间', align: 'center', templet: function (d) {
                        var index = "";
                        if (d.end_usefultime == "999999999999") {
                            index = "投放截止时间未设置";
                        } else {
                            index = "20" + d.end_usefultime.substr(0, 2) + "-" + d.end_usefultime.substr(2, 2) + "-" + d.end_usefultime.substr(4, 2) + " " + d.end_usefultime.substr(6, 2) + ":" + d.end_usefultime.substr(8, 2) + ":" + d.end_usefultime.substr(10, 2);
                        }
                        return index;
                    }
                }
                , {
                    field: 'last_usefultime', width: 170, title: '投放剩余时间', align: 'center', templet: function (d) {
                        var index = "";
                        if (d.last_usefultime == "") {
                            index = "----";
                        } else {
                            index = "20" + d.last_usefultime.substr(0, 2) + "-" + d.last_usefultime.substr(2, 2) + "-" + d.last_usefultime.substr(4, 2) + " " + d.last_usefultime.substr(6, 2) + ":" + d.last_usefultime.substr(8, 2) + ":" + d.last_usefultime.substr(10, 2);
                        }
                        return index;
                    }
                }
                , {field: 'column_useful_area', width: 100, title: '投放地区', align: 'center'}
                , {field: 'clicks', width: 100, title: '点击量', align: 'center',templet:function (d) {
                        return d.clicks + "次";
                    }}
                , {field: 'successful_pay', width: 250, title: '成功支付订单量', align: 'center'  }
                , {field: 'turnVolume', width: 100, title: '成交额', align: 'center'}
                , {field: 'edit_user', width: 100, title: '操作人', align: 'center'}

                , {fixed: 'right', title: '操作', width: 200, align: 'center', toolbar: "#recommenColumnStatusManage"}
            ]]
            , page: true//关闭自动分页
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , id: 'ColumnListInfoReload'
        });


        table.on('checkbox(columnListFilter)', function (obj) {

        });
        table.on('tool(columnListFilter)', function (obj) {
            if (obj.event === 'recommenColumnStatus') {
                var columnStatus = obj.data.cstatus;
                if (columnStatus == 1){
                    // 说明此栏目开启中 询问是否关闭
                    layer.msg('确定要关闭该栏目吗?', {
                        skin: 'layui-layer-molv' //样式类名  自定义样式
                        ,closeBtn: 1    // 是否显示关闭按钮
                        ,anim: 1 //动画类型
                        ,btn: ['确定','取消'] //按钮
                        ,icon: 5    // icon
                        ,yes:function(){
                            console.log();
                            obj.update({
                                cid:obj.data.cid
                            });

                            setTimeout(sendMsg(obj,obj.data.cid,0),60000);//60秒内不可以重复点击，一秒等于1000毫秒
                         //   table.reload("columnList");

                        }
                        ,btn2:function(){
                            layer.closeAll();
                        }});

                }
                else{
                    // 说明栏目是关闭状态 准备开启
                    layer.msg('确定要开启该栏目吗?', {
                        skin: 'layui-layer-molv' //样式类名  自定义样式
                        ,closeBtn: 1    // 是否显示关闭按钮
                        ,anim: 1 //动画类型
                        ,btn: ['确定','取消'] //按钮
                        ,icon: 6    // icon
                        ,yes:function(){
                            setTimeout(sendMsg(obj,obj.data.cid,1),60000);//60秒内不可以重复点击，一秒等于1000毫秒
                        //    table.reload("columnList");
                        }
                        ,btn2:function(){
                            layer.closeAll();
                        }});
                }

            }
        });
        function sendMsg(obj,cid,cstatus) {

            $.ajax({
                type: "get",
                url: "${ctx}/recommen?method=updateColumnStatus",
                data: {"cid":cid,"cstatus":cstatus},   //status=2 移入回收站
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg('栏目状态变更成功!', {time: 2000}, function () {
                            //do something
                            console.log("  successful columnList   ");
                            table.reload("columnList");
                            window.location.href =  "${ctx}/recommen/column_lists.jsp";

                        });
                    } else {
                        layer.msg("  变更状态失败  ");
                    }
                },
                error: function () {
                    layer.msg("  请求错误  ");
                }
            // data:{"uvid":data.id,"memthodname":"edituv","aid":data.aid,"uv":value},

            });


           // table.reload("columnList");

        }
        
        var $ = layui.$, active = {
            Assignment_Task_Btu: function () {
                $("#dep_name").find("option").remove();
                $("#user_name").val("");
                var checkStatus = table.checkStatus('ColumnListInfoReload');
                var data = checkStatus.data;
                var selectCount = data.length;
                if (selectCount == 0) {
                    layer.msg("请选择一条数据！");
                    return false;
                }
                ;
                var ids = new Array(selectCount);
                //var nick_name=new Array(selectCount);
                var assign_user = new Array(selectCount);
                var status = new Map();
                for (var i = 0; i < selectCount; i++) {
                    ids[i] = checkStatus.data[i].id;
                    //nick_name[i]=checkStatus.data[i].nick_name;
                    assign_user[i] = checkStatus.data[i].assign_user;
                    status.set(checkStatus.data[i].order_no, checkStatus.data[i].status);
                }
                ;
                /*for(var obj in nick_name){
                    if(nick_name[obj]!=""){
                        layer.msg("请选择未指派订单！");
                        return false;
                    }
                };*/
                for (var obj in assign_user) {
                    if (assign_user[obj] != "") {
                        layer.msg("请选择未指派订单！");
                        return false;
                    }
                }
                ;
                status.forEach(function (value, key, map) {
                    if (value == "101") {
                        layer.msg("订单号：" + key + "为待支付状态不能指派");
                        return false;
                    } else if (value == "106") {
                        layer.msg("订单号：" + key + "为待提收状态不能指派");
                        return false;
                    } else if (value == "107") {
                        layer.msg("订单号：" + key + "为已提收状态不能指派");
                        return false;
                    } else if (value == "108") {
                        layer.msg("订单号：" + key + "为已完成状态不能指派");
                        return false;
                    } else if (value == "109") {
                        layer.msg("订单号：" + key + "为失效订单状态不能指派");
                        return false;
                    } else if (value == "110") {
                        layer.msg("订单号：" + key + "为已提收状态不能指派");
                        return false;
                    } else if (value == "111") {
                        layer.msg("订单号：" + key + "为已取消（申请退款）状态不能指派");
                        return false;
                    } else if (value == "112") {
                        layer.msg("订单号：" + key + "为异常订单状态不能指派");
                        return false;
                    } else if (value == "113") {
                        layer.msg("订单号：" + key + "为已取消（售后取消）状态不能指派");
                        return false;
                    } else {
                        openAssignment_Task();
                    }

                });


            }
        };

        function openAssignment_Task() {
            layer.open({
                type: 1
                , title: ['分配任务—员工列表', 'font-size: 20px']
                , offset: 'auto'
                , id: 'Assignment_Task_Manage'
                , area: ['800px', '500px']
                , content: $('#Assignment_Task_Div')
                //,btn: '关闭'
                , shade: 0 //不显示遮罩
                , btnAlign: 'c' //按钮居中
                , yes: function () {
                    layer.closeAll();
                }
                , success: function () {
                    <%--var url="";--%>
                    <%--if($('#dep_name').val()!=null || $('#user_name').val() !=""){--%>
                    <%--alert(1111)--%>
                    <%--url="${ctx}/taskManage?method=getPurchaserList";--%>
                    <%--}--%>
                    table.render({
                        elem: '#PurchaserList'
                        , url: '${ctx}/taskManage?method=getPurchaserList'
                        , height: 300
                        , cols: [[
                            {type: 'numbers', fixed: 'true', align: 'center'}
                            , {type: 'checkbox', fixed: 'left'}
                            , {field: 'nick_name', width: 400, title: '代购人姓名', align: 'center', fixed: 'left'}
                            // ,{field:'department_name', width:150, title: '本月已完成代购订单数量',align:'center',fixed: 'left'}
                            // ,{field:'phone', width:150, title: '本周已完成代购订单数量',align:'center'}
                            // ,{field:'created_date', width:150, title: '未完成代购订单数量',align:'center'}
                            , {fixed: 'right', title: '操作', width: 207, align: 'center', toolbar: "#PurchaserManage"}
                        ]]
                        , page: true//关闭自动分页
                        , limit: 50 //每页显示的条数
                        , limits: [50, 100]
                        , response: {
                            statusName: 'success' //数据状态的字段名称，默认：code
                            , statusCode: 1  //成功的状态码，默认：0
                            , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                            , countName: 'total' //数据总数的字段名称，默认：count
                            , dataName: 'rs' //数据列表的字段名称，默认：data
                        }
                        , id: 'PurchaserListInfoReload'
                    });

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/department",
                        data: "method=getDepartmentInfoToSel",
                        dataType: "json",
                        success: function (data) {
                            var array = data.rs;
                            if (array.length > 0) {
                                for (var obj in array) {
                                    $("#dep_name").append("<option value='" + array[obj].id + "'>" + array[obj].department_name + "</option>");
                                }
                            }
                        },
                        error: function () {
                            layer.alert("错误");
                        }
                    });

                }
            });
        }


        $("#sreach").on('click', function () {
            table.reload('ColumnListInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    cname: $('#cname').val(),
                    cstatus: $('#cstatus').val(),
                    sales: $('#sales').val(),
                    start_usefultime: $('#start_usefultime').val(),
                    end_usefultime: $('#end_usefultime').val(),
                    // price_min: $('#price_min').val(),
                    // price_max: $('#price_max').val(),
                    // order_source: $('#order_source').val(),
                    // order_Type: $('#order_Type').val(),
                    // status: $('#status').val(),
                    // sku_name: $('#sku_name').val(),
                    // spuCode: $('#spu_code').val()
                }
            });
            return false;
        });

        $("#PurchaserReset").on('click', function () {
            $('#cname').val("");
            $('#transaction_no').val("");
            $('#sales').val("");
            $('#start_usefultime').val("");
            $("#end_usefultime").empty();
            // $("#purchasingOrder_source").text("");
            // $('#price_min').val("");
            // $('#price_max').val("");
            // $("#order_Type").text("");
            // $("#order_Type").empty();
            // $("#order_source").empty();
            // $("#order_source").text("");
            // $('#status').val("");
            //执行重载
            table.reload('ColumnListInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    cname: $('#cname').val(),
                    transaction_no: $('#transaction_no').val(),
                    sales: $('#sales').val(),
                    start_usefultime: $('#start_usefultime').val(),
                    end_usefultime: $('#end_usefultime').val(),
                    // price_min: $('#price_min').val(),
                    // price_max: $('#price_max').val(),
                    // order_source: $('#order_source').val(),
                    // order_Type: $('#order_Type').val(),
                    // status: $('#status').val(),
                    // sku_name: $('#sku_name').val(),
                    // spuCode: $('#spu_code').val()
                }
            });
            return false;
        });


        // $("#PurchaserSreach").on('click', function () {
        //     table.reload('PurchaserListInfoReload', {
        //         page: {
        //             curr: 1 //重新从第 1 页开始
        //         }
        //         , where: {
        //             dep_name: $('#dep_name').val(),
        //             user_name: $('#user_name').val()
        //         }
        //     });
        //     return false;
        // });

        // $("#PurchaserReset").on('click', function () {
        //     // $('#dep_name').val("");
        //     $('#user_name').val("");
        //     //执行重载
        //     table.reload('PurchaserListInfoReload', {
        //         page: {
        //             curr: 1 //重新从第 1 页开始
        //         }
        //         , where: {
        //             cname: $('#cname').val(),
        //             sales: $('#sales').val()
        //         }
        //     });
        //     return false;
        // });


        table.on('tool(PurchaserFilter)', function (obj) {
            if (obj.event === 'Appointed_Task') {
                var checkStatus = table.checkStatus('ColumnListInfoReload');
                var data = checkStatus.data;
                var selectCount = data.length;
                if (selectCount == 0) {
                    layer.msg("请选择一条数据！");
                    return false;
                }
                ;
                var ids = new Array(selectCount);
                for (var i = 0; i < selectCount; i++) {
                    ids[i] = checkStatus.data[i].id;
                }
                layer.confirm('确认指派吗？', function (index) {
                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/taskManage?method=appointedTask&id=" + obj.data.id + "&order_id=" + ids,
                        // data:{'id':obj.data.id,'order_id':ids} ,   //批量处理 status=2 移入回收站
                        dataType: "json",
                        success: function (data) {
                            if (data.success == 1) {
                                layer.closeAll();
                                table.reload("ColumnListInfoReload");
                                layer.msg("指派成功");
                            }
                            else {
                                layer.closeAll();
                                table.reload("ColumnListInfoReload");
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.closeAll();
                            table.reload("ColumnListInfoReload");
                            layer.alert("错误");
                        }
                    });
                });
            }
        });

        // $('.Assignment_Task_Div .layui-btn').on('click', function () {
        //     var type = $(this).data('type');
        //     active[type] ? active[type].call(this) : '';
        // });
        //日期时间选择器
        laydate.render({
            elem: '#price_min'
            , type: 'datetime'
        });
        //日期时间选择器
        laydate.render({
            elem: '#price_max'
            , type: 'datetime'
        });

        function onLoadData() {
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/taskManage",
              //  data: "method=getPurchasingTerraceInfo",
                dataType: "json",
                success: function (data) {

                    if (data.success) {
                        var array = data.result.rs;
                        if (array.length > 0) {
                            for (var obj in array) {
                                $("#purchasingOrder_source").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + " [" + array[obj].dict_data_value + "]" + "</option>");

                            }
                        }
                        //(注意：需要重新渲染)

                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });

            form.render('select');
            return false;
        };

       // onLoadData();
    });


</script>

<script id="create_timeTpl" type="text/html">

    {{#  if(d.create_time !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.create_time.substr(0,2) }}-{{ d.create_time.substr(2,2) }}-{{ d.create_time.substr(4,2) }} {{ d.create_time.substr(6,2) }}:{{ d.create_time.substr(8,2) }}:{{ d.create_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">---</span>
    {{#  } }}
</script>

<script type="text/html" id="goodsNameTpl">
    <a href="#" onclick="Foo('{{d.spu_name}}','{{d.id}}')" class="a" style="color: #003399">{{ d.spu_name }}</a>
</script>
    <script type="text/html" id="recommenColumnStatusManage">
        {{#  if(d.cstatus == 1){ }}
        <a  href ="javascript:return false;" onclick="return false;" style="cursor: default;">
            <i class="edit" style="opacity: 0.2">开启</i></a>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a   lay-event="recommenColumnStatus">禁用</a>
        {{#  } else if(d.cstatus == 0) { }}
        <a 	 lay-event="recommenColumnStatus">启动</a>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a  href ="javascript:return false;" onclick="return false;" style="cursor: default;">
            <i class="edit" style="opacity: 0.2">禁用</i></a>
        {{#  } else if(d.purchas_order_state == '') { }}
        <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo">去处理</a>


        <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" style="color: gray">去处理</a>
        {{#  } }}
    </script>
<script type="text/html" id="PurchaserManage">
    <button class="layui-btn layui-btn-xs" lay-event="Appointed_Task">指派任务</button>
</script>

<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">栏目列表</div>
        <form class="layui-form layui-form-pane">
            <div style="background-color: #f2f2f2;padding:5px 0">
                <div class="layui-form-item" style="margin-bottom:5px">
                    <label class="layui-form-label">栏目名称</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input class="layui-input" autocomplete="off" name="cname" id="cname">
                    </div>

                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <select id="cstatus" name="cstatus">
                            <option value=""></option>
                            <option value="1">正常</option>
                            <option value="0">停用</option>
                        </select>
                    </div>

                    <label class="layui-form-label">商品销售量</label>
                    <div class="layui-input-inline">
                        <select id="sales" name="sales">
                            <option value=""></option>
                            <option value="1">正序</option>
                            <option value="0">倒叙</option>
                        </select>
                    </div>

                    <label class="layui-form-label">投放时间</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input name="start_usefultime" id="start_usefultime" placeholder="开始日期" autocomplete="off"
                               class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline" style="width: 150px">
                        <input name="end_usefultime" id="end_usefultime" placeholder="结束日期" autocomplete="off"
                               class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-input-inline" style="width: 200px">
                        <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="sreach"><i
                                class="layui-icon">&#xe615;</i>搜索
                        </button>
                        <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="reset"><i class="layui-icon">&#x2746;</i>重置
                        </button>
                    </div>

                </div>

                <div class="layui-form-item" style="margin-bottom: 0">


                </div>
            </div>
        </form>


        <table class="layui-hide" id="columnList" lay-filter="columnListFilter"></table>
        <!-- 分配任务 -->
        <div id="Assignment_Task_Div" style="display: none;">
            <div style="padding: 15px;margin-left: 20px">
                <div class="layui-inline">
                    <label>部门</label>
                    <div class="layui-inline">
                        <select class="layui-select" style="width: 200px" autocomplete="off" name="dep_name"
                                id="dep_name">
                            <%--<option value="" >请选择</option>--%>
                        </select>
                    </div>
                </div>
                <div class="layui-inline" style="margin-left: 30px">
                    <label>姓名</label>
                    <div class="layui-inline">
                        <input class="layui-input" name="user_name" id="user_name">
                    </div>
                </div>
                <button class="layui-btn layui-btn-sm" style="margin-left: 10px" id="PurchaserSreach"><i
                        class="layui-icon">&#xe615;</i>搜索
                </button>
                <button class="layui-btn layui-btn-sm" id="PurchaserReset"><i class="layui-icon">&#x2746;</i>重置</button>
            </div>

            <div style="margin-left: 30px;width: 700px">
                <table class="layui-table" id="PurchaserList" lay-filter="PurchaserFilter"></table>
            </div>
        </div>
    </div>

</div>

<div class="layui-footer">
    <%@ include file="/common/footer.jsp" %>
</div>






