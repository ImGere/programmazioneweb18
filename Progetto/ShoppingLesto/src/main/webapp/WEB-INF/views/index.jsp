<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:choose>
    <c:when test="${not empty param.lang}">
        <c:set var="language" value="${param.lang}" scope="session"/>
    </c:when>
    <c:otherwise>
        <c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : pageContext.request.locale}" scope="session" />
    </c:otherwise>
</c:choose>
<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : pageContext.request.locale}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="i18n.text" />
<!DOCTYPE html>
<html lang="${language}">

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>ShoppingLesto - Webprogramming18</title>

    <%@include file="parts/_imports.jspf" %>

    <style>
        body{
            background-color: #303030;
        }
    </style>

</head>
<body id="page-top" style="margin-top: 0%">

<%@include file="parts/_errors.jspf" %>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light fixed-top" id="mainNav">
    <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="${pageContext.request.contextPath}/home">ShoppingLesto</a>
    </div>
</nav>

<!-- Header -->
<header class="masthead">
    <div class="container">
        <div class="intro-text">
            <div class="intro-heading text-uppercase"><fmt:message key="index.div.shopping_lesto" /></div>
            <div class="intro-lead-in"><fmt:message key="index.div.compri" /></div>
            <a class="btn btn-primary btn-xl text-uppercase js-scroll-trigger" style="margin: 1%"
               href="${pageContext.request.contextPath}/login"><fmt:message key="index.div.login" /></a>
            <a class="btn btn-primary btn-xl text-uppercase js-scroll-trigger" style="margin: 1%"
               href="${pageContext.request.contextPath}/register"><fmt:message key="index.div.register" /></a>
            <a class="btn btn-primary btn-xl text-uppercase js-scroll-trigger" style="margin: 1%"
               href="${pageContext.request.contextPath}/home?anonymous=true"><fmt:message key="index.div.anonymous" /></a>
        </div>
    </div>
</header>

<%@include file="parts/_footer.jspf" %>
<%@include file="parts/_importsjs.jspf" %>

</body>

</html>
