package it.unitn.shoppinglesto.servlet;

import it.unitn.shoppinglesto.db.daos.*;
import it.unitn.shoppinglesto.db.entities.Category;
import it.unitn.shoppinglesto.db.entities.Product;
import it.unitn.shoppinglesto.db.entities.ShoppingList;
import it.unitn.shoppinglesto.db.entities.User;
import it.unitn.shoppinglesto.db.exceptions.DAOException;
import it.unitn.shoppinglesto.db.exceptions.DAOFactoryException;
import it.unitn.shoppinglesto.db.factories.DAOFactory;
import it.unitn.shoppinglesto.utils.UtilityHelper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@WebServlet(name = "HomeServlet")
public class HomeServlet extends HttpServlet {
    private final String TEMPLISTCOOKIENAME = "templist_shoppingLesto_token";
    private UserDAO userDAO;
    private ShoppingListDAO shoppingListDAO;
    private ListCategoryDAO listCategoryDAO;
    private ProductDAO productDAO;
    private ProdCategoryDAO prodCategoryDAO;

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
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get shopping list dao from dao factory!", ex);
        }
        try {
            listCategoryDAO = daoFactory.getDAO(ListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get listCategory dao from dao factory!", ex);
        }
        try {
            prodCategoryDAO = daoFactory.getDAO(ProdCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get prodCategory dao from dao factory!", ex);
        }
        try {
            productDAO = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get product dao from dao factory!", ex);
        }
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String dispatchPath = null;
        if (user == null) {
            String uuidStr = UtilityHelper.getCookieValue(request, TEMPLISTCOOKIENAME);

            /*if (uuidStr != null) {
                try {
                    ShoppingList list = shoppingListDAO.getTemporaryList(uuidStr);
                    request.setAttribute("shoppingList", list); //maybe should change it to session.

                } catch (DAOException ex) {
                    response.sendError(500, ex.getMessage()); //gives error if cookie present but db record is cancelled.
                }
            }*/
            dispatchPath = "/WEB-INF/views/index.jsp";
        } else {
            if (user.isAdmin()) {
                try {
                    List<Category> listCategory = listCategoryDAO.getAll();
                    List<Product> products = productDAO.getAll();
                    List<Category> prodCategory = prodCategoryDAO.getAll();

                    session.setAttribute("listCategory", listCategory);
                    session.setAttribute("products", products);
                    session.setAttribute("prodCategory", prodCategory);

                } catch (DAOException ex) {
                    response.sendError(500, ex.getMessage());
                }

                dispatchPath = "/WEB-INF/views/admin/adminHome.jsp";
            } else {
                try {
                    List<ShoppingList> lists = shoppingListDAO.getUserLists(user);
                    session.setAttribute("userLists", lists);
                } catch (DAOException ex) {
                    response.sendError(500, ex.getMessage());
                }

                dispatchPath = "/WEB-INF/views/home.jsp";
            }

        }
        if(!response.isCommitted()) {
            RequestDispatcher rd = request.getRequestDispatcher(dispatchPath);
            rd.forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
