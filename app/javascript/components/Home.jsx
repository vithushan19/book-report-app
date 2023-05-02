import React, { useState } from "react";
import { Link } from "react-router-dom";

export default () => {
  const [inputValue, setInputValue] = useState("Who are the Montagues?");
  const [answer, setAnswer] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [selectedBook, setSelectedBook] = useState("");
  const [recentQuestions, setRecentQuestions] = useState([]);

  const handleChange = (event) => {
    const selectedValue = event.target.value;
    setSelectedBook(selectedValue);
    console.log(selectedValue);
    fetch(`/homepage/get_recent_questions?book=${selectedValue}`, {
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        setRecentQuestions(data.data.map((question) => question.question));
      });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    setIsLoading(true);
    fetch(`/homepage/search?question=${inputValue}&book=${selectedBook}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        setAnswer(data.data.trim());
        setRecentQuestions(prev => {
          if (prev.includes(inputValue)) {
            return prev;
          } else {
            return [inputValue, ...prev];
          }
        });
        setIsLoading(false);
      });
  };

  const books = [
    { id: 1, title: "Romeo and Juliet" },
    { id: 2, title: "Palace of Illusions" },
  ];

  const handleRecentQuestionClick = (question) => {
    setInputValue(question);
  };

  return (
    <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
      <div className="jumbotron jumbotron-fluid bg-transparent">
        <div className="container secondary-color">
          <h1 className="display-4">Book Report</h1>

          <form onSubmit={handleSubmit}>
            <p className="lead">
              Select a book from the list below to ask a question. about it
            </p>

            <select value={selectedBook} onChange={handleChange}>
              <option value="">Select a book</option>
              {books.map((book) => (
                <option key={book.title} value={book.title}>
                  {book.title}
                </option>
              ))}
            </select>

            <hr />

            <div className="mt-4">
              <p className="fs-3">Most Recently Asked Questions</p>
              {selectedBook ? <ul>
                {recentQuestions.map((question, i) => (
                  <li onClick={() => handleRecentQuestionClick(question)} key={i}>{question}</li>
                ))}
              </ul> : <p>Select a book to see the most recently asked questions</p>}
            </div>

            <hr />

            <p className="lead">
              Ask any question about this book as if you were talking to a
              human.
            </p>

            <input
              className="form-control question-input"
              type={"text"}
              value={inputValue}
              onChange={(event) => setInputValue(event.target.value)}
            />

            <button className="btn btn-lg custom-button">Submit</button>
          </form>

          <div className="answer">
            {isLoading ? (
              <div className="spinner-border" role="status">
                <span className="sr-only">Loading...</span>
              </div>
            ) : (
              <p>{answer}</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
