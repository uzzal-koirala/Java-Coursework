package service;

import dao.UserDAO;
import model.User;

public class AuthService {
    private UserDAO userDAO = new UserDAO();

    public boolean register(User user) {
        if (userDAO.isEmailOrPhoneExists(user.getEmail(), user.getPhone())) {
            return false;
        }
        return userDAO.registerUser(user);
    }

    public User login(String email, String password) {
        return userDAO.loginUser(email, password);
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }
}
