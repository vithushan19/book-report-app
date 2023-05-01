import React, { useState } from "react";
import { Link } from "react-router-dom";

export default () => {
  
  const [inputValue, setInputValue] = useState("Who are the Montagues?");
  const [answer, setAnswer] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (event) => {
    event.preventDefault();
    setIsLoading(true)
    fetch(`/homepage/search?question=${inputValue}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",   
      },
    })  
      .then((response) => response.json())
      .then((data) => {
        alert(JSON.stringify(data))
        setAnswer(data.data.trim())
        setIsLoading(false)
      });
  };

  return (
    <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
      <div className="jumbotron jumbotron-fluid bg-transparent">
        <div className="container secondary-color">
          <h1 className="display-4">Book Report</h1>
          <p className="lead">
            Ask any question about this book as if you were talking to a human.
          </p>

          <form onSubmit={handleSubmit}>
            <input
              className="form-control question-input"
              type={"text"}
              value={inputValue}
              onChange={(event) => setInputValue(event.target.value)}
            />

            <button className="btn btn-lg custom-button">Submit</button>
          </form>

          <div className="answer">
            {isLoading ? <div className="spinner-border" role="status">
              <span className="sr-only">Loading...</span>
            </div> : <p>{answer}</p>}
          </div>
        </div>
      </div>
    </div>
  );
};
