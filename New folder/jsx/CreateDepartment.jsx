import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/CreateDepartment.css';

const CreateDepartment = () => {
  const navigate = useNavigate();

  const [departmentData, setDepartmentData] = useState({
    fullName: 'UI/UX Design Department',
    headName: 'Ms. Sara Williams',
    description: 'The UI/UX Design Department is dedicated to teaching user-centered design principles, interface design, and user experience strategies. Students learn how to create intuitive, accessible, and visually appealing digital products using industry-standard tools and methodologies.',
    photo: null
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setDepartmentData(prev => ({ ...prev, [name]: value }));
  };

  const handlePhotoUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setDepartmentData(prev => ({ ...prev, photo: reader.result }));
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = () => {
    alert('✅ Department Created Successfully!');
    console.log('Department Data:', departmentData);
  };

  return (
    <div className="createdepartment-page">
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
          <div className="nav-item active" onClick={() => navigate('/createdepartment')}>
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
      <div className="createdepartment-main">
        <div className="createdepartment-card">
        <div className="createdepartment-header">
          <h1>Create Department</h1>
        </div>

          {/* name */}
          <div className='row row-2'>
             <div className="form-field">
            <label>Full Name</label>
            <input
              type="text"
              name="fullName"
              value={departmentData.fullName}
              onChange={handleChange} />
          </div>

          {/* headname */}
          <div className="form-field">
            <label>HeadName</label>
            <input
              type="text"
              name="headName"
              value={departmentData.headName}
              onChange={handleChange} />
            </div>
          </div>

          {/* description */}
          <div className="form-field">
            <label>Description</label>
            <textarea
              name="description"
              rows="6"
              value={departmentData.description}
              onChange={handleChange}
            />
          </div>

          {/* photo upload */}
          <div className="upload-field">
            <label>Photo</label>
            <div className="upload-box" onClick={() => document.getElementById('photoInput').click()}>
              {departmentData.photo ? (
                <img src={departmentData.photo} alt="Department" className="upload-preview" />
              ) : (
                <>
                  <span className="upload-icon">📁</span>
                  <p>Upload Photo</p>
                </>
              )}
            </div>
            <input
              type="file"
              id="photoInput"
              accept="image/*"
              style={{ display: 'none' }}
              onChange={handlePhotoUpload}
            />
          </div>

          {/* submit button */}
          <button className="submit-btn" onClick={handleSubmit}>
            Create Department
          </button>
        </div>
      </div>
    </div>
  );
};

export default CreateDepartment;