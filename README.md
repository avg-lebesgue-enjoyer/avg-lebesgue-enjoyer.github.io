# avg-lebesgue-enjoyer.github.io
have



# TODO LIST:

Missing content:
  - [ ] Literally any real Proof-family pages
    - [ ] `proof/right-adjoints-preserve-limits.html`
    - [ ] Proper nice internal encodings of interactive diagrams
    - [ ] HTML generation for interactive diagrams
    - [ ] CSS for interactive diagrams
    - [ ] JS for *interactive* diagrams
  - [ ] More Discussion-family pages
  - [ ] More Proof-family pages

Defo fix:
  - Discussion- and Proof-family pages:
    - [ ] Make `<iframe>`s not terrible on screen sizes other than my own...
    - [ ] Redesign where necessary for mobile.
        - ^^ a decent chunk is necessary...
        - [ ] E.g. text should *left*-justify, rather than *justify*. (apple.com does this, for example)
  - General admin:
    - [ ] Make this `README.md` nice for public repo viewing

Fix if can:
  - [ ] Hero image gets squished once width gets too small...
    - [ ] Change the files in the `<picture>` for small enough screen size. No "cropped", or better cropping.
  - [ ] Make sidenotes appear as a pop up on tapping the link when too small
        - ^^ like wikipedia hovering over internal links
  - [ ] When hovering over navbar links, the text transitions through *gray*. 
    - Could change from "black --> white" to "(very dark blue) --> white"



# SECTION: ON SUBMIT:
  - [ ] `git checkout -b submission-branch`; `git push --set-upstream origin submission-branch`
  - `suggestions.html`:
    - [ ] Change the "TODO:" message on submit to a "yay that worked!" message
  - JS:
    - [ ] Merge them all into one horrible monster `.js` file
  - Write `Readme.md` file to explain folder setup



# KILLME:
```html
<!-- TESTING:: -->
<div class="interactive-diagram-container">
  <!-- Frame 1 -->
  <div class="interactive-diagram-frame">
    <div class="block-static-diagram-container">
      <iframe
        height="302"
        class="quiver-embed block-static-diagram"
        src="https://q.uiver.app/#q=WzAsNCxbMSwwLCJhIl0sWzEsMSwiXFxjaXJjbGVhcnJvd2xlZnQiXSxbMCwyLCJVIFxcd3Rse0R9IGkiXSxbMiwyLCJVXFx3dGx7RH1qIl0sWzIsMywiVSBcXHd0bHtEfSBmIiwyXSxbMCwyLCJcXGFscGhhX2kiLDJdLFswLDMsIlxcYWxwaGFfaiJdXQ==&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex&embed"
      ></iframe>
    </div>
    <div class="supporting-text">
      <span>
        For any $f : i \to j$ in $\mathsf{J}$, the above diagram must commute.
      </span>
    </div>
    <div class="controls">
      <button class="left">
        &larr; <span class=keyboard-shortcut-hint>(h)</span>
      </button>
      <input type="number" class="frame-number" min="1" max="4">
      <button class="right">
        <span class=keyboard-shortcut-hint>(l)</span> &rarr; 
      </button>
    </div>
  </div>
  <!-- Frame 2 -->
  <div class="interactive-diagram-frame hidden">
    <div class="block-static-diagram-container">
      <iframe
        height="332"
        class="quiver-embed block-static-diagram"
        src="https://q.uiver.app/#q=WzAsMTAsWzMsNCwiXFxwaGFudG9te3h9Il0sWzEsMSwiYSJdLFswLDMsIlUgXFx3dGx7RH0gaSJdLFsyLDMsIlUgXFx3dGx7RH0gaiJdLFs0LDMsIlxcd3Rse0R9IGkiXSxbNiwzLCJcXHd0bHtEfSBqIl0sWzUsMSwiRiBhIl0sWzEsMiwiXFxjaXJjbGVhcnJvd2xlZnQiXSxbNSwyLCJcXGNpcmNsZWFycm93bGVmdCJdLFszLDAsIlxccGhhbnRvbXt4fSJdLFsxLDIsIlxcYWxwaGFfaSIsMl0sWzIsMywiVSBcXHd0bHtEfSBmIiwyXSxbMSwzLCJcXGFscGhhX2oiXSxbNiw0LCJcXG92ZXJsaW5le1xcYWxwaGFfaX0iLDJdLFs2LDUsIlxcb3ZlcmxpbmV7XFxhbHBoYV9qfSJdLFs0LDUsIlxcd3Rse0R9IGYiLDJdLFs5LDAsIkYgXFxkYXNodiBVIiwxLHsibGFiZWxfcG9zaXRpb24iOjEwLCJzdHlsZSI6eyJoZWFkIjp7Im5hbWUiOiJub25lIn19fV1d&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex&embed"
      ></iframe>
    </div>
    <div class="supporting-text">
      <span>
        Since we have a limit over $\widetilde{D}$, we transpose the left diagram to the right diagram. Commutativity is preserved by adjunctions, so $\overline{\alpha}$ is a cone over $\widetilde{D}$.
      </span>
    </div>
    <div class="controls">
      <button class="left">
        &larr; <span class=keyboard-shortcut-hint>(h)</span>
      </button>
      <input type="number" class="frame-number" min="1" max="4">
      <button class="right">
        <span class=keyboard-shortcut-hint>(l)</span> &rarr; 
      </button>
    </div>
  </div>
</div>
DEBUG: FIXME: Writing out interactive diagrams isn't supported yet!
<!-- ::TESTING -->
```
