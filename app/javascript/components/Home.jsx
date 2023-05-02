import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";

export default () => {
  const [inputValue, setInputValue] = useState("");
  const [answer, setAnswer] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [selectedBook, setSelectedBook] = useState("Romeo and Juliet");
  const [recentQuestionsData, setRecentQuestionsData] = useState([]);

  // Fetch recent book questions on load and whenever the selected book changes
  useEffect(() => {
    fetch(`/homepage/get_recent_questions?book=${selectedBook}`, {
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        setRecentQuestionsData(data.data);
        setInputValue("")
        setAnswer("")
      });
  }, [selectedBook])

  const handleChange = (event) => {
    const bookTitle = event.target.value;
    setSelectedBook(bookTitle);
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
        const answer = data.data.trim()
        setAnswer(answer);

        // Only update the recent questions, if we found an answer
        if (answer != "No answer found") {
          setRecentQuestionsData(prev => {
            if (prev.includes(inputValue)) {
              return prev;
            } else {
              return [{question: inputValue, answer}, ...prev];
            }
          });
        }
        
        setIsLoading(false);
      });
  };

  const books = [
    { id: 1, title: "Romeo and Juliet" },
    { id: 2, title: "Palace of Illusions" },
  ];

  const handleRecentQuestionClick = (question) => {
    setInputValue(question.question);
    setAnswer(question.answer)
  };

  const handleDeleteRecentQuestionClick = (question) => {
    setRecentQuestionsData(prev => prev.filter(q => q.question != question.question))
  }

  return (
    <div className="vw-100 primary-color d-flex align-items-center justify-content-center">
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
              {selectedBook ? <div>
                {recentQuestionsData.map((question, i) => (
                  <div key={i}>
                    <div className="recent-question-row">
                      <p className="recent-question-text" onClick={() => handleRecentQuestionClick(question)}>{question.question}</p>
                      <div onClick={() => handleDeleteRecentQuestionClick(question)} className="btn btn-danger custom-btn-danger">Delete</div>
                    </div>
                  </div>
                ))}
              </div> : <p>Select a book to see the most recently asked questions</p>}
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
