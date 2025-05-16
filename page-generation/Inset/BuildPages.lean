/-
  **FILE:** `Inset/BuildPages.lean`
  **PURPOSE:** Provide functions for transforming `inset`-encoded pages into actual `.html` files.
-/

/- IMPORTS: -/

import Inset.EncodePages



/- SECTION: Miscellaneous helpers -/

/-- Wrap the `pageName` with extra stuff to display in the `<title>`. -/
private def titleTemplate (pageName : String) : String :=
  s!"{pageName} - Empty Limit"

/-- `true` iff `it` is a valid character for a HTML `id=""`. -/
private def isValidIdChar (it : Char) : Bool :=
  it.isAlphanum || it == '-' || it == '_' || it == ':' || it == '.'

/--
  Convert the given section `title` to an `id=""`.

  Spaces `' '`are converted to `'-'`.
-/
private def sectionTitleToId (title : String) : String :=
  title
  |>.toList
  |>.dropWhile (not ∘ Char.isAlpha)
  |>.map (fun c => if c == ' ' then '-' else c)
  |>.filter isValidIdChar
  |>.asString

/-- Compute the `id=""` of a `Section`. -/
private def Section.id (it : Section) : String :=
  sectionTitleToId it.title



/- SECTION: Helper types and functions for writing -/

/-- Alias for `String` representing the contents of a `.html` file. -/
private abbrev HtmlOutput : Type := String

/-- State as a page is written -/
private structure WriterState : Type where
  /-- Current accumulated HTML output. -/
  currentHtml : HtmlOutput := ""
  /-- Current indentation level. -/
  indentationLevel : Nat := 0
  /-- Number of spaces per indentation level. -/
  indentationSpaces : Nat := 2
  /-- Whether or not this page qualifies as a Discussion-family page (i.e. no interactive diagrams). -/
  okAsDiscussion : Bool := true
  /-- The number of the next sidenote to print. -/
  sidenoteNumber : Nat := 1

/-- Give a string full of enough spaces to match the indentation level. -/
private def WriterState.indentSpaces (s : WriterState) : String :=
  List.replicate (s.indentationLevel * s.indentationSpaces) ' '
  |>.asString

/--
  Get the `id=""` of the next sidenote.
  Does not include the leading `#`.
  Does not increment the sidenote number.
-/
private def getSidenoteId : StateT WriterState Id String := do
  pure s!"sidenote-{(←get).sidenoteNumber}"

/-- Increment the number identifying the next sidenote to print. -/
private def incrementSidenoteNumber : StateT WriterState Id Unit := do
  set { (←get) with sidenoteNumber := (←get).sidenoteNumber + 1 }

/-- Append the given `html` to the `.currentHtml`, **without beginning a new line or adding indentation**. -/
private def appendHtml' (html : HtmlOutput) : StateT WriterState Id Unit := do
  set { (←get) with currentHtml := (←get).currentHtml ++ html }

/-- Append a newline to the `.currentHtml`. -/
private def newLine : StateT WriterState Id Unit := do
  appendHtml' "\n"

/-- Write the appropriate number of spaces to indent a new line of text. -/
private def writeIndentation : StateT WriterState Id Unit := do
  appendHtml' <| (←get).indentSpaces

/-- Append the given `html` to the `.currentHtml`, **after beginning a new indented line**. -/
private def appendHtml (html : HtmlOutput) : StateT WriterState Id Unit := do
  newLine
  writeIndentation
  appendHtml' html

/-- Increment the indentation level. -/
private def indent : StateT WriterState Id Unit := do
  set { (←get) with indentationLevel := (←get).indentationLevel + 1 }

/-- Decrement the indentation level. -/
private def unindent : StateT WriterState Id Unit := do
  set { (←get) with indentationLevel := (←get).indentationLevel - 1 }

/-- Run the `child` whilst indented. -/
private def indented (child : StateT WriterState Id Unit) : StateT WriterState Id Unit := do
  indent
  child
  unindent

/--
  Write out the `(option, value)` pairs in `tagOptions` as follows:
  ```
  option0="value0"
  ⋯
  optionN="valueN"
  ```
-/
private def appendOptions (tagOptions : List (String × String)) : StateT WriterState Id Unit := do
  for (option, value) in tagOptions do
    appendHtml s!"{option}=\"{value}\""

/--
  Print a `<tagName>` with no closing tag and no children.

  If the `tagOptions` is `[]`, print as above.
  If the `tagOptions` is non-empty, then print as follows:
  ```html
  <tagName
    option0 = "value0"
    ⋯
    optionN = "valueN"
  >
  ```
-/
private def justTag
  (tagName : String)
  (tagOptions : List (String × String))
  : StateT WriterState Id Unit
  := do
    if let [] := tagOptions then do
      appendHtml s!"<{tagName}>"
    else if let [(option, value)] := tagOptions then do
      appendHtml s!"<{tagName} {option}=\"{value}\">"
    else do
      appendHtml s!"<{tagName}"
      indented <| appendOptions tagOptions
      appendHtml s!">"

/-- Print `<tagName>`, where the tag takes no options. -/
private def justTag'
  (tagName : String)
  : StateT WriterState Id Unit
  :=
    justTag tagName []

/--
  Print a child enclosed in `<tagName> ⋯ </tagName>`.

  If the `tagOptions` is `[]`, print as above.
  If the `tagOptions` is non-empty, then print as follows:
  ```html
  <tagName
    option0 = "value0"
    ⋯
    optionN = "valueN"
  >
    child
  </tagName>
  ```
-/
private def inTag
  (tagName : String)
  (tagOptions : List (String × String))
  (child : StateT WriterState Id Unit)
  : StateT WriterState Id Unit
  := do
    justTag tagName tagOptions
    indented child
    appendHtml s!"</{tagName}>"

/-- Print a child enclosed in `<tagName> ⋯ </tagName>`, where the tag takes no options. -/
private def inTag'
  (tagName : String)
  (child : StateT WriterState Id Unit)
  : StateT WriterState Id Unit
  :=
    inTag tagName [] child

/--
  Print a child-less tag in the form
  ```html
  <tagName
    option0="value0"
    ⋯
    optionN="valueN"
  ></tagName>
  ```
-/
private def childlessTag
  (tagName : String)
  (tagOptions : List (String × String))
  : StateT WriterState Id Unit
  := do
    appendHtml s!"<{tagName}"
    indented <| appendOptions tagOptions
    appendHtml s!"></{tagName}>"

/-- Print a child enclosed in `<tagName> ⋯ </tagName>`, with no newline before, after or within the tag. -/
private def inlineTag
  (tagName : String)
  (tagOptions : List (String × String))
  (child : StateT WriterState Id Unit)
  : StateT WriterState Id Unit
  := do
    if let [] := tagOptions then do
      appendHtml' s!"<{tagName}>"
    else do
      let options := tagOptions |>.map (fun (option, value) => s!" {option}={value}") |>.foldr (· ++ ·) ""
      appendHtml' s!"<{tagName}{options}>"
    child
    appendHtml' s!"</{tagName}>"

/-- Print a child enclosed in `<tagName> ⋯ </tagName>`, with no newline before, after or within the tag, where the tag takes no options. -/
private def inlineTag'
  (tagName : String)
  (child : StateT WriterState Id Unit)
  : StateT WriterState Id Unit
  := inlineTag tagName [] child

/--
  Write a comment, styled as follows:
  ```html
  <!--
    ⋯
  -->
  ```
  The `lines` of content go in the `⋯`.
-/
private def comment
  (lines : List String)
  : StateT WriterState Id Unit
  := do
    appendHtml "<!--"
    indented do
      for line in lines do
        appendHtml line
    appendHtml "-->"

/--
  Write a comment, stylised as follows:
  ```html
  <!-- ⋯ -->
  ```
  The `content` goes in the `⋯`.
-/
private def comment' (content : String) : StateT WriterState Id Unit := do
  appendHtml s!"<!-- {content} -->"



/- SECTION: Combinators to write the page -/

/-- Write the `<!DOCTYPE html>`. -/
private def doctype : StateT WriterState Id Unit := do
  appendHtml "<!DOCTYPE html>"

/-- Write the `<html> ⋯ </html>`. The `child` goes in the `⋯`. -/
private def html (child : StateT WriterState Id Unit) : StateT WriterState Id Unit := do
  inTag "html" [.mk "lang" "en"] do
    child

/-- Write the `<head> ⋯ </head>`. The `pageName` is used in the `<title> ⋯ </title>`. -/
private def head (pageName : String) : StateT WriterState Id Unit := do
  inTag' "head" do
    inTag' "title" do
      appendHtml <| titleTemplate pageName
    justTag "link"
      [ .mk "rel" "icon"
      , .mk "href" "../asset/logo/logo-128-round.png"
      ]
    justTag "meta"
      [ .mk "name" "viewport"
      , .mk "content" "width=device-width, initial-scale=1.0"
      ]
    justTag "link"
      [ .mk "rel" "stylesheet"
      , .mk "href" "../style.css"
      ]
    comment
      [ "NOTE: The following elements allow for `KaTeX` to be used on this webpage."
      , "SOURCE: https://katex.org/docs/browser"
      ]
    justTag "link"
      [ .mk "rel" "stylesheet"
      , .mk "href" "https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.css"
      , .mk "integrity" "sha384-5TcZemv2l/9On385z///+d7MSYlvIEw9FuZTIdZ14vJLqWphw7e7ZPuOiCHJcFCP"
      , .mk "crossorigin" "anonymous"
      ]
    childlessTag "script"
      [ .mk "src" "https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.js"
      , .mk "integrity" "sha384-cMkvdD8LoxVzGF/RPUKAcvmm49FQ0oxwDF3BGKtDXcEc+T1b2N+teh/OJfpU0jr6"
      , .mk "crossorigin" "anonymous"
      ]
    childlessTag "script"
      [ .mk "src" "https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/contrib/auto-render.min.js"
      , .mk "integrity" "sha384-hCXGrW6PitJEwbkoStFjeJxv+fSOOQKOPbJxSfM6G5sWZjAyWhXiTIIAmQqnlLlh"
      , .mk "crossorigin" "anonymous"
      ]
    comment
      [ "NOTE: `../script/discussion.js` is included after `KaTeX` to make `KaTeX` available"
      , "in `../script/discussion.js`."
      ]
    childlessTag "script"
      [ .mk "src" "../script/discussion.js"
      ]

/-- Write the `<nav> ⋯ </nav>`. -/
private def nav : StateT WriterState Id Unit := do
  inTag' "nav" do
    inTag "a" [.mk "href" "../index.html"] do
      inTag "div" [.mk "class" "logo"] do
        justTag "img"
          [ .mk "src" "../asset/logo/logo-270.png"
          , .mk "alt" "Logo"
          ]
    inTag "div" [.mk "class" "link-container"] do
      inTag "a" [.mk "href" "../glossary.html", .mk "class" "nav-link"] do
        appendHtml "Glossary"

      inTag "a" [.mk "href" "../suggestions.html", .mk "class" "nav-link"] do
        appendHtml "Suggestions"

      inTag "a" [.mk "href" "../about.html", .mk "class" "nav-link"] do
        appendHtml "About"

/-- Write the `<footer> ⋯ </footer>`. -/
private def footer : StateT WriterState Id Unit := do
  inTag' "footer" do
    inTag "a" [.mk "href" "../index.html"] do
      inTag "div" [.mk "class" "logo"] do
        justTag "img"
          [ .mk "src" "../asset/logo/logo-270.png"
          , .mk "alt" "Logo"
          ]

/--
  Write the sidenotes bar.

  The sidenotes themselves are embedded within the main `<article> ⋯ </article>` and a CSS
  hack is used to position them within the space reserved by the `<div id="sidenotes-bar">`.
  Consequently, this state transformer doesn't actually write much HTML.
-/
private def sidenotesBar : StateT WriterState Id Unit := do
  inTag "div" [.mk "id" "sidenotes-bar"] do
    inTag "div" [.mk "class" "bar-title"] do
      inTag' "span" do
        appendHtml "Sidenotes"
      inTag "button" [.mk "id" "sidenotes-bar-hide"] do
        indented do
          appendHtml' "hide "
          inlineTag "span" [.mk "class" "keyboard-shortcut-hint"] do
            appendHtml' "(s)"
          newLine

/-- Write the `bar-title` of the contents bar. -/
private def contentsBar.title : StateT WriterState Id Unit := do
  inTag "div" [.mk "class" "bar-title"] do
    inTag' "span" do
      appendHtml "Contents"
    inTag "button" [.mk "id" "contents-bar-hide"] do
      indented do
        appendHtml' "hide "
        inlineTag "span" [.mk "class" "keyboard-shortcut-hint"] do
          appendHtml' "(c)"
        newLine

/-- Write the `<ul>` of the contents bar. -/
private def contentsBar.list (sections : List Section) (pageTitle : String) : StateT WriterState Id Unit := do
  inTag "div" [.mk "class" "contents-bar-page-name"] do
    newLine
    writeIndentation
    appendHtml' s!"{pageTitle}: "
    inlineTag "a" [.mk "href" "#"] do
      appendHtml' "(top)"
  inTag' "ul" do
    for it in sections do
      inTag' "li" do
        inTag "a" [.mk "href" s!"#{it.id}"] do
          appendHtml it.title
    inTag' "li" do
      inTag "a" [.mk "href" "#See-also"] do
        appendHtml "See also"

/-- Write the contents bar. The `sections` are used to generate the `<li>`s in the `<ul>`. The `pageTitle` is used for a "top of page" link. -/
private def contentsBar (sections : List Section) (pageTitle : String) : StateT WriterState Id Unit := do
  inTag "div" [.mk "id" "contents-bar"] do
    inTag "div" [.mk "id" "contents-bar-outer-container"] do
      inTag "div" [.mk "id" "contents-bar-inner-container"] do
        contentsBar.title
        contentsBar.list sections pageTitle

/-- Write a `TextElement`. -/
private def textElement (element : TextElement) : StateT WriterState Id Unit := do
  match element with
  | .s string =>
    appendHtml' string
  | .eqn equation => do
    appendHtml' "$$"
    indented do
      appendHtml equation.toString
    newLine
    writeIndentation
    appendHtml' "$$"
  | .al alignContent => do
    appendHtml "$$\\begin{align*}"
    indented do
      for line in alignContent.toList do
        appendHtml line
    appendHtml "\\end{align*}$$"
    newLine
    writeIndentation
  | .a href content => do
    inlineTag "a" [.mk "href" href] do
      appendHtml' content

/--
  Write a `Sidenote`. This renders somewhat ugly in the output HTML to get around the fact that
  ```HTML
  some text
  <span>
    <sup>
      a
    </sup>
  </span>
   more text
  ```
  renders as `some text ᵃ more text` instead of the desired `some textᵃ more text`.
-/
private def sidenote (sidenote : Sidenote) : StateT WriterState Id Unit := do
  inlineTag "span" [.mk "class" "sidenote-container"] do
    inlineTag' "sup" do
      inlineTag "a" [.mk "class" "sidenote-anchor", .mk "href" s!"#{(←getSidenoteId)}"] do
        appendHtml' s!"[{(←get).sidenoteNumber}]"
    inlineTag "span" [.mk "class" "sidenote", .mk "id" (←getSidenoteId)] do
      appendHtml s!"[{(←get).sidenoteNumber}]"
      newLine
      writeIndentation
      for element in sidenote.toList do
        textElement element
  incrementSidenoteNumber

/-- Write out some `Text`. -/
private def text (t : Text) : StateT WriterState Id Unit := do
  newLine
  writeIndentation
  for content in t.toList do
    match content with
    | .e e => textElement e
    | .sn s => sidenote s

/-- Write out a `<p> ⋯ </p>`. The `t` is to be written as the `⋯`. -/
private def p (t : Text) : StateT WriterState Id Unit := do
  inTag' "p" do
    text t

/-- Write out a `<ul> ⋯ </ul>`. The `ts` are to be written as `<li>`s in the `⋯`. -/
private def ul (ts : List Text) : StateT WriterState Id Unit := do
  inTag' "ul" do
    for t in ts do
      inTag' "li" do
        text t

/--
  Write out the `<iframe>` for a (static) commutative diagram.

  The `extraClasses`, if not `""`, are appended to the written class list.
-/
private def cda.iframe (d : Diagram) (extraClasses : String := "") : StateT WriterState Id Unit := do
  childlessTag "iframe" <|
    let options : List (String × String) :=
      [ .mk "class" ("quiver-embed block-static-diagram" ++ (if extraClasses = "" then "" else s!" {extraClasses}"))
      , .mk "src" s!"{d.href}&embed"
      , .mk "data-src" s!"{d.href}&embed"
      ]
    ; match d.height with
      | none    => options
      | some h  => .mk "height" s!"{h}" :: options

/-- Write a (static) commutative diagram. -/
private def cda (d : Diagram) : StateT WriterState Id Unit := do
  inTag "div" [.mk "class" "block-static-diagram-container"] do
    cda.iframe d

/--
  Write the controls bar for an interactive commutative diagram.

  The "frame number" input is limited to a `max` value of `totalFrameCount`.
-/
private def ida.frame.controls (totalFrameCount : Nat) : StateT WriterState Id Unit := do
  inTag "div" [.mk "class" "controls"] do
    inTag' "button" do
      newLine
      writeIndentation
      appendHtml' "&larr; "
      inlineTag "span" [.mk "class" "keyboard-shortcut-hint"] do
        appendHtml' "(h)"
    justTag "input"
      [ .mk "type" "number"
      , .mk "class" "frame-number"
      , .mk "min" "1"
      , .mk "max" s!"{totalFrameCount}"
      , .mk "value" "1"
      ]
    inTag' "button" do
      newLine
      writeIndentation
      inlineTag "span" [.mk "class" "keyboard-shortcut-hint"] do
        appendHtml' "(l)"
      appendHtml' " &rarr;"

/-- Write out the optional "supporting texts" of an interactive commutative diagram. -/
private def ida.frame.text (texts : List (Option Text)) : StateT WriterState Id Unit := do
  if texts.all Option.isNone then return ()
  inTag "div" [.mk "class" "supporting-text"] do
    for (frameNumber, text) in (texts |>.map (match · with | none => [.s "~"] | some t => t) |>.enumFrom 1) do
      inTag "span" [.mk "class" (if frameNumber = 1 then "" else "fake-hidden")] do
        comment' s!"Frame {frameNumber}"
        _root_.text text

/-- Write out the (static) commutative diagrams within an interactive commutative diagram. -/
private def ida.frame.cdas (ds : List Diagram) : StateT WriterState Id Unit := do
  inTag "div" [.mk "class" "block-static-diagram-container"] do
    for (frameNumber, d) in ds.enumFrom 1 do
      comment' s!"Frame {frameNumber}"
      cda.iframe d (if frameNumber = 1 then "" else "fake-hidden")

/-- Write an interactive commutative diagram. -/
private def ida (d : InteractiveDiagram) : StateT WriterState Id Unit := do
  set { (←get) with okAsDiscussion := false } -- No `InteractiveDiagram`s on Discussion-family pages
  inTag "div" [.mk "class" "interactive-diagram-container"] do
    inTag "div" [.mk "class" "interactive-diagram-frame"] do
      ida.frame.cdas (d.map IDFrame.cda)
      ida.frame.text (d.map IDFrame.text)
      ida.frame.controls d.length

/-- Write the `Body` of some container. -/
private def elementBody (b : Body) : StateT WriterState Id Unit := do
  for e in b.toList do
    match e with
    | .p t => p t
    | .ul ts => ul ts
    | .cda d => cda d
    | .ida d => ida d

/-- Write an `OutLink`. -/
private def outLink (l : OutLink) : StateT WriterState Id Unit := do
  inTag "svg" [.mk "class" "outlink", .mk "viewBox" "0 0 102 22"] do
    inTag "a" [.mk "href" l.href] do
      childlessTag "path"
        [ .mk "class" "outlink-arrow"
        , .mk "d" "M 1 1 L 91 1 L 101 11 L 91 21 L 1 21 L 11 11 Z"
        ]
      inTag "text" [.mk "class" "outlink-text", .mk "x" "51", .mk "y" "11"] do
        appendHtml l.label

/-- Write a `Block`, including its internal content. -/
private def elementBlock (b : Block) : StateT WriterState Id Unit := do
  inTag "div" [.mk "class" "block-section-element"] do
    inTag' "h3" do
      match b.title with
      | none    => appendHtml s!"{b.kind.toString}."
      | some t  => appendHtml s!"{b.kind.toString}. ({t})"
    elementBody b.body
  if let some l := b.outLink? then do
    outLink l

/-- Write an element inside a `<section>`. -/
private def element (e : Element) : StateT WriterState Id Unit := do
  match e with
    | .body b => elementBody b
    | .block b => elementBlock b

/-- Write a `<section>`. -/
private def writeSection (it : Section) : StateT WriterState Id Unit := do
  inTag "section" [.mk "id" it.id] do
    inTag' "h2" do
      appendHtml it.title
    for e in it.elements do
      element e

/-- Write the "see also" section. -/
private def seeAlso (s : SeeAlso) : StateT WriterState Id Unit := do
  inTag "section" [.mk "id" "See-also"] do
    inTag' "h2" do
      appendHtml "See also"
    inTag' "p" do
      if let some (href, title) := s.readNext then do
        inTag' "strong" do
          appendHtml "Read next:"
        inTag "a" [.mk "href" href] do
          appendHtml title
      if ! s.links.isEmpty then do
        inTag "h3" [.mk "class" "see-also"] do
          appendHtml "See also:"
        inTag "ul" [.mk "class" "see-also"] do
          for (href, title) in s.links do
            inTag' "li" do
              inTag "a" [.mk "href" href] do
                appendHtml title

/-- Write the main `<article>`. -/
private def article (page : Page) : StateT WriterState Id Unit := do
  inTag "article" [.mk "id" "content"] do
    inTag' "h1" do
      appendHtml page.title
    for it in page.sections do
      writeSection it
    seeAlso page.seeAlso

/-- Write the `<main> ⋯ </main>`. -/
private def main (page : Page) : StateT WriterState Id Unit := do
  inTag "main" [.mk "class" "family"] do
    contentsBar page.sections page.title
    article page
    sidenotesBar

/--
  Write the `<body> ⋯ </body>`.
  The `sections` are rendered within the main content and are used to produce the contents
  bar.
-/
private def body (page : Page) : StateT WriterState Id Unit := do
  inTag' "body" do
    nav
    main page
    footer

/-- Write the `page` into an `HTML` document, captured in the `WriterState.currentHtml`. -/
private def Page.write (page : Page) : StateT WriterState Id Unit := do
  doctype
  html do
    head page.title
    body page

/-- Convert the `page` to a string encoding an `HTML` document. -/
private def Page.toHtml (page : Page) : String :=
  page.write |>.run {} |>.snd  |>.currentHtml



/- LAUNCH: writeHtml -/

/-- Write the `HTML` document corresponding to the given `page` out to the given `filename`. -/
private def writeHtml (filename : System.FilePath) (page : Page) : IO Unit := do
  IO.FS.writeFile filename page.toHtml

/-- Write the `HTML` document corresponding to the given `page` out to the given `filename`. -/
def Page.writeHtmlToFile (page : Page) (filename : System.FilePath) : IO Unit :=
  writeHtml filename page
