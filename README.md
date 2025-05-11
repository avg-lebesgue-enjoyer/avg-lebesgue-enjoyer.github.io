# avg-lebesgue-enjoyer.github.io
have



# SECTION: Notes
Take `q.uiver`'s suggested `height`s and scale them by `0.7` on the `<iframe>` you try to embed.



# SECTION: Things to fix, if possible
  [ ] Hero image gets squished once width gets too small...
    [ ] Use a media query to change out the image (different file) when the screen size is small enough.
  [ ] When hovering over navbar links, the text transitions through *gray*. 
    Could change from black --> white to (very dark blue) --> white
  [ ] On non-homepage pages, have website title written next to logo in `<navbar>`.
    [ ] Something like `"Empty Limit -> Glossary"` or `"Empty Limit -> Right Adjoints Preserve Limits"`
      [ ] Time permitting, make these breadcrumbs into *functional* hyperlinks
  [ ] On Discussion- and Proof-family pages, change top of contents bar to have page name shown once you scroll down
  [ ] fwiw, it's actually really easy to add darkmode:
    ```css3
    :root.darkmode {
      --default-background-colour: #010101;
    }
    ```


# TODO LIST:
`discussion/whatever.html`:
  [ ] Make `<iframe>`s not terrible on screen sizes other than my own...
  [ ] Make sidenotes appear as a pop up on tapping the link when too small
    ^^ like wikipedia hovering over internal links
  [ ] Redesign where necessary for mobile.
    ^^ a decent chunk is necessary...
    [ ] E.g. text should *left*-justify, rather than *justify*. (apple.com does this, for example)

# ON SUBMIT ASSESSMENT:
  - [ ] `git checkout -b submission-branch`; `git push --set-upstream origin submission-branch`
  - `suggestions.html`:
    - [ ] Change the "TODO:" message on submit to a "yay that worked!" message
  - JS:
    - [ ] Merge them all into one horrible monster `.js` file
  - Write `Readme.md` file to explain folder setup
