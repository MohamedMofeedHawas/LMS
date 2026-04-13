import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/Announcements.css';

const Announcements = () => {
  const navigate = useNavigate();
  const [announcements, setAnnouncements] = useState([
    {
      id: 1,
      author: 'Dr. Rogelio Hansen',
      role: 'Human Program Designer',
      title: 'Final Project Submission Guidelines',
      content: 'Please ensure all project files are uploaded in PDF format by Friday at midnight. Late submissions will incur a 10% penalty per day. Make sure to include your documentation and design assets in a single ZIP file.',
      comments: 12,
      views: 48,
      time: '2 hours ago',
      date: '2024-03-15'
    },
    {
      id: 2,
      author: 'Dr. Barry Witting',
      role: 'Dynamic Brand Architect',
      title: 'System Maintenance Notice',
      content: 'The LMS will be temporarily unavailable on Saturday from 2:00 AM to 4:00 AM due to scheduled maintenance. Please save your work in advance',
      comments: 5,
      views: 20,
      time: '5 hours ago',
      date: '2024-03-15'
    },
    {
      id: 3,
      author: 'Dr. Jamie Heaney',
      role: 'Customer Interactions Assistant',
      title: 'Midterm Exam Schedule',
      content: 'The midterm exam will take place on Wednesday at 9:00 AM. The exam will be conducted online and will cover Modules 1–3. Make sure to check the exam guidelines beforehand.',
      comments: 10,
      views: 55,
      time: '1 day ago',
      date: '2024-03-14'
    }
  ]);

  // comments
  const [commentText, setCommentText] = useState('');
  const [activeCommentId, setActiveCommentId] = useState(null);
  const handleAddComment = (id) => {
    if (commentText.trim()) {
      setAnnouncements(prev =>
        prev.map(item =>
          item.id === id
            ? { ...item, comments: item.comments + 1 }
            : item));
      setCommentText('');
      setActiveCommentId(null); }};

  // high view
  const handleView = (id) => {
    setAnnouncements(prev =>
      prev.map(item =>
        item.id === id
          ? { ...item, views: item.views + 1 }
          : item ));};

  return (
    <div className="announcements-page">
      <div className="sidebar">
        <div className="profile-header-side">
          <div className="profile-avatar-side">AM</div>
          <div className="profile-name-side">
            <h3>Assem Mohamed</h3>
            <p>Teacher</p>
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
          <div className="nav-item active" onClick={() => navigate('/announcements')}>
            <span className="nav-icon">📢</span>
            <span>Announcements</span>
          </div>
          <div className="nav-item">
            <span className="nav-icon">📊</span>
            <span>Grades overview</span>
          </div>
          <div className="nav-item " onClick={()=> navigate('/createyear')}>
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
          <div className="nav-item"  onClick={()=> navigate('/createsquadron')}>
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
            <span>Log out</span>
          </div>
        </nav>
      </div>

      {/* main content */}
      <div className="announcements-main">
        <div className="announcements-header">
          <h1>Announcements</h1>
          <p>Stay updated with the latest announcements, course updates, and important notifications from your instructors and university.</p>
        </div>

        <div className="announcements-list">
          {announcements.map((item) => (
            <div key={item.id} className="announcement-card" onClick={() => handleView(item.id)}>
              <div className="announcement-author">
                <div className="author-avatar">
                  {item.author.split(' ').map(n => n[0]).join('')}
                </div>
                <div className="author-info">
                  <h3>{item.author}</h3>
                  <p>{item.role}</p>
                </div>
                <span className="announcement-time">{item.time}</span>
              </div>

              <div className="announcement-content">
                <h4>{item.title}</h4>
                <p>{item.content}</p>
              </div>

              <div className="announcement-stats">
                <div className="stat-item">
                  <span className="stat-icon">💬</span>
                  <span>{item.comments} Comments</span>
                </div>
                <div className="stat-item">
                  <span className="stat-icon">👁️</span>
                  <span>{item.views} Views</span>
                </div>
              </div>

              {/* comment section */}
              {activeCommentId === item.id && (
                <div className="comment-input">
                  <input
                    type="text"
                    placeholder="Write a comment..."
                    value={commentText}
                    onChange={(e) => setCommentText(e.target.value)}
                    onKeyPress={(e) => {
                      if (e.key === 'Enter') {
                        handleAddComment(item.id);
                      }
                    }}
                  />
                  <button onClick={() => handleAddComment(item.id)}>Post</button>
                </div>
              )}

              {/* add comment button */}
              <button
                className="add-comment-btn"
                onClick={(e) => {
                  e.stopPropagation();
                  setActiveCommentId(item.id);
                }}
              >
                💬 Add Comment
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>);};

export default Announcements;