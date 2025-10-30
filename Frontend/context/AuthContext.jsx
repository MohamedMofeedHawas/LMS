import React, { createContext, useState, useEffect } from "react";
import axios from "axios";
export const AuthContext = createContext();
export const AuthProvider = ({ children }) => {
  // save data and token
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem("token") || null);
  // check from data is in storage
  useEffect(() => {
    const savedUser = localStorage.getItem("loggedInUser");
    if (savedUser) {
      try {setUser(JSON.parse(savedUser)); } 
        catch {localStorage.removeItem("loggedInUser");}
    }
  }, []);
  // to make login
  const login = async (email, password) => {
    try {
      const { data } = await axios.post( "http://skylearn.runasp.net/api/Auth/login",
        { email, password } );

      if (data?.token) { setToken(data.token);
        setUser({ email });
        // save data
        localStorage.setItem("token", data.token);
        localStorage.setItem("loggedInUser", JSON.stringify({ email }));
        localStorage.setItem("userName", email.split("@")[0]);} }
         catch (err) {  console.error("Login failed:", err);
      throw err; }
  };

  // to make logout
  const logout = async () => {
    try {await axios.post("http://skylearn.runasp.net/api/Auth/logout",
        {},
        { headers: { Authorization: Bearer &{token} } }
      );
    } catch (err) {console.error("Logout error:", err);
    } finally {
      // to make data clean
      setUser(null);
      setToken(null);
      localStorage.clear();
    }
  };

  return (
    <AuthContext.Provider value={{ user, token, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};