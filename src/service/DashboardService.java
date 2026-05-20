package service;

import dao.DashboardDAO;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardService {
    
    private DashboardDAO dashboardDAO;

    public DashboardService() {
        this.dashboardDAO = new DashboardDAO();
    }
    
    /**
     * Compiles a comprehensive dashboard data package for an administrator.
     * Contains multiple analytics streams combined into one map.
     */
    public Map<String, Object> compileAdminDashboardMetrics() {
        Map<String, Object> dashboardData = new HashMap<>();
        
        // 1. Core Summary Stats
        Map<String, Integer> summaryStats = dashboardDAO.getAdminGunasoSummary();
        dashboardData.put("summaryStats", summaryStats);
        
        // 2. Compute overall status percentages
        int totalGunaso = 0;
        for (Integer count : summaryStats.values()) {
            totalGunaso += count;
        }
        Map<String, Double> percentageStats = new HashMap<>();
        if (totalGunaso > 0) {
            for (Map.Entry<String, Integer> entry : summaryStats.entrySet()) {
                double pct = ((double) entry.getValue() / totalGunaso) * 100.0;
                percentageStats.put(entry.getKey(), Math.round(pct * 10.0) / 10.0);
            }
        }
        dashboardData.put("percentageStats", percentageStats);
        
        // 3. System Load Metrics
        int activeUsers = dashboardDAO.getActiveUserCount();
        dashboardData.put("activeUsers", activeUsers);
        
        // 4. Performance KPIs
        double resolutionRate = dashboardDAO.getMonthlyResolutionRate();
        double avgResponseTime = dashboardDAO.getAverageResponseTimeHours();
        
        dashboardData.put("monthlyResolutionRate", Math.round(resolutionRate * 10.0) / 10.0);
        dashboardData.put("avgResponseTimeHours", Math.round(avgResponseTime * 10.0) / 10.0);
        
        // 5. Department Breakdown
        Map<String, Integer> deptStats = dashboardDAO.getComplaintsByDepartment();
        dashboardData.put("departmentBreakdown", deptStats);
        
        // 6. Recent Timeline
        List<Map<String, Object>> timeline = dashboardDAO.getRecentActivities(15);
        dashboardData.put("timeline", timeline);
        
        return dashboardData;
    }
    
    /**
     * Compiles dashboard metrics specifically for a single user (Citizen or Authority).
     */
    public Map<String, Object> compileUserDashboardMetrics(int userId) {
        Map<String, Object> dashboardData = new HashMap<>();
        
        // 1. Personal Summary
        Map<String, Integer> userSummary = dashboardDAO.getUserGunasoSummary(userId);
        dashboardData.put("userSummary", userSummary);
        
        int totalPersonal = 0;
        for (Integer count : userSummary.values()) {
            totalPersonal += count;
        }
        dashboardData.put("totalPersonalGunaso", totalPersonal);
        
        // 2. Personal Recent Timeline (Fallback to system timeline if needed)
        // Here we just fetch generic timeline, but in a real app it might be filtered
        List<Map<String, Object>> timeline = dashboardDAO.getRecentActivities(5);
        dashboardData.put("timeline", timeline);
        
        return dashboardData;
    }
}
