import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/CreateUser.css';

const CreateUser = () => {
  const navigate = useNavigate();

  const [userData, setUserData] = useState({});

  const handleChange = (e) => {
    const { name, value } = e.target;
    setUserData(prev => ({ ...prev, [name]: value }));
  };

  return (
    <div className="createuser-page">
      <div className="sidebar">
            <div className="profile-header-side">
        </div>

        <nav className="nav-menu">
          <div className="nav-item" onClick={() => navigate('/profile')}>
            <span className="nav-icon">👤</span>
            <span>Profile</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/courses')}>
            <span className="nav-icon">📚</span>
            <span>My Courses</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/announcements')}>
            <span className="nav-icon">📢</span>
            <span>Announcements</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/grades')}>
            <span className="nav-icon">📊</span>
            <span>Grades overview</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/createyear')}>
            <span className="nav-icon">📅</span>
            <span>Create Years</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/allyear')}>
            <span className="nav-icon">📋</span>
            <span>All Years</span>
          </div>
          <div className="nav-item active" onClick={() => navigate('/createuser')}>
            <span className="nav-icon">👥</span>
            <span>Create User</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/allusers')}>
            <span className="nav-icon">👤</span>
            <span>All Users</span>
          </div>
          <div className="nav-item" onClick={()=> navigate('/newcourse')}>
            <span className="nav-icon">📝</span>
            <span>Create New Course</span>
          </div>
          <div className="nav-item" onClick={()=> navigate('/createdepartment')}>
            <span className="nav-icon">🏛️</span>
            <span>Create Department</span>
          </div>
          <div className="nav-item" onClick={()=> navigate('/alldepartments')}>
            <span className="nav-icon">🏢</span>
            <span>All Departments</span>
          </div>
          <div className="nav-item" onClick={()=> navigate('/createsquadron')}>
            <span className="nav-icon">✈️</span>
            <span>Create Squadron</span>
          </div>
          <div className="nav-item" onClick={()=> navigate('/allsquadron')}>
            <span className="nav-icon">🛩️</span>
            <span>All Squadron</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/settings')}>
            <span className="nav-icon">⚙️</span>
            <span>Settings</span>
          </div>
          <div className="nav-item logout">
            <span className="nav-icon">🚪</span>
            <span>Logout</span>
          </div>
        </nav>
      </div>

      {/* main */}
      <div className="createuser-main">
        <div className="createuser-header">
          <h1>Create New User</h1>
        </div>

        <div className="createuser-card">
          <h2 className="section-title">Basic Information</h2>
          <div className="row row-2">
            <div className="form-field">
              <label>Full Name</label>
              <input
                type="text"
                name="fullName"
                value={userData.fullName}
                onChange={handleChange}
                placeholder='Mohamed Ahmed' />
            </div>
            <div className="form-field">
              <label>Email address</label>
              <input
                type="email"
                name="email"
                value={userData.email}
                onChange={handleChange}
                placeholder='moahmed@gmail.com'/>
            </div>
          </div>

          <div className='form-field full-width'>
            <label>Role</label>
            <input
              type='text'
              name='role'
              value={userData.role}
              onChange={handleChange}
              placeholder='Student'/>
          </div>

          <h2 className="section-title">Personal Details</h2>
          <div className="row row-2">
            <div className="form-field">
              <label>Date of Birth</label>
              <input
                type="date"
                name="dateOfBirth"
                value={userData.dateOfBirth}
                onChange={handleChange}
              />
            </div>
            <div className="form-field">
              <label>Gender</label>
              <select name="gender" value={userData.gender} onChange={handleChange}>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
              </select>
            </div>
          </div>

          {/* id */}
          <h3 className="sub-section-title">National Id</h3>
          <div className="form-field full-width">
            <input
              type="text"
              name="nationalId"
              value={userData.nationalId}
              onChange={handleChange}
              placeholder='39838720'/>
          </div>

          {/* academic information */}
          <h2 className="section-title">Academic Information</h2>
          <div className="row row-2">
            <div className="form-field">
              <label>Academic Level</label>
              <input
                type="text"
                name="academicLevel"
                value={userData.academicLevel}
                onChange={handleChange}
                placeholder='Level 1' />
            </div>
            <div className="form-field">
              <label>Department</label>
              <input
                type="text"
                name="department"
                value={userData.department}
                onChange={handleChange}
                placeholder='Aviation system'
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CreateUser;