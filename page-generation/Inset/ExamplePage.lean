/-
  **FILE:** `Inset/ExamplePage.lean`
  **PURPOSE:** Demonstrate an example page
-/

/- IMPORTS: -/

import Inset.BuildPages



/- SECTION: Internal Lean page representation -/
section «in lean»

-- NOTE: `q.uiver` URLs
private def opposingFunctorsHref : String := "https://q.uiver.app/#q=WzAsMixbMCwwLCJcXGNhdHtDfSJdLFsyLDAsIlxcY2F0e1xcd3Rse0N9fSJdLFswLDEsIkYiLDAseyJvZmZzZXQiOi0yfV0sWzEsMCwiVSIsMCx7Im9mZnNldCI6LTJ9XV0=&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
private def triangleIdentitiesHref : String := "https://q.uiver.app/#q=WzAsNixbMiwwLCJGVUYiXSxbMiwyLCJGIl0sWzAsMCwiRiJdLFs0LDAsIlUiXSxbNiwwLCJVRlUiXSxbNiwyLCJVIl0sWzIsMCwiRiBcXGV0YSJdLFswLDEsIlxcdmFyZXBzaWxvbiBGIl0sWzIsMSwiMV9GIiwyXSxbMyw0LCJcXGV0YSBVIl0sWzQsNSwiVVxcdmFyZXBzaWxvbiJdLFszLDUsIjFfVSIsMl1d&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
private def raplHref : String := "https://q.uiver.app/#q=WzAsNSxbMCwwLCJcXGNhdHtDfV57XFxjYXR7Sn19Il0sWzAsMiwiXFxjYXR7Q30iXSxbMiwwLCJcXGNhdHtcXHd0bHtDfX1ee1xcY2F0e0p9fSJdLFsyLDIsIlxcY2F0e1xcd3Rse0N9fSAiXSxbMSwxLCJcXGNpcmNsZWFycm93bGVmdF97XFxzaW1lcX0iXSxbMCwxLCJcXGxpbV97XFxjYXR7Sn19IiwyXSxbMiwzLCJcXGxpbV97XFxjYXR7Sn19Il0sWzEsMywiVSIsMl0sWzAsMiwiVSBcXGNpcmMgLSJdXQ==&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
-- NOTE: `\begin{align*} ⋯ \end{align*}` contents
private def homSetIsomorphismAlign : String :=
  " \\varphi_{x, \\tilde{y}}
    : \\widetilde{\\mathsf{C}}(F x, \\tilde{y})
    \\simeq \\mathsf{C}(x, U \\tilde{y})
  "
private def unitCounitAlign : String :=
  " \\eta
    : 1_{\\mathsf{C}}
    &\\to U F
    &\\varepsilon
    : F U
    &\\to 1_{\\widetilde{\\mathsf{C}}}
  "
private def raplAlign : String :=
  " \\lim_{\\mathsf{J}} \\left( U \\widetilde{D} \\right)
    &\\simeq U \\left( \\lim_{\\mathsf{J}} \\widetilde{D} \\right)
  "

def adjunctionPage : Page :=
  .mk
    "Adjunctions"
    [ .mk
        "Hom-set definition"
        [ .body
            [ .p "The hom-set definition of an adjunction is how adjunctions are most typically introduced. Let $\\mathsf{C}$ and $\\mathsf{\\widetilde{C}}$ be categories. A hom-set adjunction consists of a pair of opposing functors"
            , .cda { href := opposingFunctorsHref }
            , .eqn homSetIsomorphismAlign
            , .p "natural in $x \\in \\mathsf{C}^{\\mathrm{op}}$ and in $\\tilde{y} \\in \\widetilde{\\mathsf{C}}."
            ]
        ]
    , .mk
        "Unit-counit definition"
        [ .body
            [ .p "The unit-counit definition is useful in 2-category theory, and for practically working with adjunctions."
            , .p "Let $\\mathsf{C}$ and $\\widetilde{\\mathsf{C}}$ be categories. A unit-counit adjunction consists of a pair of opposing functors"
            , .cda { href := opposingFunctorsHref }
            , .p "and two natural transformations"
            , .eqn unitCounitAlign
            , .p "such that the triangle identities shown below commute:"
            , .cda { href := triangleIdentitiesHref }
            ]
        ]
    , .mk
        "Equivalence of Definitions"
        [ .body
            [ .p "The two definitions provided above are equivalent in the following sense:"
            ]
        , .block
            { kind :=
                .lem
              body :=
                [ .p "Fix a pair of opposing functors $F : \\mathsf{C} \\rightleftarrows \\mathsf{\\widetilde{C}} : U$. Then, there is a family of isomorphisms"
                , .eqn homSetIsomorphismAlign
                , .p "specifying a hom-set adjunction if and only if there is a pair of natural transformations"
                , .eqn unitCounitAlign
                , .p "specifying a unit-counit adjunction."
                ]
              outLink? :=
                { href := "proof/adjunction-definition-equivalence.html" : OutLink }
            }
        ]
    , .mk
        "Result: RAPL"
        [ .body
            [ .p "Perhaps the most frequently used result in category theory is the following."
            ]
        , .block
            { kind :=
                .thm
              body :=
                [ .p "Let $U : \\mathsf{\\widetilde{C}} \\to \\mathsf{C}$ be a right adjoint functor and let $\\widetilde{D} : \\mathsf{J} \\to \\mathsf{\\widetilde{C}}$ be a diagram with a limit in $\\mathsf{\\widetilde{C}}$. Then, the composite diagram $U \\widetilde{D} : \\mathsf{J} \\to \\mathsf{C}$ has a limit in $\\mathsf{C}$$ and"
                , .eqn raplAlign
                , .p "Consequently, if $\\mathsf{C}$ and $\\mathsf{\\widetilde{C}}$ have all $\\mathsf{J}$-shaped limits, then the following diagram commutes up to isomorphism"
                , .cda { href := raplHref }
                ]
            }
        ]
    ]

end «in lean»
