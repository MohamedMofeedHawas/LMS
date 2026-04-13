import React, { useState } from 'react';
import './css/Profile.css';
import { useNavigate } from 'react-router-dom';

const Profile = () => {
    const navigate = useNavigate();
  const [isEditing, setIsEditing] = useState(false);
  const [profileImage, setProfileImage] = useState(null);
  const [profileData, setProfileData] = useState({
    fullName:'',
    email:'',
    nationalId:'',
    dateOfBirth:'',
    city :'',
    role :'',});
 const handleChange =(e) =>{ const { name, value} =e.target; setProfileData (prev => ({...prev, [name]: value}));};
  const [editedData, setEditedData] = useState({ ...profileData });

  const handleEdit = () => {
    setIsEditing(true);
    setEditedData({ ...profileData }); };

  const handleSave = () => {
    setProfileData({ ...editedData });
    setIsEditing(false); };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setEditedData(prev => ({ ...prev, [name]: value }));};

  //navigation items
  const navItems = [
    { icon: '👤', label: 'Profile', path :'/profile',active: true },
    { icon: '📚', label: 'My Courses' ,path:'/courses', active: false},
    { icon: '📢', label: 'Announcements',path:'/announcement',active:false },
    { icon: '📊', label: 'Grades overview' },
    { icon: '📅', label: 'Create Years' ,path :'/createyear'},
    { icon: '📋', label: 'All Years' ,path: '/allyear'},
    { icon: '👥', label: 'Create User' ,path:'/createuser'},
    { icon: '👤', label: 'All Users',path:'allusers' },
    { icon: '📝', label: 'Create New Course', path:'newcourse' },
    { icon: '🏛️', label: 'Create Department', path:'createdeprtment' },
    { icon: '🏢', label: 'All Departments', path:'alldepartments' }, 
    { icon: '✈️', label: 'Create Squadron', path:'createsquadron' },
    { icon: '🛩️', label: 'All Squadron' , path:'allsquadron'},
    { icon: '⚙️', label: 'Settings' },
    { icon: '🚪', label: 'Log out' }
  ];

  return (
    <div className="profile-container">
      {/* Sidebar */}
      <div className="sidebar">
        <div className="profile-header-side">
          <div className="profile-avatar-side">
            {profileData.fullName.split(' ').map(n => n[0]).join('')}
          </div>
          <div className="profile-name-side">
            <h3>{profileData.fullName}</h3>
            <p>{profileData.role}</p>
          </div>
        </div>
        {/* form */}
        <nav className="nav-menu">
          {navItems.map((item, index) => (
            <div
              key={index}
              onClick={()=> item.path && navigate(item.path)}
              className={`nav-item ${item.active ? 'active' : ''}`} style={{ cursor: 'pointer'}}>
              <span className="nav-icon">{item.icon}</span>
              <span>{item.label}</span>
            </div>
          ))}
        </nav>
      </div>

      {/* main content */}
      <div className="main-content">
        <div className="content-header">
          <div className="header-title">
            <h1></h1>
           
          </div>
          <div className="header-actions">
            <div className="user-avatar">
              {profileData.fullName.split(' ').map(n => n[0]).join('')}
            </div>
          </div>
        </div>

        {/* profile card w image*/}
        <div className="profile-card">
          <div className="profile-image-section">
            <div className="profile-image-wrapper">
              <img
                src={profileImage || 'https://picsum.photos/120/120'}
                alt="profile"
                className="profile-image"/>
              {isEditing && ( <>
                  <label htmlFor="image-upload" className="image-upload-btn"> 📷</label>
                  <input
                    type="file"
                    id="image-upload"
                    className="image-upload-input"
                    accept="image/*"
                    onChange={handleImageUpload}/>
                </>
              )}
            </div>
            <div className="image-info">
                <h3>Your Profile</h3> 
              <p>Here are all your personal details that you can view and update anytime</p>
            </div>
          </div>

          {/* Form */}
          <div className='container'>
            <div className='profile-box'>
                <div className='field'>
                    <input
                    type='text'
                    name='fullName'
                    className='simple-input'
                    value={profileData.fullName}
                    onChange={handleChange}
                    placeholder=''/>
                    <label> Full Name </label>
                </div>
                <div className='field'>
                    <input
                    type='email'
                    name='email'
                    className='simple-input'
                    value={profileData.email}
                    onChange={handleChange}
                    placeholder=''/>
                    <label >Email Address</label>
                </div>
                <div className='field'>
                    <input
                    type='text'
                    name='nationalId'
                    className='simple-input'
                    value={profileData.nationalId}
                    onChange={handleChange}
                    placeholder=''/>
                    <label> National Id</label>
                </div>
                <div className='field'>
                    <input
                    type='date'
                    name='dateOfBirth'
                    className='simple-input'
                    value={profileData.dateOfBirth}
                    onChange={handleChange}
                    placeholder=''/>
                    <label> Date Of Birth</label>
                </div>
                <div className='field'>
                    <input
                    type='text'
                    name='city'
                    className='simple-input'
                    value={profileData.city}
                    onChange={handleChange}
                    placeholder=''/>
                    <label> City</label>
                </div>
                <div className='field'>
                    <input
                    type='text'
                    name='role'
                    className='simple-input'
                    value={profileData.role}
                    onChange={handleChange}
                     placeholder=''/>
                    <label className=''> Role</label>
                </div>  
            </div>
          </div>

          {/* Next Button */}
          <div className="next-button-container">
            <button className="next-button">Next →</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Profile;