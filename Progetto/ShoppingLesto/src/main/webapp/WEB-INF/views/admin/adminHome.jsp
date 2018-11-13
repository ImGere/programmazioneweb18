<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

    <title>ShoppingLesto | Admin Panel - Webprogramming18</title>

    <%@include file="../parts/_imports.jspf" %>

</head>
<body id="page-top">

<%@include file="../parts/_navigation.jspf" %>
<%@include file="../parts/_errors.jspf" %>

<div class="container-fluid">
    <div class="row justify-content-md-center">
        <div class="col-md-2">
        </div>
        <div class="col-lg-8 col-md-8 col-12">
            <%@include file="../parts/_successMessage.jspf" %>
            <h2><fmt:message key="admin.h.admin_panel" /></h2>
            <p><small><fmt:message key="admin.h.click" /></small></p>
            <ul class="nav nav-pills nav-fill mb-3" id="pills-tab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link" id="pills-listCat-tab" data-toggle="pill" href="#pills-listCat" role="tab" aria-controls="pills-listCat" aria-selected="true"><fmt:message key="admin.a.lists" /></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="pills-prod-tab" data-toggle="pill" href="#pills-prod" role="tab" aria-controls="pills-prod" aria-selected="false"><fmt:message key="admin.a.products" /></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="pills-prodCat-tab" data-toggle="pill" href="#pills-prodCat" role="tab" aria-controls="pills-prodCat" aria-selected="false"><fmt:message key="admin.a.product_cat" /></a>
                </li>
            </ul>
            <!-- Categoria di liste -->
            <div class="tab-content" id="pills-tabContent">
                <div class="tab-pane fade" id="pills-listCat" role="tabpanel" aria-labelledby="pills-listCat-tab">
                    <ul class="list-inline">
                        <li class="list-inline-item">
                            <h5><fmt:message key="admin.h.manage" /></h5>
                        </li>
                        <li class="list-inline-item">
                            <button type="button" class="btn btn-primary addListCat"
                                    style="padding: 0 .375rem 0 .375rem;"
                                    data-toggle="modal" data-target="#addListCatModal">
                                <i class="fas fa-plus"></i>
                            </button>
                        </li>
                    </ul>
                    <table class="table table-striped table-hover">
                        <thead>
                        <tr>
                            <th scope="col"><fmt:message key="admin.h.photos" /></th>
                            <th scope="col"><fmt:message key="admin.h.name" /></th>
                            <th scope="col"><fmt:message key="admin.h.description" /></th>
                            <th scope="col"><fmt:message key="admin.h.edit" /></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${listCategory}" var="listCat">

                            <tr>
                                <td>
                                    <c:forEach items="${listCat.photos}" var="photo">
                                        <img class="rounded shadow mb-3 bg-white rounded deletePhoto image" height="65" width="65"
                                             src="${pageContext.request.contextPath}/images?id=${photo.id}&resource=listCatPhoto"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/avatars/Products/default.png';"
                                             onclick="deleteListCatPhoto(${photo.id}, this)"
                                             onmouseover="mouseOverPhoto(this)" title="Click on the picture to delete it!"/>
                                    </c:forEach>
                                </td>
                                <td>${listCat.name}</td>
                                <td>${listCat.description}</td>
                                <td>
                                    <ul class="list-inline">
                                            <li class="list-inline-item">
                                                <button type="button" class="btn btn-primary modifyListCat"
                                                        style="padding: 0 .375rem 0 .375rem;"
                                                        data-toggle="modal" data-target="#modifyListCatModal"
                                                        data-id="${listCat.id}"
                                                        data-name="${listCat.name}"
                                                        data-desc="${listCat.description}">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                            </li>
                                        <li class="list-inline-item">
                                            <button type="button" class="btn btn-primary deleteListCat"
                                                    style="padding: 0 .375rem 0 .375rem;"
                                                    data-toggle="modal" data-target="#deleteListCatModal" data-id-list-cat="${listCat.id}">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </li>
                                    </ul>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- Prodotti -->
                <div class="tab-pane fade" id="pills-prod" role="tabpanel" aria-labelledby="pills-prod-tab">
                    <h5><fmt:message key="admin.h.manage_available" /></h5>
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <th scope="col"><fmt:message key="admin.h.name" /></th>
                            <th scope="col"><fmt:message key="admin.h.description" /></th>
                            <th scope="col"><fmt:message key="admin.h.edit" /></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${products}" var="prod">
                            <tr>
                                <td>${prod.name}</td>
                                <td>${prod.description}</td>
                                <td>@mdo</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- Categoria di prodotti -->
                <div class="tab-pane fade" id="pills-prodCat" role="tabpanel" aria-labelledby="pills-prodCat-tab">
                    <ul class="list-inline">
                        <li class="list-inline-item">
                            <h5><fmt:message key="admin.h.manage_lists" /></h5>
                        </li>
                        <li class="list-inline-item">
                            <button type="button" class="btn btn-primary addListCat"
                                    style="padding: 0 .375rem 0 .375rem;"
                                    data-toggle="modal" data-target="#addListCatModal">
                                <i class="fas fa-plus"></i>
                            </button>
                        </li>
                    </ul>
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <th scope="col"><fmt:message key="admin.h.photos" /></th>
                            <th scope="col"><fmt:message key="admin.h.name" /></th>
                            <th scope="col"><fmt:message key="admin.h.description" /></th>
                            <th scope="col"><fmt:message key="admin.h.edit" /></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${prodCategory}" var="prodCat">
                            <tr>
                                <td>
                                    <c:forEach items="${prodCat.photos}" var="photo">
                                    <img class="rounded shadow mb-3 bg-white rounded" height="65" width="65"
                                         src="${pageContext.request.contextPath}/images?id=${photo.id}&resource=prodCatPhoto"
                                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/avatars/Products/default.png';"
                                         onmouseover="mouseOverPhoto(this)"
                                         onclick="deleteProdCatPhoto(${photo.id}, this)"  title="Click on the picture to delete it!"/>
                                    </c:forEach>
                                </td>
                                <td>${prodCat.name}</td>
                                <td>${prodCat.description}</td>
                                <td>
                                    <ul class="list-inline">
                                        <li class="list-inline-item">
                                            <button type="button" class="btn btn-primary modifyProdCat"
                                                    style="padding: 0 .375rem 0 .375rem;"
                                                    data-toggle="modal" data-target="#modifyProdCatModal"
                                                    data-id="${prodCat.id}"
                                                    data-name="${prodCat.name}"
                                                    data-desc="${prodCat.description}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </li>
                                        <li class="list-inline-item">
                                            <button type="button" class="btn btn-primary"
                                                    style="padding: 0 .375rem 0 .375rem;"
                                                    data-toggle="modal" data-target="#deleteProdCatModal" data-id-prod-cat="${prodCat.id}">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </li>
                                    </ul>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-2">
        </div>
    </div>
</div>
<!-- List Categoy -->
<!-- Modal add list category button -->
<div class="modal fade" id="addListCatModal" tabindex="-1" role="dialog" aria-labelledby="addListCatModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addListCatModalLabel"><fmt:message key="admin.h.add_list" /></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/list/category/new" method="POST"
                      enctype='multipart/form-data'>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="nameListCat"><fmt:message key="admin.h.name" /></label>
                            <input type="text" class="form-control" placeholder="Name" name="nameListCat">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="descriptionListCat"><fmt:message key="admin.h.description" /></label>
                            <textarea class="form-control" name="descriptionListCat" rows="3"
                                      placeholder="Description"></textarea>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group  col-md-6">
                            <label for="photo"><fmt:message key="admin.h.photos" /></label>
                            <input type="file" class="form-control-file" name="photo">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary"><fmt:message key="admin.h.add_list" /></button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal edit list category button -->
<div class="modal fade" id="modifyListCatModal" tabindex="-1" role="dialog" aria-labelledby="modifyListCatModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modifyListCatModalLabel"><fmt:message key="admin.h.edit_list" /></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/list/category/edit" method="POST"
                      enctype='multipart/form-data'>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="nameListCat"><fmt:message key="admin.h.name" /></label>
                            <input type="text" class="form-control" id="nameListCat" placeholder="Name" name="nameListCat">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="descriptionListCat"><fmt:message key="admin.h.description" /></label>
                            <textarea class="form-control" id="descriptionListCat" name="descriptionListCat" rows="3"
                                      placeholder="Description"></textarea>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group  col-md-6">
                            <label for="photo"><fmt:message key="admin.h.photo" /></label>
                            <input type="file" class="form-control-file" id="photo" name="photo">
                        </div>
                    </div>
                    <input type="hidden" name="listCatId" id="hiddenListCatId">
                    <button type="submit" class="btn btn-primary"><fmt:message key="admin.h.edit_list" /></button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal delete list category button -->
<div class="modal fade" id="deleteListCatModal" tabindex="-1" role="dialog" aria-labelledby="deleteListCatModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteListCatModalLabel"><fmt:message key="admin.h.delete_list" /></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/list/category/delete" method="POST">
                    <div class="form-row">
                        <label><fmt:message key="admin.h.sure" /><br><fmt:message key="admin.h.sure2" /></label>
                    </div>
                    <input type="hidden" id="hiddenListCatDeleteId" name="listCatId">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary"><fmt:message key="admin.h.delete_list" /></button>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- Product Category -->
<!-- Modal add list category button -->
<div class="modal fade" id="addProdCatModal" tabindex="-1" role="dialog" aria-labelledby="addProdCatModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addProdCatModalLabel">Add List Category</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/product/category/new" method="POST"
                      enctype='multipart/form-data'>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="nameProdCat">Name</label>
                            <input type="text" class="form-control" placeholder="Name" name="nameProdCat">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="descriptionProdCat">Description</label>
                            <textarea class="form-control" name="descriptionProdCat" rows="3"
                                      placeholder="Description"></textarea>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group  col-md-6">
                            <label for="photo">Add photo</label>
                            <input type="file" class="form-control-file" name="photo">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Add product category</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal edit list category button -->
<div class="modal fade" id="modifyProdCatModal" tabindex="-1" role="dialog" aria-labelledby="modifyProdCatModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modifyProdCatModalLabel">Edit List Category</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/product/category/edit" method="POST"
                      enctype='multipart/form-data'>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="nameProdCat">Name</label>
                            <input type="text" class="form-control" id="nameProdCat" placeholder="Name" name="nameProdCat">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for="descriptionProdCat">Description</label>
                            <textarea class="form-control" id="descriptionProdCat" name="descriptionProdCat" rows="3"
                                      placeholder="Description"></textarea>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group  col-md-6">
                            <label for="photo">Add photo</label>
                            <input type="file" class="form-control-file" name="photo">
                        </div>
                    </div>
                    <input type="hidden" name="prodCatId" id="hiddenProdCatId">
                    <button type="submit" class="btn btn-primary">Edit product category</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal delete list category button -->
<div class="modal fade" id="deleteProdCatModal" tabindex="-1" role="dialog" aria-labelledby="deleteProdCatModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteProdCatModalLabel">Delete Product Category</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/product/category/delete" method="POST">
                    <div class="form-row">
                        <label>Are you sure you want to delete this category<br>You will delete all product using this category</label>
                    </div>
                    <input type="hidden" id="hiddenProdCatDeleteId" name="prodCatId">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Delete product category</button>
                </form>
            </div>
        </div>
    </div>
</div>


<%@include file="../parts/_footer.jspf" %>
<%@include file="../parts/_importsjs.jspf" %>
<script type="text/javascript">
    // language=JQuery-CSS
    $('.modifyListCat').click(function () {
        $('#hiddenListCatId').val($(this).data('id'));
        $('#descriptionListCat').html($(this).data('desc'));
        $('#nameListCat').val($(this).data('name'));
    });

    $('.deleteListCat').click(function () {
        $('#hiddenListCatDeleteId').val($(this).data('id-list-cat'));
    });

    $('.deleteProdCat').click(function () {
        $('#hiddenProdCatDeleteId').val($(this).data('id-prod-cat'));
    });

    $('.modifyProdCat').click(function () {
        $('#hiddenProdCatId').val($(this).data('id'));
        $('#descriptionProdCat').html($(this).data('desc'));
        $('#nameProdCat').val($(this).data('name'));
    });

    function mouseOverPhoto(elem){
        $(elem).css( 'cursor', 'pointer' );
    }

    function deleteListCatPhoto(id, elem) {        // When HTML DOM "click" event is invoked on element with ID "somebutton", execute the following function...
        $.post("list/category/photo/delete",
            {
                listCategoryPhotoId : id
            }).done(function(){});
        $(elem).fadeOut(300, function() { $(this).remove(); });
        $(elem).tooltip( "option", "disabled" );
    }


    function deleteProdCatPhoto(id, elem) {        // When HTML DOM "click" event is invoked on element with ID "somebutton", execute the following function...
        $.post("product/category/photo/delete",
            {
                prodCategoryPhotoId : id
            }).done(function(){});
        $(elem).fadeOut(300, function() { $(this).remove(); });
        $(elem).tooltip( "option", "disabled" );
    }


</script>
</body>

</html>