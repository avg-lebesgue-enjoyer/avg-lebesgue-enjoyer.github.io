/- **FILE:** `Pages/RightAdjointsPreserveLimits.lean` -/

/- IMPORTS: -/

import Inset.EncodePages



/- SECTION: Helper definitions -/

-- NOTE: `q.uiver` URLs
private def triangleIdentitiesHref : String := "https://q.uiver.app/#q=WzAsNixbMiwwLCJGVUYiXSxbMiwyLCJGIl0sWzAsMCwiRiJdLFs0LDAsIlUiXSxbNiwwLCJVRlUiXSxbNiwyLCJVIl0sWzIsMCwiRiBcXGV0YSJdLFswLDEsIlxcdmFyZXBzaWxvbiBGIl0sWzIsMSwiMV9GIiwyXSxbMyw0LCJcXGV0YSBVIl0sWzQsNSwiVVxcdmFyZXBzaWxvbiJdLFszLDUsIjFfVSIsMl1d&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
private def raplHref : String := "https://q.uiver.app/#q=WzAsNSxbMCwwLCJcXGNhdHtDfV57XFxjYXR7Sn19Il0sWzAsMiwiXFxjYXR7Q30iXSxbMiwwLCJcXGNhdHtcXHd0bHtDfX1ee1xcY2F0e0p9fSJdLFsyLDIsIlxcY2F0e1xcd3Rse0N9fSAiXSxbMSwxLCJcXGNpcmNsZWFycm93bGVmdF97XFxzaW1lcX0iXSxbMCwxLCJcXGxpbV97XFxjYXR7Sn19IiwyXSxbMiwzLCJcXGxpbV97XFxjYXR7Sn19Il0sWzEsMywiVSIsMl0sWzAsMiwiVSBcXGNpcmMgLSJdXQ==&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
-- NOTE: `$$ ⋯ $$` contents
private def opposingFunctorsEqn : String :=
  "F : \\mathsf{C} \\rightleftarrows \\mathsf{\\widetilde{C}} : U"
private def homSetIsomorphismEqn : String :=
  "\\varphi_{x, \\tilde{y}} : \\widetilde{\\mathsf{C}}(F x, \\tilde{y}) \\simeq \\mathsf{C}(x, U \\tilde{y})"
private def raplEqn : String :=
  "\\lim_{\\mathsf{J}} \\left( U \\widetilde{D} \\right) \\simeq U \\left( \\lim_{\\mathsf{J}} \\widetilde{D} \\right)"
  -- NOTE: `$$\begin{align*} ⋯ \end{align*}$$` contents
private def unitCounitAlign : BigEquation :=
  [ "\\eta"
  , ": 1_{\\mathsf{C}}"
  , "&\\to U F"
  , "&\\varepsilon"
  , ": F U"
  , "&\\to 1_{\\widetilde{\\mathsf{C}}}"
  ]



/- LAUNCH: -/

namespace RightAdjointsPreserveLimits
  def it : Page :=
    { title :=
        "Right Adjoints Preserve Limits"
    , sections :=
        [ .mk
            "Theorem statement"
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
                }
          ]
      ]
    , seeAlso :=
        { links :=
            [ .mk "../discussion/adjunctions.html" "Adjunctions"
            , .mk "../discussion/limits.html" "Limits"
            ]
        }
    }
end RightAdjointsPreserveLimits
