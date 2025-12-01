import React from "react";
import { useNavigate } from "react-router-dom";

const Navbar = () => {
  const navigate = useNavigate();
  const logoutAndGoHome = () => { localStorage.removeItem("userToken");
    navigate("/home");
  };
  return ( <nav className="flex justify-between items-center p-4 bg-gray-100 shadow-md">
      <div className="font-bold text-xl text-gray-700">MyWebsite</div>
      <div className="flex gap-3">
        
        <button onClick={() => navigate("/login")}
          className="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg shadow 
          hover:shadow-lg transition duration-300"> Sign In</button>

        <button onClick={() => navigate("/courses")}
          className="bg-green-500 hover:bg-green-600 text-white font-semibold py-2 px-4 rounded-lg 
          shadow hover:shadow-lg transition duration-300"> Start Learning </button>

        <button onClick={logoutAndGoHome}
          className="bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-4 rounded-lg 
          shadow hover:shadow-lg transition duration-300"> Logout </button>

      </div>
    </nav>
  );
};
export default Navbar;