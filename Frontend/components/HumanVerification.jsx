import React, { useState, useEffect } from 'react';
import './css/HumanVerification.css';

const HumanVerification = ({ onVerified }) => {
  const [question, setQuestion] = useState('');
  const [answer, setAnswer] = useState('');
  const [userInput, setUserInput] = useState('');
  const [error, setError] = useState('');
  const [verified, setVerified] = useState(false);

  useEffect(() => {
    generateQuestion();
  }, []);
  const generateQuestion = () => {
    const num1 = Math.floor(Math.random() * 10) + 1;
    const num2 = Math.floor(Math.random() * 10) + 1;
    setQuestion(`${num1}` + `${num2}`);
    setAnswer((num1 + num2).toString());
  };
  const handleSubmit = (e) => {
    e.preventDefault();
    if (userInput === answer) {
      setVerified(true);
      setError('');
      if (onVerified) onVerified();
    } else {
      setError('Incorrect answer. Try again.');
      setUserInput('');
      generateQuestion();
    }
  };

  if (verified) {
    return (
      <div className="verification-success">
        <h3>Verified as Human </h3>
        <p>You can now proceed.</p>
      </div>
    );
  }
  return (
    <div className="human-verification">
      <h3>Prove You're Human</h3>
      <p>Solve this simple math question:</p>
      <form onSubmit={handleSubmit}>
        <label>{question} = ?</label>
        <input
          type="text"
          value={userInput}
          onChange={(e) => setUserInput(e.target.value)}
          placeholder="Enter your answer"
          required
        />
        <button type="submit">Verify</button>
      </form>
      {error && <p className="error">{error}</p>}
    </div>
  );
};
export default HumanVerification;