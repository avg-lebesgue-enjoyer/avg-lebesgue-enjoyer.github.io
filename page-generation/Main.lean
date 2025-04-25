/-
  **FILE:** `Main.lean`
  **PURPOSE:** Main entry point to built executable
-/

/- IMPORTS: -/

import Inset



/- LAUNCH: `main` -/

/-- Build all the pages in `Pages/`, and place the resulting HTML files in the designated locations. -/
def main : IO Unit := do
  IO.println "(inset) Building pages..."
  pagesToRender.forM (fun (page, filename) => page.writeHtmlToFile s!"../{filename}")
  IO.println "(inset) ...done."
