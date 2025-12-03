import React, { createContext, useState, useEffect } from "react";
import axios from "axios";
export const AuthContext = createContext();
export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);

  const [token, setToken] = useState(localStorage.getItem("token") || null);

  useEffect(() => {
    const savedUser = localStorage.getItem("loggedInUser");
    if (savedUser) {
      try {
        setUser(JSON.parse(savedUser));
      } catch (err) {
        console.error("Error parsing user from localStorage:", err);
        localStorage.removeItem("loggedInUser");
      }
    }
  }, []);

  const login = async (email, password) => {
    try {
      const { data } = await axios.post(
        "http://skylearn.runasp.net/api/Auth/login",
        { email, password }
      );

      if (data?.token) {
        setToken(data.token);
        setUser({ email });

        localStorage.setItem("token", data.token);
        localStorage.setItem("loggedInUser", JSON.stringify({ email }));
        localStorage.setItem("userName", email.split("@")[0]);
      }
    } catch (err) {
      console.error("Login failed:", err);
      throw err;
    }
  };

  const logout = async () => {
    try {
      await axios.post(
        "http://skylearn.runasp.net/api/Auth/logout",
        {},
        { headers: { Authorization:` Bearer ${token}` } }
      );
    } catch (err) {
      console.error("Logout error:", err);
    } finally {
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