<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gunaso Management System | Official Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/landing.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="brand">
            <img src="https://upload.wikimedia.org/wikipedia/commons/2/23/Emblem_of_Nepal.svg" alt="Emblem of Nepal">
            <div class="brand-text">
                <h1>Government of Nepal</h1>
                <span>Gunaso Management System</span>
            </div>
        </div>
        <div class="nav-links">
            <a href="index.jsp" class="active">Home</a>
            <a href="about.jsp">About</a>
            <a href="contact.jsp">Contact</a>
            <a href="auth/login.jsp" class="btn-login">Login</a>
            <a href="auth/register.jsp" class="btn-register">Register</a>
        </div>
    </nav>

    <!-- Bento-Box Hero Section -->
    <section class="hero" id="home">
        <div class="hero-container">
            <!-- Left Side: Content -->
            <div class="hero-content">
                <h2 class="bento-headline">Empowering Citizens,<br>Transforming Nepal.</h2>
                <p class="bento-subtext">With Gunaso Management System, master the art of civic engagement<br>as we harness technology to transform your grievance strategy.</p>
                <div class="hero-buttons">
                    <a href="auth/register.jsp" class="btn-solid-primary">Start Now</a>
                    <a href="auth/login.jsp" class="btn-outline-dark">
                        <i class="fa-solid fa-arrow-right"></i> Track Status
                    </a>
                </div>
            </div>

            <!-- Right Side: Bento Box Grid -->
            <div class="bento-grid-wrapper">
                <div class="bento-grid">
                    <!-- Top Left Orange Card -->
                    <div class="bento-card bento-orange-main">
                        <div class="avatars">
                            <img src="https://i.pravatar.cc/150?img=1" alt="User">
                            <img src="https://i.pravatar.cc/150?img=2" alt="User">
                            <img src="https://i.pravatar.cc/150?img=3" alt="User">
                        </div>
                        <h3>124K+</h3>
                        <p>More than 2,000<br>people have joined us</p>
                    </div>
                    
                    <!-- Bottom Left Orange Chart -->
                    <div class="bento-card bento-orange-chart">
                        <p>For Digital<br>Citizenship</p>
                        <i class="fa-solid fa-chart-line chart-icon"></i>
                    </div>

                    <!-- Top Right Vertical Image -->
                    <div class="bento-card bento-img-vertical">
                        <img src="images/heroimg1.png" alt="Hero Image 1">
                    </div>

                    <!-- Bottom Right Horizontal Image -->
                    <div class="bento-card bento-img-horizontal">
                        <img src="images/heroimg2.png" alt="Hero Image 2">
                    </div>

                    <!-- Center Circular Badge -->
                    <div class="bento-center-badge" id="openVideoBtn" style="cursor: pointer;">
                        <div class="badge-inner">
                            <i class="fa-solid fa-play"></i>
                        </div>
                        <svg viewBox="0 0 100 100" class="badge-text">
                            <path id="curve" d="M 50, 50 m -35, 0 a 35,35 0 1,1 70,0 a 35,35 0 1,1 -70,0" fill="transparent" />
                            <text><textPath href="#curve">WATCH VIDEO OF OUR ACTION •</textPath></text>
                        </svg>
                    </div>
                </div>

                <!-- Far Right Floating Stats -->
                <div class="bento-side-stats">
                    <div class="stat-box">
                        <span>satisfied rate</span>
                        <strong>98%</strong>
                    </div>
                    <div class="stat-box">
                        <span>successful projects</span>
                        <strong>14K</strong>
                    </div>
                    <div class="stat-box">
                        <span>problems solved</span>
                        <strong>5,8K</strong>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Redesigned About Section ("Because Your Voice Matters") -->
    <section class="about-section" id="about">
        <div class="about-container">
            <!-- Left: Rounded Image with Overlapping Stats Card -->
            <div class="about-image-wrapper">
                <img src="images/balenrabi.png" alt="Because Your Voice Matters">
                <div class="about-stats-card">
                    <span class="stats-number">753+</span>
                    <span class="stats-label">Municipalities Connected</span>
                    <span class="stats-sub">Active administrative network across all provinces of Nepal.</span>
                </div>
            </div>

            <!-- Right: Content -->
            <div class="about-content">
                <span class="about-tagline">About Gunaso</span>
                <h2 class="about-title">Because Your <br>Voice Matters</h2>
                <p class="about-description">Gunaso is Nepal's dedicated civic response portal, bridging the gap between citizens and local authorities. We ensure every grievance is systematically heard, tracked, and resolved with absolute transparency.</p>

                <a href="about.jsp" class="btn-about">Read More</a>
            </div>
        </div>
    </section>

    <!-- Redesigned How It Works Section (Interactive Roadmap) -->
    <section class="how-it-works" id="how-it-works">
        <div class="benefits-header">
            <span class="about-tagline" style="display: inline-flex !important; width: fit-content !important; margin: 0 auto 12px auto !important; border-radius: 100px !important; padding: 6px 16px !important; background: #fee2e2 !important; color: #b91c1c !important; font-size: 0.85rem !important; font-weight: 700 !important; letter-spacing: 1.5px !important; text-transform: uppercase !important; align-items: center !important; justify-content: center !important;">Grievance Lifecycle</span>
            <h2 class="benefits-main-title">How Your Voice Translates To Action</h2>
        </div>
        
        <div class="roadmap-container">
            <!-- The dynamic connecting timeline path -->
            <div class="roadmap-track">
                <div class="roadmap-progress"></div>
            </div>
            
            <div class="roadmap-steps">
                <!-- Step 1: Secure Registration -->
                <div class="roadmap-step">
                    <div class="step-icon-wrapper">
                        <div class="step-icon-glow"></div>
                        <div class="step-icon">
                            <i class="fa-solid fa-user-plus"></i>
                        </div>
                    </div>
                    <div class="step-content-card">
                        <span class="step-badge">Phase 01</span>
                        <h3>Secure Registration</h3>
                        <p>Create a verified citizen profile securely using your national identification details to unlock the portal.</p>
                    </div>
                </div>
                
                <!-- Step 2: Smart Submission -->
                <div class="roadmap-step">
                    <div class="step-icon-wrapper">
                        <div class="step-icon-glow"></div>
                        <div class="step-icon">
                            <i class="fa-solid fa-file-signature"></i>
                        </div>
                    </div>
                    <div class="step-content-card">
                        <span class="step-badge">Phase 02</span>
                        <h3>Smart Submission</h3>
                        <p>File your complaint details, select target municipal department, and securely upload media evidence.</p>
                    </div>
                </div>
                
                <!-- Step 3: Dynamic Routing -->
                <div class="roadmap-step active">
                    <div class="step-icon-wrapper">
                        <div class="step-icon-glow"></div>
                        <div class="step-icon">
                            <i class="fa-solid fa-route"></i>
                        </div>
                    </div>
                    <div class="step-content-card">
                        <span class="step-badge">Phase 03</span>
                        <h3>Dynamic Routing</h3>
                        <p>Your ticket is automatically triaged, verified, and routed directly to the desk of the concerned ward officer.</p>
                    </div>
                </div>
                
                <!-- Step 4: Verified Resolution -->
                <div class="roadmap-step">
                    <div class="step-icon-wrapper">
                        <div class="step-icon-glow"></div>
                        <div class="step-icon">
                            <i class="fa-solid fa-certificate"></i>
                        </div>
                    </div>
                    <div class="step-content-card">
                        <span class="step-badge">Phase 04</span>
                        <h3>Verified Resolution</h3>
                        <p>Receive formal legally binding resolutions, track audit trials, and rate the efficiency of the department.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="features-header">
            <span class="features-tagline">Portal Capabilities</span>
            <h2 class="features-main-title">Advanced Features for Modern Governance</h2>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon-wrapper"><i class="fa-solid fa-language"></i></div>
                <h3>Multilingual Support</h3>
                <p>Access the portal in Nepali and English for broader accessibility across all demographics.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon-wrapper"><i class="fa-solid fa-bell"></i></div>
                <h3>Real-time Alerts</h3>
                <p>Receive instant SMS and email notifications upon status changes of your lodged grievances.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon-wrapper"><i class="fa-solid fa-map-location-dot"></i></div>
                <h3>Geotagged Evidence</h3>
                <p>Upload photos of public issues with automated GPS tagging for precise location mapping.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon-wrapper"><i class="fa-solid fa-chart-pie"></i></div>
                <h3>Analytics Dashboard</h3>
                <p>Publicly view real-time statistics on government response times and resolution rates.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon-wrapper"><i class="fa-solid fa-user-secret"></i></div>
                <h3>Anonymous Reporting</h3>
                <p>Safely report sensitive issues with our secure identity-masking protocol.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon-wrapper"><i class="fa-solid fa-network-wired"></i></div>
                <h3>Automated Routing</h3>
                <p>Smart algorithm automatically assigns tickets to the most relevant department or ward officer.</p>
            </div>
        </div>
    </section>

    <!-- Redesigned Benefits Section (Bento Grid) -->
    <section class="benefits-section" id="benefits">
        <div class="benefits-header">
            <span class="benefits-tagline">Why Choose Gunaso?</span>
            <h2 class="benefits-main-title">Smarter Civic Governance Starts Here</h2>
        </div>
        <div class="benefits-grid">
            <!-- Card 1: Nationwide Reach (Large Landscape - span 2) -->
            <div class="benefit-card landscape-card">
                <div class="card-info">
                    <h3>Nationwide Integrated Reach</h3>
                    <p>Connecting citizens from all 7 provinces and 753 municipalities directly to central administrative authorities for dynamic nationwide administrative scaling.</p>
                </div>
                <div class="card-visual map-visual">
                    <div class="nepal-map-dots">
                        <!-- Node elements for municipalities -->
                        <div class="map-node node-ktm"><span class="node-tooltip">Kathmandu</span></div>
                        <div class="map-node node-pkr"><span class="node-tooltip">Pokhara</span></div>
                        <div class="map-node node-ltp"><span class="node-tooltip">Lalitpur</span></div>
                        <div class="map-node node-brt"><span class="node-tooltip">Biratnagar</span></div>
                        <div class="map-node node-brj"><span class="node-tooltip">Birgunj</span></div>
                    </div>
                </div>
            </div>

            <!-- Card 2: 24/7 Live Tracking (Portrait - span 1) -->
            <div class="benefit-card portrait-card">
                <div class="card-info">
                    <h3>Real-time Live Tracking</h3>
                    <p>Absolute transparency with zero hidden steps. Monitor your grievance lifecycle live.</p>
                </div>
                <div class="card-visual tracking-visual">
                    <div class="mini-tracker">
                        <div class="tracker-step completed">
                            <span class="step-bullet"><i class="fa-solid fa-circle-check"></i></span>
                            <div class="step-text">
                                <strong>Grievance Submitted</strong>
                                <span>Today, 09:15 AM</span>
                            </div>
                        </div>
                        <div class="tracker-step completed">
                            <span class="step-bullet"><i class="fa-solid fa-circle-check"></i></span>
                            <div class="step-text">
                                <strong>Assigned to Ward-4</strong>
                                <span>Today, 10:30 AM</span>
                            </div>
                        </div>
                        <div class="tracker-step active">
                            <span class="step-bullet"><i class="fa-solid fa-spinner fa-spin"></i></span>
                            <div class="step-text">
                                <strong>Under Review</strong>
                                <span>Pending Action</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card 3: Instant Feedback (Square - span 1) -->
            <div class="benefit-card square-card">
                <div class="card-visual feedback-visual">
                    <div class="micro-chat">
                        <div class="chat-bubble user">
                            <i class="fa-solid fa-user"></i>
                            <div class="bubble-content">Road damaged at Ward-4</div>
                        </div>
                        <div class="chat-bubble official">
                            <i class="fa-solid fa-building-columns"></i>
                            <div class="bubble-content">Action approved. Dispatching.</div>
                        </div>
                    </div>
                </div>
                <div class="card-info">
                    <h3>Direct Feedback Loop</h3>
                    <p>Maintain an active dialogue channel with ward leaders and administrative heads directly.</p>
                </div>
            </div>

            <!-- Card 4: Lightning-Fast Filing (Square - span 1) -->
            <div class="benefit-card square-card">
                <div class="card-visual lightning-visual">
                    <div class="lightning-node-grid">
                        <div class="node-dot"></div><div class="node-dot"></div><div class="node-dot"></div>
                        <div class="node-dot"></div><div class="node-icon"><i class="fa-solid fa-bolt"></i></div><div class="node-dot"></div>
                        <div class="node-dot"></div><div class="node-dot"></div><div class="node-dot"></div>
                    </div>
                </div>
                <div class="card-info">
                    <h3>1-Minute Filing</h3>
                    <p>Report issues with ease. Our guided portal lets you lodge complete grievances in seconds.</p>
                </div>
            </div>

            <!-- Card 5: Safe & Secure (Square - span 1) -->
            <div class="benefit-card square-card">
                <div class="card-visual security-visual">
                    <div class="radar-circle">
                        <div class="radar-pulse"></div>
                        <div class="radar-core"><i class="fa-solid fa-shield-halved"></i></div>
                    </div>
                </div>
                <div class="card-info">
                    <h3>Enterprise Security</h3>
                    <p>State-of-the-art encryption guarantees your identity and data remain completely confidential.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Redesigned Bento Services Section -->
    <section class="services-section" id="services">
        <div class="services-header-container">
            <div class="services-title-area">
                <span class="services-tagline">
                    <span class="tagline-dot"></span>
                    Citizen Services
                </span>
                <h2 class="services-main-title">Digital Governance <br>at Your Fingertips</h2>
            </div>
            <a href="auth/login.jsp" class="btn-services-cta">Explore Services <i class="fa-solid fa-arrow-right"></i></a>
        </div>
        
        <div class="services-grid">
            <!-- Card 1: Lodge Grievance (Standard - Image Top, Content Bottom) -->
            <div class="service-card standard-service">
                <div class="service-image-wrapper">
                    <img src="https://images.unsplash.com/photo-1531403009284-440f080d1e12?auto=format&fit=crop&w=600&q=80" alt="Lodge Grievance">
                </div>
                <div class="service-content">
                    <h3>Lodge Grievance</h3>
                    <p>Easily report municipal, environmental, or public service challenges. Upload media evidence directly to concerned ward offices.</p>
                    <a href="auth/register.jsp" class="service-link">File a Complaint <i class="fa-solid fa-arrow-right-long"></i></a>
                </div>
            </div>

            <!-- Card 2: Real-time Tracking (Highlighted Active Card - Content Top, Image Bottom) -->
            <div class="service-card active-service">
                <div class="service-content">
                    <h3>Real-time Tracking</h3>
                    <p>Monitor your ticket lifecycle from submission to resolution. Receive direct notifications and chat responses from ward heads.</p>
                    <a href="auth/login.jsp" class="service-link">Track Progress <i class="fa-solid fa-arrow-right-long"></i></a>
                </div>
                <div class="service-image-wrapper">
                    <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=600&q=80" alt="Real-time Tracking">
                </div>
            </div>

            <!-- Card 3: Civic Dialogue (Standard - Image Top, Content Bottom) -->
            <div class="service-card standard-service">
                <div class="service-image-wrapper">
                    <img src="https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=600&q=80" alt="Civic Dialogue">
                </div>
                <div class="service-content">
                    <h3>Civic Dialogue</h3>
                    <p>Participate in ward discussions, vote on local development polls, and work hand-in-hand with neighborhood representatives.</p>
                    <a href="auth/login.jsp" class="service-link">Join Discussions <i class="fa-solid fa-arrow-right-long"></i></a>
                </div>
            </div>
        </div>
    </section>

    <!-- Public Footer -->
    <jsp:include page="components/public-footer.jsp" />

    <!-- Video Modal -->
    <div id="videoModal" class="video-modal">
        <div class="video-modal-content">
            <span class="close-video">&times;</span>
            <div class="video-container">
                <iframe id="youtubeIframe" src="https://www.youtube.com/embed/Yse0H0mXEuQ?enablejsapi=1" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
        </div>
    </div>

    <script>
        // Video Modal Logic
        const modal = document.getElementById("videoModal");
        const btn = document.getElementById("openVideoBtn");
        const span = document.getElementsByClassName("close-video")[0];
        const iframe = document.getElementById("youtubeIframe");

        btn.onclick = function() {
            modal.style.display = "flex";
        }

        span.onclick = function() {
            modal.style.display = "none";
            // Reload the static iframe src to stop video playback safely
            iframe.src = iframe.src;
        }

        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
                iframe.src = iframe.src;
            }
        }
    </script>
</body>
</html>
