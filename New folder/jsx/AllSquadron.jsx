import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/AllSquadron.css';

const AllSquadron = () => {
  const navigate = useNavigate();

  const [squadrons, setSquadrons] = useState([
    { id: 1, name: 'Alpha 11', studentCount: 25 },
    { id: 2, name: 'Alpha 11', studentCount: 25 },
    { id: 3, name: 'Alpha 11', studentCount: 50 },
    { id: 4, name: 'Alpha 11', studentCount: 25 },
    { id: 5, name: 'Alpha 11', studentCount: 75 }
  ]);
 {/* pen*/ }
  const EditIcon = () => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M17 3L21 7L7 21H3V17L17 3Z" />
    </svg>
  );

  return (
    <div className="allsquadron-page">
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
          <div className="nav-item" onClick={() => navigate('/createsquadron')}>
            <span className="nav-icon">✈️</span>
            <span>Create Squadron</span>
          </div>
          <div className="nav-item active" onClick={() => navigate('/allsquadron')}>
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

      {/*main */}
      <div className="allsquadron-main">
        <div className="squadron-grid">
          {squadrons.map((sq) => (
            <div key={sq.id} className="squadron-card">
              <div className="squadron-info">
                <h3>{sq.name}</h3>
                <p>Student Count: {sq.studentCount}</p>
              </div>
              <button className="edit-btn">
                <EditIcon />
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default AllSquadron;