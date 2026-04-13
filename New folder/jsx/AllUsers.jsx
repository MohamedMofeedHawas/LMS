import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/AllUsers.css';

const AllUsers = () => {
  const navigate = useNavigate();

  const [users, setUsers] = useState([
    {
      id: 1,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Active'
    },
    {
      id: 2,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Pending Active'
    },
    {
      id: 3,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Active'
    },
    {
      id: 4,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Pending Active'
    },
    {
      id: 5,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Active'
    },
    {
      id: 6,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Pending Active'
    },
    {
      id: 1,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Active'
    },
    {
      id: 1,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Active'
    },
    {
      id: 1,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Active'
    },
    {
      id: 1,
      name: 'Leslie Alexander',
      email: 'deanna.curtis@example.com',
      role: 'Student',
      nationalId: '3984098',
      academicLevel: 'Level 2',
      department: 'Aviation System',
      status: 'Active'
    },
  ]);

  return (
    <div className="allusers-page">
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
          <div className="nav-item active" onClick={() => navigate('/allusers')}>
            <span className="nav-icon">👤</span>
            <span>All Users</span>
          </div>
          <div className="nav-item"> onClick={()=> navigate('/newcourse')}
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

    {/* users table */}
    <div className="users-table-container"> 
        <table className="users-table">
            <thead>
                <tr>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>National Id</th>
                    <th>Academic Level</th>
                    <th>Department</th>
                    <th>Status</th>
                </tr>
            </thead>
        <tbody>
            {users.map((user) => (
                <tr key={user.id}>
                    <td>{user.name}</td>
                    <td>{user.email}</td>
                    <td>{user.role}</td>
                    <td>{user.nationalId}</td>
                    <td>{user.academicLevel}</td>
                    <td>{user.department}</td>
                    <td>
                      <span className={`status-badge ${user.status === 'Active' ? 'status-active' : 'status-pending'}`}> {user.status}</span>
                  </td>
                </tr>))}
        </tbody>
        </table>
    </div>
      </div>
  );
};

export default AllUsers;