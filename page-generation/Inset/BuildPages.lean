/-
  **FILE:** `Inset/BuildPages.lean`
  **PURPOSE:** Provide types and functions for constructing pages
-/

/- IMPORTS: -/



/- SECTION: Basic type aliases -/

/--
  A URL.

  `abbrev` for `String`.
-/
abbrev URL : Type := String

/--
  A display-style `\begin{align*} ⋯ \end{align*}` equation.

  `abbrev` for a `String` that would go into the `⋯` above.
-/
def Equation : Type := String



/- SECTION: Text -/

/--
  Some text.

  TODO: Upgrade this to handle `KaTeX` and `<a>` and footnotes etc.
-/
def Text : Type := String



/- SECTION: Diagrams -/

/-- A (static) commutative diagram. -/
-- FIXME: Check whether we'll actually use the `width` and `height` fields
structure Diagram : Type where
  /-- URL to diagram to render in an `<iframe>`, *without* the trailing `"&embed"`. -/
  href : URL
  /--
    Width of the `<iframe>` to render. If `none`, allow the CSS to determine the width and height.

    Default: `none`

    **FIXME: Check whether or not this is necessary.**
  -/
  width : Option Nat := none
  /--
    Height of the `<iframe>` to render. If `none`, allow the CSS to determine the width and height.

    Default: `none`

    **FIXME: Check whether or not this is necessary.**
  -/
  height : Option Nat := none

/-- A single frame in an `InteractiveDiagram`. -/
structure IDFrame : Type where
  /-- The static `Diagram` in this frame. -/
  cda : Diagram
  /--
    Optional explanatory text.

    Default: `none`.
  -/
  text : Option Text := none
  /--
    Optional sidenote text.

    Default: `none`.
  -/
  sidenote : Option Text := none

/-- An interactive commutative diagram. -/
def InteractiveDiagram : Type := List IDFrame



/- SECTION: Body -/

/-- An element to render in the `Body` of an `Element` -/
inductive BodyElement : Type where
  /-- A paragraph of `Text`. -/
  | p : Text → BodyElement
  /-- A (static) commutative `Diagram`. -/
  | cda : Diagram → BodyElement
  /--
    A display-style `\begin{align*} ⋯ \end{align*}` equation.

    Provide the string to be placed in `⋯` as an argument.
  -/
  | eqn : Equation → BodyElement
  /-- An interactive commutative diagram. -/
  | ida : InteractiveDiagram → BodyElement

/-- The body of an `Element` or a `Block`. -/
def Body : Type := List BodyElement



/- SECTION: Block -/

/-- The kind of a `Block`. -/
inductive Block.Kind : Type where
  /-- Designates a **Theorem**. -/
  | thm : Kind
  /-- Designates a **Proposition**. -/
  | pro : Kind
  /-- Designates a **Lemma**. -/
  | lem : Kind
  /-- Designates a **Definition**. -/
  | dfn : Kind
  /-- Designates an **Example**. -/
  | exa : Kind
  /-- Designates a **Remark**. -/
  | rmk : Kind
  /-- Designates something else, to be rendered using the provided `title`. -/
  | other (title : String) : Kind

/--
  A link at the end of a `Block`.

  Used, for example, to redirect from a theorem to its proof.
-/
structure OutLink where
  /-- The `URL` to redirect to. -/
  href : URL
  /--
    The label to render on the link.

    Default: `"see proof"`
  -/
  label : String := "see proof"

/-- A `Block` element, such as the statement of a theorem. -/
structure Block : Type where
  /-- The `Kind` of a `Block`. -/
  kind : Block.Kind
  /-- The `Body` of a `Block`. -/
  body : Body
  /--
    Optional link at the end of the `Block`.

    Default: `none`.
  -/
  outLink? : Option OutLink := none



/- SECTION: TitledList -/

/-- A `List β` which has been augmented with a `title : String` field. -/
private structure TitledList (β : Type u) : Type u where
  /-- The title. -/
  title : String
  /--
    The underlying list.

    Default: `[]`
  -/
  list : List β := []



/- SECTION: Element, Section, Page -/

/-- An element to render within a `Section`. -/
inductive Element : Type where
  /-- The `Body` of an `Element`. -/
  | body : Body → Element
  /-- The `Block` held by an `Element`. -/
  | block : Block → Element

/-- A section within a `Page`. -/
def Section := TitledList Element
/--
  Construct a `Section`.

  **Parameter `(title : String)`:**
    The title of the section.

  **Parameter `(elements : List Element := [])`:**
    The underlying list of elements.
-/
def Section.mk (title : String) (elements : List Element := []) : Section :=
  { title := title, list := elements }
/-- Extract the list of `Element`s held in a `Section`. -/
def Section.elements : Section → List Element := TitledList.list

/-- A Discussion- or Proof-family webpage. -/
def Page := TitledList Section
/--
  Construct a `Page`.

  **Parameter `(title : String)`:**
    The title of the section.

  **Parameter `(sections : List Element := [])`:**
    The underlying list of sections.
-/
def Page.mk (title : String) (sections : List Section := []) : Page :=
  { title := title, list := sections }
/-- Extract the list of `Section`s hend in a `Page`. -/
def Page.sections : Page → List Section := TitledList.list
