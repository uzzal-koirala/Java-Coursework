package model;

import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

public class SarkarUpdate {
    private int id;
    private int userId;
    private String content;
    private String photoUrl;
    private String status;
    private Timestamp createdAt;

    // Join fields
    private String userFullName;
    private String userAvatar;
    private String userRoleName;
    private String userDeptName;

    // Derived fields
    private int likeCount;
    private int commentCount;
    private boolean likedByCurrentUser;
    private List<UpdateComment> comments = new ArrayList<>();

    public SarkarUpdate() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getPhotoUrl() { return photoUrl; }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }

    public String getUserAvatar() { return userAvatar; }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }

    public String getUserRoleName() { return userRoleName; }
    public void setUserRoleName(String userRoleName) { this.userRoleName = userRoleName; }

    public String getUserDeptName() { return userDeptName; }
    public void setUserDeptName(String userDeptName) { this.userDeptName = userDeptName; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }

    public boolean isLikedByCurrentUser() { return likedByCurrentUser; }
    public void setLikedByCurrentUser(boolean likedByCurrentUser) { this.likedByCurrentUser = likedByCurrentUser; }

    public List<UpdateComment> getComments() { return comments; }
    public void setComments(List<UpdateComment> comments) { this.comments = comments; }
}
// Done by Manjila