package model;

import java.sql.Timestamp;

public class UpdateComment {
    private int id;
    private int updateId;
    private int userId;
    private String comment;
    private Timestamp createdAt;

    // Join fields
    private String userFullName;
    private String userAvatar;
    private String userRoleName;

    public UpdateComment() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUpdateId() { return updateId; }
    public void setUpdateId(int updateId) { this.updateId = updateId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }

    public String getUserAvatar() { return userAvatar; }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }

    public String getUserRoleName() { return userRoleName; }
    public void setUserRoleName(String userRoleName) { this.userRoleName = userRoleName; }
}
