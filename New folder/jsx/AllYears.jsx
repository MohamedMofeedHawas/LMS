import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/AllYears.css';

const AllYears = () => {
  const navigate = useNavigate();

  const [years, setYears] = useState([
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year' },

    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year' },

    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year' },
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year' },
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year'},
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year' },
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year' },
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year'},
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year' },
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year'},
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year' },
    {id: 1,
      name: 'First Day',
      description: 'This is first year',
      startDate: '2022-01-01',
      endDate: '2027-01-01',
      totalCourses: 10,
      totalYears: 3,
      department: 'This is first year'}, ]);

  // calculate days
  const calculateDays = (startDate, endDate) => {
    const start = new Date(startDate);
    const end = new Date(endDate);
    const today = new Date();
    
    if (today < start) {
      const daysUntil = Math.ceil((start - today) / (1000 * 60 * 60 * 24));
      return `Starts in ${daysUntil} days`;
    } else if (today > end) {
      const daysSince = Math.ceil((today - end) / (1000 * 60 * 60 * 24));
      return `Ended ${daysSince} days ago`;
    } else {
      const daysLeft = Math.ceil((end - today) / (1000 * 60 * 60 * 24));
      return `${daysLeft} days left`;
    }
  };

  return (
    <div className="all-years-page">
      {/* sidebar */}
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
          <div className="nav-item" onClick={() => navigate('/createyear')}>
            <span className="nav-icon">📅</span>
            <span>Create Years</span>
          </div>
          <div className="nav-item active" onClick={() => navigate('/allyear')}>
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

      {/* main content */}
      <div className="all-years-main">
                <div className="years-table-container">
          <table className="years-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Description</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Total Courses</th>
                <th>Total Years</th>
                <th>Department Name</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              {years.map((year) => (
                <tr key={year.id}>
                  <td>{year.name}</td>
                  <td>{year.description}</td>
                  <td>{new Date(year.startDate).toLocaleDateString('en-US', { year: 'numeric', month: 'numeric', day: 'numeric' })}</td>
                  <td>{new Date(year.endDate).toLocaleDateString('en-US', { year: 'numeric', month: 'numeric', day: 'numeric' })}</td>
                  <td>{year.totalCourses}</td>
                  <td>{year.totalYears}</td>
                  <td>{year.department}</td>
                  <td>
                    <button className="action-btn edit">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="blue">
                            <path d="M17 3L21 7L7 21H3V17L17 3Z" stroke="blue" strokeWidth="2"/>
                            </svg>
                    </button>
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

export default AllYears;