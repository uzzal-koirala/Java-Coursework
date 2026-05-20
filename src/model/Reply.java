package model;

import java.sql.Timestamp;

public class Reply {
    private int id;
    private int gunasoId;
    private int userId;
    private String message;
    private Timestamp createdAt;

    // Join fields
    private String userName;
    private String roleName;

    public Reply() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getGunasoId() { return gunasoId; }
    public void setGunasoId(int gunasoId) { this.gunasoId = gunasoId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
}
