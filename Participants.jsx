import React from "react";
import { Link } from "react-router-dom";
import './css/Participants.css';

const users = [
  { name: "Frances Banks", role: "Teacher", group: "No groups", last: "5 days 12 hours" },
  { name: "Angela Bowman", role: "Student", group: "GroupA", last: "Never" },
  { name: "Lao Cai", role: "Student", group: "GroupA", last: "Never" },
  { name: "Paul Castillo", role: "Student", group: "No groups", last: "Never" },
  { name: "Maria Cruz", role: "Student", group: "No groups", last: "Never" },
  { name: "Thomas Day", role: "Student", group: "No groups", last: "Never" },
  { name: "Lisa Diaz", role: "Student", group: "No groups", last: "5 days 12 hours" },
  { name: "Brian Franklin", role: "Student", group: "No groups", last: "5 days 12 hours" },
  { name: "Barbara Gardner", role: "Student", group: "No groups", last: "11 secs" },
  { name: "Amy George", role: "Student", group: "No groups", last: "Never" },
  { name: "Ann Hansen", role: "Student", group: "No groups", last: "Never" },
  { name: "William Kim", role: "Student", group: "No groups", last: "Never" },
  { name: "Joshua Knight", role: "Student", group: "No groups", last: "5 days 12 hours" },
  { name: "Jennifer Larson", role: "Student", group: "No groups", last: "Never" },
  { name: "Steve Moreno", role: "Student", group: "No groups", last: "Never" },
  { name: "Anthony Ramirez", role: "Student", group: "No groups", last: "5 days 12 hours" },
  { name: "David Ray", role: "Student", group: "No groups", last: "5 days 12 hours" },
  { name: "Heather Reyes", role: "Student", group: "No groups", last: "11 years 96 days" },
  { name: "Eric Richard", role: "Student", group: "No groups", last: "Never" },
  { name: "Jeffrey Sanders", role: "Teacher", group: "No groups", last: "31 mins 5 secs" }
];

export default function Participants() {
  return (
    <div className="participants-page">
      {/* hena 3l4an nrboot el to files swa*/ }
      <h1>Celebrating Cultures</h1>
      <div className="tabs">
        <Link to="/culture" className="tab">Course</Link>
        <Link to="/culture/participants" className="tab active">Participants</Link>
        <span className="tab">Grades</span>
        <span className="tab">Activities</span>
      </div>

      <div className="search-bar">
        <input type="text" placeholder="Search" />
      </div>

      <div className="letters-filter">
        <span>First name</span>
        {"ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("").map(letter => ( <button key={letter}>{letter}</button>))}
      </div>

      <div className="letters-filter">
        <span>Last name</span>
        {"ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("").map(letter => ( <button key={letter}>{letter}</button>))}
      </div>

      <p className="count">{users.length} participants found</p>

      <table>
        <thead>
          <tr>
            <th>First name / Last name</th>
            <th>Calculated weight</th>
            <th>Role</th>
            <th>Groups</th>
            <th>Last access to course</th>
          </tr>
        </thead>

        <tbody>
          {users.map((u, i) => (
            <tr key={i}>
              <td>{u.name}</td>
              <td>78.06%</td>
              <td>{u.role}</td>
              <td>{u.group}</td>
              <td>{u.last}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <div className="pagination">
        <button>{"<"}</button>
        <button className="active">1</button>
        <button>2</button>
        <button>{">"}</button>
      </div>

    </div>
  );
}
