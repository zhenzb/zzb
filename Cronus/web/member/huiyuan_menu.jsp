<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%
    String menuIndex = request.getParameter("menuIndex");
%>



<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
        <ul class="layui-nav layui-nav-tree"  lay-filter="test">


            <li class="layui-nav-item layui-nav-itemed">
                <a class="" href="javascript:;">会员管理</a>
                <dl class="layui-nav-child">
                    <dd id="dd1"><a href="${ctx}/member/pregistered.jsp?menuIndex=1">注册设置</a></dd>
                    <dd id="dd2"><a href="${ctx}/member/member_mrank.jsp?menuIndex=2">会员等级管理</a></dd>
                    <dd id="dd3"><a href="${ctx}/member/memberList.jsp?menuIndex=3">会员查询</a></dd>
                    <dd id="dd4"><a href="${ctx}/member/certification.jsp?menuIndex=4">会员认证审核</a></dd>
                </dl>
            </li>


<!--
            <li class="layui-nav-item">
                <a href="${pageContext.request.contextPath}/member/pregistered.jsp">注册设置</a>
                <%--<dl class="layui-nav-child">
                    <dd><a href="${pageContext.request.contextPath}/member/pregistered.jsp">禁止注册账户</a></dd>
                </dl>--%>
            </li>
            <li class="layui-nav-item">
                <a href="${pageContext.request.contextPath}/member/member_mrank.jsp">会员等级管理</a>
               <%-- <dl class="layui-nav-child">
                    <dd><a href="${pageContext.request.contextPath}/member/memberList.jsp">会员查询</a></dd>
                    <dd><a href="${pageContext.request.contextPath}/member/certification.jsp">认证审核</a></dd>
                    <dd><a href="${pageContext.request.contextPath}/member/member_mrank.jsp">等级管理</a></dd>
                </dl>--%>
            </li>
            <li class="layui-nav-item">
                <a href="${pageContext.request.contextPath}/member/memberList.jsp">会员查询</a>
                <%--<dl class="layui-nav-child">
                    <dd><a href="${pageContext.request.contextPath}/member/memberList.jsp">会员查询</a></dd>
                    <dd><a href="${pageContext.request.contextPath}/member/certification.jsp">认证审核</a></dd>
                    <dd><a href="${pageContext.request.contextPath}/member/member_mrank.jsp">等级管理</a></dd>
                </dl>--%>
            </li>
            <li class="layui-nav-item">
                <a href="${pageContext.request.contextPath}/member/certification.jsp">会员认证审核</a>
                <%--<dl class="layui-nav-child">
                    <dd><a href="${pageContext.request.contextPath}/member/memberList.jsp">会员查询</a></dd>
                    <dd><a href="${pageContext.request.contextPath}/member/certification.jsp">认证审核</a></dd>
                    <dd><a href="${pageContext.request.contextPath}/member/member_mrank.jsp">等级管理</a></dd>
                </dl>--%>
            </li>
           <%-- <li class="layui-nav-item">
                <a href="javascript:;">基本档案</a>
                <dl class="layui-nav-child">
                    <dd><a href="${pageContext.request.contextPath}/member/employee.jsp">员工管理</a></dd>
                </dl>
            </li>--%>
-->


        </ul>






    </div>
</div>

<script>
    var menuIndex = <%=menuIndex%>;
    $('#dd' + menuIndex).addClass("layui-this");
</script>