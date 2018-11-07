package it.unitn.shoppinglesto.servlet.lists;

import it.unitn.shoppinglesto.db.daos.ListCategoryDAO;
import it.unitn.shoppinglesto.db.daos.ShoppingListDAO;
import it.unitn.shoppinglesto.db.daos.UserDAO;
import it.unitn.shoppinglesto.db.entities.Category;
import it.unitn.shoppinglesto.db.entities.ShoppingList;
import it.unitn.shoppinglesto.db.entities.User;
import it.unitn.shoppinglesto.db.exceptions.DAOException;
import it.unitn.shoppinglesto.db.exceptions.DAOFactoryException;
import it.unitn.shoppinglesto.db.factories.DAOFactory;
import it.unitn.shoppinglesto.utils.CookieHelper;
import it.unitn.shoppinglesto.utils.UtilityHelper;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@MultipartConfig
@WebServlet(name = "NewListServlet")
public class NewListServlet extends HttpServlet {
    private final String TEMPLISTCOOKIENAME = "templist_shoppingLesto_token";
    private UserDAO userDAO;
    private ShoppingListDAO shoppingListDAO;
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
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get shopping list dao from dao factory!", ex);
        }
        try {
            listCategoryDAO = daoFactory.getDAO(ListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get list category dao from dao factory!", ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(500, "There was an error processing the request");
            return;
        }

        String message = null;
        boolean hasError = false;
        boolean modified = false;
        String avatarsFolder = getServletContext().getInitParameter("avatarsFolder");
        if (avatarsFolder == null) {
            response.sendError(500, "Avatars folder not configured");
            return;
        }

        String rootPath = System.getProperty("catalina.home");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("category"));
        if (name == null || description == null || name.equals("") || description.equals("")) {
            hasError = true;
            message = "All fields are mandatory and must be filled!";
        } else {
            if (description.length() > 255) {
                hasError = true;
                message = "List description can contain a maximum of  255 characters.";
            } else {
                // int id, String name, String description, String image, int categoryId, int userId, User user
                ShoppingList list = new ShoppingList(null, name, description, null, categoryId, user.getId(), user);
                try {
                    list.setId(shoppingListDAO.save(list));
                } catch (DAOException e) {
                    e.printStackTrace();
                }
                Part filePart = request.getPart("avatar");
                if ((filePart != null) && (filePart.getSize() > 0)) {
                    String fileName = UtilityHelper.getFilename(filePart);
                    fileName = UtilityHelper.renameImage(fileName, "List_" + list.getId());
                    String listIconUploadDir = rootPath + File.separator + avatarsFolder + "Lists";
                    try {
                        list.setImage(UtilityHelper.uploadFileToDirectory(listIconUploadDir, fileName, filePart));
                    } catch (IOException ex) {
                        response.sendError(500, ex.getMessage());
                    }
                    modified = true;
                }
                try {
                    list = shoppingListDAO.update(list);
                    list.setUser(userDAO.getById(list.getUserId()));
                    list.setCategory(listCategoryDAO.getByPrimaryKey(list.getCategoryId()));
                    if (user == null) {
                        String uuid = UUID.randomUUID().toString();
                        //shoppingListDAO.insertTempList(list, uuid);
                        //CookieHelper.storeGenericCookie(response, TEMPLISTCOOKIENAME, uuid);
                    } else {
                        //shoppingListDAO.linkShoppingListToUser(list, user);
                        list.setUserId(user.getId());
                    }

                } catch (DAOException ex) {
                    response.sendError(500, ex.getMessage());
                }
            }

        }

        if (hasError) {
            session.setAttribute("errorMessage", message);
            session.setAttribute("action", "newList");
            response.sendRedirect(response.encodeRedirectURL(getServletContext().getContextPath() + "/home"));
        } else {
            message = "List was successfully created";
            session.setAttribute("successMessage", message);
            response.sendRedirect(response.encodeRedirectURL(getServletContext().getContextPath() + "/home"));
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!response.isCommitted()) {
            List<Category> categories = new ArrayList<>();
            try {
                categories = listCategoryDAO.getAll();
            } catch (DAOException e) {
                e.printStackTrace();
            }
            request.setAttribute("listCategories", categories);
            request.getRequestDispatcher("/WEB-INF/views/new_list.jsp").forward(request, response);
        }
    }
}
