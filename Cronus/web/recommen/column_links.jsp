<%@ page import="common.PropertiesConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="menu_task.jsp" %>


<%--<script type="text/javascript" src="${ctx}/layui/layui.js?t=1515376178738"></script>--%>
<%
    String order_id = request.getParameter("order_id");
    String pur_id = request.getParameter("pur_id");
    if(pur_id==""){
        pur_id =null;
    }
    String url=request.getRequestURI();
    String imgUrlPrefix = PropertiesConf.IMG_URL_PREFIX;
    System.out.println(imgUrlPrefix);
%>

<script>
    var imgUrlPrefix="<%=imgUrlPrefix%>";
    $(document).ready(function () {

        $.ajax({
            type: "get",
            contentType : "application/json",
            url : "${ctx}/taskManage?method=getSkipTasksDetailInfo",
            data:{'order_id':<%=order_id%>,'pur_id':<%=pur_id%>},
            cache: false,
            async: true,
            dataType: "json",
            success : function(data){
                var array=data.rs;
                for (var obj in array){
                    $("#purchas_order_state").val(array[obj].purchas_order_state);
                    if(array[obj].order_error == '1'){
                        var form = layui.form;
                        $("#order_error_Meaker_Div").show();
                        $("#order_error").attr('checked',true);
                        $("#order_error_marker").text(array[obj].order_error_marker);
                        form.render('checkbox');
                        $("#order_error_hide").attr('value',1);
                    }
                    $("#Consignee").val(array[obj].consignee);
                    $("#Consignee_phone").val(array[obj].consignee_tel);
                    $("#Consignee_site").val(array[obj].delivery_address);
                    if(array[obj].data_source=="miniWetCat"){
                        $("#order_source").val("小程序");
                    }else{
                        $("#order_source").val("APP");
                    }
                    $("#order_no").val(array[obj].order_no);
                    if(array[obj].created_date!=undefined){
                        $("#pre_order_date").val("20"+array[obj].created_date.substring(0,2)+"-"+array[obj].created_date.substring(2,4)+"-"+array[obj].created_date.substring(4,6)+" "+array[obj].created_date.substring(6,8)+":"+array[obj].created_date.substring(6,8)+":"+array[obj].created_date.substring(8,10));
                    }
                    $("#goods_name").val(array[obj].spu_name+array[obj].sku_name);
                    if (array[obj].goods_url){
                        //document.getElementById("goods_url_copy").style.display = 'block';
                        $("#goods_url_copy").show();
                        $("#goods_url").val(array[obj].goods_url);
                        // $("#goods_url").css('display','none');
                    }/*else{
                        $("#goods_url").val(array[obj].goods_url);
                    }*/

                    switch (array[obj].status){
                        case "101":
                            $("#order_status").val("待支付");
                            break;
                        case "103":
                            $("#order_status").val("待备货");
                            break;
                        case "104":
                            $("#order_status").val("待发货");
                            break;
                        case "106":
                            $("#order_status").val("待提收");
                            break;
                        case "107":
                            $("#order_status").val("已提收");
                            break;
                        case "108":
                            $("#order_status").val("已完成");
                            break;
                        case "109":
                            $("#order_status").val("失效订单");
                            break;
                        case "110":
                            $("#order_status").val("已取消（待支付）");
                            break;
                        case "111":
                            $("#order_status").val("已取消（申请退款）");
                            break;
                        case "112":
                            $("#order_status").val("异常订单");
                            break;
                        case "113":
                            $("#order_status").val("已取消（售后取消）");
                            break;
                    }
                    var image_path=new Array();
                    var http_path=new Array();
                    if(array[obj].http_path ==""){
                        image_path=array[obj].image_path.split(",");
                        for(var i=0;i<image_path.length;i++){
                            $('#goods_img').append('<img src="'+ imgUrlPrefix+image_path[i] +'"  class="layui-upload-img" style="height: 200px;width: 200px;margin-left: 30px">')
                        }
                    }else {
                        http_path = array[obj].http_path.split(",");
                        for (var j = 0; j < http_path.length; j++) {
                            $('#goods_img').append('<img src="' + http_path[j] + '"  class="layui-upload-img" style="height: 200px;width: 200px;margin-left: 30px">')
                        }
                    }
                    $("#total_price").val("￥ "+(array[obj].total_price*0.01).toFixed(2));
                    $("#buy_num").val(array[obj].sku_num);
                    $("#sku_no").val(array[obj].frist_attribute_value+" "+array[obj].second_attribute_value);
                    $("#original_price").val("￥ "+(array[obj].original_price*0.01).toFixed(2));
                    $("#order_remark").val(array[obj].remark);
                    if(array[obj].purchas_platform!=""){
                        $("#purchasing_terrace").val(array[obj].purchas_platform);
                    }
                    // if(array[obj].purchase_price!=0 && array[obj].purchase_price!=""){
                    //     $("#purchase_price").val(array[obj].purchase_price*0.01);
                    // }
                    // alert(1.35.toFixed(2));
                    if(array[obj].pay!=0 && array[obj].pay!=""){
                        $("#actual_payment_money").val((array[obj].pay*0.01).toFixed(2));
                    }
                    $("#purchas_order_id").val(array[obj].pur_order_id);
                    $("#purchase_number").val(array[obj].purchase_number);
                    $("#purchasing_freight").val(array[obj].purchase_freight);
                    $("#purchase_order_no").val(array[obj].purchas_order_no);
                    $("#waybill_no").val(array[obj].waybill_no);
                    $("#express_company").val(array[obj].express_company);
                    $("#purchasing_terrace_no").val(array[obj].purchasing_terrace_no);
                    $("#order_error_marker").val(array[obj].logistics_companies);
                    $("#substituter").val(array[obj].substituter);
                    if(array[obj].status=="112"){
                        var form = layui.form;
                        $("#order_error_Meaker_Div").show();
                        $("#order_error").attr('checked',true);
                        $("#order_error_marker").text(array[obj].order_error_marker);
                        form.render('checkbox');
                        $("#order_error_hide").attr('value',1);
                    }

                }
            }
        });
    });
    var clickTag =0;
    function  saveSkipTasksDetailInfo() {
        if(clickTag == 1){
            alert("请勿频繁点击！");
            return;
        }
        clickTag=1;
        $.ajax({
            type: "get",
            contentType : "application/json",
            url : "${ctx}/taskManage?method=saveSkipTasksDetailInfo",
            data:{'order_id':<%=order_id%>,'jsonObj':JSON.stringify($('form').serializeObject())},
            cache: false,
            async: true,
            dataType: "json",
            success : function(data){
                if(data.success) {
                    clickTag = 0;
                    alert("操作成功");
                    // history.go(-1);
                    window.location.href="skipTasksInfo.jsp"
                }
            },
            error:function (error) {
                clickTag = 0;
                if(error.responseText!=""){
                    alert(error.responseText)
                }
            }
        });
    }


    function Consignee_Copy() {
        var e=document.getElementById("Consignee");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy","true",null); //执行浏览器复制命令
        alert("复制成功");
        return false;
    }
    function Consignee_phone_Copy() {
        var e=document.getElementById("Consignee_phone");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy"); //执行浏览器复制命令
        alert("复制成功");
        return false;
    }
    function Consignee_site_Copy() {
        // window.clipboardData.setData("text","")
        var e=document.getElementById("Consignee_site");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy"); //执行浏览器复制命令
        alert("复制成功");
        return false;
    }

    function goods_name_Copy() {
        var e=document.getElementById("goods_name");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy"); //执行浏览器复制命令
        alert("复制成功");
        return false;
    }

    function goods_url_Copy() {
        //var goods_url =  $('#goods_url').html();
        var goods_url = document.getElementById("goods_url");
        if(goods_url == ''){
            document.execCommand("Clear"); //执行浏览器复制命令
            alert("该商品链接地址为空");
            return false;
        }
        var e=document.getElementById("goods_url");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy"); //执行浏览器复制命令
        //alert("复制成功");
        window.open($('#goods_url').val(),'target','');
        return false;
    }
    layui.use(['form'],function () {
        var form = layui.form;

        form.on('checkbox(order_errorFilter)', function(obj){
            if(this.name == 'order_error' && obj.elem.checked==false){
                $("#order_error_Meaker_Div").hide();
                $("#order_error_hide").attr('value',0);

            }else if(this.name == 'order_error' && obj.elem.checked==true){
                $("#order_error_Meaker_Div").show();
                $("#order_error_hide").attr('value',1);
            }
            form.render('checkbox');
        });
    });
</script>



<!-- 内容主体区域 -->
<div class="layui-body" style="padding: 15px">
    <blockquote class="layui-elem-quote">订单处理详情
        <button class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" style="margin-left: 70%" onclick="history.go(-1)">返回</button>
    </blockquote>
    <form  class="layui-form">
        <input  id="purchas_order_state" name="purchas_order_state" autocomplete="off" class="layui-input" type="hidden" >
        <input  id="order_error_value" name="order_error_value" autocomplete="off" class="layui-input" type="hidden" >
        <input  id="purchas_order_id" name="purchas_order_id" autocomplete="off" class="layui-input" type="hidden">
        <h3>收货人信息 : </h3>
        <hr class="layui-bg-blue">
        <div id="mainId">
            <br>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px;width: 200px">
                    <label style="width: 100px;height: 10px">收&nbsp;&nbsp;&nbsp;货&nbsp;&nbsp;&nbsp;人 :</label>&nbsp;&nbsp;
                    <button class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" onClick="return Consignee_Copy()">复制</button>&nbsp;&nbsp;
                    <input style="border:none;width: 200px" readonly="readonly" id="Consignee"/>
                </label>

                <label class="layui-label" style="margin-left: 500px;width: 350px">
                    <label style="width: 100px;height: 10px">收货人手机号 : </label>&nbsp;&nbsp;
                    <button class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" onClick="return Consignee_phone_Copy()">复制</button>&nbsp;&nbsp;
                    <input style="border:none" readonly="readonly" id="Consignee_phone"/>
                </label>
            </div>
            <br>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 15px">
                    <label style="width: 100px;height: 10px">收货人地址 :</label>&nbsp;&nbsp;
                    <button class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" onClick="return Consignee_site_Copy()">复制</button>&nbsp;&nbsp;
                    <input type="text" style="border:none;width: 90%" readonly="readonly" id="Consignee_site"/>
                </label>
            </div>
            <h3>订单信息 : </h3>
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">订单来源：
                    <input type="text"  style="border:none;width: 200px;margin-left: 10px;color:#FF0000;" readonly="readonly" id="order_source"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label"  style="margin-left: 20px">订单编号：
                    <input style="border:none;width: 200px;margin-left: 10px" readonly="readonly" id="order_no"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">下单日期：
                    <input style="border:none;width: 200px;margin-left: 10px" readonly="readonly" id="pre_order_date"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">订单状态：
                    <input style="border:none;width: 200px;margin-left: 10px" readonly="order_status" id="order_status"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">商品名称：
                    <input style="border:none;width: 80%;margin-left: 10px" readonly="readonly" id="goods_name" />
                    <input style="border:none;width: 1px;" readonly="readonly" id="goods_url" />
                </label>
                <div style="margin-left:100px;margin-top: 10px">
                    <button class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" onClick="return goods_name_Copy()">复制商品名称</button>
                    <button id="goods_url_copy" style="display: none;" class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" onClick="return goods_url_Copy()">点击进入商品详情页</button>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">商品图片：
                    <blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                        <div class="layui-list" style="margin-left: 10px" id="goods_img"></div>
                    </blockquote>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">支付金额：
                    <input style="border:none;width: 100px;margin-left: 10px" readonly="readonly" id="total_price" />
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">购买数量：
                    <input style="border:none;width: 100px;margin-left: 10px;color:#FF0000;" readonly="readonly" id="buy_num" />
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">规格型号：
                    <input style="border:none;width: 200px;margin-left: 10px;color:#FF0000;"  readonly="readonly" id="sku_no" />
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">商品成本价：
                    <input style="border:none;width: 200px;margin-left: 10px;color:#FF0000;"  readonly="readonly" id="original_price" />
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">订单备注：
                    <input style="border:none;width: 200px;margin-left: 10px;color:#FF0000;"  readonly="readonly" id="order_remark" />
                </label>
            </div>
            <h3>代购信息 : </h3>
            <hr class="layui-bg-blue">
            <div class="layui-form-item" style="margin-bottom:5px">
                <label class="layui-form-label" style="width: 120px"><label style="color: red">*</label>代购平台：</label>
                <div class="layui-input-inline" style="width: 300px">
                    <input id="purchasing_terrace" name="purchasing_terrace" lay-verify="sort" autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                    <%--<select class="layui-select" style="width: 150px" id="purchasing_terrace" name="purchasing_terrace">--%>
                    <%--<option value="">---请选择---</option>--%>
                    <%--</select>--%>
                </div>
                <label class="layui-form-label" style="width: 120px" ><label style="color: red">*</label>实际支付金额：</label>
                <div class="layui-input-inline" style="width: 300px">
                    <input id="actual_payment_money" name="actual_payment_money" lay-verify="title1" autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
                <label class="layui-form-label" style="width: 120px" ><label style="color: red">*</label>购买数量：</label>
                <div class="layui-input-inline" style="width: 300px">
                    <input id="purchase_number" name="purchase_number" lay-verify="title1" autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
            </div>
            <div class="layui-form-item">
                <%--<label class="layui-form-label" style="width: 120px"><label style="color: red">*</label>采购价：</label>--%>
                <%--<div class="layui-input-inline" style="width: 500px">--%>
                <%--<input  id="purchase_price" name="purchase_price" lay-verify="sort" autocomplete="off" placeholder=""--%>
                <%--class="layui-input" type="text">--%>
                <%--</div>--%>
                <label class="layui-form-label" style="width: 120px"><label style="color: red">*</label>代购订单号：</label>
                <div class="layui-input-inline" style="width: 300px">
                    <input  id="purchase_order_no" name="purchase_order_no" lay-verify="title1" autocomplete="off" placeholder=""
                            class="layui-input" type="text">
                </div>
                <label class="layui-form-label"style="width: 120px"><label style="color: red">*</label>下单账号：</label>
                <div class="layui-input-inline" style="width: 300px">
                    <input  id="purchasing_terrace_no" name="purchasing_terrace_no" lay-verify="title1" autocomplete="off" placeholder=""
                            class="layui-input" type="text">
                </div>

                    <label class="layui-form-label"style="width: 120px"><label style="color: red">*</label>购运费：</label>
                    <div class="layui-input-inline" style="width: 300px">
                        <input  id="purchasing_freight" name="purchase_freight" lay-verify="title1" autocomplete="off" placeholder=""
                                class="layui-input" type="text">
                    </div>
            </div>
            <div class="layui-form-item" pane="">

                <label class="layui-form-label"style="width: 120px"><label style="color: red">*</label>代付人：</label>
                <div class="layui-input-inline" style="width: 300px">
                    <input  id="substituter" name="substituter" lay-verify="title1" autocomplete="off" placeholder=""
                            class="layui-input" type="text">
                </div>
                <label class="layui-form-label"style="width: 120px">运 单 号：</label>
                <div class="layui-input-inline" style="width: 300px">
                    <input id="waybill_no" name="waybill_no" lay-verify="title1" autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
            </div>
            <div class="layui-form-item" >
                <label class="layui-form-label"style="width: 120px">运单公司：</label>
                <div class="layui-input-inline" style="width: 300px">
                    <input id="express_company" name="express_company" lay-verify="title1" autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
                <label class="layui-form-label"style="width: 120px"></label>
                <div class="layui-input-inline" style="width: 500px">
                    <button  id ="bu" type="button" style="background:#40AFFE" onclick="nextStep(this.id)">添加下一条代购信息</button>
                </div>
            </div>
            <%--第二个代购信息--%>
            <div id="main_2"></div>

            <div class="layui-form-item"  pane="">
                <div class="layui-inline">
                    <label class="layui-form-label"></label>
                    <input type="checkbox"  id="order_error" name="order_error" lay-skin="primary" value="1" title="是否为异常订单" lay-filter="order_errorFilter">
                    <input type="hidden" id="order_error_hide" name="order_error_hide" value="0"/>
                </div>
            </div>
            <div class="layui-form-item" id="order_error_Meaker_Div" style="display: block">
                <label class="layui-form-label" style="width: 120px;">备注：</label>
                <div class="layui-input-inline" style="width: 500px">
                    <textarea style="width: 500px;height: 200px" id="order_error_marker" name="order_error_marker"></textarea>
                </div>
            </div>
        </div>
    </form>
    <div style="margin-left: 20%" >
        <button id="saveSkipTasksDetailInfo" onclick="saveSkipTasksDetailInfo()" class="layui-btn layui-btn-normal">确认</button>
        <button id="saveAndToSKU" style="margin-left: 80px"  class="layui-btn layui-btn-normal">取消</button>
    </div>
</div>
<script>
    var i =0;
    function nextStep(value) {
        var mainDiv = document.createElement("div");
        mainDiv.setAttribute("id","bu"+i);
        document.getElementById("main_2").appendChild(mainDiv);
        var dempDiv = document.createElement("div");
        var label_var = document.createElement("label");
        var div_1 = document.createElement("div");
        var input_1 = document.createElement("input");
        document.getElementById("bu"+i).appendChild(dempDiv);

        dempDiv.setAttribute("id", "newDiv"+i);
        dempDiv.setAttribute("class","layui-form-item");
        dempDiv.style.marginBottom="5px";

        label_var.setAttribute("class","layui-form-label");
        label_var.setAttribute("id","label_var_id");
        label_var.style.width = "120px";
        label_var.innerHTML="<font color='red'>*</font>代购平台：";
        div_1.setAttribute("class","layui-input-inline");
        div_1.style.width="300px";
        div_1.setAttribute("id","div_1_id"+i);
        input_1.setAttribute("type","text");
        input_1.setAttribute("class","layui-input");
        input_1.setAttribute("id","z1"+i);
        input_1.setAttribute("name","purchasing_terrace");
        input_1.setAttribute("lay-verify","sort");
        input_1.setAttribute("autocomplete","off");
        document.getElementById("newDiv"+i).appendChild(label_var);
        document.getElementById("newDiv"+i).appendChild(div_1);
        document.getElementById("div_1_id"+i).appendChild(input_1);

        var label_var_2 = document.createElement("label");
        label_var_2.setAttribute("class","layui-form-label");
        label_var_2.setAttribute("id","label_var_id"+i);
        label_var_2.style.width = "120px";
        label_var_2.innerHTML="<font color='red'>*</font>实际支付金额：";
        var div_2 = document.createElement("div");
        div_2.setAttribute("class","layui-input-inline");
        div_2.style.width="300px";
        div_2.setAttribute("id","div_2_id"+i);
        var input_2 = document.createElement("input");
        input_2.setAttribute("type","text");
        input_2.setAttribute("class","layui-input");
        input_2.setAttribute("id","z1"+i);
        input_2.setAttribute("name","actual_payment_money");
        input_2.setAttribute("lay-verify","sort");
        input_2.setAttribute("autocomplete","off");
        document.getElementById("newDiv"+i).appendChild(label_var_2);
        document.getElementById("newDiv"+i).appendChild(div_2);
        document.getElementById("div_2_id"+i).appendChild(input_2);

        var label_var_z1 = document.createElement("label");
        label_var_z1.setAttribute("class","layui-form-label");
        label_var_z1.setAttribute("id","label_var_zid"+i);
        label_var_z1.style.width = "120px";
        label_var_z1.innerHTML="<font color='red'>*</font>购买数量：";
        var div_z2 = document.createElement("div");
        div_z2.setAttribute("class","layui-input-inline");
        div_z2.style.width="300px";
        div_z2.setAttribute("id","div_2_zid"+i);
        var input_z2 = document.createElement("input");
        input_z2.setAttribute("type","text");
        input_z2.setAttribute("class","layui-input");
        input_z2.setAttribute("id","z2"+i);
        input_z2.setAttribute("name","purchase_number");
        input_z2.setAttribute("lay-verify","sort");
        input_z2.setAttribute("autocomplete","off");
        document.getElementById("newDiv"+i).appendChild(label_var_z1);
        document.getElementById("newDiv"+i).appendChild(div_z2);
        document.getElementById("div_2_zid"+i).appendChild(input_z2);
        /*=========================================1================================================*/
        var dempDiv_1 = document.createElement("div");
        var label_var_1 = document.createElement("label");
        var div_1_1 = document.createElement("div");
        var input_1_1 = document.createElement("input");
        document.getElementById("bu"+i).appendChild(dempDiv_1);

        dempDiv_1.setAttribute("id", "newDiv_1"+i);
        dempDiv_1.setAttribute("class","layui-form-item");
        dempDiv_1.style.marginBottom="5px";

        label_var_1.setAttribute("class","layui-form-label");
        label_var_1.setAttribute("id","label_var_id_1"+i);
        label_var_1.style.width = "120px";
        label_var_1.innerHTML="<font color='red'>*</font>代购订单号：";
        div_1_1.setAttribute("class","layui-input-inline");
        div_1_1.style.width="300px";
        div_1_1.setAttribute("id","div_1_id_1"+i);
        input_1_1.setAttribute("type","text");
        input_1_1.setAttribute("class","layui-input");
        input_1_1.setAttribute("id","z1_1"+i);
        input_1_1.setAttribute("name","purchase_order_no");
        input_1_1.setAttribute("lay-verify","sort");
        input_1_1.setAttribute("autocomplete","off");
        document.getElementById("newDiv_1"+i).appendChild(label_var_1);
        document.getElementById("newDiv_1"+i).appendChild(div_1_1);
        document.getElementById("div_1_id_1"+i).appendChild(input_1_1);

        var label_var_2_1 = document.createElement("label");
        label_var_2_1.setAttribute("class","layui-form-label");
        label_var_2_1.setAttribute("id","label_var_id_1"+i);
        label_var_2_1.style.width = "120px";
        label_var_2_1.innerHTML="<font color='red'>*</font>下单账号：";
        var div_2_1 = document.createElement("div");
        div_2_1.setAttribute("class","layui-input-inline");
        div_2_1.style.width="300px";
        div_2_1.setAttribute("id","div_2_id_1"+i);
        var input_2_1 = document.createElement("input");
        input_2_1.setAttribute("type","text");
        input_2_1.setAttribute("class","layui-input");
        input_2_1.setAttribute("id","z1"+i);
        input_2_1.setAttribute("name","purchasing_terrace_no");
        input_2_1.setAttribute("lay-verify","sort");
        input_2_1.setAttribute("autocomplete","off");
        document.getElementById("newDiv_1"+i).appendChild(label_var_2_1);
        document.getElementById("newDiv_1"+i).appendChild(div_2_1);
        document.getElementById("div_2_id_1"+i).appendChild(input_2_1);

        var label_var_2_z1 = document.createElement("label");
        label_var_2_z1.setAttribute("class","layui-form-label");
        label_var_2_z1.setAttribute("id","label_var_id_z1"+i);
        label_var_2_z1.style.width = "120px";
        label_var_2_z1.innerHTML="<font color='red'>*</font>购运费：";
        var div_2_z1 = document.createElement("div");
        div_2_z1.setAttribute("class","layui-input-inline");
        div_2_z1.style.width="300px";
        div_2_z1.setAttribute("id","div_2_id_z1"+i);
        var input_2_z1 = document.createElement("input");
        input_2_z1.setAttribute("type","text");
        input_2_z1.setAttribute("class","layui-input");
        input_2_z1.setAttribute("id","b1"+i);
        input_2_z1.setAttribute("name","purchase_freight");
        input_2_z1.setAttribute("lay-verify","sort");
        input_2_z1.setAttribute("autocomplete","off");
        document.getElementById("newDiv_1"+i).appendChild(label_var_2_z1);
        document.getElementById("newDiv_1"+i).appendChild(div_2_z1);
        document.getElementById("div_2_id_z1"+i).appendChild(input_2_z1);

        /*==========================================2===============================================*/
        var dempDiv_2 = document.createElement("div");
        var label_var_2 = document.createElement("label");
        var div_1_2 = document.createElement("div");
        var input_1_2 = document.createElement("input");
        document.getElementById("bu"+i).appendChild(dempDiv_2);

        dempDiv_2.setAttribute("id", "newDiv_2"+i);
        dempDiv_2.setAttribute("class","layui-form-item");
        dempDiv_2.style.marginBottom="5px";

        label_var_2.setAttribute("class","layui-form-label");
        label_var_2.setAttribute("id","label_var_id_2"+i);
        label_var_2.style.width = "120px";
        label_var_2.innerHTML="<font color='red'>*</font>代付人：";
        div_1_2.setAttribute("class","layui-input-inline");
        div_1_2.style.width="300px";
        div_1_2.setAttribute("id","div_1_id_3"+i);
        input_1_2.setAttribute("type","text");
        input_1_2.setAttribute("class","layui-input");
        input_1_2.setAttribute("id","z1_2"+i);
        input_1_2.setAttribute("name","substituter");
        input_1_2.setAttribute("lay-verify","sort");
        input_1_2.setAttribute("autocomplete","off");
        document.getElementById("newDiv_2"+i).appendChild(label_var_2);
        document.getElementById("newDiv_2"+i).appendChild(div_1_2);
        document.getElementById("div_1_id_3"+i).appendChild(input_1_2);

        var label_var_2_2 = document.createElement("label");
        label_var_2_2.setAttribute("class","layui-form-label");
        label_var_2_2.setAttribute("id","label_var_id_2"+i);
        label_var_2_2.style.width = "120px";
        label_var_2_2.innerHTML="运单号：";
        var div_2_2 = document.createElement("div");
        div_2_2.setAttribute("class","layui-input-inline");
        div_2_2.style.width="300px";
        div_2_2.setAttribute("id","div_2_id_2"+i);
        var input_2_2 = document.createElement("input");
        input_2_2.setAttribute("type","text");
        input_2_2.setAttribute("class","layui-input");
        input_2_2.setAttribute("id","z2"+i);
        input_2_2.setAttribute("name","waybill_no");
        input_2_2.setAttribute("lay-verify","sort");
        input_2_2.setAttribute("autocomplete","off");
        document.getElementById("newDiv_2"+i).appendChild(label_var_2_2);
        document.getElementById("newDiv_2"+i).appendChild(div_2_2);
        document.getElementById("div_2_id_2"+i).appendChild(input_2_2);

        /*==========================================3===============================================*/
        var dempDiv_3 = document.createElement("div");
        var label_var_3 = document.createElement("label");
        var div_1_3 = document.createElement("div");
        var input_1_3 = document.createElement("input");
        document.getElementById("bu"+i).appendChild(dempDiv_3);

        dempDiv_3.setAttribute("id", "newDiv_3"+i);
        dempDiv_3.setAttribute("class","layui-form-item");
        dempDiv_3.style.marginBottom="5px";

        label_var_3.setAttribute("class","layui-form-label");
        label_var_3.setAttribute("id","label_var_id_3"+i);
        label_var_3.style.width = "120px";
        label_var_3.innerHTML="运单公司：";
        div_1_3.setAttribute("class","layui-input-inline");
        div_1_3.style.width="300px";
        div_1_3.setAttribute("id","div_1_id_4"+i);
        input_1_3.setAttribute("type","text");
        input_1_3.setAttribute("class","layui-input");
        input_1_3.setAttribute("id","z1_3"+i);
        input_1_3.setAttribute("name","express_company");
        input_1_3.setAttribute("lay-verify","sort");
        input_1_3.setAttribute("autocomplete","off");
        document.getElementById("newDiv_3"+i).appendChild(label_var_3);
        document.getElementById("newDiv_3"+i).appendChild(div_1_3);
        document.getElementById("div_1_id_4"+i).appendChild(input_1_3);

        var label_var_2_3 = document.createElement("label");
        label_var_2_3.setAttribute("class","layui-form-label");
        label_var_2_3.setAttribute("id","label_var_id_3"+i);
        label_var_2_3.style.width = "120px";
        var div_2_3 = document.createElement("div");
        div_2_3.setAttribute("class","layui-input-inline");
        div_2_3.style.width="500px";
        div_2_3.setAttribute("id","div_2_id_3"+i);
        var button_1 = document.createElement("button");
        button_1.setAttribute("type","button");
        button_1.setAttribute("id","bu");
        button_1.style.background="#40AFFE";
        button_1.innerHTML="添加下一条代购信息";
        button_1.addEventListener("click",function () {
            nextStep(this.id)
        })
        document.getElementById("newDiv_3"+i).appendChild(label_var_2_3);
        document.getElementById("newDiv_3"+i).appendChild(div_2_3);
        document.getElementById("div_2_id_3"+i).appendChild(button_1);
        i++;
    }
</script>