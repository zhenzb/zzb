<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  Created by IntelliJ IDEA.
  User: sdmin
  Date: 2018/3/13
  Time: 15:43
  To change this template use File | Settings | File Templates.
--%>
<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
        <ul class="layui-nav layui-nav-tree"  lay-filter="test">
            <li class="layui-nav-item layui-nav-itemed">
                <a class="" href="javascript:;">掌达赚管理</a>
                <dl class="layui-nav-child">

                    <dd><a href="${ctx}/zhangDaZhuan/goodsList.jsp">掌达赚商品管理</a></dd>

                    <dd><a href="${ctx}/zhangDaZhuan/zhangDaOrderList.jsp">掌达赚订单管理</a></dd>

                </dl>
            </li>

        </ul>
    </div>
</div>