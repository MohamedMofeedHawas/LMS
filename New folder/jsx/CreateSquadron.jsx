import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/CreateSquadron.css';

const CreateSquadron = () => {
  const navigate = useNavigate();

  const [squadronData, setSquadronData] = useState({
    name: 'Squadron Name',
    description: 'Description'
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setSquadronData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = () => {
    alert('✅ Squadron Created Successfully!');
    console.log('Squadron Data:', squadronData);
  };

  return (
    <div className="createsquadron-page">
      {/* Sidebar */}
      <div className="sidebar">
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
          <div className="nav-item" onClick={() => navigate('/createuser')}>
            <span className="nav-icon">👥</span>
            <span>Create User</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/allusers')}>
            <span className="nav-icon">👤</span>
            <span>All Users</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/newcourse')}>
            <span className="nav-icon">📝</span>
            <span>Create New Course</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/createdepartment')}>
            <span className="nav-icon">🏛️</span>
            <span>Create Department</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/alldepartments')}>
            <span className="nav-icon">🏢</span>
            <span>All Departments</span>
          </div>
          <div className="nav-item active" onClick={() => navigate('/createsquadron')}>
            <span className="nav-icon">✈️</span>
            <span>Create Squadron</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/allsquadron')}>
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

      {/* maln */}
      <div className="createsquadron-main">
        <div className="createsquadron-card">
          <div className="createsquadron-header">
            <h1>Create Squadron</h1>
          </div>
          <div className="form-field">
            <label>Squadron Name</label>
            <input
              type="text"
              name="name"
              value={squadronData.name}
              onChange={handleChange}
              placeholder="Enter squadron name"
            />
          </div>
          <div className="form-field">
            <label>Description</label>
            <textarea
              name="description"
              rows="5"
              value={squadronData.description}
              onChange={handleChange}
              placeholder="Enter description"
            />
          </div>
          <button className="submit-btn" onClick={handleSubmit}>Create Squadron </button>
        </div>
      </div>
    </div>
  );
};

export default CreateSquadron;