import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/MyCourses.css';

const MyCourses = () => {
  const navigate = useNavigate();
  const [courseData, setCourseData] = useState({
    title: 'Introduction to Marketing',
    description: 'Brief overview of what the course covers',
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
    <div className="courses-page">
      {/* navbar */}
      <nav className="navbar">
        <div className="nav-left">
          <div className="logo" onClick={() => navigate('/')}>📘</div>
          <a href="/" className="nav-link">Home</a>
          <a href="/courses" className="nav-link active">Courses</a>
          <a href='/dashboard' className='nav-link'> Dashboard</a>
        </div>
        <div className="nav-right">
          <div className="search-box">
            <input type="text" placeholder="Search courses..." />
            <span className="search-icon">🔍</span>
          </div>
          <div className="nav-avatar" onClick={() => navigate('/profile')}>
            AM
          </div>
        </div>
      </nav>

      {/* main content */}
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
                <div className='form-field '>
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
            <label>Allowed Attemps</label>
            <select name='attemps' value={courseData.attempts} onChange={handleChange}>
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
                  onChange={handleChange} />
              </div>
              </div>
          <button className="publish-btn" onClick={handlePublish}> Publish Course </button>
        </div>
      </div>
    </div>
  );
};

export default MyCourses;