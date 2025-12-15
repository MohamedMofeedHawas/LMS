import React from 'react';
import { useNavigate } from 'react-router-dom';
import './css/LandingPage.css';
import boy from '../photo/boy.jpg'
const LandingPage = () => {const navigate = useNavigate();
  return (
    <div id="landing-page">

      {/* Navbar */}
      <header className="navbar">
        <div className="logo">EduLearn</div>
        <nav className="nav-links">
          <a href="#" onClick={(e) => { e.preventDefault(); navigate('/'); }}>Home</a>
          <a href="#" onClick={(e) => { e.preventDefault(); navigate('/courses'); }}>Courses</a>
          <a href="#" onClick={(e) => { e.preventDefault(); navigate('/about'); }}>About</a>
          <a href="#" onClick={(e) => { e.preventDefault(); navigate('/login'); }}>Login</a>
        </nav>
      </header>

      {/* Hero Section */}
      <section className="hero">
        <div className="hero-text">
          <h1>Learn Smarter. Grow Faster.</h1>
          <p>Join thousands of learners growing their skills through interactive courses and real-world projects.</p>
          <div className="buttons">
            <button className="btn primary" onClick={() => navigate('/login')}>Login</button>
            <button className="btn secondary" onClick={() => navigate('/courses')}>Start Learning</button>
          </div>
        </div>
        <div className="hero-img">
          <img src={boy} alt="Boy" />
        </div>
      </section>

      {/* Footer */}
      <footer>
        <p>© 2025 EduLearn. All rights reserved.</p>
      </footer>
    </div>
  );
};

export default LandingPage;
