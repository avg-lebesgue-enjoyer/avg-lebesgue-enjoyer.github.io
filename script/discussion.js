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
  /* SECTION: Jumping around page */

  /**
   * Jump to a section by specifying its ID
   * @param {string} sectionId
   *  `id` of the section to jump to
   */
  function jumpToSection(sectionId) {
    try {
      document.getElementById(sectionId).scrollIntoView({behavior: "auto"}); // SOURCE: https://stackoverflow.com/a/62546650
    } catch (exception) {
      // squash
    }
  }

  function jumpToTop() {
    window.scrollTo(0, 0);
  }



  /* SECTION: Toggle sidebars */

  /** Toggle whether the contents bar is displayed or not. */
  const toggleContentsBar = () => {
    const contentsBar = document.getElementById("contents-bar");
    contentsBar.classList.toggle("hidden");
  }
  
  /** Toggle whether the sidenotes bar is displayed or not. */
  const toggleSidenotesBar = () => {
    const sidenotesBar = document.getElementById("sidenotes-bar");
    sidenotesBar.classList.toggle("hidden");
  }



  /* SECTION: Amend `.frame-number` field of some interactive diagram */
  /**
   * Compute whether the given `element`'s top-left corner is on-screen.
   * @param {Element} element
   *  The element to check for visibility
   * @returns {boolean}
   *  `true` just when the top-left corner of the `element` is on-screen.
   */
  const isOnScreen = (element) => {
    let rect = element.getBoundingClientRect();
    return rect.x >= 0 && rect.y >= 0;
  }

  /**
   * Get an array containing all of the interactive diagrams currently on-screen, sorted top-to-bottom.
   * @returns {Array<Element>}
   *  The array of all interactive diagrams currently on-screen.
   */
  const getOnScreenInteractiveDiagrams = () => {
    return document.getElementsByClassName("interactive-diagram-container").filter(isOnScreen);
  }

  /**
   * Append the given `key : string` to the `.frame-number` field of the topmost interactive diagram
   * currently on screen. If there are no such diagrams on screen, then do nothing.
   * @param {string} key
   *  The keypress to be appended to the relevant `.frame-number` field.
   */
  const appendToFrameNumber = (key) => {
    let diagrams = getOnScreenInteractiveDiagrams();
    if (diagrams.length === 0) {
      return;
    }
    const [diagram, ...ignoreThese] = diagrams;
    
  }



  /* SECTION: Event handlers */

  /**
   * Handle keypresses by the user. The following actions are supported:
   *  SHIFT + NUMBER:
   *    ")":  Jump to top
   *    "!":  Jump to the section at `sectionIds[0]`
   *    "@":  Jump to the section at `sectionIds[1]`
   *    "#":  Jump to the section at `sectionIds[2]`
   *    "$":  Jump to the section at `sectionIds[3]`
   *    "%":  Jump to the section at `sectionIds[4]`
   *    "^":  Jump to the section at `sectionIds[5]`
   *    "&":  Jump to the section at `sectionIds[6]`
   *    "*":  Jump to the section at `sectionIds[7]`
   *    "(":  Jump to the section at `sectionIds[secitonIds.length - 1]`
   *  NUMBER:
   *    "0", "1", "2":  Focus the `.frame-number` input of the topmost on-screen
   *    "3", "4", "5":   interactive diagram, and append the string `"0"`/.../`"9"`
   *    "6", "7", "8":   to its value. Only useful on Proof-family pages.
   *    "9"          :
   *    " ":            Focus the `.frame-number` input of the topmost on-screen
   *                     interactive diagram, and reset its value to `""`. Only
   *                     useful on Proof-family pages.
   *  LETTER:
   *    "c", "a": Toggle contents bar
   *    "s", "f": Toggle sidenotes bar
   * All alphabetic keys are case-insensitive.
   * @param {KeyboardEvent} e
   *  The event triggering this callback
   */
  const handleKeyDown = (e) => {
    // Act on the relevant key press
    // Enclosed in a `try { ... } catch { ... }` because there may not be enough sections to match the key pressed,
    // if the key is one of `"!@#$%^&*()"`. This squashes index-out-of-bounds-errors.
    try {
      switch (e.key.toLowerCase()) {
        // Jump to section
        case "!":
          jumpToSection(sectionIds[0]);
          break;
        case "@":
          jumpToSection(sectionIds[1]);
          break;
        case "#":
          jumpToSection(sectionIds[2]);
          break;
        case "$":
          jumpToSection(sectionIds[3]);
          break;
        case "%":
          jumpToSection(sectionIds[4]);
          break;
        case "^":
          jumpToSection(sectionIds[5]);
          break;
        case "&":
          jumpToSection(sectionIds[6]);
          break;
        case "*":
          jumpToSection(sectionIds[7]);
          break;
        case "(":
          jumpToSection(sectionIds[sectionIds.length - 1]);
          break;
        case ")":
          jumpToTop();
          break;
        // Type into `.frame-number` field
        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
          appendToFrameNumber(e.key.toLowerCase());
          break;
        case " ":
          resetFrameNumber();
          break;
        // Toggle sidebars
        case "c":
        case "a":
          toggleContentsBar();
          break;
        case "s":
        case "f":
          toggleSidenotesBar();
          break;
        // Squash anything else
        default:
          break;
      }
    } catch (exception) {
      // squash
    }
  }



  /* LAUNCH: */

  /** Array of all section `id`s. */
  const sectionIds =
    Array.from(
      document
      .getElementById("content")
      .children
    ).filter((child) => (child.tagName === "SECTION"))
    .map((section) => (section.id))
  ;

  // Add event listeners
  document.addEventListener("keydown", handleKeyDown);
  document.getElementById("contents-bar-hide").onclick = toggleContentsBar;
  document.getElementById("sidenotes-bar-hide").onclick = toggleSidenotesBar;

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
