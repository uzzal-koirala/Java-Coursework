<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | Gunaso Management System – Government of Nepal</title>
    <meta name="description" content="Learn about the Gunaso Management System, Nepal's official civic complaint portal connecting citizens to government authorities.">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/landing.css">
    <link rel="stylesheet" href="css/about.css">
</head>
<body>

    <!-- ===== NAVBAR ===== -->
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
            <a href="about.jsp" class="active">About</a>
            <a href="contact.jsp">Contact</a>
            <a href="auth/login.jsp" class="btn-login">Login</a>
            <a href="auth/register.jsp" class="btn-register">Register</a>
        </div>
    </nav>



    <!-- ===== MAIN ABOUT SECTION ===== -->
    <section class="about-main-section">
        <div class="about-main-container">

            <!-- Left: Text Content -->
            <div class="about-main-left">
                <span class="about-section-tag">Who We Are</span>
                <h2 class="about-main-heading">
                    Empowering Citizens,<br>
                    <span class="text-red">Transforming Governance.</span>
                </h2>
                <p class="about-main-desc">
                    The <strong>Gunaso Management System</strong> is Nepal's official, government-backed digital portal for civic grievance management. Built on Java EE MVC architecture, it provides a secure, transparent, and efficient platform where citizens can formally register complaints against public service failures and track their resolution in real time.
                </p>
                <p class="about-main-desc">
                    The system connects citizens directly to responsible authorities, such as Wada Adakshya, Nagar Pramukh, Prime Minister's Office, and other departments, eliminating bureaucratic delays and ensuring accountability at every level of governance.
                </p>
                <div class="about-main-actions">
                    <a href="auth/register.jsp" class="btn-about-primary">
                        <i class="fa-solid fa-file-circle-plus"></i> File a Complaint
                    </a>
                    <div class="about-phone-cta">
                        <div class="phone-icon-wrap">
                            <i class="fa-solid fa-phone"></i>
                        </div>
                        <div>
                            <span>Call Us Now</span>
                            <strong>+977-01-4200000</strong>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: Overlapping Images + Badge -->
            <div class="about-main-right">
                <div class="about-img-stack">
                    <div class="about-img-main">
                        <img src="images/sitalniwash.png" alt="Sital Niwash Government of Nepal">
                    </div>
                    <div class="about-img-secondary">
                        <img src="images/peopleonfile.png" alt="Citizen Administrative Files">
                    </div>
                    <div class="about-exp-badge">
                        <strong>10+</strong>
                        <span>Years Of<br>Service</span>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- ===== FEATURES ROW ===== -->
    <section class="about-features-row">
        <div class="about-features-container">
            <div class="about-feature-item">
                <div class="feature-icon-wrap">
                    <i class="fa-solid fa-scale-balanced"></i>
                </div>
                <div class="feature-text">
                    <h3>Transparency &amp; Accountability</h3>
                    <p>Every complaint is logged with a unique ID, time-stamped, and publicly tracked. No complaint falls through the cracks.</p>
                </div>
            </div>
            <div class="about-feature-divider"></div>
            <div class="about-feature-item">
                <div class="feature-icon-wrap feature-icon-red">
                    <i class="fa-solid fa-bolt-lightning"></i>
                </div>
                <div class="feature-text">
                    <h3>Swift Resolution Pipeline</h3>
                    <p>Automated routing sends each complaint directly to the responsible authority for fastest possible government response.</p>
                </div>
            </div>
            <div class="about-feature-divider"></div>
            <div class="about-feature-item">
                <div class="feature-icon-wrap">
                    <i class="fa-solid fa-users-gear"></i>
                </div>
                <div class="feature-text">
                    <h3>Comprehensive Role System</h3>
                    <p>Five distinct roles—Citizen, Wada Adakshya, Nagar Pramukh, Prime Minister, and Super Admin—each with a dedicated dashboard.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== MISSION & VISION SECTION ===== -->
    <section class="about-mv-section">
        <div class="about-mv-inner">
            <div class="about-mv-header">
                <span class="about-section-tag">Our Purpose</span>
                <h2>Our Mission <span class="text-red">&amp;</span> Vision</h2>
                <p>Guided by the principles of transparent governance and citizen-first service, Gunaso exists to make Nepal's public administration more responsive and accountable.</p>
            </div>
            <div class="about-mv-grid">
                <!-- Mission -->
                <div class="about-mv-card blue-card">
                    <div class="mv-card-icon"><i class="fa-solid fa-bullseye"></i></div>
                    <h3>Our Mission</h3>
                    <p>To provide every citizen of Nepal with a powerful, accessible, and secure digital platform to raise civic grievances, ensuring that no complaint goes unheard and every government authority is held accountable for timely resolution through a transparent, role-based system.</p>
                </div>
                <!-- Vision -->
                <div class="about-mv-card light-card">
                    <div class="mv-card-icon"><i class="fa-solid fa-eye"></i></div>
                    <h3>Our Vision</h3>
                    <p>To become Nepal's leading civic technology platform, creating a nation where every citizen has a direct, digital voice in governance, and where government authorities proactively respond to public needs, building a culture of trust, transparency, and democratic accountability across all 7 provinces and 753 municipalities.</p>
                </div>
                <!-- Values Wide Card -->
                <div class="about-mv-card red-card mv-card-wide">
                    <div style="display:flex; align-items:center; gap:20px; flex-wrap:wrap;">
                        <div class="mv-card-icon"><i class="fa-solid fa-shield-halved"></i></div>
                        <div>
                            <h3 style="margin-bottom:8px;">Our Core Values</h3>
                            <p style="max-width:900px;">Transparency in every action &nbsp;·&nbsp; Accountability at every level &nbsp;·&nbsp; Equity for every citizen &nbsp;·&nbsp; Integrity in public service &nbsp;·&nbsp; Innovation for better governance</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== WHY WE WERE CREATED SECTION ===== -->
    <section class="about-why-section">
        <div class="about-why-container">
            <!-- Left: Explanation -->
            <div class="about-why-left">
                <span class="about-section-tag">The Problem We Solve</span>
                <h2>Why Gunaso <span class="text-red">Was Created</span></h2>
                <p>Nepal's citizens have long faced a fragmented, slow, and opaque system of lodging complaints against government services. Physical visits, lost paperwork, unclear status updates, and a lack of accountability left millions of grievances unresolved.</p>
                <p>Gunaso was created to solve these exact problems by digitising and centralising the entire complaint lifecycle from submission to resolution, bringing the government closer to its citizens.</p>
            </div>
            <!-- Right: Problem Cards -->
            <div class="about-problem-cards">
                <div class="problem-card">
                    <div class="problem-num"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div>
                        <h4>No Centralised Platform</h4>
                        <p>Citizens had no single trusted portal to submit complaints to the right authority, such as Wada, Municipality, or Prime Minister's Office, causing misdirection and delays.</p>
                    </div>
                </div>
                <div class="problem-card">
                    <div class="problem-num"><i class="fa-solid fa-clock"></i></div>
                    <div>
                        <h4>Zero Transparency in Status</h4>
                        <p>Once a complaint was filed physically, citizens had no way to track its progress, know who was handling it, or when it would be resolved.</p>
                    </div>
                </div>
                <div class="problem-card">
                    <div class="problem-num"><i class="fa-solid fa-user-slash"></i></div>
                    <div>
                        <h4>No Authority Accountability</h4>
                        <p>Without a formal digital record, government officials faced little accountability. Complaints could be ignored, lost, or delayed without consequence.</p>
                    </div>
                </div>
                <div class="problem-card">
                    <div class="problem-num"><i class="fa-solid fa-mountain-city"></i></div>
                    <div>
                        <h4>Geographic Barriers</h4>
                        <p>Citizens in remote wards and rural municipalities had no practical means to reach higher authorities, but Gunaso removes those barriers entirely.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== COMPETENCE SECTION ===== -->
    <section class="about-competence-section">
        <div class="about-competence-container">

            <!-- Left: Image -->
            <div class="competence-img-wrap">
                <img src="images/primisiterofficeimage.png" alt="Office of the Prime Minister Nepal">
                <div class="competence-img-badge">
                    <i class="fa-solid fa-circle-check"></i>
                    <span>ISO Certified<br>Govt. Portal</span>
                </div>
            </div>

            <!-- Right: Content -->
            <div class="competence-content">
                <span class="about-section-tag">Our Capabilities</span>
                <h2 class="competence-heading">
                    Our Government-Backed<br>
                    <span class="text-red">Civic Competence</span>
                </h2>
                <p class="competence-desc">
                    Gunaso is built on a foundation of secure MVC architecture, JDBC-powered MySQL databases, and Java EE Servlet technology, engineered to handle thousands of concurrent citizen requests with zero data loss.
                </p>
                <div class="competence-list-grid">
                    <ul class="competence-list">
                        <li><i class="fa-solid fa-circle-dot"></i> Complaint Submission Portal</li>
                        <li><i class="fa-solid fa-circle-dot"></i> Multi-Authority Routing</li>
                        <li><i class="fa-solid fa-circle-dot"></i> Real-Time Status Tracking</li>
                    </ul>
                    <ul class="competence-list">
                        <li><i class="fa-solid fa-circle-dot"></i> Role-Based Dashboards</li>
                        <li><i class="fa-solid fa-circle-dot"></i> Secure Session Management</li>
                        <li><i class="fa-solid fa-circle-dot"></i> 24/7 Citizen Support</li>
                    </ul>
                </div>
                <a href="auth/register.jsp" class="btn-competence-cta">
                    Get Started Now <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>

        </div>
    </section>

    <!-- ===== STATS BANNER ===== -->
    <section class="about-stats-section">
        <div class="about-stats-container">
            <div class="about-stat-item">
                <strong>753+</strong>
                <span>Municipalities Connected</span>
            </div>
            <div class="stat-sep"></div>
            <div class="about-stat-item">
                <strong>124K+</strong>
                <span>Complaints Resolved</span>
            </div>
            <div class="stat-sep"></div>
            <div class="about-stat-item">
                <strong>98%</strong>
                <span>Citizen Satisfaction Rate</span>
            </div>
            <div class="stat-sep"></div>
            <div class="about-stat-item">
                <strong>7</strong>
                <span>Provinces Covered</span>
            </div>
        </div>
    </section>

    <!-- ===== EXPERT TEAM SECTION ===== -->
    <section class="about-team-section">
        <div class="about-team-header">
            <h2>Project <span class="text-red">Team &amp; Leadership</span></h2>
            <p>Meet the visionary developers and government administrators behind the Gunaso platform, ensuring secure backend operations and swift grievance management.</p>
        </div>
        <div class="about-team-wrapper">
            <div class="about-team-grid">

                <!-- ===== SET 1 ===== -->
                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/uzzalkoirala.png" alt="Ujwal Koirala">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Backend Architect</span>
                        <h4>Ujwal Koirala</h4>
                        <p class="team-desc">Designed secure MVC backend with Session Management, authentication filters, and industry-standard BCrypt hashing.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/kiran.png" alt="Kiran Bardewa">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Documentation Lead</span>
                        <h4>Kiran Bardewa</h4>
                        <p class="team-desc">Chaired the documentation process and requirements analysis, compiling the technical report justifying Servlets and JSTL.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/roshan.jpg" alt="Roshan Katel">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Frontend Designer</span>
                        <h4>Roshan Katel</h4>
                        <p class="team-desc">Created the frontend design using JSP and CSS3, concentrating on building a responsive and user-friendly experience for the landing page and registration portal.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/rojina.png" alt="Rojina Rijal">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Java Developer</span>
                        <h4>Rojina Rijal</h4>
                        <p class="team-desc">Designed Java business logic objects, applied CRUD operations to grievance management, and integrated JSTL/EL in the view layer to dynamically view complaint data.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/manjila.png" alt="Manjila Shrestha">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Database Engineer</span>
                        <h4>Manjila Shrestha</h4>
                        <p class="team-desc">Led database design and logical ER diagrams mapping government and citizen entities, optimizing tables to 3NF standards to eliminate data redundancy.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/dweep.png" alt="Dweep Limbukhim">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Database Administrator</span>
                        <h4>Dweep Limbukhim</h4>
                        <p class="team-desc">Managed MySQL physical database implementation and complex SQL schemas, running system-wide tests to verify data integrity and optimal frontend-backend communication.</p>
                    </div>
                </div>

                <!-- ===== SET 2 (DUPLICATED FOR INFINITE LOOP) ===== -->
                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/uzzalkoirala.png" alt="Ujwal Koirala">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Backend Architect</span>
                        <h4>Ujwal Koirala</h4>
                        <p class="team-desc">Designed secure MVC backend with Session Management, authentication filters, and industry-standard BCrypt hashing.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/kiran.png" alt="Kiran Bardewa">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Documentation Lead</span>
                        <h4>Kiran Bardewa</h4>
                        <p class="team-desc">Chaired the documentation process and requirements analysis, compiling the technical report justifying Servlets and JSTL.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/roshan.jpg" alt="Roshan Katel">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Frontend Designer</span>
                        <h4>Roshan Katel</h4>
                        <p class="team-desc">Created the frontend design using JSP and CSS3, concentrating on building a responsive and user-friendly experience for the landing page and registration portal.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/rojina.png" alt="Rojina Rijal">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Java Developer</span>
                        <h4>Rojina Rijal</h4>
                        <p class="team-desc">Designed Java business logic objects, applied CRUD operations to grievance management, and integrated JSTL/EL in the view layer to dynamically view complaint data.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/manjila.png" alt="Manjila Shrestha">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Database Engineer</span>
                        <h4>Manjila Shrestha</h4>
                        <p class="team-desc">Led database design and logical ER diagrams mapping government and citizen entities, optimizing tables to 3NF standards to eliminate data redundancy.</p>
                    </div>
                </div>

                <div class="team-card">
                    <div class="team-card-img">
                        <img src="images/dweep.png" alt="Dweep Limbukhim">
                        <div class="team-card-overlay">
                            <div class="team-socials">
                                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                                <a href="#"><i class="fa-solid fa-envelope"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="team-card-info">
                        <span class="team-role">Database Administrator</span>
                        <h4>Dweep Limbukhim</h4>
                        <p class="team-desc">Managed MySQL physical database implementation and complex SQL schemas, running system-wide tests to verify data integrity and optimal frontend-backend communication.</p>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ===== FAQ SECTION ===== -->
    <section class="faq-section" id="faq-section">
        <div class="faq-container">

            <!-- Left Column -->
            <div class="faq-left">
                <span class="faq-tag">
                    <i class="fa-solid fa-circle-question"></i> Your Questions, Answered
                </span>
                <h2 class="faq-heading">
                    Frequently<br>
                    Asked <span class="text-red-faq">Questions</span>
                </h2>
                <p class="faq-intro">
                    The Gunaso Management System is Nepal's official civic grievance portal. We help you submit, track, and resolve complaints with government authorities across all 7 provinces, making complaint resolution faster, simpler, and smarter.
                </p>

                <!-- Still Have Questions Card -->
                <div class="faq-still-card">
                    <h3>Still Have Questions?</h3>
                    <p>We understand that every citizen has unique concerns. If there's anything you'd like to clarify about our portal features, complaint tracking, or how Gunaso fits into your governance needs, our support team is here to help.</p>
                    <p>Reach out anytime, and we'll guide you through every step to make sure you get the most out of the portal.</p>
                    <a href="contact.jsp" class="btn-faq-cta">Contact Support</a>
                </div>
            </div>

            <!-- Right Column: FAQ Accordion -->
            <div class="faq-right">

                <div class="faq-item active" id="faq1">
                    <button class="faq-question" onclick="toggleFaq('faq1')">
                        <span>What is the Gunaso Management System?</span>
                        <i class="fa-solid fa-chevron-up faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Gunaso is Nepal's official government-backed digital portal that allows citizens to submit, track, and resolve civic complaints. It connects citizens directly to Wada Adakshya, Nagar Pramukh, Prime Minister's Office, and other government authorities through a secure, transparent system.</p>
                    </div>
                </div>

                <div class="faq-item" id="faq2">
                    <button class="faq-question" onclick="toggleFaq('faq2')">
                        <span>How do I submit a complaint?</span>
                        <i class="fa-solid fa-chevron-up faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Simply register an account, log in as a citizen, and navigate to your user dashboard. Click "File a Complaint," fill in the details — category, description, priority, and supporting documents — then submit. You'll receive a unique tracking ID immediately.</p>
                    </div>
                </div>

                <div class="faq-item" id="faq3">
                    <button class="faq-question" onclick="toggleFaq('faq3')">
                        <span>Is my personal data safe on this portal?</span>
                        <i class="fa-solid fa-chevron-up faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Yes. We use enterprise-grade session management, role-based access control, and secured JDBC connections to protect your information. Your data is handled exclusively by authorised government officials and belongs to you, always.</p>
                    </div>
                </div>

                <div class="faq-item" id="faq4">
                    <button class="faq-question" onclick="toggleFaq('faq4')">
                        <span>Which authorities can review my complaint?</span>
                        <i class="fa-solid fa-chevron-up faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Based on your complaint category and location, it will be routed to the appropriate authority — Wada Adakshya for ward-level issues, Nagar Pramukh for municipality-level concerns, or the Prime Minister's Office for national-level matters. Super Admin oversees the entire system.</p>
                    </div>
                </div>

                <div class="faq-item" id="faq5">
                    <button class="faq-question" onclick="toggleFaq('faq5')">
                        <span>Can I track the status of my complaint?</span>
                        <i class="fa-solid fa-chevron-up faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Absolutely. After filing, log in to your citizen dashboard at any time to see the real-time status — Pending, Under Review, In Progress, or Resolved. You will also receive official replies from government authorities directly through the portal.</p>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ===== PRE-FOOTER CTA ===== -->
    <div class="pre-footer">
        <div class="pre-footer-inner">
            <div class="pre-footer-content">
                <h4>Need Help?</h4>
                <h2>Don't hesitate to contact us for more information about the portal.</h2>
            </div>
            <a href="contact.jsp" class="btn-contact-outline">CONTACT US</a>
        </div>
    </div>

    <!-- ===== MAIN FOOTER ===== -->
    <footer class="site-footer">
        <div class="footer-grid">
            <div class="footer-col footer-about">
                <div class="footer-logo-brand">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/2/23/Emblem_of_Nepal.svg" alt="Emblem of Nepal">
                    <div class="footer-brand-text">
                        <h4>Government of Nepal</h4>
                        <span>Gunaso Portal</span>
                    </div>
                </div>
                <h3>About Gunaso</h3>
                <p>We create a transparent, effective bridge between citizens and the government. From feedback to grievance resolution, we help you get heard.</p>
                <div class="footer-socials">
                    <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                    <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                    <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#"><i class="fa-brands fa-youtube"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h3>Support</h3>
                <ul class="footer-links">
                    <li><a href="#">Ticket Support</a></li>
                    <li><a href="#">Help Center</a></li>
                    <li><a href="about.jsp#faq-section">FAQ</a></li>
                    <li><a href="contact.jsp">Contact Us</a></li>
                    <li><a href="#">Community</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h3>Government</h3>
                <ul class="footer-links">
                    <li><a href="about.jsp">About Us</a></li>
                    <li><a href="#">Leadership</a></li>
                    <li><a href="#">Careers</a></li>
                    <li><a href="#">News &amp; Articles</a></li>
                    <li><a href="#">Legal Notice</a></li>
                </ul>
            </div>
            <div class="footer-col footer-newsletter">
                <h3>Newsletter</h3>
                <p>Subscribe to our newsletter to receive the latest updates directly in your inbox.</p>
                <div class="newsletter-form">
                    <input type="text" placeholder="Name">
                    <input type="email" placeholder="Email">
                </div>
                <button class="btn-newsletter">SIGN UP NEWSLETTER</button>
            </div>
        </div>
        <div class="footer-bottom">
            <div class="copyright">
                Copyright &copy; <%= java.time.Year.now().getValue() %> Government of Nepal, All rights reserved.
            </div>
            <div class="footer-bottom-links">
                <a href="#">Sitemap</a>
                <a href="#">Privacy policy</a>
                <a href="#">Cookie policy</a>
            </div>
        </div>
    </footer>

    <script>
        function toggleFaq(id) {
            const allItems = document.querySelectorAll('.faq-item');
            allItems.forEach(item => {
                if (item.id !== id) {
                    item.classList.remove('active');
                }
            });
            const target = document.getElementById(id);
            target.classList.toggle('active');
        }
    </script>

</body>
</html>
