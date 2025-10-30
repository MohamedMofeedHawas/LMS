import React, { useContext, useEffect } from 'react';
import { AuthContext } from '../context/AuthContext.jsx';
import { useNavigate } from 'react-router-dom';
import './CoursesPage.css';
import photo from '<src/photo/photo.jpg';
import photo1 from 'src/photo/photo1.jpg';
import photo2 from 'src/photo/pyhoto2.jpg';
import photo3 from 'src/photo/photo3-css.jpg';
import photo4 from 'src/photo/photo4.jpg';

const CoursesPage = () => {
  const { user, logout } = useContext(AuthContext);
  const navigate = useNavigate();

  // lw el user msgalsh so come back ll main
  useEffect(() => {
    if (!user) {
      navigate('/login');}
  }, [user, navigate]);

  const handleLogout = async () => {
    await logout();
    navigate('/');
  };

  const courses = [
    { name: "chemical nomenclature", img: photo },
    { name: "class and conflict in world cinema", img: photo1 },
    { name: "Psychlogy in cinema", img: photo2 },
    { name: "celebrating culture", img: photo3 },
    { name: "A1/A2 english with h5p", img: photo4 },
  ];

  return (
    <div className="courses-page">
      <header className="courses-header">
        <h1>Welcome, {user?.email?.split('@')[0]}</h1>
        <button onClick={handleLogout} className="logout-btn">Logout</button>
      </header>

      <main className="courses-container">
        {courses.map((course, index) => (
          <div key={index} className="course-card">
            <img src={course.img} alt={course.name} />
            <h3>{course.name}</h3>
          </div>
        ))}
      </main>
    </div>
  );
};

export default CoursesPage;