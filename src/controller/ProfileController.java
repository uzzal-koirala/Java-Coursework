package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet({"/user/profile/update", "/user/profile/theme"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfileController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/user/profile/theme".equals(path)) {
            String themeMode = request.getParameter("themeMode");
            String activeTheme = "dark".equals(themeMode) ? "dark" : "light";
            request.getSession().setAttribute("userThemeMode", activeTheme);
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
            return;
        }

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String citizenshipNo = request.getParameter("citizenshipNo");
        
        // Handle file uploads
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        File fileSaveDir = new File(uploadFilePath);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        String avatarPath = user.getAvatar();
        String citizenshipPhotoPath = user.getCitizenshipPhoto();

        try {
            Part avatarPart = request.getPart("avatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(avatarPart);
                avatarPart.write(uploadFilePath + File.separator + fileName);
                avatarPath = UPLOAD_DIR + "/" + fileName;
            }

            Part citizenshipPart = request.getPart("citizenshipPhoto");
            if (citizenshipPart != null && citizenshipPart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(citizenshipPart);
                citizenshipPart.write(uploadFilePath + File.separator + fileName);
                citizenshipPhotoPath = UPLOAD_DIR + "/" + fileName;
            }

            boolean success = userDAO.updateProfile(user.getId(), citizenshipNo, citizenshipPhotoPath, avatarPath);
            
            if (success) {
                // Update session object
                user.setCitizenshipNo(citizenshipNo);
                user.setCitizenshipPhoto(citizenshipPhotoPath);
                user.setAvatar(avatarPath);
                user.setVerificationStatus("Pending");
                request.getSession().setAttribute("user", user);
                request.getSession().setAttribute("success", "Profile updated. Verification is now Pending.");
            } else {
                request.getSession().setAttribute("error", "Failed to update profile.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error uploading files: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
