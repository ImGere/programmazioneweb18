package it.unitn.shoppinglesto.servlet.lists;


import it.unitn.shoppinglesto.db.daos.ListCategoryDAO;
import it.unitn.shoppinglesto.db.daos.ProductDAO;
import it.unitn.shoppinglesto.db.daos.ShoppingListDAO;
import it.unitn.shoppinglesto.db.daos.UserDAO;
import it.unitn.shoppinglesto.db.entities.Category;
import it.unitn.shoppinglesto.db.entities.Product;
import it.unitn.shoppinglesto.db.entities.ShoppingList;
import it.unitn.shoppinglesto.db.entities.User;
import it.unitn.shoppinglesto.db.exceptions.DAOException;
import it.unitn.shoppinglesto.db.exceptions.DAOFactoryException;
import it.unitn.shoppinglesto.db.factories.DAOFactory;
import it.unitn.shoppinglesto.utils.UtilityHelper;

import java.util.ArrayList;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ShowListServlet")
public class ShowListServlet extends HttpServlet {
    private final String TEMPLISTCOOKIENAME = "templist_shoppingLesto_token";
    private UserDAO userDAO;
    private ShoppingListDAO shoppingListDAO;
    private ProductDAO productDAO;
    private ListCategoryDAO listCategoryDAO;


    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory!");
        }
        try {
            userDAO = daoFactory.getDAO(UserDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get user dao from dao factory!", ex);
        }
        try {
            listCategoryDAO = daoFactory.getDAO(ListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get list category dao from dao factory!", ex);
        }
        try {
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get shopping list dao from dao factory!", ex);
        }
        try {
            productDAO = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get product dao from dao factory!", ex);
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        ShoppingList list = null;
        List<Product> productList = null;
        boolean anon = false;
        if (request.getParameterMap().containsKey("anonymous")) {
            anon = true;
        }
        request.setAttribute("anon", anon);
        Integer listId = null;
        try {
            listId = Integer.valueOf(request.getParameter("id"));
        } catch (RuntimeException ex) {
            response.sendError(500, ex.getMessage());
        }

        if (user != null && !anon) {
            try {
                if (listId == null) {
                    response.sendError(500, "There is no list selected!");
                    return;
                } else {
                    if (!shoppingListDAO.isUserInList(user, listId))
                        response.sendError(404, "You're not in this list!");
                    else {
                        list = shoppingListDAO.getByPrimaryKey(listId);
                        shoppingListDAO.getPermissions(user, list);

                        list.setUser(userDAO.getById(list.getUserId()));
                        list.setCategory(listCategoryDAO.getByPrimaryKey(list.getCategoryId()));
                        productList = productDAO.getProductsByList(list);
                    }
                }
            } catch (DAOException e) {
                response.sendError(500, e.getMessage());
            }
        } else {
            try {
                Integer cookieList = Integer.parseInt(Objects.requireNonNull(UtilityHelper.getCookieValue(request, TEMPLISTCOOKIENAME)));
                if (listId == null) {
                    response.sendError(500, "There is no list selected!");
                    return;
                } else if (listId.equals(cookieList)) {
                    list = shoppingListDAO.getByPrimaryKey(listId);
                    list.setCategory(listCategoryDAO.getByPrimaryKey(list.getCategoryId()));
                    productList = productDAO.getProductsByList(list);
                } else {
                    response.sendError(404, "You're not in this list!");
                }

            } catch (DAOException ex) {
                Logger.getLogger(ShowListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        request.getSession().setAttribute("list", list);
        request.getSession().setAttribute("productsList", productList);
        List<Category> categories = new ArrayList<>();
        List<User> listUsers;
        List<User> sharedWith;
        try {
            categories = listCategoryDAO.getAll();
            if (!anon) {
                listUsers = shoppingListDAO.getSharableUsers(list);
                sharedWith = shoppingListDAO.getSharedUser(list);
                request.setAttribute("listUsers", listUsers);
                request.setAttribute("sharedWith", sharedWith);
            }
        } catch (DAOException e) {
            e.printStackTrace();
        }
        request.setAttribute("listCategories", categories);
        request.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
