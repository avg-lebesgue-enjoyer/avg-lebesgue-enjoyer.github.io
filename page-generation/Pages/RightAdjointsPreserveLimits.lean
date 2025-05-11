/- **FILE:** `Pages/RightAdjointsPreserveLimits.lean` -/

/- IMPORTS: -/

import Inset.EncodePages



/- SECTION: Helper definitions -/

-- NOTE: `q.uiver` URLs
private def raplHref : String := "https://q.uiver.app/#q=WzAsNSxbMCwwLCJcXGNhdHtDfV57XFxjYXR7Sn19Il0sWzAsMiwiXFxjYXR7Q30iXSxbMiwwLCJcXGNhdHtcXHd0bHtDfX1ee1xcY2F0e0p9fSJdLFsyLDIsIlxcY2F0e1xcd3Rse0N9fSAiXSxbMSwxLCJcXGNpcmNsZWFycm93bGVmdF97XFxzaW1lcX0iXSxbMCwxLCJcXGxpbV97XFxjYXR7Sn19IiwyXSxbMiwzLCJcXGxpbV97XFxjYXR7Sn19Il0sWzEsMywiVSIsMl0sWzAsMiwiVSBcXGNpcmMgLSJdXQ==&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
private def FindMap.cda₁ : String := "https://q.uiver.app/#q=WzAsNCxbMSwwLCJhIl0sWzEsMSwiXFxjaXJjbGVhcnJvd2xlZnQiXSxbMCwyLCJVIFxcd3Rse0R9IGkiXSxbMiwyLCJVXFx3dGx7RH1qIl0sWzIsMywiVSBcXHd0bHtEfSBmIiwyXSxbMCwyLCJcXGFscGhhX2kiLDJdLFswLDMsIlxcYWxwaGFfaiJdXQ==&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
private def FindMap.cda₂ : String := "https://q.uiver.app/#q=WzAsMTAsWzMsNCwiXFxwaGFudG9te3h9Il0sWzEsMSwiYSJdLFswLDMsIlUgXFx3dGx7RH0gaSJdLFsyLDMsIlUgXFx3dGx7RH0gaiJdLFs0LDMsIlxcd3Rse0R9IGkiXSxbNiwzLCJcXHd0bHtEfSBqIl0sWzUsMSwiRiBhIl0sWzEsMiwiXFxjaXJjbGVhcnJvd2xlZnQiXSxbNSwyLCJcXGNpcmNsZWFycm93bGVmdCJdLFszLDAsIlxccGhhbnRvbXt4fSJdLFsxLDIsIlxcYWxwaGFfaSIsMl0sWzIsMywiVSBcXHd0bHtEfSBmIiwyXSxbMSwzLCJcXGFscGhhX2oiXSxbNiw0LCJcXG92ZXJsaW5le1xcYWxwaGFfaX0iLDJdLFs2LDUsIlxcb3ZlcmxpbmV7XFxhbHBoYV9qfSJdLFs0LDUsIlxcd3Rse0R9IGYiLDJdLFs5LDAsIkYgXFxkYXNodiBVIiwxLHsibGFiZWxfcG9zaXRpb24iOjEwLCJzdHlsZSI6eyJoZWFkIjp7Im5hbWUiOiJub25lIn19fV1d&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
private def FindMap.cda₃ : String := "https://q.uiver.app/#q=WzAsMTAsWzMsNCwiXFxwaGFudG9te3h9Il0sWzEsMSwiXFxncmF5e2F9Il0sWzAsMywiXFxncmF5e1UgXFx3dGx7RH0gaX0iXSxbMiwzLCJcXGdyYXl7VSBcXHd0bHtEfSBqfSJdLFs0LDMsIlxcd3Rse0R9IGkiXSxbNiwzLCJcXHd0bHtEfSBqIl0sWzUsMSwiRiBhIl0sWzEsMiwiXFxncmF5e1xcY2lyY2xlYXJyb3dsZWZ0fSJdLFszLDAsIlxccGhhbnRvbXt4fSJdLFs1LDIsIlxcdGlsZGV7XFxlbGx9Il0sWzEsMiwiXFxncmF5e1xcYWxwaGFfaX0iLDIseyJjb2xvdXIiOlswLDAsMzJdfSxbMCwwLDMyLDFdXSxbMiwzLCJcXGdyYXl7VSBcXHd0bHtEfSBmfSIsMix7ImNvbG91ciI6WzAsMCwzMl19LFswLDAsMzIsMV1dLFsxLDMsIlxcZ3JheXtcXGFscGhhX2p9IiwwLHsiY29sb3VyIjpbMCwwLDMyXX0sWzAsMCwzMiwxXV0sWzYsNCwiXFxvdmVybGluZXtcXGFscGhhX2l9IiwyXSxbNiw1LCJcXG92ZXJsaW5le1xcYWxwaGFfan0iXSxbNCw1LCJcXHd0bHtEfSBmIiwyXSxbOCwwLCJGIFxcZGFzaHYgVSIsMSx7ImxhYmVsX3Bvc2l0aW9uIjoxMCwiY29sb3VyIjpbMCwwLDMyXSwic3R5bGUiOnsiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX0sWzAsMCwzMiwxXV0sWzYsOSwiXFxleGlzdHMgISBcXHRpbGRle3V9IiwxXSxbOSw0LCJcXHRpbGRle1xcbGFtYmRhfV9pIiwxXSxbOSw1LCJcXHRpbGRle1xcbGFtYmRhfV9qIiwxXV0=&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2F81aa235cf14b3a74a2d46500473a6f1b617ce2e7%2Fquiver-preamble.tex"
private def FindMap.cda₄ : String := "https://q.uiver.app/#q=WzAsMTAsWzMsNCwiXFxwaGFudG9te3h9Il0sWzEsMSwiYSJdLFswLDMsIlUgXFx3dGx7RH0gaSJdLFsyLDMsIlUgXFx3dGx7RH0gaiJdLFs0LDMsIlxcZ3JheXtcXHd0bHtEfSBpfSJdLFs2LDMsIlxcZ3JheXtcXHd0bHtEfSBqfSJdLFs1LDEsIlxcZ3JheXtGIGF9Il0sWzMsMCwiXFxwaGFudG9te3h9Il0sWzUsMiwiXFxncmF5e1xcdGlsZGV7XFxlbGx9fSJdLFsxLDIsIlUgXFx0aWxkZXtcXGVsbH0iXSxbMSwyLCJcXGdyYXl7XFxhbHBoYV9pfSIsMl0sWzIsMywiXFxncmF5e1UgXFx3dGx7RH0gZn0iLDJdLFsxLDMsIlxcZ3JheXtcXGFscGhhX2p9Il0sWzYsNCwiXFxvdmVybGluZXtcXGFscGhhX2l9IiwyLHsiY29sb3VyIjpbMCwwLDMyXX0sWzAsMCwzMiwxXV0sWzYsNSwiXFxvdmVybGluZXtcXGFscGhhX2p9IiwwLHsiY29sb3VyIjpbMCwwLDMyXX0sWzAsMCwzMiwxXV0sWzQsNSwiXFx3dGx7RH0gZiIsMix7ImNvbG91ciI6WzAsMCwzMl19LFswLDAsMzIsMV1dLFs3LDAsIkYgXFxkYXNodiBVIiwxLHsibGFiZWxfcG9zaXRpb24iOjEwLCJzdHlsZSI6eyJoZWFkIjp7Im5hbWUiOiJub25lIn19fV0sWzYsOCwiXFxleGlzdHMgISBcXHRpbGRle3V9IiwxLHsiY29sb3VyIjpbMCwwLDMyXX0sWzAsMCwzMiwxXV0sWzgsNCwiXFx0aWxkZXtcXGxhbWJkYX1faSIsMSx7ImNvbG91ciI6WzAsMCwzMl19LFswLDAsMzIsMV1dLFs4LDUsIlxcdGlsZGV7XFxsYW1iZGF9X2oiLDEseyJjb2xvdXIiOlswLDAsMzJdfSxbMCwwLDMyLDFdXSxbMSw5LCJcXG92ZXJsaW5le1xcdGlsZGV7dX19IiwxXSxbOSwyLCJVXFx0aWxkZXtcXGxhbWJkYX1faSIsMV0sWzksMywiVSBcXHRpbGRle1xcbGFtYmRhfV9qIiwxXV0=&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2F81aa235cf14b3a74a2d46500473a6f1b617ce2e7%2Fquiver-preamble.tex"
-- NOTE: `$$ ⋯ $$` contents
private def raplEqn : String :=
  "\\lim_{\\mathsf{J}} \\left( U \\widetilde{D} \\right) \\simeq U \\left( \\lim_{\\mathsf{J}} \\widetilde{D} \\right)"
  -- NOTE: `$$\begin{align*} ⋯ \end{align*}$$` contents
private def yonedaAlign : BigEquation :=
  [ " \\mathsf{C}\\left("
  , "   z, U\\left("
  , "     \\lim_{\\mathsf{J}} \\widetilde{D}"
  , "   \\right)"
  , " \\right)"
  , " &\\simeq \\widetilde{\\mathsf{C}}\\left("
  , "   F z, \\lim_{\\mathsf{J}} \\widetilde{D}"
  , " \\right)"
  , .alignBreak
  , " &\\simeq \\lim_{j \\in \\mathsf{J}}"
  , "   \\widetilde{\\mathsf{C}}\\left("
  , "     F z, \\widetilde{D} j"
  , "   \\right)"
  , .alignBreak
  , " &\\simeq \\lim_{j \\in \\mathsf{J}}"
  , "   \\mathsf{C}\\left("
  , "     z, U \\widetilde{D}"
  , "   \\right)"
  , .alignBreak
  , " \\mathsf{C}\\left("
  , "   z, U\\left("
  , "     \\lim_{\\mathsf{J}} \\widetilde{D}"
  , "   \\right)"
  , " \\right)"
  , " &\\simeq \\mathsf{C}\\left("
  , "   z, \\lim_{\\mathsf{J}} U \\widetilde{D}"
  , " \\right)"
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
      , .mk
          "Diagrammatic proof"
          [ .body
              [ .ps "Let $F : \\mathsf{C} \\to \\widetilde{\\mathsf{C}}$ be a left adjoint and let $\\tilde{\\lambda} : \\tilde{\\ell} \\Rightarrow \\widetilde{D}$ be a limit cone. We can form the cone $U \\tilde{\\lambda} : U \\tilde{\\ell} \\Rightarrow U \\widetilde{D}$, which we wish to show is a limit cone."
              , .ps "To this end, let $\\alpha : a \\Rightarrow U \\widetilde{D}$ be another cone over $U \\widetilde{D}$. We wish to show that there is a unique map from the summit $a$ of $\\alpha$ to the summit $U \\tilde{\\ell}$ of our proposed limit cone $U \\widetilde{\\lambda}$ which commutes with the cones. We first find such a map."
              , .ida
                  [ { cda  := { href := FindMap.cda₁, height := some 332 } -- Suggested height: `some 302`; overridden here for consistency
                    , text := some [.s "For any $f : i \\to j$ in $\\mathsf{J}$, the above diagram must commute."]
                    }
                  , { cda  := { href := FindMap.cda₂, height := some 332 }
                    , text := some [.s "Since we have a limit over $\\widetilde{D}$, we transpose the left diagram to the right diagram. Commutativity is preserved by adjunctions, so $\\overline{\\alpha}$ is a cone over $\\widetilde{D}$."]
                    }
                  , { cda  := { href := FindMap.cda₃, height := some 332 }
                    , text := some [.s "The cone $\\overline{\\alpha}$ factors through the limit cone along some (unique) map $\\tilde{u}$."]
                    }
                  , { cda  := { href := FindMap.cda₄, height := some 332 }
                    , text := some [.s "Transposing this diagram back, we obtain a map $\\overline{\\tilde{u}}$ from the cone $\\alpha$ to the cone $U \\tilde{\\lambda}$."]
                    }
                  ]
              , .ps "Therefore, there is such a map. Demonstrating its uniqueness is left as an exercise to the reader."
              ]
          ]
      , .mk
          "Yoneda-style equational proof"
          [ .body
              [ .p
                  [ .s "Let $F : \\mathsf{C} \\to \\widetilde{\\mathsf{C}}$ be a left adjoint. Then, we have the following isomorphisms, all natural in $z \\in \\mathsf{C}^{\\mathrm{op}}$."
                  , .al yonedaAlign
                  , .s "By the "
                  , .a "../discussion/yoneda-lemma.html" "Yoneda lemma"
                  , .s ", we conclude that"
                  , .eqn raplEqn
                  , .s "as desired."
                  , .sn
                      [ .s "This argument is not 100% airtight &mdash; it seemingly assumes the existence of $\\lim_{\\mathsf{J}} U \\widetilde{D}$. "
                      , .s "It is not difficult to fix this inaccuracy, and so it is left as an exercise to the reader."
                      ]
                  ]
              ]
          ]
      ]
    , seeAlso :=
        { links :=
            [ .mk "../discussion/adjunctions.html" "Adjunctions"
            , .mk "../discussion/limits.html" "Limits"
            , .mk "../discussion/yoneda-lemma.html" "Yoneda Lemma"
            ]
        }
    }
end RightAdjointsPreserveLimits
