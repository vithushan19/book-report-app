# README

[ ] Extract the text from your PDF book and store them into an array of book sections
[x] Generate embeddings for each book section
[x] Save embeddings to a database to be referenced later
[x] Build a search page that prompts the user for input
[ ] Take user's input, and check cache for the answer
[x] If answer is not in database, then generate a one-time embedding, then perform a similarity search against the pre-processed embeddings.
[x] Create a text prompt that includes the most similar book sections to the text prompt
[x] Get a text completion from Open AI to answer the question give the relevant sections of the book.
[ ] Save questions and answers to the database
