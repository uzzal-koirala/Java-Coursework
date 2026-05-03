<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ne">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>मेरो सरकार - आधिकारिक सरकारी पोर्टल</title>
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>

    <body>

        <!-- Enhanced Top Bar -->
        <div class="top-bar">
            <div class="container top-bar-content">
                <div class="top-left-info">
                    <div class="top-date">
                        <i class="far fa-calendar-alt"></i> <span id="currentDate">१४ वैशाख २०८३, आइतबार</span>
                    </div>
                    <div class="top-links">
                        <a href="#"><i class="fas fa-globe"></i> नेपाली</a>
                        <a href="#"><i class="fas fa-language"></i> English</a>
                        <a href="#"><i class="fas fa-archive"></i> अभिलेख</a>
                    </div>
                </div>
                <div class="top-right-actions">
                    <div class="emergency-line">
                        <i class="fas fa-phone-volume"></i> आपतकालीन नम्बर: ११४४
                    </div>
                    <div class="accessibility-tools">
                        <i class="fas fa-minus-circle" title="Font Decrease"></i>
                        <i class="fas fa-font" title="Reset Font"></i>
                        <i class="fas fa-plus-circle" title="Font Increase"></i>
                        <i class="fas fa-adjust" title="Contrast Toggle" style="margin-left: 10px;"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Header Refined -->
        <header>
            <div class="container header-main">
                <div class="logo-section">
                    <img src="images/logo.png" alt="Nepal Government Logo">
                    <div class="logo-divider"></div>
                    <div class="logo-text">
                        <h1>मेरो सरकार</h1>
                        <p>नागरिक सेवा तथा गुनासो पोर्टल</p>
                    </div>
                </div>
                <div class="mobile-menu-btn" onclick="document.querySelector('.nav-menu').classList.toggle('active')">
                    <i class="fas fa-bars"></i>
                </div>
                <nav class="nav-menu">
                    <a href="index.jsp"><i class="fas fa-home"></i> गृहपृष्ठ</a>
                    <a href="#"><i class="fas fa-building"></i> मन्त्रालयहरू</a>
                    <a href="#"><i class="fas fa-concierge-bell"></i> सेवाहरू</a>
                    <a href="#"><i class="fas fa-bullhorn"></i> सुचना</a>
                    <a href="#"><i class="fas fa-info-circle"></i> हाम्रो बारेमा</a>
                    <a href="login.jsp" class="btn-gov" style="display: none; margin-top: 10px;">
                        <i class="fas fa-user-lock"></i> लगइन
                    </a>
                </nav>
                <div class="header-right">
                    <div class="search-trigger" title="Search">
                        <i class="fas fa-search"></i>
                    </div>
                    <a href="login.jsp" class="btn-gov">
                        <i class="fas fa-user-lock"></i> लगइन
                    </a>
                </div>
            </div>
        </header>

        <!-- Hero Portal -->
        <section class="hero-portal" style="background-image: url('nepal_government_hero_1777224383614.png');">
            <div class="hero-overlay"></div>
            <div class="container">
                <div class="hero-content">
                    <span class="hero-badge"><i class="fas fa-check-circle" style="color: var(--gov-gold);"></i> नागरिक पोर्टल</span>
                    <h2>नागरिकको आवाज, <br>सरकारको प्राथमिकता</h2>
                    <p>सुशासन र पारदर्शिताका लागि नेपाल सरकारको एकीकृत गुनासो व्यवस्थापन प्रणाली। आफ्नो समस्या आजै दर्ता गर्नुहोस्।</p>
                    <div class="hero-actions" style="margin-top: 30px;">
                        <a href="register.jsp" class="btn-gov" style="font-size: 1.1rem; padding: 16px 40px; background: var(--gradient-red);">
                            गुनासो दर्ता गर्नुहोस्
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Action Cards -->
        <section class="container">
            <div class="action-grid">
                <div class="action-card">
                    <div class="icon-box"><i class="fas fa-file-signature fa-2x"></i></div>
                    <div>
                        <h4>नयाँ गुनासो</h4>
                        <p>आफ्नो समस्या सिधै पठाउनुहोस्</p>
                    </div>
                </div>
                <div class="action-card">
                    <div class="icon-box"><i class="fas fa-search-location fa-2x"></i></div>
                    <div>
                        <h4>स्थिति जाँच</h4>
                        <p>गुनासोको कारबाही ट्र्याक गर्नुहोस्</p>
                    </div>
                </div>
                <div class="action-card">
                    <div class="icon-box"><i class="fas fa-user-check fa-2x"></i></div>
                    <div>
                        <h4>अधिकारी लगइन</h4>
                        <p>सरकारी कर्मचारीहरूका लागि</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- News Section -->
        <section class="container" style="margin-top: 100px;">
            <div class="section-header">
                <h3>ताजा अपडेट तथा समाचार</h3>
                <a href="#" style="color: var(--gov-blue); font-weight: 700;">सबै हेर्नुहोस् <i
                        class="fas fa-arrow-right"></i></a>
            </div>
            <div class="news-grid">
                <div class="news-card">
                    <div class="news-img"
                        style="background-image: url('https://images.unsplash.com/photo-1544928147-79a2dbc1f389?q=80&w=600');">
                    </div>
                    <div class="news-content">
                        <span class="news-date">१२ वैशाख २०८३</span>
                        <h4>डिजिटल सुशासन प्रवर्द्धनका लागि नयाँ कार्ययोजना सार्वजनिक</h4>
                        <p>प्रधानमन्त्री कार्यालयले आगामी वर्षका लागि डिजिटल ट्रान्सफर्मेसन गाइडलाइन जारी गरेको छ।</p>
                    </div>
                </div>
                <div class="news-card">
                    <div class="news-img"
                        style="background-image: url('https://images.unsplash.com/photo-1517048676732-d65bc937f952?q=80&w=600');">
                    </div>
                    <div class="news-content">
                        <span class="news-date">१० वैशाख २०८३</span>
                        <h4>स्थानीय निकायका ५०० भन्दा बढी सेवाहरू अब अनलाइनमा</h4>
                        <p>नागरिकले अब घरमै बसेर वडा तहका सेवाहरू लिन सक्ने व्यवस्था मिलाइएको छ।</p>
                    </div>
                </div>
                <div class="news-card">
                    <div class="news-img"
                        style="background-image: url('https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?q=80&w=600');">
                    </div>
                    <div class="news-content">
                        <span class="news-date">०८ वैशाख २०८३</span>
                        <h4>गुनासो व्यवस्थापनमा उत्कृष्ट कार्य गर्ने ५ वडा पुरस्कृत</h4>
                        <p>जनताको समस्या छिटो समाधान गर्ने वडाहरूलाई सुशासन पदक प्रदान गरियो।</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Service/Department Section -->
        <section class="service-section">
            <div class="container">
                <div class="section-header">
                    <h3>हाम्रा विभाग तथा सेवाहरू</h3>
                </div>
                <div class="service-grid">
                    <div class="service-item">
                        <i class="fas fa-landmark"></i>
                        <h4>गृह मन्त्रालय</h4>
                        <p>शान्ति सुरक्षा र प्रशासन</p>
                    </div>
                    <div class="service-item">
                        <i class="fas fa-hospital-user"></i>
                        <h4>स्वास्थ्य मन्त्रालय</h4>
                        <p>स्वास्थ्य सेवा र जनस्वास्थ्य</p>
                    </div>
                    <div class="service-item">
                        <i class="fas fa-graduation-cap"></i>
                        <h4>शिक्षा मन्त्रालय</h4>
                        <p>विद्यालय तथा उच्च शिक्षा</p>
                    </div>
                    <div class="service-item">
                        <i class="fas fa-road"></i>
                        <h4>भौतिक पूर्वाधार</h4>
                        <p>बाटो, पुल र निर्माण</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer>
            <div class="container">
                <div class="footer-grid">
                    <div class="footer-col">
                        <img src="images/logo.png" alt="Logo"
                            style="height: 60px; filter: brightness(0) invert(1); margin-bottom: 20px;">
                        <h4>मेरो सरकार</h4>
                        <p>नेपाल सरकारको एकीकृत डिजिटल सेवा तथा गुनासो व्यवस्थापन प्रणाली। सुशासनको आधार, नागरिकको
                            अधिकार।</p>
                    </div>
                    <div class="footer-col">
                        <h4>महत्वपूर्ण लिङ्कहरू</h4>
                        <ul>
                            <li><a href="#">नेपाल सरकार</a></li>
                            <li><a href="#">प्रधानमन्त्री कार्यालय</a></li>
                            <li><a href="#">सचिवालय</a></li>
                            <li><a href="#">लोक सेवा आयोग</a></li>
                        </ul>
                    </div>
                    <div class="footer-col">
                        <h4>सेवाहरू</h4>
                        <ul>
                            <li><a href="#">नागरिकता</a></li>
                            <li><a href="#">राहदानी</a></li>
                            <li><a href="#">पञ्जीकरण</a></li>
                            <li><a href="#">राजस्व भुक्तानी</a></li>
                        </ul>
                    </div>
                    <div class="footer-col">
                        <h4>सम्पर्क</h4>
                        <p>सिंहदरबार, काठमाडौं</p>
                        <p>फोन: १६६०-०१-१११११</p>
                        <p>इमेल: info@merosarkar.gov.np</p>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; २०२६ मेरो सरकार | सर्वाधिकार सुरक्षित।</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook fa-lg"></i></a>
                        <a href="#"><i class="fab fa-twitter fa-lg" style="margin-left: 20px;"></i></a>
                        <a href="#"><i class="fab fa-youtube fa-lg" style="margin-left: 20px;"></i></a>
                    </div>
                </div>
            </div>
        </footer>

    </body>

    </html>