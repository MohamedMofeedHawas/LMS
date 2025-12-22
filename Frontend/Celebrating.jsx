import React from 'react';
import './css/Celebrating.css'; 
import helloImg  from "../assets/hello.jpg"
import hiImg  from "../assets/hi.jpg"
import funImg  from "../assets/fun.jpg"

const Celebrating = ({ imageUrl, moodiersImage, workshopImage }) => {
  return (
    <div className="page-container">
      
      {/* el navbar */}
      <nav className="navbar">
        <div className="navbar-left">
          <div className="logo-placeholder">
            {/* el notification */}
          </div>
        </div> 

        <div className="navbar-center">
          <a href="#" className="nav-link">Home</a>
          <a href="#" className="nav-link">My Courses</a>
          <a href="#" className="nav-link">Dashboard</a>
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
        
        {/* el 3enwan el 2sasi */}
        <h2 className="main-title mt-50">Celebrating Cultures</h2>
        
        {/* el shreet eli batharak mno */}
        <div className="sub-nav">
          <a href="#" className="sub-nav-link active-sub-nav-link">Course</a>
          <a href="#" className="sub-nav-link">Participants</a>
          <a href="#" className="sub-nav-link">Grades</a>
          <a href="#" className="sub-nav-link">Activities</a>
        </div>
        <hr className="divider" />
        
        {/* mohtawa el video */}
        <div className="welcome-section">
          <div className="welcome-header">
            <span>↓ Welcome! Alohai Bonvenon!</span>
            <a href="#" className="collapse-link">Collapse all</a>
          </div>
          <p className="welcome-text">
            We are all from different communities but we are all one community at Mount Orange. This course is for students, teachers and the wider community members to share and learn about our cultural diversity.
          </p>
          {/* mohtawa el sora*/}
          <div className="video-placeholder-container">
            <img 
              src={imageUrl || 'path/to/your/placeholder/image.jpg'} 
              alt="Cultural Celebration" 
              className="video-placeholder-image"
            />
            {/*put the photo */}
           <img src={ helloImg}
          alt='hello' 
          className='w-full max-w-5xl rounded-lg shadow'/> 

          {/* to play*/}
            <div className="play-button">
              <span>▶</span>
            </div> 
          </div>
          {/* el bta3 el taht llsora */}
          <div className="bottom-bar">
            <span className="bottom-bar-text">
              <span className="file-icon">📄</span>
              Interesting cities
            </span>
            <span className="bottom-bar-note">
              No need to download these images - view them here
            </span>
          </div>
        </div>

        {/* bta3 el active */}
        <div className="activities-content">
          <h2 className="section-title">Activities</h2>

          {/* el data for food*/}
          <div className="activity-item">
            <div className="activity-icon">📄</div>
            <div className="activity-details">
              <h3 className="activity-title">Database: Food for Moodiers</h3>
              <p className="activity-description">Share your favourite meal or recipe with others here.</p>
            </div>
            <div className="activity-image-container">

              <img 
                src={hiImg} 
                alt="Food for Moodiers" 
                className=" activity-image"
                />

            </div>
          </div>
          
          {/* eli bt3alem mno */}
          <div className="activity-item">
            <div className="activity-icon">📑</div>
            <div className="activity-details">
              <h3 className="activity-title">Glossary: Informational Teaching Terms</h3>
              <p className="activity-description">Elux uses around the world was a variety of phrases and acronyms. Add yours to this glossary.</p>
            </div>
          </div>

          {/* hw */}
          <div className="activity-item">
            <div className="activity-icon">✍️</div>
            <div className="activity-details">
              <h3 className="activity-title">Assignment: Languages of Love</h3>
              <p className="activity-description">Speak 10 us!</p>
            </div>
          </div>

          {/* mobile hw */}
          <div className="activity-item">
            <div className="activity-icon">📲</div>
            <div className="activity-details">
              <h3 className="activity-title">(Mobile assignment) View from your window</h3>
              <p className="activity-description">With at ina and issues to many different and varied locations. Take a piece within your amnistries or inact omyies of ma view from your window. Upated it has. From your nocitle and add a few words to explain it.</p>
            </div>
          </div>
          
          {/* el sho8el */}
          <div className="activity-item">
            <div className="activity-icon">🏗️</div>
            <div className="activity-details">
              <h3 className="activity-title">Workshop: My home country</h3>
              <p className="activity-description">In this activity, you're asked to submit some work and then witness 4 submissions from other participants. After submitting your work, you need to check best here to your accoss other participants' work.</p>
              <div className="workshop-image-placeholder">
                <img 
                  src={funImg} 
                  alt="Workshop Placeholder" 
                  className="activity-image workshop-red-border"
                />
              </div>
            </div>
          </div>

          {/* el hw */}
          <div className="activity-item">
            <div className="activity-icon">📝</div>
            <div className="activity-details">
              <h3 className="activity-title">Assignment: My homm donation</h3>
              <p className="activity-description">Tell lia your choice destination!!</p>
            </div>
          </div>

          {/* bta3 el mozakra*/}
          <div className="activity-item">
            <div className="activity-icon">📄</div>
            <div className="activity-details">
              <h3 className="activity-title">Database: Identity Pages (donated by Elton LaClare)</h3>
            </div>
          </div>

          {/* el quizes */}
          <div className="activity-item">
            <div className="activity-icon">❓</div>
            <div className="activity-details">
              <h3 className="activity-title">Quiz: Know Bestful Places</h3>
              <p className="activity-description">Have a better be as out<br/>deng knews</p>
            </div>
          </div>

          {/* bd5al el database */}
          <div className="activity-item">
            <div className="activity-icon">📄</div>
            <div className="activity-details">
              <h3 className="activity-title">Database: Identity Pages...</h3>
              <p className="activity-description">...as well you know London, the United Kingdom. Accorate and different types of Geography in a quiz which demonstrates the four kew qendies types avaliable excel Moodle 3.0.</p>
            </div>
          </div>
          
          {/*Remarktable Locations */}
          <div className="activity-item">
            <div className="activity-icon">📄</div>
            <div className="activity-details">
              <h3 className="activity-title">Presentation: Remarktable Locations</h3>
              <p className="activity-description">Uploaded 16/11/15, 15:12</p>
            </div>
          </div>
          
          {/* el topic eli taht*/}
          <div className="topic-footer">
            <div className="topic-icon">↓</div>
            <span>Topic 2</span>
            <span className="restriction-tag">Not available</span>
          </div>

        </div>
        
      </div>
    </div>
  );
};

export default Celebrating;