import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/AllDepartments.css';

const AllDepartments = () => {
  const navigate = useNavigate();

  const [departments, setDepartments] = useState([
    {
      id: 1,
      name: 'Aviation Information Systems',
      description: 'Computer science',
      head: 'Admin',
      years: 'Third Year',
      image: 'https://cdn-icons-png.flaticon.com/512/3106/3106980.png'
    },
    {
      id: 2,
      name: 'Aviation Information Systems',
      description: 'Computer science',
      head: 'Admin',
      years: 'Third Year',
      image: 'https://cdn-icons-png.flaticon.com/512/3106/3106980.png'
    },
    {
      id: 3,
      name: 'Aviation Information Systems',
      description: 'Computer science',
      head: 'Admin',
      years: 'Third Year',
      image: 'https://cdn-icons-png.flaticon.com/512/3106/3106980.png'
    },
    {
      id: 4,
      name: 'Aviation Information Systems',
      description: 'Computer science',
      head: 'Admin',
      years: 'Third Year',
      image: 'https://cdn-icons-png.flaticon.com/512/3106/3106980.png'
    },
    {
      id: 5,
      name: 'Aviation Information Systems',
      description: 'Computer science',
      head: 'Admin',
      years: 'Third Year',
      image: 'https://cdn-icons-png.flaticon.com/512/3106/3106980.png'
    },
    {
      id: 6,
      name: 'Aviation Information Systems',
      description: 'Computer science',
      head: 'Admin',
      years: 'Third Year',
      image: 'https://cdn-icons-png.flaticon.com/512/3106/3106980.png'
    },
    {
      id: 7,
      name: 'Aviation Information Systems',
      description: 'Computer science',
      head: 'Admin',
      years: 'Third Year',
      image: 'https://cdn-icons-png.flaticon.com/512/3106/3106980.png'
    },
    {
      id: 8,
      name: 'Aviation Information Systems',
      description: 'Computer science',
      head: 'Admin',
      years: 'Third Year',
      image: 'https://cdn-icons-png.flaticon.com/512/3106/3106980.png'
    }
  ]);

  return (
    <div className="alldepartments-page">
      <div className="sidebar">
        <div className="profile-header-side"></div>

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
          <div className="nav-item active" onClick={() => navigate('/alldepartments')}>
            <span className="nav-icon">🏢</span>
            <span>All Departments</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/createsquadron')}>
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

      {/* main*/}
      <div className="alldepartments-main">
        <div className="departments-table-container">
          <table className="departments-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Description</th>
                <th>Head</th>
                <th>Years</th>
                <th>Image</th>
              </tr>
            </thead>
            <tbody>
              {departments.map((dept) => (
                <tr key={dept.id}>
                  <td>{dept.name}</td>
                  <td>{dept.description}</td>
                  <td>{dept.head}</td>
                  <td>{dept.years}</td>
                  <td>
                    <img src={dept.image} alt="icon" className="dept-icon" />
                   </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default AllDepartments;