<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../common/header.jsp" %>
<%@include file="menu_finance.jsp" %>

<div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
        <div class="layui-row">
            <div class="layui-elem-quote" style="margin-top: 3px;background-color: #EEEEEE">
                <label>提现管理</label>
            </div>

            <form class="layui-form layui-form-pane">
                <div class="layui-elem-quote"
                     style="margin-top: 10px;background-color: #EEEEEE;margin-top: 10px;height: 30px">

                    <div class="layui-inline">
                        <label class="layui-form-label" style="width:100px;">用户名</label>
                        <div class="layui-input-inline">
                            <input type="text" id="name" autocomplete="off" class="layui-input" placeholder="请输入用户名">
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">手机号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="phone" autocomplete="off" class="layui-input" placeholder="请输入手机号">
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">处理状态</label>
                        <div class="layui-input-inline">
                            <select class="layui-select" id="status" autocomplete="off">
                                <option value="" selected="selected">全部</option>
                                <option value="1">已处理</option>
                                <option value="0">未处理</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">申请日期</label>
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="test5" placeholder="请输入开始时间">
                        </div>
                        <span style="line-height:40px;">~</span>
                    </div>

                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="test6" placeholder="请输入结束时间">
                        </div>
                    </div>


                        <button class="layui-btn layui-btn-sm" style="margin-left:10px;" id="searchBtn"><i
                                class="layui-icon">&#xe615;</i>搜索
                        </button>
                        <button type="reset" class="layui-btn layui-btn-sm"><i class="layui-icon">&#x2746;</i>重置</button>

                </div>

            </form>

            <table class="layui-table" id="withdrawalsList" lay-filter="withdrawals"></table>
        </div>
    </div>




<%@ include file="/common/footer.jsp" %>


<script type="text/html" id="barDemo">
    <button lay-event="agree"
            style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">
        同意
    </button>
    <button lay-event="refuse"
            style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">
        拒绝
    </button>
    <button lay-event="abolish"
            style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">
        作废
    </button>
    <button lay-event="detail"
            style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">
        详情
    </button>
</script>
<script>
    layui.use('table', function () {
        var table = layui.table;
        //列表加载
        table.render({
            elem: '#withdrawalsList'
            , url: '${ctx}/finance?method=Withdraw' //数据接口
            , cellMinWidth: 100 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            , page: true
            //,height: 650
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , cols: [[
                {type: 'numbers', fixed: 'true'}
                , {type: 'checkbox', fixed: 'true'}
                , {field: 'nick_name', title: '姓名', align: 'center', sort: true, fixed: true}
                , {field: 'phone', title: '手机号', sort: true, align: 'center', fixed: true}
                , {
                    field: 'rental', title: '可提现账户总金额(元)', align: 'center', width: '170', templet: function (d) {
                        var num = "";
                        if (Number(d.rental) == '') {
                            num = 0;
                        } else {
                            num = Number(d.rental);
                        }
                        return num;
                    }
                }
                , {
                    field: 'num', title: '当前预估总金额（元）', width: 170, templet: function (d) {
                        var num = Number(d.rental) + Number(d.commimoney);
                        return num;
                    }
                }
                , {field: 'time', title: '最后统计时间', align: 'center', width: '150'} //单元格内容水平居中
                , {
                    field: 'operation_time',
                    title: '申请时间',
                    sort: true,
                    align: 'center',
                    width: '150',
                    templet: '#create_date'
                } //单元格内容水平居中
                , {field: 'money', title: '申请提现金额(元)', sort: true, align: 'center', width: '130'}
                , {field: 'status', title: '处理状态', sort: true, align: 'center', templet: '#state'}
                , {field: 'order_id', title: '提现单号', align: 'center', sort: true, width: '150'}
                , {field: 'status', title: '提现状态', align: 'center', sort: true, templet: '#statu'}
                , {field: 'payment_way_key', title: '打款方式', align: 'center', sort: true, templet: '#payment_way_key'}
                , {field: 'reason', title: '决绝原因', align: 'center', sort: true, width: '150'}
                , {fixed: 'right', title: '操作', width: 250, align: 'center', toolbar: "#barDemo"}
            ]]
            , id: 'listTable'

        });

        var $ = layui.$, active = {};

        $('.demoTable .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        //点击按钮 搜索
        $('#searchBtn').on('click', function () {

            //执行重载
            table.reload('listTable', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    nick_name: $('#name').val(),
                    phone: $('#phone').val(),
                    test5: $('#test5').val(),
                    test6: $('#test6').val(),
                    status: $('#status').val(),
                }
            });
            return false;
        });
        //监听工具条
        table.on('tool(withdrawals)', function (obj) {
            var data = obj.data;
            if (obj.event === 'agree') {
                agree(data)
            } else if (obj.event === 'refuse') {
                refuse(data)
            } else if (obj.event === 'abolish') {
                layer.confirm('确认作废吗？', function (obj) {
                    abolish(data);

                });
            } else if (obj.event === 'detail') {
                detailInfo(data)
            }
        });

        function agree(obj) {
            layer.open({
                type: 1
                , title: '提现确认'
                , area: ['390px', '260px']
                , content: '<ul class=""  lay-filter="test">'
                + '<li class="layui-nav-item"><a>&nbsp;提现单号:' + obj.order_id + '</a></li>'
                + '<li class="layui-nav-item"><a>&nbsp;提现金额:' + obj.money + '</a></li>'
                + '<li class="layui-nav-item"><a>&nbsp;提现方式:' + obj.payment_way_key + '</a></li>'
                + '<li class="layui-nav-item"><hr class="layui-bg-gray"></li>'
                + '<li class="layui-nav-item"><a>确认后，提现金额将自动转入会员账户</a></li></ul>'
                , btn: '确认'
                , btnAlign: 'c' //按钮居中
                , shade: 0 //不显示遮罩
                , yes: function () {
                    var id = obj.id;
                    var order_id = obj.order_id;
                    $.ajax({
                        //几个参数需要注意一下
                        type: "post",//方法类型
                        dataType: "json",//预期服务器返回的数据类型
                        url: "${ctx}/finance?method=Agreerequest",//url
                        async: true,
                        data: {id: id, order_id: order_id},
                        success: function (res) {
                            var obj = JSON.parse(JSON.stringify(res));
                            if (obj.success == 1) {
                                alert("已通过");
                                layer.closeAll();
                            }
                        },
                        error: function () {
                            alert("未通过");
                            layer.closeAll();
                        },
                    });
                    return false;
                }
            });
        }

        function refuse(obj) {
            layer.open({
                type: 1
                , title: '拒绝提现确认'
                , area: ['390px', '260px']
                , content: '<ul class=""  lay-filter="test">'
                + '<li class="layui-nav-item"><a>&nbsp;提现单号:' + obj.order_id + '</a></li>'
                + '<li class="layui-nav-item"><a>&nbsp;提现金额:' + obj.money + '</a></li>'
                + '<li class="layui-nav-item"><a>&nbsp;提现方式:' + obj.payment + '</a></li>'
                + '<li class="layui-nav-item"><hr class="layui-bg-gray"></li>'
                + '<li class="layui-nav-item"><a>备注:</a><textarea id="reason"></textarea></li>'
                + '</ul>'
                , btn: '确认'
                , btnAlign: 'c' //按钮居中
                , titAlign: 'c'
                , shade: 0 //不显示遮罩
                , yes: function () {
                    var id = obj.id;
                    var order_no = obj.order_id;
                    var reason = $('#reason').val();

                    $.ajax({
                        //几个参数需要注意一下
                        type: "post",//方法类型
                        dataType: "json",//预期服务器返回的数据类型
                        url: "${ctx}/finance?method=Rejectrequest",//url
                        async: true,
                        data: {id: obj.id, reason: reason},
                        success: function (res) {
                            var obj = JSON.parse(JSON.stringify(res));
                            if (obj.success == 1) {
                                alert("已拒绝");
                                layer.closeAll();
                            }
                        },
                        error: function () {
                            alert("拒绝失败");
                            layer.closeAll();
                        },
                    });


                }
            });
        }

        function abolish(obj) {
            alert(obj.id);
            var id = obj.id;
            $.ajax({
                //几个参数需要注意一下
                type: "post",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${ctx}/finance?method=abolishquest",//url
                async: true,
                data: {id: id},
                success: function (res) {
                    var obj = JSON.parse(JSON.stringify(res));
                    if (obj.success == 1) {
                        alert("已作废");
                        layer.closeAll();
                    }
                },
                error: function () {
                    alert("作废失败");
                    layer.closeAll();
                },
            });
            return false;


        }

        function detailInfo(obj) {
            if (obj.order_id != "") {
                window.location.href = 'withdrawalsDetailInfo.jsp?user_id=' + obj.user_id + '&id=' + obj.id + '&order_id=' + obj.order_id;
            } else {
                window.location.href = 'withdrawalsDetailInfo.jsp?user_id=' + obj.user_id + '&id=' + obj.id;
            }

        }


    });
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        //常规用法
        laydate.render({
            elem: '#price_min'
        });
        laydate.render({
            elem: '#price_max'
        });
    });

    layui.use('element', function () {
        var element = layui.element;
    });

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
<script>
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        //时间选择器
        laydate.render({
            elem: '#test5'
            , type: 'datetime'
        });
        //时间选择器
        laydate.render({
            elem: '#test6'
            , type: 'datetime'
        });
    })
</script>
<script type="text/html" id="statu">
    {{# if(d.status=='1'){}}
    <span style="color:#FF0000; ">已提现</span>

    {{# }else if(d.status=='2'){ }}
    <span style="color:green; ">已拒绝</span>

    {{# }else if(d.status=='0'){ }}
    <span style="color:green; ">未处理</span>
    {{# } }}
</script>

<script type="text/html" id="state">
    {{# if(d.status=='0'){}}
    <span style="color:#FF0000; ">未处理</span>

    {{# }else if(d.status!='0'){ }}
    <span style="color:green; ">已处理</span>
    {{# } }}
</script>

<script type="text/html" id="payment_way_key">
    {{# if(d.order_id==''){}}
    <span style="color:#FF0000; ">提现到银行卡或微信</span>

    {{# }else if(d.order_id!=''){ }}
    <span style="color:green; ">提现到账户</span>
    {{# } }}
</script>