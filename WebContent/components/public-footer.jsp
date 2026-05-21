    <!-- Pre-Footer CTA -->
    <div class="pre-footer">
        <div class="pre-footer-inner">
            <div class="pre-footer-content">
                <h4>Need Help?</h4>
                <h2>Don't hesitate to contact us for more information about the portal.</h2>
            </div>
            <a href="contact.jsp" class="btn-contact-outline">CONTACT US</a>
        </div>
    </div>

    <!-- Main Footer -->
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
                    <li><a href="#">News & Articles</a></li>
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
                <a href="<%= request.getContextPath() %>/auth/login.jsp">Login</a>
                <a href="#">Sitemap</a>
                <a href="#">Privacy policy</a>
                <a href="#">Cookie policy</a>
            </div>
        </div>
    </footer>
