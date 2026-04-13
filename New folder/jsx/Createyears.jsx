import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/Createyears.css';

const Createyear = () => {
  const navigate = useNavigate();
  const [yearData, setYearData] = useState({
    name: '',
    department: '',
    startDate: '',
    endDate: '',
    description: ''});

  const handleChange = (e) => {
    const { name, value } = e.target;
    setYearData(prev => ({ ...prev, [name]: value }));  };

  const handleCreate = () => {
    alert('✅ Department Created Successfully!');
    console.log('Year Data:', yearData);};

  return (
    <div className="createyear-page">
      <div className="sidebar">
        <div className="profile-header-side">
          <div className="profile-avatar-side">{yearData.name? yearData.name.slice(0,2). toUpperCase():''}</div>
          <div className="profile-name-side">
            <h3>{yearData.name|| 'UserName'}</h3>
            <p>{yearData.role|| 'ROle'}</p>
          </div>
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
          <div className="nav-item">
            <span className="nav-icon">📊</span>
            <span>Grades overview</span>
          </div>
          <div className="nav-item active" onClick={() => navigate('/createyear')}>
            <span className="nav-icon">📅</span>
            <span>Create Years</span>
          </div>
          <div className="nav-item" onClick={()=> navigate('/allyear')}>
            <span className="nav-icon">📋</span>
            <span>All Years</span>
          </div>
          <div className="nav-item" onClick={()=> navigate('/createuser')}>
            <span className="nav-icon">👥</span>
            <span>Create User</span>
          </div>
          <div className="nav-item" onClick={()=> navigate('/allusers')}>
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

      {/* main*/}
      <div className="createyear-main">
        <div className="createyear-header">
          <h1>Create Years</h1>
        </div>
        <div className="createyear-card">
         <div className='row row-2'>
          <div className="form-field">
            <label>Name</label>
            <input
              type="text"
              name="name"
              value={yearData.name}
              onChange={handleChange}
              placeholder='Enter your Name'/>
              
             </div>
         
          {/* department name */}
          <div className="form-field half">
          <div>
            <label>Department Name</label>
            <input
              type="text"
              name="role"
              value={yearData.role}
              onChange={handleChange}
              placeholder='Enter your Role'/>
          </div>
          </div>
        </div>

          {/* start date */}
          <div className="row row-2">
            <div className='form-field'>
            <label>Start Date</label>
            <input
              type="date"
              name="startDate"
              value={yearData.startDate}
              onChange={handleChange}/>
          </div>
          {/* end date */}
          <div className="form-field half">
            <label>End Date</label>
            <input
              type="date"
              name="endDate"
              value={yearData.endDate}
              onChange={handleChange}/>
            </div>
          </div>

          {/* description */}
          <div className="form-field">
            <label>Description</label>
            <input
              type="text"
              name="description"
              value={yearData.description}
              onChange={handleChange}
              placeholder='Enter description'
            />
          </div>

          {/* create button */}
          <button className="create-btn" onClick={handleCreate}> Create Department</button>
        </div>
      </div>
    </div>
  );
};

export default Createyear;