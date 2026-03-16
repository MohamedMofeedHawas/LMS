from datetime import datetime

SEED = 42

DEPT_IDS       = [1, 2, 3]
INSTRUCTOR_IDS = list(range(1, 16))

DATE_RANGES = [
    (datetime(2022, 1, 1), datetime(2022, 12, 31)),
    (datetime(2023, 1, 1), datetime(2023, 12, 31)),
    (datetime(2024, 1, 1), datetime(2024, 12, 31)),
    (datetime(2025, 1, 1), datetime(2025, 6, 30)),
]

USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 Safari/605.1.15",
    "Mozilla/5.0 (X11; Linux x86_64) Gecko/20100101 Firefox/121.0",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 Mobile/604.1",
    "Mozilla/5.0 (Android 13; Mobile) Gecko/121.0 Firefox/121.0",
    "curl/7.68.0",
]

LOG_SENTENCES = [
    "The system processed the request successfully.",
    "User authentication was completed.",
    "Data import finished without errors.",
    "Squadron assignment updated by admin.",
    "Profile information was reviewed.",
    "Bulk operation completed for selected records.",
    "Access token generated for session.",
    "Record was archived by the administrator.",
    "Enrollment confirmed for the selected course.",
    "Annual academic year data was synchronized.",
    "User session expired and was terminated.",
    "Password reset request was initiated.",
    "New student record was added to the system.",
    "Course registration period has been updated.",
    "System backup was completed successfully.",
]

FIRST_NAMES = [
    "Ahmed", "Mohamed", "Omar", "Youssef", "Kareem", "Hassan", "Ali", "Ibrahim",
    "Mahmoud", "Khaled", "Mostafa", "Tamer", "Wael", "Nader", "Tarek", "Amr",
    "Sara", "Nour", "Mona", "Aya", "Dina", "Rania", "Hana", "Mariam",
    "Nadia", "Salma", "Yasmine", "Fatma", "Heba", "Laila", "Samira", "Amira",
]

LAST_NAMES = [
    "Mohamed", "Ahmed", "Hassan", "Ali", "Ibrahim", "Khalil", "Sayed",
    "Mostafa", "Abdallah", "Mahmoud", "Nasser", "Fahmy", "Gaber", "Hamdy",
    "El-Sayed", "Abdelaziz", "Abdelhamid", "Abdelrahman", "Fathy", "Samir",
]

CITIES = [
    "Cairo", "Alexandria", "Giza", "Mansoura", "Tanta", "Assiut",
    "Luxor", "Aswan", "Ismailia", "Suez", "Port Said", "Fayoum",
    "Zagazig", "Beni Suef", "Minya", "Hurghada", None, None,
]

COURSE_TITLES = [
    "Data Structures", "Algorithms", "Operating Systems", "Database Systems",
    "Machine Learning", "Computer Networks", "Software Engineering",
    "Cyber Security Fundamentals", "Artificial Intelligence", "Web Development",
    "Mobile App Development", "Cloud Computing", "Data Science",
    "Computer Architecture", "Discrete Mathematics",
]

LECTURE_TITLES = [
    "Introduction to the Course", "Data Structures Overview", "Linked Lists",
    "Trees and Graphs", "Sorting Algorithms", "Search Algorithms",
    "Dynamic Programming", "OOP Concepts", "Design Patterns",
    "Database Normalization", "SQL Joins", "Indexing & Performance",
    "Machine Learning Basics", "Neural Networks", "Computer Vision Intro",
    "Network Protocols", "Cybersecurity Fundamentals", "Encryption Methods",
    "OS Scheduling", "Memory Management", "Concurrency",
    "Web Development Basics", "REST APIs", "Cloud Architecture",
    "Python for Data Science", "Big Data Overview", "Ethics in AI",
]

QUESTIONS_BANK = [
    ("What is the time complexity of binary search?",    "O(log n)",                              ["O(n)", "O(n²)", "O(1)"]),
    ("Which data structure uses LIFO?",                  "Stack",                                  ["Queue", "Heap", "Tree"]),
    ("What does SQL stand for?",                         "Structured Query Language",              ["Simple Query Language", "Standard Query Logic", "Sequential Query Language"]),
    ("Which is NOT a supervised learning algorithm?",    "K-Means",                               ["SVM", "Decision Tree", "Naive Bayes"]),
    ("Which OSI layer handles routing?",                 "Network Layer",                         ["Data Link", "Transport", "Session"]),
    ("Which sorting algorithm has worst-case O(n²)?",   "Bubble Sort",                           ["Merge Sort", "Quick Sort", "Heap Sort"]),
    ("What is a foreign key?",                           "References a primary key in another table", ["A key for encryption", "A composite key", "An index key"]),
    ("Output of 2**3 in Python?",                        "8",                                     ["6", "9", "16"]),
    ("Which protocol is stateless?",                     "HTTP",                                  ["FTP", "TCP", "SSH"]),
    ("What does OOP stand for?",                         "Object Oriented Programming",           ["Object Output Process", "Ordered Object Program", "Open Object Programming"]),
    ("What is a deadlock?",                              "Two processes waiting for each other",  ["A system crash", "A memory overflow", "A CPU spike"]),
    ("What is normalization in databases?",              "Reducing data redundancy",              ["Encrypting data", "Backing up data", "Indexing data"]),
    ("Which algorithm underlies RSA?",                   "Public Key Cryptography",               ["Symmetric key", "Hashing", "Steganography"]),
    ("What does API stand for?",                         "Application Programming Interface",     ["Automated Process Integrator", "Applied Program Index", "Application Process Interface"]),
    ("Overfitting in ML means?",                         "Good on training, poor on test data",   ["Model underfits", "Too few parameters", "Model is too simple"]),
]

FEEDBACK_SAMPLES = [
    "Excellent work! Very well structured.",
    "Good attempt but needs more detail.",
    "Please review the requirements again.",
    "Well done, minor formatting issues.",
    "Incomplete submission, please resubmit.",
    "Strong analysis and clear presentation.",
    "You missed the key points of the question.",
    "Satisfactory but could be improved.",
    None, None,
]

COMMENT_TEXTS = [
    "Great lecture, very helpful!",
    "Can you explain this concept more?",
    "I didn't understand the second part.",
    "Thank you, this was very clear.",
    "When is the next quiz?",
    "This topic is challenging but interesting.",
    "Could you provide more examples?",
    "الشرح كان واضح جداً، شكراً",
    "محتاج مزيد من التوضيح",
    "ممتاز!",
]

REPLY_TEXTS = [
    "I agree with this comment.",
    "Thanks for the clarification.",
    "That makes sense now.",
    "Can you elaborate further?",
    "شكراً على الرد",
]

AVIATION_ALPHABET = [
    "Alpha", "Bravo", "Charlie", "Delta", "Echo",
    "Foxtrot", "Golf", "Hotel", "India", "Juliet",
    "Kilo", "Lima", "Mike", "November", "Oscar",
    "Papa", "Quebec", "Romeo", "Sierra", "Tango",
    "Uniform", "Victor", "Whiskey", "X-ray", "Yankee", "Zulu",
]

YEAR_LEVELS    = ["First Year", "Second Year", "Third Year", "Fourth Year"]
ACADEMIC_YEARS = [2022, 2023, 2024, 2025]
