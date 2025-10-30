import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import HumanVerification from './HumanVerification.jsx';
import './LandingPage.css';

const LandingPage = () => {
  const [showLogin, setShowLogin] = useState(false);
  const navigate = useNavigate();

  const openLogin = () => setShowLogin(true);
  const backToLanding = () => setShowLogin(false);

  return (
    <>
      {/* main padge */}
      <div id="landing-page" style={{ display: showLogin ? 'none' : 'block' }}>
        <HumanVerification onVerified={openLogin} />
        <header className="navbar">
          <div className="logo">EduLearn</div>
          <nav>
            <a href="#">Home</a>
            <a href="#">Courses</a>
            <a href="#">About</a>
            <a href="#" className="login-btn" onClick={openLogin}>Login</a>
          </nav>
        </header>

        <section className="hero">
          <div className="hero-text">
            <h1>Learn Smarter. Grow Faster.</h1>
            <p>Join thousands of learners growing their skills through interactive courses and real-world projects.</p>
            <div className="buttons">
              <button className="btn primary" onClick={openLogin}>Login</button>
              <button className="btn secondary">Start Learning</button>
            </div>
          </div>
          <div className="hero-img">
            <img src="/photo.jpg" alt="Learning Image" />
          </div>
        </section>

        <footer>
          <p>© 2025 EduLearn. All rights reserved.</p>
        </footer>
      </div>

      {/* login padge */}
      <div id="login-page" className="login-page" style={{ display: showLogin ? 'flex' : 'none' }}>
        <div className="login-container">
          <h2>Welcome Back 👋</h2>
          <p className="subtitle">Sign in to continue to your courses</p>
          <form onSubmit={(e) => { e.preventDefault(); navigate('/login'); }}>
            <input type="email" placeholder="Email" required />
            <input type="password" placeholder="Password" required />
            <div className="remember">
              <label><input type="checkbox" /> Remember Me</label>
              <a href="#">Forgot Password?</a>
            </div>
            <button type="submit" className="btn primary full">Login</button>
          </form>
          <p className="back">
            <a href="#" onClick={backToLanding}>← Back to Home</a>
          </p>
        </div>
      </div>
    </>
  );
};

export default LandingPage;