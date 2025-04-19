addEventListener('DOMContentLoaded', () => {
  /* SECTION: Helper functions */
  
  /** Extract the only element of an array, or `throw` an error if the array does not have exactly one element */
  const extractUniqueElement = (errorMessage, array) => {
    if (array.length != 1) {
      throw new Error(errorMessage);
    }
    return array[0];
  };
  


  /* SECTION: Form submission event */

  const notUniqueSuggestionTypeMessage = "There was not exactly one radio button selected for the \"Suggestion type\" field!";
  const fakeAPIMessage = "TODO: You tried to submit the data printed out via \`console.log\`. Writing a secure API backend for this is beyond the scope of this assessment item, so that's that for now!"

  document.getElementById("suggestion-form").onsubmit = (e) => {
    e.preventDefault();
    // Hide error message (if not already hidden)
    const errorMessage = document.getElementById("suggestion-error-message");
    errorMessage.classList.add("hidden");
    // Try to process the form
    try {
      // Collect form data
      const submissionDateTime = new Date();
      const topic = document.getElementById("suggestion-topic");
      const body = document.getElementById("suggestion-body");
      const type =
        extractUniqueElement(
          notUniqueSuggestionTypeMessage
        , Array.from(
            document
            .getElementById("suggestion-type")
            .children
          )
          .flatMap((element) => (Array.from(element.children)))
          .filter((element) => (element.tagName == "INPUT" && element.checked))
          .map((element) => (element.value))
        )
      ;
      const comments = document.getElementById("suggestion-comments");
      // Compile data into an object to be posted
      const suggestionData = {
        submissionDateTime: submissionDateTime,
        topic: topic.value,
        body: body.value,
        type: type,
        ...(comments.value != "" && { comments: comments.value }) // Trick from SOURCE: https://stackoverflow.com/a/40560953
      };
      // Send object to API (faked)
      // NOTE: I'm not required to write a backend to actually handle that in this assignment, so I'm not going to.
      console.log(suggestionData);
      alert(fakeAPIMessage);
      // Clean up the form
      [topic, body, comments].forEach((htmlElement) => {
        htmlElement.value = "";
      });
    } catch (exception) {
      errorMessage.classList.remove("hidden");
      document.getElementById("suggestion-error-timestamp").innerText = `Timestamp: ${new Date().toString()}`
    }
  };
});
