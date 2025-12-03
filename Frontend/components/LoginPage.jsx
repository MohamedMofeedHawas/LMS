import React, { useState, useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import { AuthContext } from '../context/AuthContext.jsx';
import './css/LoginPage.css';

const LoginPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [isVerified, setIsVerified] = useState(false);
  const { login } = useContext(AuthContext);
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!email || !password) {
      setError('Please enter your email and password.');
      return;
    }

    try {
      await login(email, password);
      navigate('/Coursespage');
    } catch (err) {
      setError('Login failed. Check your credentials.');
    }
  };


const handleLogin = async (e) => {
  e.preventDefault();
  try {
    const response = await fetch("http://localhost:8000/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        email,
        password,
      }),
    });
    const data = await response.json();
    const userRole = data.role; 
    localStorage.setItem("token", data.token);
    if (userRole === "student") {
      navigate("/student-dashboard");
    } else if (userRole === "admin") {
      navigate("/admin-dashboard");
    } else if (userRole === "teacher") {
      navigate("/teacher-dashboard");
    } else {
      alert("Unknown user role");
    }
  } catch (err) {
    console.log(err);
    alert("Server error");
  }
};


  return (
    <div className="login-container">
      <div className="login-card">
        <h2>Welcome Back 👋</h2>
        <p>Enter your details below to access your courses and progress.</p>

        <form onSubmit={handleSubmit}>
          <div className='input-row'>
          <label>Email</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Enter your email"
            required
          />
          </div>
        <div className='input-row'>
          <label>Password</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Enter your password"
            required
          />
          </div>

          <div className="extra">
            <a
              href="#"
              onClick={(e) => {
                e.preventDefault();
                navigate('/forgot-password');
              }}
              className="forgot"
            >
              Forgot Password?
            </a>
          </div>

          <button type="submit" className="login-btn">Login</button>

          <div className="extra">
            <a
              href="#"
              onClick={(e) => {
                e.preventDefault();
                navigate('/');
              }}
              className="forgot"
            >
              Come back to home
            </a>
          </div>
        </form>

        {error && <p className="error">{error}</p>}
      </div>
    </div>
  );
};

export default LoginPage;
