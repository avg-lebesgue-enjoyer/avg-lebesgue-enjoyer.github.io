/-
  **FILE:** `Pages/Basic.lean`
  **PURPOSE:** Collect together all the pages to be rendered
  **NOTES:**
    Each page identified by some "ShortName" is to be placed in a file named `Pages/ShortName.lean`,
    and the page itself is to be exported as `ShortName.it`.
-/

/- IMPORTS: -/

import Pages.Adjunctions



/- SECTION: `pagesToRender` -/

/--
  The list of pages to render, each paired with a filename.

  The filename is taken as if from the root directory of the website, without a `"./"` prefix.
-/
def pagesToRender : List (Page × System.FilePath) :=
  [ .mk Adjunctions.it "discussion/adjunctions.html"
  ]
