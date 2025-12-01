import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import LandingPage from "./components/LandingPage.jsx";
import LoginPage from "./components/LoginPage.jsx";
import CoursesPage from "./components/CoursesPage.jsx";
import NotFound from "./components/NotFound.jsx";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/courses" element={<CoursesPage />} />
        {/*<Route path="/courses" element={user? <CoursesPage/> : <LoginPage/> }/>*/}
        <Route path="*" element={<NotFound />} />
      </Routes>
    </Router>
  );
}

export default App;
