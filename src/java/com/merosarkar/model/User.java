package com.merosarkar.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String fullName;
    private String phoneNumber;
    private String passwordHash;
    private String role;
    private String status;
    private String profilePic;
    private Timestamp createdAt;

    // Constructors
    public User() {}

    public User(int id, String fullName, String phoneNumber, String passwordHash, String role, String status, String profilePic, Timestamp createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.passwordHash = passwordHash;
        this.role = role;
        this.status = status;
        this.profilePic = profilePic;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getProfilePic() { return profilePic; }
    public void setProfilePic(String profilePic) { this.profilePic = profilePic; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
