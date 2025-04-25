/- **FILE:** `Pages/Template.lean` -/

/- IMPORTS: -/

import Inset.EncodePages



/- SECTION: Helper definitions -/

-- NOTE: `q.uiver` URLs:
-- private def aHref : String :=
--   "https://q.uiver.app/#q=WzAsNSxbMCwwLCJcXGNhdHtDfV57XFxjYXR7Sn19Il0sWzAsMiwiXFxjYXR7Q30iXSxbMiwwLCJcXGNhdHtcXHd0bHtDfX1ee1xcY2F0e0p9fSJdLFsyLDIsIlxcY2F0e1xcd3Rse0N9fSAiXSxbMSwxLCJcXGNpcmNsZWFycm93bGVmdF97XFxzaW1lcX0iXSxbMCwxLCJcXGxpbV97XFxjYXR7Sn19IiwyXSxbMiwzLCJcXGxpbV97XFxjYXR7Sn19Il0sWzEsMywiVSIsMl0sWzAsMiwiVSBcXGNpcmMgLSJdXQ==&macro_url=https%3A%2F%2Fgist.githubusercontent.com%2Favg-lebesgue-enjoyer%2Ffacad9c53abe5718a59f4400e28c87f3%2Fraw%2Fbf740cfaac1cf36f7c5faed44562c7fe9fd9f8f3%2Fquiver-preamble.tex"
-- NOTE: `$$ ⋯ $$` contents
-- private def anEqn : String :=
--   "F : \\mathsf{C} \\rightleftarrows \\mathsf{\\widetilde{C}} : U"
-- NOTE: `$$\begin{align*} ⋯ \end{align*}$$` contents
-- private def anAlign : BigEquation :=
--   [ "\\eta : 1_{\\mathsf{C}} &\\to U F"
--   , "&\\varepsilon : F U &\\to 1_{\\widetilde{\\mathsf{C}}}"
--   ]



/- LAUNCH: -/

namespace Template
  def it : Page :=
    { title :=
        "NOTE: Title goes here!"
    , sections :=
        [ -- NOTE: Sections go here!
        ]
    , seeAlso :=
        { readNext :=
            none -- NOTE: Change if desired
        , links :=
            [ -- NOTE: Links go here!
            ]
        }
    }
end Template
