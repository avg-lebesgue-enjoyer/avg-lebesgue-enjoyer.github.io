/-
  **FILE:** `Inset/ExamplePage.lean`
  **PURPOSE:** Demonstrate an example page
-/

/- IMPORTS: -/

import Inset.EncodePages
import Inset.BuildPages



/- SECTION: Internal Lean page representation -/
section «in lean»

-- NOTE: `q.uiver` URLs
private def triangleIdentitiesHref : String := "https://q.uiver.app/#q=WzAsNixbMiwwLCJGVUYiXSxbMiwyLCJGIl0sWzAsMCwiRiJdLFs0LDAsIlUiXSxbNiwwLCJVRlUiXSxbNiwyLCJVIl0sWzIsMCwiRiBcXGV0YSJdLFswLDEsIlxcdmFyZXBzaWxvbiBGIl0sWzIsMSwiMV9GIiwyXSxbMyw0LCJcXGV0YSBVIl0sWzQsNSwiVVxcdmFyZXBzaWxvbiJdLFszLDUsIjFfVSIsMl1d&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
private def raplHref : String := "https://q.uiver.app/#q=WzAsNSxbMCwwLCJcXGNhdHtDfV57XFxjYXR7Sn19Il0sWzAsMiwiXFxjYXR7Q30iXSxbMiwwLCJcXGNhdHtcXHd0bHtDfX1ee1xcY2F0e0p9fSJdLFsyLDIsIlxcY2F0e1xcd3Rse0N9fSAiXSxbMSwxLCJcXGNpcmNsZWFycm93bGVmdF97XFxzaW1lcX0iXSxbMCwxLCJcXGxpbV97XFxjYXR7Sn19IiwyXSxbMiwzLCJcXGxpbV97XFxjYXR7Sn19Il0sWzEsMywiVSIsMl0sWzAsMiwiVSBcXGNpcmMgLSJdXQ==&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
-- NOTE: `\begin{align*} ⋯ \end{align*}` contents
private def opposingFunctorsEqn : String :=
  "F : \\mathsf{C} \\rightleftarrows \\mathsf{\\widetilde{C}} : U"
private def homSetIsomorphismEqn : String :=
  "\\varphi_{x, \\tilde{y}} : \\widetilde{\\mathsf{C}}(F x, \\tilde{y}) \\simeq \\mathsf{C}(x, U \\tilde{y})"
private def unitCounitAlign : BigEquation :=
  [ "\\eta"
  , ": 1_{\\mathsf{C}}"
  , "&\\to U F"
  , "&\\varepsilon"
  , ": F U"
  , "&\\to 1_{\\widetilde{\\mathsf{C}}}"
  ]
private def raplEqn : String :=
  "\\lim_{\\mathsf{J}} \\left( U \\widetilde{D} \\right) \\simeq U \\left( \\lim_{\\mathsf{J}} \\widetilde{D} \\right)"

def adjunctionPage : Page :=
  { title :=
      "Adjunctions"
  , sections :=
      [ .mk
        "Hom-set definition"
        [ .body
            [ .p
              [ .s <| "The hom-set definition of an adjunction is how adjunctions are most typically introduced. Let $\\mathsf{C}$ and $\\mathsf{\\widetilde{C}}$ be categories. A " ++ strong "hom-set adjunction" ++ " consists of a pair of opposing functors"
              , .eqn opposingFunctorsEqn
              , .s "and a family of isomorphisms"
              , .sn [.s "This family is often suppressed in practice."]
              , .eqn homSetIsomorphismEqn
              , .s "natural in $x \\in \\mathsf{C}^{\\mathrm{op}}$ and in $\\tilde{y} \\in \\widetilde{\\mathsf{C}}$."
              ]
            ]
        ]
    , .mk
        "Unit-counit definition"
        [ .body
            [ .p
              [ .s "The unit-counit definition is useful in 2-category theory, and for practically working with adjunctions."
              , .s <| "Let $\\mathsf{C}$ and $\\widetilde{\\mathsf{C}}$ be categories. A " ++ strong "unit-counit adjunction" ++ " consists of a pair of opposing functors"
              , .eqn opposingFunctorsEqn
              , .s "and two natural transformations"
              , .sn [.s "These are known as the unit and the counit respectively."]
              , .al unitCounitAlign
              , .s "such that the triangle identities shown below commute:"
              ]
            , .cda { href := triangleIdentitiesHref, height := some 302 }
            ]
        ]
    , .mk
        "Equivalence of Definitions"
        [ .body
            [ .ps "The two definitions provided above are equivalent in the following sense."
            ]
        , .block
            { kind :=
                .lem
            , body :=
                [ .p
                  [ .s "Fix a pair of opposing functors $F : \\mathsf{C} \\rightleftarrows \\mathsf{\\widetilde{C}} : U$. Then, there is a family of isomorphisms"
                  , .eqn homSetIsomorphismEqn
                  , .s "specifying a hom-set adjunction if and only if there is a pair of natural transformations"
                  , .al unitCounitAlign
                  , .s "specifying a unit-counit adjunction."
                  ]
                ]
              outLink? :=
                { href := "../proof/adjunction-definition-equivalence.html" : OutLink }
            }
        ]
    , .mk
        "Result: RAPL"
        [ .body
            [ .ps "Perhaps the most frequently used result in category theory is the following."
            ]
        , .block
            { kind :=
                .thm
            , title :=
                "RAPL"
            , body :=
                [ .p
                  [ .s "Let $U : \\mathsf{\\widetilde{C}} \\to \\mathsf{C}$ be a right adjoint functor and let $\\widetilde{D} : \\mathsf{J} \\to \\mathsf{\\widetilde{C}}$ be a diagram with a limit in $\\mathsf{\\widetilde{C}}$. Then, the composite diagram $U \\widetilde{D} : \\mathsf{J} \\to \\mathsf{C}$ has a limit in $\\mathsf{C}$ and"
                  , .eqn raplEqn
                  , .s "Consequently, if $\\mathsf{C}$ and $\\mathsf{\\widetilde{C}}$ have all $\\mathsf{J}$-shaped limits, then the following diagram commutes up to isomorphism."
                  ]
                , .cda { href := raplHref, height := some 302 }
                ]
            , outLink? :=
                { href := "../proof/rapl.html" : OutLink }
            }
        ]
    ]
  , seeAlso :=
    { readNext :=
        some ("./multivariate-adjunctions.html", "Multivariate Adjunctions")
    , links :=
        [ .mk "../proof/equivalence-of-adjunction-definitions.html" "Equivalence of Adjunction Definitions"
        , .mk "../proof/right-adjoints-preserve-limits.html" "Right Adjoints Preserve Limits"
        ]
    }
  }

end «in lean»



/- SECTION: Writing out to file -/
section «on file»
  -- #eval adjunctionPage.writeHtmlToFile "../discussion/DEBUG.html"
end «on file»
