<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

    <title>ShoppingLesto | Login - Webprogramming18</title>

    <%@include file="parts/_imports.jspf" %>

</head>
<body id="page-top">

<%@include file="parts/_navigation.jspf" %>
<%@include file="parts/_errors.jspf" %>

<div class="container-fluid">
    <div class="row">
        <div class="col">
        </div>
        <div class="col-6">
            <h2>Login</h2>
            <form  method="POST" action="${pageContext.request.contextPath}/login">
                <div class="form-group">
                    <label for="email"><fmt:message key="login.label.email" /></label>
                    <input type="email" class="form-control" id="email" name="email" aria-describedby="emailHelp" placeholder="<fmt:message key="login.label.email" />"  value="${user.mail}">
                    <small id="emailHelp" class="form-text text-muted"><fmt:message key="login.label.never" /></small>
                </div>
                <div class="form-group">
                    <label for="password"><fmt:message key="login.label.password" /></label>
                    <input type="password" class="form-control" id="password" name="password" value="${user.password}" placeholder="<fmt:message key="login.label.password" />">
                </div>
                <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="rememberMe"  name="rememberMe" value="Y">
                    <label class="form-check-label" for="rememberMe" ><fmt:message key="login.label.remember" /></label>
                </div>
                <button type="submit" class="btn btn-primary"><fmt:message key="login.button.submit" /></button>
            </form>
            <div class="mt-4">
                <hr/>
                <fmt:message key="login.h.if" /> <a class="badge-pill btn-primary" href="${pageContext.request.contextPath}/register"><fmt:message key="register.h.here" /></a>!
            </div>

        </div>
        <div class="col">
        </div>
    </div>
</div>
<%@include file="parts/_footer.jspf" %>
<%@include file="parts/_importsjs.jspf" %>
</body>

</html>