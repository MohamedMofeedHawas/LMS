import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import './css/Grades.css';

const Grades = () => {
  const [reportType, setReportType] = useState('overview');

  return (
    <div className="page-container">
      <nav className="navbar">
        <div className="navbar-left">
          <div className="logo-placeholder"></div>
        </div> 

        <div className="navbar-center">
          <Link to="/culture" className="nav-link">Home</Link>
          <Link to="#" className="nav-link">My Courses</Link>
          <Link to="#" className="nav-link">Dashboard</Link>
        </div>
        
        <div className="navbar-right">
          <span className="icon-placeholder">🔍</span>
          <span className="icon-placeholder">🔔</span>
          <span className="icon-placeholder">💬</span>
          <span className="icon-placeholder">👤</span>
          <span className="icon-placeholder">⚙️</span>
        </div>
      </nav>
      
      <div className="content-container">
        <h2 className="main-title">Celebrating Cultures</h2>
        
        <div className="sub-nav">
          <Link to="/culture" className="sub-nav-link">Course</Link>
          <Link to="/culture/participants" className="sub-nav-link">Participants</Link>
          <Link to="/culture/grades" className="sub-nav-link active">Grades</Link>
          <Link to="/culture/activities" className="sub-nav-link">Activities</Link>
        </div>
        
        <hr className="divider" />

        <div className="report-toggle">
          <button 
            className={`toggle-btn ${reportType === 'overview' ? 'active' : ''}`}
            onClick={() => setReportType('overview')}
          >
            Overview report
          </button>
          <button 
            className={`toggle-btn ${reportType === 'user' ? 'active' : ''}`}
            onClick={() => setReportType('user')}
          >
            User report
          </button>
        </div>

        {/* Overview Report */}
        {reportType === 'overview' && (
          <div className="grades-content">
            <h3 className="report-title">
              <span className="dropdown-icon">▼</span>
              Overview report
            </h3>

            <div className="student-info">
              <h4 className="student-name">Barbara Gardner</h4>
              <div className="course-label">
                <span className="label">Course name</span>
                <span className="value">Grade</span>
              </div>
            </div>

            <div className="grades-list">
              {/* Grade Item 1 */}
              <div className="grade-item">
                <div className="grade-info">
                  <p className="grade-title">Workshop: My home country (submission)</p>
                  <span className="grade-type workshop">WORKSHOP</span>
                </div>
                <div className="grade-percentage high">76.92 %</div>
              </div>

              {/* Grade Item 2 */}
              <div className="grade-item">
                <div className="grade-info">
                  <p className="grade-title">Workshop: My home country (assessment)</p>
                  <span className="grade-type workshop">WORKSHOP</span>
                </div>
                <div className="grade-percentage medium">17.52 %</div>
              </div>

              {/* Grade Item 3 */}
              <div className="grade-item">
                <div className="grade-info">
                  <p className="grade-title">Database: Food for Moodlers</p>
                  <span className="grade-type database">DATABASE</span>
                </div>
                <div className="grade-percentage low">2.88 %</div>
              </div>

              {/* Grade Item 4 */}
              <div className="grade-item">
                <div className="grade-info">
                  <p className="grade-title">Assignment: My dream destination</p>
                  <span className="grade-type assignment">ASSIGNMENT</span>
                </div>
                <div className="grade-percentage zero">0.00 %</div>
              </div>

              {/* Grade Item 5 */}
              <div className="grade-item">
                <div className="grade-info">
                  <p className="grade-title">Quiz: Know your Geography!</p>
                  <span className="grade-type quiz">QUIZ</span>
                </div>
                <div className="grade-percentage zero">0.00 %</div>
              </div>

              {/* Grade Item 6 */}
              <div className="grade-item">
                <div className="grade-info">
                  <p className="grade-title">Assignment: Languages of Love</p>
                  <span className="grade-type assignment">ASSIGNMENT</span>
                </div>
                <div className="grade-percentage zero">0.00 %</div>
              </div>

              {/* Grade Item 7 */}
              <div className="grade-item">
                <div className="grade-info">
                  <p className="grade-title">(Mobile assignment) View from your window</p>
                  <span className="grade-type assignment">ASSIGNMENT</span>
                </div>
                <div className="grade-percentage zero">0.00 %</div>
              </div>

              {/* Course Total */}
              <div className="course-total">
                <div className="total-info">
                  <p className="total-title">Course total</p>
                  <span className="total-type">AGGREGATION</span>
                </div>
                <div className="total-percentage">97.33%</div>
              </div>
            </div>
          </div>
        )}

        {/* User Report */}
        {reportType === 'user' && (
          <div className="user-report">
            <h3 className="report-title">
              <span className="dropdown-icon">▼</span>
              User report
            </h3>
            <div className="user-report-placeholder">
              <p>User report content will be displayed here...</p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Grades;