# README

## Implementation Plan

- [x] Extract the text from your PDF book and store them into an array of book sections
- [x] Generate embeddings for each book section
- [x] Save embeddings to a database to be referenced later
- [x] Build a search page that prompts the user for input
- [x] Take user's input, and check cache for the answer
- [x] If answer is not in database, then generate a one-time embedding, then perform a similarity search against the pre-processed embeddings.
- [x] Create a text prompt that includes the most similar book sections to the text prompt
- [x] Get a text completion from Open AI to answer the question give the relevant sections of the book.
- [x] Save questions and answers to the database

## Technical Design

[Notion Tech Spec](https://www.notion.so/Book-Report-Challenge-56800f558b7848dd83c0a24232ffd527?pvs=4)

## How to Run

### Step 1 Preprocess a PDF

- drag and drop a pdf into the books folder
- update the [`pdfToText`](https://github.com/vithushan19/book-report-app/blob/main/lib/tasks/pre_process/pdf_to_text.rb) script to point to your pdf
- update the [`generate embeddings`](https://github.com/vithushan19/book-report-app/blob/main/lib/tasks/pre_process/generate_embeddings.rb) script to point to the output of your pdf
- update the [books](https://github.com/vithushan19/book-report-app/blob/main/app/javascript/components/Home.jsx#L60) array in the frontend to include your new book

### Step 2 Run application

- run `bin/dev` in your terminal to start the application
- visit https://localhost:3000
- Click on a recently asked question and get a previously cached answer
- Ask new questions to save new questions to the cache
- Only the 5 most recently asked questions are displayed on the fronent UI, but we are able to cache/save many more questions to the database
- You can delete recently asked questions, which will remove it from the cache

## Data Layer
<img width="911" alt="Screen Shot 2023-05-02 at 10 56 30 PM" src="https://user-images.githubusercontent.com/4795012/235824845-fef8d4bd-51dd-4feb-b365-dc33243e1b02.png">

- [schema.rb](https://github.com/vithushan19/book-report-app/blob/main/db/schema.rb)
- [migrations](https://github.com/vithushan19/book-report-app/tree/main/db/migrate)
- [BookQuestions Model](https://github.com/vithushan19/book-report-app/blob/main/app/models/book_question.rb) - previously asked questions and answers that have been saved to the database
- [BookSections Model](https://github.com/vithushan19/book-report-app/blob/main/app/models/book_section.rb) - sections of a book that have been indexed

## Business Logic Layer

Routes
[routes.rb](https://github.com/vithushan19/book-report-app/blob/main/config/routes.rb)

Controller
[homepageController.rb](https://github.com/vithushan19/book-report-app/blob/main/app/controllers/homepage_controller.rb)

<img width="915" alt="Screen Shot 2023-05-02 at 10 55 23 PM" src="https://user-images.githubusercontent.com/4795012/235824742-4d7d8d0b-9a59-406a-a4c8-a7d3747a966a.png">

### Homepage Controller Actions

- [search](https://github.com/vithushan19/book-report-app/blob/main/app/controllers/homepage_controller.rb#L19) => action that searches the cache for a question, and returns an answer. If the question isn't found in the cache, then we get the answer from open ai using a sophisticated semantic search
- [get_recent_questions](https://github.com/vithushan19/book-report-app/blob/main/app/controllers/homepage_controller.rb#L9) => action that gets all recently cached questions and answers for a given book
- [delete_recent_questions](https://github.com/vithushan19/book-report-app/blob/main/app/controllers/homepage_controller.rb#L52) => action to manually clear the database of saved questions and answers

### OpenAI Service

- [fetch_embeddings_for_book](https://github.com/vithushan19/book-report-app/blob/main/app/services/openai_service.rb#L10)
- [fetch_embedding_for_question](https://github.com/vithushan19/book-report-app/blob/main/app/services/openai_service.rb#L88)
- [fetch_completion_for_prompt](https://github.com/vithushan19/book-report-app/blob/main/app/services/openai_service.rb#L100)
- [cosine_similarity](https://github.com/vithushan19/book-report-app/blob/main/app/services/openai_service.rb#L112)

## View Layer

<img width="966" alt="Screen Shot 2023-05-02 at 10 54 42 PM" src="https://user-images.githubusercontent.com/4795012/235824656-42c45470-b215-41c5-b432-586096bc5b65.png">

- [React Home componet](https://github.com/vithushan19/book-report-app/blob/main/app/javascript/components/Home.jsx)
- [Recently asked questions](https://github.com/vithushan19/book-report-app/blob/main/app/javascript/components/Home.jsx#L109)

## Tests

- [Model Tests](https://github.com/vithushan19/book-report-app/tree/main/test/models)
- [Controller Tests](https://github.com/vithushan19/book-report-app/tree/main/test/controllers)
