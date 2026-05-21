<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | Gunaso Management System – Government of Nepal</title>
    
    <!-- External Icon & Typography Assets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Stylesheet Layers -->
    <link rel="stylesheet" href="css/landing.css">
    <link rel="stylesheet" href="css/about.css">
    <link rel="stylesheet" href="css/contact.css">
</head>
<body>

    <!-- ===== HEADER NAVIGATION ===== -->
    <nav class="navbar">
        <div class="brand">
            <img src="https://upload.wikimedia.org/wikipedia/commons/2/23/Emblem_of_Nepal.svg" alt="Emblem of Nepal">
            <div class="brand-text">
                <h1>Government of Nepal</h1>
                <span>Gunaso Management System</span>
            </div>
        </div>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="about.jsp">About</a>
            <a href="contact.jsp" class="active">Contact</a>
            <a href="auth/login.jsp" class="btn-login">Login</a>
            <a href="auth/register.jsp" class="btn-register">Register</a>
        </div>
    </nav>

    <!-- ===== CONTACT MAIN LAYOUT ===== -->
    <section class="contact-main-section">
        <div class="contact-container">
            
            <!-- Top Intro Header -->
            <div class="contact-intro-header">
                <span class="contact-badge">
                    <i class="fa-solid fa-headset"></i> Civic Redressal &amp; Support Hub
                </span>
                <h1>Connect With Our <span class="text-red">Support Team</span></h1>
                <p>Have questions about filing complaints, processing timelines, or coordinating with provincial ministries? Send us a direct query or reach our dedicated support lines.</p>
            </div>

            <!-- Two Column Interactive Grid -->
            <div class="contact-grid">
                
                <!-- Left Panel: Official Information -->
                <div class="contact-info-panel">
                    <div>
                        <h2>Contact Information</h2>
                        <p class="info-tagline">Official contact coordinates for the central administration of the Gunaso platform in Kathmandu.</p>
                        
                        <div class="info-items-list">
                            
                            <!-- Location -->
                            <div class="info-card-item">
                                <div class="info-icon-badge">
                                    <i class="fa-solid fa-location-dot"></i>
                                </div>
                                <div class="info-text-details">
                                    <h3>Office Location</h3>
                                    <p>Singha Durbar, Kathmandu, Nepal</p>
                                </div>
                            </div>

                            <!-- Phone -->
                            <div class="info-card-item">
                                <div class="info-icon-badge">
                                    <i class="fa-solid fa-phone-volume"></i>
                                </div>
                                <div class="info-text-details">
                                    <h3>Helpline Support</h3>
                                    <p>+977-1-4211000 (Toll Free support)</p>
                                    <span class="highlight-time">Direct citizen hotline available</span>
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="info-card-item">
                                <div class="info-icon-badge">
                                    <i class="fa-solid fa-envelope-open-text"></i>
                                </div>
                                <div class="info-text-details">
                                    <h3>Electronic Mail</h3>
                                    <p>support@gunaso.gov.np</p>
                                </div>
                            </div>

                            <!-- Working Hours -->
                            <div class="info-card-item">
                                <div class="info-icon-badge">
                                    <i class="fa-solid fa-business-time"></i>
                                </div>
                                <div class="info-text-details">
                                    <h3>Working Hours</h3>
                                    <p>Sunday to Friday, 10:00 AM to 5:00 PM</p>
                                    <span class="highlight-time">Except government public holidays</span>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- Social Channels Block -->
                    <div class="info-social-block">
                        <h4>Official Government Channels</h4>
                        <div class="social-circle-links">
                            <a href="#" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
                            <a href="#" aria-label="Twitter"><i class="fa-brands fa-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="fa-brands fa-linkedin-in"></i></a>
                            <a href="#" aria-label="YouTube"><i class="fa-brands fa-youtube"></i></a>
                        </div>
                    </div>

                </div>

                <!-- Right Panel: Message Submission Form -->
                <div class="contact-form-panel">
                    <h2>Send Us a Message</h2>
                    <p class="form-tagline">Fill out your details below and our public relation desk will process your inquiry within two working days.</p>
                    
                    <form class="contact-message-form" action="#" method="POST" onsubmit="event.preventDefault(); alert('Inquiry successfully recorded. Our public desk will get back to you shortly.');">
                        <div class="form-grid">
                            
                            <!-- Full Name -->
                            <div class="input-container">
                                <i class="fa-solid fa-user field-icon"></i>
                                <input type="text" placeholder="Your Full Name" required>
                            </div>

                            <!-- Email Address -->
                            <div class="input-container">
                                <i class="fa-solid fa-envelope field-icon"></i>
                                <input type="email" placeholder="Your Email Address" required>
                            </div>

                            <!-- Phone Number -->
                            <div class="input-container">
                                <i class="fa-solid fa-phone field-icon"></i>
                                <input type="tel" placeholder="Your Contact Number" required>
                            </div>

                            <!-- Query Subject -->
                            <div class="input-container">
                                <i class="fa-solid fa-heading field-icon"></i>
                                <input type="text" placeholder="Subject of Inquiry" required>
                            </div>

                            <!-- Message Content -->
                            <div class="input-container full-width">
                                <i class="fa-solid fa-pen-fancy field-icon"></i>
                                <textarea placeholder="Describe your issue or feedback in detail..." required></textarea>
                            </div>

                        </div>

                        <!-- Action Submit Button -->
                        <button type="submit" class="btn-submit-message">
                            <span>SEND MESSAGE</span>
                            <i class="fa-solid fa-paper-plane"></i>
                        </button>
                    </form>
                </div>

            </div>

            <!-- ===== INTERACTIVE DISTRICT COORDINATION MAP ===== -->
            <div class="contact-map-section">
                
                <div class="map-header">
                    <h3>
                        <i class="fa-solid fa-map-location-dot"></i> 
                        District &amp; Provincial Coordination Grid
                    </h3>
                    <div class="map-status-pill">
                        <div class="pulse-dot"></div>
                        <span>Live Telemetry Node Active</span>
                    </div>
                </div>

                <!-- Interactive Map Canvas visual mockup -->
                <div class="map-canvas-visual">
                    <div class="map-grid-pattern"></div>
                    <div class="map-nepal-outline"></div>
                    
                    <!-- Kathmandu Marker -->
                    <div class="map-location-marker marker-kathmandu">
                        <div class="marker-pin"></div>
                        <div class="marker-label">Kathmandu (Central HQ)</div>
                    </div>

                    <!-- Pokhara Marker -->
                    <div class="map-location-marker marker-pokhara">
                        <div class="marker-pin"></div>
                        <div class="marker-label">Pokhara Node</div>
                    </div>

                    <!-- Biratnagar Marker -->
                    <div class="map-location-marker marker-biratnagar">
                        <div class="marker-pin"></div>
                        <div class="marker-label">Biratnagar Node</div>
                    </div>

                    <!-- Nepalgunj Marker -->
                    <div class="map-location-marker marker-nepalgunj">
                        <div class="marker-pin"></div>
                        <div class="marker-label">Nepalgunj Node</div>
                    </div>

                    <!-- Side Telemetry Card Mockup inside map -->
                    <div class="map-popup-window">
                        <h4>Provincial Telemetry</h4>
                        <p>Singha Durbar main server coordinates verified. Dynamic connection to Biratnagar, Pokhara, and Nepalgunj administrative node routing tables enabled.</p>
                        <span class="status"><i class="fa-solid fa-circle-check"></i> System Operational</span>
                    </div>

                    <!-- Compass visual graphic -->
                    <div class="map-compass-visual">
                        <i class="fa-solid fa-compass fa-spin fa-3x" style="color: var(--primary); --fa-animation-duration: 25s;"></i>
                    </div>

                </div>

            </div>

        </div>
    </section>

    <!-- Public Footer -->
    <jsp:include page="components/public-footer.jsp" />

</body>
</html>
