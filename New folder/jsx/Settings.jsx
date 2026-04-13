import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './css/Settings.css';

const Settings = () => {
  const navigate = useNavigate();
  const[showDepConfirm, setShowDeptConfirm]= useState(false);
  const [activeSection, setActiveSection] = useState('main'); // main, yearSettings, confirmDelete
  const [deleteItem, setDeleteItem] = useState(null);
  const [confirmName, setConfirmName] = useState('');
  const [yearsData, setYearsData] = useState([
    { id: 1, name: 'Level one', students: 5, department: 'Department' },
    { id: 2, name: 'Level one', students: 5, department: 'Department' },
    { id: 3, name: 'Level one', students: 5, department: 'Department' },
    { id: 4, name: 'Level one', students: 5, department: 'Department' },
    { id: 5, name: 'Level one', students: 1, department: 'Department' },
    { id: 6, name: 'Level one', students: 5, department: 'Department' }
  ]);

  const [dangerItems, setDangerItems] = useState([
    { id: 1, name: 'Level One', students: 10 },
    { id: 2, name: 'Level One', students: 10 },
    { id: 3, name: 'Level One', students: 10 },
    { id: 4, name: 'Level One', students: 10 }
  ]);

  const handleDeleteClick = (item) => {
    setDeleteItem(item);
    setActiveSection('confirmDelete');
  };

  const handleConfirmDelete = () => {
    if (confirmName === 'Alpha') {
      setDangerItems(dangerItems.filter(item => item.id !== deleteItem.id));
      setActiveSection('yearSettings');
      setConfirmName('');
      setDeleteItem(null);
      alert('✅ Item deleted successfully!');
    } else {
      alert('❌ Please enter "Alpha" to confirm deletion');
    }
  };

/*department*/
  const [deptData, setDeptData] = useState([
  { id: 1, name: 'Department System', students: 5, description: 'Department' },
  { id: 2, name: 'Department System', students: 5, description: 'Department' },
  { id: 3, name: 'Department System', students: 5, description: 'Department' },
  { id: 4, name: 'Department System', students: 5, description: 'Department' },
  { id: 5, name: 'Department System', students: 5, description: 'Department' }
]);

const [deptDangerItems, setDeptDangerItems] = useState([
  { id: 1, name: 'All Departments', action: 'Delete' },
  { id: 2, name: 'All Departments', action: 'Delete' },
  { id: 3, name: 'All Departments', action: 'Delete' },
  { id: 4, name: 'All Departments', action: 'Delete' }
]);
 const handleDeptDeleteClick = (item) => { 
    setDeleteItem(item);
    setActiveSection('confirmDeptDelete');
    setShowDeptConfirm(true) };

  const handleDeptConfirmDelete = () => {
    if (confirmName === 'Alpha') {
      setDeptDangerItems(deptDangerItems.filter(item => item.id !== deleteItem.id));
      setShowDeptConfirm(false);
      setActiveSection('departmentSettings');
      setConfirmName('');
      setDeleteItem(null);
      alert('✅ Department deleted successfully!');
    } else {
      alert('❌ Please enter "Alpha" to confirm deletion');
    }};

    // squadron
  const [squadronData, setSquadronData] = useState([
    { id: 1, name: 'Alpha', students: 5, description: 'Alpha Squadron' },
    { id: 2, name: 'Alpha', students: 5, description: 'Alpha Squadron' },
    { id: 3, name: 'Alpha', students: 5, description: 'Alpha Squadron' },
    { id: 4, name: 'Alpha', students: 5, description: 'Alpha Squadron' },
    { id: 5, name: 'Alpha', students: 5, description: 'Alpha Squadron' }]);

   const [squadronDangerItems, setSquadronDangerItems] = useState([
    { id: 1, name: 'Alpha', students: 10 },
    { id: 2, name: 'Alpha', students: 10 },
    { id: 3, name: 'Alpha', students: 10 },
    { id: 4, name: 'Alpha', students: 10 },
    { id: 5, name: 'Alpha', students: 10 }]);
    const [showSquadronConfirm, setShowSquadronConfirm] = useState(false);
    const handleSquadronDeleteClick = (item) => {
        setDeleteItem(item);
        setShowSquadronConfirm(true);
        setActiveSection('confirmSquadronDelete');};
    const handleSquadronConfirmDelete = () => {
        if (confirmName === 'Alpha') {
            setSquadronDangerItems(squadronDangerItems.filter(item => item.id !== deleteItem.id));
            setShowSquadronConfirm(false);
            setActiveSection('squadronSettings');
            setConfirmName('');
            setDeleteItem(null);
        alert('✅ Squadron deleted successfully!');}
         else { alert('❌ Please enter "Alpha" to confirm deletion');}};



  const renderContent = () => {
    if (activeSection === 'main') {
      return (
        <div className="settings-main">
          <h1>Settings</h1>
          <div className="settings-options">
            <div className="settings-card" onClick={() => setActiveSection('yearSettings')}>
              <span className="settings-icon">📅</span>
              <h3>Year Settings</h3>
              <p>Manage academic years</p>
            </div>
            <div className="settings-card" onClick={() => setActiveSection('departmentSettings')}>
              <span className="settings-icon">🏛️</span>
              <h3>Department Settings</h3>
              <p>Manage departments</p>
            </div>
            <div className="settings-card" onClick={() => setActiveSection('squadronSettings')}>
              <span className="settings-icon">✈️</span>
              <h3>Squadron Settings</h3>
              <p>Manage squadrons</p>
            </div>
          </div>
        </div>
      );
    }

    // year settings
    if (activeSection === 'yearSettings') {
      return (
        <div className="year-settings-content">
          <div className="section-header">
            <button className="back-btn" onClick={() => setActiveSection('main')}>← Back to Settings</button>
            <h1>Year Settings</h1>
            <p>Manage configuration and access control</p>
          </div>

          <div className="data-table blue-table">
            <h2>Years List</h2>
            <table>
              <thead>
                <tr><th>Name</th><th>Students</th><th>Department</th></tr>
              </thead>
              <tbody>
                {yearsData.map(item => (
                  <tr key={item.id}><td>{item.name}</td><td>{item.students}</td><td>{item.department}</td></tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="data-table red-table">
            <h2>⚠️ Danger Zone</h2>
            <p className="warning-text">Irreversible and destructive actions</p>
            <table>
              <thead>
                <tr><th>Name</th><th>Students</th><th>Action</th></tr>
              </thead>
              <tbody>
                {dangerItems.map(item => (
                  <tr key={item.id}>
                    <td>{item.name}</td>
                    <td>{item.students} Student{item.students !== 1 ? 's' : ''}</td>
                    <td><button className="delete-btn" onClick={() => handleDeleteClick(item)}>Delete</button></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      );
    }

    // delete to sure
    if (activeSection === 'confirmDelete') {
      return (
        <div className="confirm-delete-content">
          <div className="confirm-card">
            <h2>Delete Year</h2>
            <p className="warning">⚠️ This action cannot be undone</p>
            <p className="warning-text">Deleting this course will permanently remove all associated data from the system. This is an irreversible operation that will impact your organization.</p>
            
            <div className="confirm-input">
              <label>To Confirm Type The Year Name</label>
              <input 
                type="text" 
                placeholder="Alpha" 
                value={confirmName}
                onChange={(e) => setConfirmName(e.target.value)}
              />
            </div>
            
            <div className="confirm-buttons">
              <button className="cancel-btn" onClick={() => { setActiveSection('yearSettings'); setConfirmName(''); }}>Cancel</button>
              <button className="confirm-delete-btn" onClick={handleConfirmDelete}>Delete</button>
            </div>
          </div>
        </div>);}


   //department settind
     if (activeSection === 'departmentSettings') {
        return(
    <div className="department-settings-content">
      <div className="section-header">
        <button className="back-btn" onClick={() => setActiveSection('main')}>← Back to Settings</button>
        <h1>Department Settings</h1>
        <p>Manage configuration and access control</p>
      </div>

      <div className="data-table blue-table">
        <h2>Name</h2>
        <table>
          <thead><tr><th>Student Count</th><th>Description</th></tr></thead>
          <tbody>
            {deptData.map(item => (
              <tr key={item.id}><td>{item.students}</td><td>{item.description}</td></tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="data-table red-table">
        <h2>⚠️ Danger Zone</h2>
        <p className="warning-text">Irreversible and destructive actions</p>
        <table>
          <thead><tr><th>All Departments</th><th>Actions</th></tr></thead>
          <tbody>
            {deptDangerItems.map(item => (
              <tr key={item.id}>
                <td>{item.name}</td>
                <td><button className="delete-btn" onClick={() => handleDeptDeleteClick(item)}>Delete</button></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );}

  if (activeSection==='confirmDeptDelete'){
    return(
        <div className='confirm-overlay'>
            <div className='confirm-card'>
                <h2>Delete Department</h2>
                <p className='warning'> ⚠️ This action cannot be undone</p>
              <p className="warning-text">Deleting this course will permanently remove all associated data from the system. This is an irreversible operation that will impact your organization.</p>
            <div className="confirm-input">
              <label>To Confirm Type The Department Name</label>
              <input 
                type="text" 
                placeholder="Alpha" 
                value={confirmName}
                onChange={(e) => setConfirmName(e.target.value)} />
            </div>
            <div className="confirm-buttons">
              <button className="cancel-btn" onClick={() => { setActiveSection('departmentSettings'); setConfirmName(''); }}>Cancel</button>
              <button className="confirm-delete-btn" onClick={handleDeptConfirmDelete}>Delete</button>
            </div>
          </div>
        </div>);} };


//squardon

     if (activeSection === 'squadronSettings') {
         return (
            <div className="settings-main-content">
                <div className='year-settings-content'>
                <div className="section-header">
                    <button className="back-btn" onClick={() => setActiveSection('main')}>← Back to Settings</button>
                    <h1>Squadron Settings</h1>
                    <p>Manage configuration and access control</p>
                </div>
                <div className="data-table blue-table">
                    <h2>Name</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Student Count</th>
                                <th>Description</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                    <tbody>
                        {squadronData.map(item => (
                            <tr key={item.id}>
                                <td>{item.name}</td>
                                <td>{item.students}</td>
                                <td>{item.description}</td>
                                <td> <button className="edit-btn-small">✏️</button></td>
                            </tr>))}
                    </tbody>
                    </table>
                </div>
            <div className="data-table red-table">
                <h2>⚠️ Danger Zone</h2>
                <p className="warning-text">Irreversible and destructive actions</p>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Students</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                <tbody>
                    {squadronDangerItems.map(item => (
                        <tr key={item.id}>
                            <td>{item.name}</td>
                            <td>{item.students} Student{item.students !== 1 ? 's' : ''}</td>
                            <td><button className="delete-btn" onClick={() => handleSquadronDeleteClick(item)}>Delete</button></td>
                        </tr>))}
                </tbody>
            </table>
        </div>
        </div>
    </div>);}
   
            if (activeSection === 'confirmSquadronDelete') {
                return (
                <div className="settings-main-content">
                    {renderContent()}
                    {showSquadronConfirm && activeSection ==='confirmSquadronDelete'&& (
                    <div className="confirm-card">
                        <h2>Delete Squadron</h2>
                        <p className="warning">⚠️ This action cannot be undone</p>
                        <p className="warning-text">Deleting this course will permanently remove all associated data from the system. This is an irreversible operation that will impact your organization.</p>
                        <div className="confirm-input">
                            <label>To Confirm Type The Squadron Name</label>
                            <input type="text" placeholder="Alpha" value={confirmName} onChange={(e) => setConfirmName(e.target.value)} />
                        </div>
                    <div className="confirm-buttons">
                        <button className="cancel-btn" onClick={() => { setShowSquadronConfirm(false); setActiveSection('squadronSettings'); setConfirmName(''); }}>Cancel</button>
                        <button className="confirm-delete-btn" onClick={handleSquadronConfirmDelete}>Delete</button>
                    </div>
                </div>)}
            </div>
            );}   

  return (
    <div className="settings-page">
      {/* Sidebar */}
      <div className="sidebar">
        <nav className="nav-menu">
          <div className="nav-item" onClick={() => navigate('/profile')}><span className="nav-icon">👤</span><span>Profile</span></div>
          <div className="nav-item" onClick={() => navigate('/courses')}><span className="nav-icon">📚</span><span>My Courses</span></div>
          <div className="nav-item" onClick={() => navigate('/announcements')}><span className="nav-icon">📢</span><span>Announcements</span></div>
          <div className="nav-item" onClick={() => navigate('/grades')}><span className="nav-icon">📊</span><span>Grades overview</span></div>
          <div className="nav-item" onClick={() => navigate('/createyear')}><span className="nav-icon">📅</span><span>Create Years</span></div>
          <div className="nav-item" onClick={() => navigate('/allyear')}><span className="nav-icon">📋</span><span>All Years</span></div>
          <div className="nav-item" onClick={() => navigate('/createuser')}><span className="nav-icon">👥</span><span>Create User</span></div>
          <div className="nav-item" onClick={() => navigate('/allusers')}><span className="nav-icon">👤</span><span>All Users</span></div>
          <div className="nav-item" onClick={() => navigate('/newcourse')}><span className="nav-icon">📝</span><span>Create New Course</span></div>
          <div className="nav-item" onClick={() => navigate('/createdepartment')}><span className="nav-icon">🏛️</span><span>Create Department</span></div>
          <div className="nav-item" onClick={() => navigate('/alldepartments')}><span className="nav-icon">🏢</span><span>All Departments</span></div>
          <div className="nav-item" onClick={() => navigate('/createsquadron')}><span className="nav-icon">✈️</span><span>Create Squadron</span></div>
          <div className="nav-item" onClick={() => navigate('/allsquadron')}><span className="nav-icon">🛩️</span><span>All Squadron</span></div>
          <div className="nav-item active" onClick={() => setActiveSection('main')}><span className="nav-icon">⚙️</span><span>Settings</span></div>
          <div className="nav-item logout"><span className="nav-icon">🚪</span><span>Logout</span></div>
        </nav>
      </div>

      {/* main same */}
      <div className="settings-main-content">
        {renderContent()}
      </div>
    </div>
  );
};

export default Settings;