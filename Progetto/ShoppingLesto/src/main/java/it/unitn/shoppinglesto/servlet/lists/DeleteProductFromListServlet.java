package it.unitn.shoppinglesto.servlet.lists;

import it.unitn.shoppinglesto.db.daos.ShoppingListDAO;
import it.unitn.shoppinglesto.db.entities.User;
import it.unitn.shoppinglesto.db.exceptions.DAOException;
import it.unitn.shoppinglesto.db.exceptions.DAOFactoryException;
import it.unitn.shoppinglesto.db.factories.DAOFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DeleteProductFromListServlet")
public class DeleteProductFromListServlet extends HttpServlet {
    private ShoppingListDAO shoppingListDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory!");
        }
        try {
            shoppingListDAO = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get shopping list dao from dao factory!", ex);
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
        Integer listId = null, prodId = null;
        try{
            listId = Integer.parseInt(request.getParameter("listId"));
            prodId = Integer.parseInt(request.getParameter("prodId"));
        }catch (RuntimeException ex) {
            response.sendError(500, "Error retrieving prod and list id");
        }
        // lo aggiungo alla lista
        if(listId != null && prodId != null){
            try{
                shoppingListDAO.deleteProductFromList(listId, prodId);
            }catch (DAOException e){
                response.sendError(500, e.getMessage());
            }
            message = "Product successfully deleted from this list";
            session.setAttribute("successMessage", message);
            response.sendRedirect(response.encodeRedirectURL(getServletContext().getContextPath() + "/list?id=" + listId));
        }
        else{
            message = "Error getting product and list id";
            session.setAttribute("errorMessage", message);
            response.sendRedirect(response.encodeRedirectURL(getServletContext().getContextPath() + "/list?id=" + listId));
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
