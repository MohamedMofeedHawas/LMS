import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/NewCourse.css';

const NewCourse = () => {
  const navigate = useNavigate();
  const [courseData, setCourseData] = useState({
   // title: 'Introduction to Marketing',
    //description: 'Brief overview of what the course covers',
    category: '',
    attempts: 'Unlimited attempts',
    publishDate: '2025-01-10'
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setCourseData(prev => ({ ...prev, [name]: value }));
  };

  const handlePublish = () => {
    alert('✅ Course Published Successfully!');
    console.log('Published Course:', courseData);
  };

  return (
    <div className="newcourse-page">
      {/* Sidebar */}
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
          <div className="nav-item" onClick={() => navigate('/createuser')}>
            <span className="nav-icon">👥</span>
            <span>Create User</span>
          </div>
          <div className="nav-item" onClick={() => navigate('/allusers')}>
            <span className="nav-icon">👤</span>
            <span>All Users</span>
          </div>
          <div className="nav-item active" onClick={() => navigate('/newcourse')}>
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

      {/* main  */}
      <div className="newcourse-main">
        <div className="courses-container">
          <div className="courses-header">
            <h1>Add New Course</h1>
            <p>Create and publish a new course for your learners</p>
          </div>

          <div className="courses-content">
            <h2>Course Details</h2>
            <div className="form-grid">
              <div className="left-column">
                {/* left column */}
                <div className="form-field full-width">
                  <label>Course Title</label>
                  <input 
                    type="text" 
                    name="title" 
                    value={courseData.title} 
                    onChange={handleChange}
                    placeholder="Enter course title"
                  />
                </div>

                <div className="form-field full-width">
                  <label>Short Description</label>
                  <input 
                    type="text" 
                    name="description" 
                    value={courseData.description} 
                    onChange={handleChange}
                    placeholder="Brief overview"
                  />
                </div>

                <div className="row row-2">
                  <div className='form-field'>
                    <label>Category</label>
                    <select name='category' value={courseData.category} onChange={handleChange}>
                      <option value=''> Select Category</option>
                      <option value='Languages'> Languages</option>
                      <option value='Group'> Group</option>
                      <option value='Aviation'> Aviation</option>  
                    </select>                
                  </div>

                  <div className="form-field">
                    <label>Group</label>
                    <select name="attempts" value={courseData.attempts} onChange={handleChange}>
                      <option value=''>Select Group</option>
                      <option value='A'>Group A</option>
                      <option value='B'>Group B</option>
                      <option value='C'>Group C</option>
                    </select>
                  </div>
                </div>
              </div>

              {/* right column */}
              <div className='row row-3'>
                <div className="files-row">
                  <div className="upload-field">
                    <label>Cover Image</label>
                    <div className="upload-box">
                      <span className="upload-icon">📁</span>
                      <p>Click to upload</p>
                    </div>
                  </div>

                  <div className="upload-field">
                    <label>Intro Video</label>
                    <div className="upload-box">
                      <span className="upload-icon">📁</span>
                      <p>Click to upload</p>
                    </div>
                  </div>

                  <div className="upload-field">
                    <label>File</label>
                    <div className="upload-box">
                      <span className="upload-icon">📁</span>
                      <p>Click to upload</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div className='row row-2'>
              <div className='form-field'>
                <label>Allowed Attempts</label>
                <select name='attempts' value={courseData.attempts} onChange={handleChange}>
                  <option>attempt 1</option>
                  <option>attempt 2</option>
                  <option>attempt 3</option>
                  <option>attempt 4</option>
                </select>
              </div>
              <div className="form-field">
                <label>Publish Date</label>
                <input 
                  type="date" 
                  name="publishDate" 
                  value={courseData.publishDate} 
                  onChange={handleChange} 
                />
              </div>
            </div>

            <button className="publish-btn" onClick={handlePublish}>Publish Course</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default NewCourse;