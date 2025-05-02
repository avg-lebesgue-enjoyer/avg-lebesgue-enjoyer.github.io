# avg-lebesgue-enjoyer.github.io
have



# SECTION: Notes
Take `q.uiver`'s suggested `height`s and scale them by `0.7` on the `<iframe>` you try to embed.



# SECTION: Things to fix, if possible
  [ ] Hero image gets squished once width gets too small...
  [ ] When hovering over navbar links, the text transitions through *gray*. 
    Could change from black --> white to (very dark blue) --> white
  [ ] `suggestions.html`: On hover over field, display tooltip giving idea of what to put in field ("please put [....] in this field!")
    [ ] WARNING: For purposes of assessment, change out the "TODO:" message for a "yay that worked" message
  [ ] On non-homepage pages, have website title written next to logo in `<navbar>`.
    [ ] Something like `"Empty Limit -> Glossary"` or `"Empty Limit -> Right Adjoints Preserve Limits"`
      [ ] Time permitting, make these breadcrumbs into *functional* hyperlinks
  [ ] On Discussion- and Proof-family pages, change top of contents bar to have page name shown once you scroll down
  [ ] On Discussion- and Proof-family pages, for hiding sidebars, show the keyboard shortcut with one of the cool `⌘` sort of icons
  [ ] WARNING: For assessment purposes, the various `.js` files need to be combined into one enormous one.
    [ ] `git checkout -b submissionbranch` when you go to do this; don't mess up the repo
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
