import React from "react";
import { BrowserRouter as Router, Routes, Route, BrowserRouter, Navigate } from "react-router-dom";
import LandingPage from "./components/LandingPage.jsx";
import LoginPage from "./components/LoginPage.jsx";
import CoursesPage from "./components/CoursesPage.jsx";
import NotFound from "./components/NotFound.jsx";
import CelebratingCultures from "./components/Celebrating.jsx";
import Participants from "./components/Participants.jsx";
import Grades from "./components/Grades.jsx";
import Activities from "./components/Activities.jsx";
import Dashboard from "./components/Dashboard.jsx";
import Profile from "./components/Profile.jsx";
import MyCourses from "./components/MyCourses.jsx";
import Announcements from "./components/Announcements.jsx";
import Createyears from "./components/Createyears.jsx";
import AllYears from "./components/AllYears.jsx";
import CreateUser from "./components/CreateUser.jsx";
import AllUsers from "./components/AllUsers.jsx";
import NewCourse from "./components/NewCourse.jsx";
import CreateDepartment from "./components/CreateDepartment.jsx";
import AllDepartments from "./components/AllDepartments.jsx";
import CreateSquadron from "./components/CreateSquadron.jsx";
import AllSquadron from "./components/AllSquadron.jsx";
import Settings from "./components/Settings.jsx";




function App() {
  return(
      <Routes>
        <Route path="/" element={<Profile/>}/>
        <Route path="/profile" element={<Profile/>}/>
        <Route path="/courses" element={<MyCourses/>}/>
        <Route path="/announcement" element={<Announcements/>}/>
        <Route path="/createyear" element={<Createyears/>}/>
        <Route path="/allyear" element={<AllYears/>}/>
        <Route path="/createuser" element={<CreateUser/>}/>
        <Route path="/allusers" element={<AllUsers/>}/>
        <Route path="/newcourse" element={<NewCourse/>}/>
        <Route path="/createdepartment" element={<CreateDepartment/>}/>
        <Route path="/alldepartments" element={<AllDepartments/>}/>
        <Route path="/createsquadron" element={<CreateSquadron/>}/>
        <Route path="/allsquadron" element={<AllSquadron/>}/>
        <Route path="/settings" element={<Settings/>}/>
      </Routes>
    /*<div> <Profile/>  </div>*/
    /*<div> <Dashboard/>  </div>*/
  )
  
/* return (
    <Routes>
      <Route path="/" element={<Navigate to="/culture" />} />
      <Route path="/culture" element={<CelebratingCultures />} />
      <Route path="/culture/participants" element={<Participants />} />
      <Route path="/culture/grades" element={<Grades />} />
      <Route path="/culture/activities" element={<Activities />} />
    </Routes>
  );*/

  /*return(<Participants/> )*/
  /*<BrowserRouter> 
   <Routes>
      <Route path="/"element={ Navigate to="/culture"/>}/>
      <Route path="/culture/participants" element={<Participants/>}             />
   </Routes>
  </BrowserRouter>*/

  /*return ( <CelebratingCultures/>*/
    /*<Router>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/courses" element={<CoursesPage />} />
        {/*<Route path="/courses" element={user? <CoursesPage/> : <LoginPage/> }/>*//*}
        <Route path="/celebrating" element={<CelebratingCultures/>}/>
        <Route path="*" element={<NotFound />} />
      </Routes>*/
    /*</Router>*/
  /*);*/
}
export default App;
