// Logout
const logoutBtn = document.getElementById("logoutBtn");
if (logoutBtn) {
  logoutBtn.addEventListener("click", () => {
    document.body.style.opacity = "0";
    document.body.style.transition = "opacity 0.5s ease";

    setTimeout(() => {
      localStorage.removeItem("userName");
      window.location.href = "signin.html";
    }, 500);
  });
}
// Login w Token mn mofeed
const signinForm = document.getElementById("signinForm");
if (signinForm) {
  signinForm.addEventListener("submit", async function (e) {
    e.preventDefault();
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value.trim();
    const emailError = document.getElementById("emailError");
    const passwordError = document.getElementById("passwordError");
    let isValid = true;

    //errors
    emailError.textContent = "";
    passwordError.textContent = "";

    // Email eli masmoh beh
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
      emailError.textContent = "Please enter a valid email address.";
      isValid = false;
    }
    // Password w tahdeedoh
    if (password.length < 6) {
      passwordError.textContent = "Password must be at least 6 characters long.";
      isValid = false;
    }
    // brbot m3 el api
    if (isValid) {
      console.log("Sending login request...");
      try {
        const response = await fetch("http://skylearnapi.runasp.net/api/Auth/login", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ email, password }),
        });
        const data = await response.json();
        console.log("Response status:", response.status);
        console.log("Response data:", data); 
        if (response.ok && data.token) {
          // save data w el token mofeed
          localStorage.setItem("token", data.token);
          localStorage.setItem("loggedInUser", JSON.stringify({ email }));

          const userName = email.split("@")[0];
          localStorage.setItem("userName", userName);

          console.log("Login successful, redirecting to courses.html");  
          // broh le padge el corsat
          window.location.href = "courses.html";
        } else {
          passwordError.textContent = data.message || "Login failed. Check your credentials.";
          console.log("Login failed:", data.message);  
        }
      } catch (error) {
        console.error("Error during login:", error);
        passwordError.textContent = "Something went wrong. Please try again later.";
      }
    }
  });
}
//Logout  for Request
if (logoutBtn) {
  logoutBtn.addEventListener("click", async () => {
    document.body.style.transition = "opacity 0.5s ease";
    document.body.style.opacity = "0";

    const token = localStorage.getItem("token");

    try {
      console.log("Sending logout request..."); 
      await fetch("http://skylearnapi.runasp.net/api/Auth/logout", {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${token}`, 
          "Content-Type": "application/json",
        },
      });
      console.log("Logout successful");  
    } catch (error) {
      console.error("Logout error:", error);
    }

    setTimeout(() => {
      localStorage.removeItem("userName");
      localStorage.removeItem("loggedInUser");
      localStorage.removeItem("token");
      window.location.href = "signin.html";
    }, 500);
  });
}

// lma el user ed5ol y3raf hwa rayah l fen
document.addEventListener("DOMContentLoaded", () => {
  const user = JSON.parse(localStorage.getItem("loggedInUser"));
  const currentPage = window.location.pathname.split("/").pop();

  console.log("Checking if user is logged in:", user); 
  if (user && (currentPage === "signin.html" || currentPage === "index.html")) {
    window.location.href = "courses.html";
  }
});

//el sahm
document.addEventListener("DOMContentLoaded", () => {
  const dropdownBtn = document.getElementById("userDropdown");
  const dropdownMenu = document.getElementById("dropdownMenu");

  if (dropdownBtn && dropdownMenu) {
    dropdownBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      dropdownMenu.classList.toggle("show");
      dropdownBtn.classList.toggle("rotate");
    });

    document.addEventListener("click", () => {
      dropdownMenu.classList.remove("show");
      dropdownBtn.classList.remove("rotate");
    });
  }
});
