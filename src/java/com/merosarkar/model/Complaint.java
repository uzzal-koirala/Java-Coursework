package com.merosarkar.model;

import java.sql.Timestamp;

public class Complaint {
    private int id;
    private int citizenId;
    private String officialRole;
    private String subject;
    private String description;
    private String status;
    private Timestamp createdAt;

    // Constructors
    public Complaint() {}

    public Complaint(int id, int citizenId, String officialRole, String subject, String description, String status, Timestamp createdAt) {
        this.id = id;
        this.citizenId = citizenId;
        this.officialRole = officialRole;
        this.subject = subject;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCitizenId() { return citizenId; }
    public void setCitizenId(int citizenId) { this.citizenId = citizenId; }

    public String getOfficialRole() { return officialRole; }
    public void setOfficialRole(String officialRole) { this.officialRole = officialRole; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
