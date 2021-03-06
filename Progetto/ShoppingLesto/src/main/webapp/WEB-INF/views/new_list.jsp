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
<c:set var="language"
       value="${not empty param.language ? param.language : not empty language ? language : pageContext.request.locale}"
       scope="session"/>
<fmt:setLocale value="${language}"/>
<fmt:setBundle basename="i18n.text"/>
<!DOCTYPE html>
<html lang="${language}">

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>ShoppingLesto - Webprogramming18</title>

    <%@include file="parts/_imports.jspf" %>

</head>
<body id="page-top">
<%@include file="parts/_navigation.jspf" %>
<%@include file="parts/_errors.jspf" %>

<div class="container-fluid">
    <div class="row justify-content-md-center">
        <div class="col-md-1">
        </div>
        <div class="col-lg-10 col-md-10 col-12">
            <h2><fmt:message key="new_list.h.new_list"/></h2>
            <%@include file="parts/_successMessage.jspf" %>
            <c:choose>
                <c:when test="${anon}">
                    <form action="${pageContext.request.contextPath}/list/new?anonymous=true" id="newList" method="POST"
                          enctype="multipart/form-data">
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/list/new" method="POST" id="newList" enctype="multipart/form-data">
                </c:otherwise>
            </c:choose>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="name"><fmt:message key="list.label.name"/></label>
                                <input type="text" class="form-control" id="name" placeholder="Name" name="name" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="category"><fmt:message key="new_list.label.category"/></label>
                                <select id="category" name="category" class="form-control" required>
                                    <option selected><fmt:message key="list.option.choose"/></option>
                                    <c:forEach items="${listCategories}" var="category">
                                        <option value="${category.id}">${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-12">
                                <label for="description"><fmt:message key="list.li.description"/></label>
                                <textarea class="form-control" id="description" name="description " rows="3"
                                          placeholder="Description" required></textarea>
                            </div>
                        </div>
                        <div class="form-row mb-4">
                            <div class="custom-file">
                                <input type="file" class="custom-file-input" id="avatar" name="avatar">
                                <label class="custom-file-label" for="avatar">Add list avatar</label>
                            </div>
                        </div>
                        <button type="submit" id="submitNewList" class="btn btn-primary"><fmt:message key="new_list.h.new_list"/></button>
                    </form>
        </div>
        <div class="col-md-1">
        </div>
    </div>
</div>
<%@include file="parts/_footer.jspf" %>
<%@include file="parts/_importsjs.jspf" %>

<script type="text/javascript">
    $(document).ready(function () {
        $("#submitNewList").click(function(e) {
            if($("#category").val() == "Choose..." || $("#category").val() == "Scegli..."){
                alert("Scegli una categoria");
                e.preventDefault();
            }
        })
    })
</script>

</body>

</html>
