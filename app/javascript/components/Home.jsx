import React from "react";
import { Link } from "react-router-dom";

export default () => (
  <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
    <div className="jumbotron jumbotron-fluid bg-transparent">
      <div className="container secondary-color">
        <h1 className="display-4">Book Report</h1>
        <p className="lead">
            Ask any question about this book as if you were talking to a human.          
        </p>
        <hr className="my-4" />

        <input className="form-control question-input" type={"text"} />
        <button
          className="btn btn-lg custom-button"
        >
          Submit
        </button>
      </div>
    </div>
  </div>
);