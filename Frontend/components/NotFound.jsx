import React from "react";
const NotFound = () => {
  return (
    <div style={{ textAlign: "center", marginTop: "100px" }}>
      <h1 style={{ fontSize: "80px", color: "#ff6b6b" }}>404</h1>
      <p style={{ fontSize: "20px" }}>Oops! Page not found 😅</p>
      <a href="/" style={{ color: "#007bff" }}>Go back to Home</a>
    </div>
  );
};

export default NotFound;
