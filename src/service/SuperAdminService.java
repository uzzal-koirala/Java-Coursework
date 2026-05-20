package service;

import dao.SuperAdminDAO;
import model.User;
import java.util.List;
import java.util.Map;

public class SuperAdminService {
    private SuperAdminDAO superAdminDAO = new SuperAdminDAO();

    public Map<String, Integer> getSystemStats() {
        return superAdminDAO.getSystemStats();
    }

    public List<User> getAllUsers() {
        return superAdminDAO.getAllUsers();
    }

    public boolean updateUserStatus(int userId, String status) {
        return superAdminDAO.updateUserStatus(userId, status);
    }

    public boolean updateUserRoleAndDept(int userId, int roleId, Integer deptId) {
        return superAdminDAO.updateUserRoleAndDept(userId, roleId, deptId);
    }

    public boolean createOfficialUser(User user) {
        return superAdminDAO.createOfficialUser(user);
    }

    public List<Map<String, String>> getSystemActivities() {
        return superAdminDAO.getSystemActivities();
    }

    public boolean addDepartment(String name) {
        if (name == null || name.trim().isEmpty()) return false;
        return superAdminDAO.addDepartment(name.trim());
    }

    public boolean updateDepartment(int id, String name) {
        if (name == null || name.trim().isEmpty()) return false;
        return superAdminDAO.updateDepartment(id, name.trim());
    }

    public boolean deleteDepartment(int id) {
        return superAdminDAO.deleteDepartment(id);
    }

    public Map<Integer, Integer> getDepartmentOfficerCounts() {
        return superAdminDAO.getDepartmentOfficerCounts();
    }

    public boolean deleteUser(int id) {
        return superAdminDAO.deleteUser(id);
    }
}
