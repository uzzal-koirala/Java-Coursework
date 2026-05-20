package service;

import dao.GunasoDAO;
import model.Gunaso;
import model.Department;
import java.util.List;

public class GunasoService {
    private GunasoDAO gunasoDAO = new GunasoDAO();

    public boolean submitGunaso(Gunaso gunaso) {
        return gunasoDAO.addGunaso(gunaso);
    }

    public List<Gunaso> getMyGunasos(int userId) {
        return gunasoDAO.getGunasoByUserId(userId);
    }

    public List<Gunaso> getAssignedGunasos(int deptId) {
        return gunasoDAO.getGunasoByDeptId(deptId);
    }

    public List<Gunaso> getAllGunasos() {
        return gunasoDAO.getAllGunasos();
    }

    public boolean updateStatus(int gunasoId, String status) {
        return gunasoDAO.updateStatus(gunasoId, status);
    }

    public List<Department> getDepartments() {
        return gunasoDAO.getAllDepartments();
    }
}
