/*
  NOTE: The following elements MUST be present in the `<head>` to allow `KaTeX` to be
  used on a Discussion-family webpage.
  SOURCE: https://katex.org/docs/browser
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.css"
      integrity="sha384-5TcZemv2l/9On385z///+d7MSYlvIEw9FuZTIdZ14vJLqWphw7e7ZPuOiCHJcFCP"
      crossorigin="anonymous"
    >
    <script
      src="https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.js"
      integrity="sha384-cMkvdD8LoxVzGF/RPUKAcvmm49FQ0oxwDF3BGKtDXcEc+T1b2N+teh/OJfpU0jr6"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/contrib/auto-render.min.js"
      integrity="sha384-hCXGrW6PitJEwbkoStFjeJxv+fSOOQKOPbJxSfM6G5sWZjAyWhXiTIIAmQqnlLlh"
      crossorigin="anonymous"
    ></script>
*/



document.addEventListener("DOMContentLoaded", () => {
  /* LAUNCH: */

  // Render all `KaTeX` content in the document.
  // SOURCE: https://katex.org/docs/autorender
  renderMathInElement(document.body, {
    delimiters: [
        {left: '$$', right: '$$', display: true},
        {left: '$', right: '$', display: false},
        {left: '\\(', right: '\\)', display: false},
        {left: '\\[', right: '\\]', display: true}
    ],
    throwOnError : false
  });
});
