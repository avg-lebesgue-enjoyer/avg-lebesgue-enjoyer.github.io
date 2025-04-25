/- **FILE:** `Pages/Categories.lean` -/

/- IMPORTS: -/

import Inset.EncodePages



/- SECTION: Helper definitions -/

-- NOTE: `q.uiver` URLs:
-- NOTE: `$$ ⋯ $$` contents
-- NOTE: `$$\begin{align*} ⋯ \end{align*}$$` contents



/- LAUNCH: -/

namespace Categories
  def it : Page :=
    { title :=
        "Categories"
    , sections :=
        [ .mk
            "Definition"
            [ .body
                [ .ps "When we study various kinds of mathematical objects, it turns out that the various relationships between them are captured by the transformations between them. For example, we compare the cardinality of sets using injective, surjective and bijective functions, and we declare that two groups are the same when there is an isomorphism between them."
                , .ps "The central thesis of category theory is that <em>understanding the objects we care about requires understanding the arrows the arrows between them</em>, and the definition of a <em>category</em> captures this notion well."
                ]
            , .block
                { kind :=
                    .dfn
                , title :=
                    "Category"
                , body :=
                    [ .ps "A <strong>category</strong> $\\mathsf{C}$ consists of:"
                    , .ul
                        [ .s "A collection $\\mathrm{ob}\\ \\mathsf{C}$ of <strong>objects</strong>"
                        , .s "For each pair of objects $x \\in \\mathrm{ob}\\ \\mathsf{C}$, a collection $\\mathsf{C}(x, y)$ called the <strong>hom-set from $x$ to $y$</strong>"
                        , .s "For each object $x \\in \\mathrm{ob}\\ \\mathsf{C}$, an <strong>identity arrow</strong> $1_x \\in \\mathrm{mor}$"
                        , .s "For each triple of objects $x, y, z \\in \\mathrm{ob}\\ \\mathsf{C}$, a <strong>composition operation</strong> $\\mathsf{C}(y, z) \\times \\mathsf{C}(x, y) \\to \\mathsf{C}(x, z)$"
                        ]
                    , .ps "Subject to the following constraints:"
                    , .ul
                        [ [ .s "(Associativity) For all $a, b, c, d \\in \\mathrm{ob}\\ \\mathsf{C}$ and for all $f \\in \\mathsf{C}(a, b),\\ g \\in \\mathsf{C}(b, c),\\ h \\in \\mathsf{C}(c, d)$, we require"
                          , .eqn "(h \\circ g) \\circ f = h \\circ (g \\circ f)"
                          ]
                        , [ .s "(Unitality) For all $a, b \\in \\mathrm{ob}\\ \\mathsf{C}$ and for all $f \\in \\mathsf{C}(a, b)$, we require"
                          , .eqn "1_b \\circ f = f = f \\circ 1_a"
                          ]
                        ]
                    ]
                }
            , .body
                [ .p
                    [ .s "The elements of the hom-sets go by various names"
                    , .sn [.s "Such as <em>arrow</em>, <em>morphism</em> and <em>map</em>."]
                    , .s ". It is also common to write expressions such as $\\text{``}a \\xrightarrow{f} b \\text{ in } \\mathsf{C}\\text{''}$ to refer to objects $a, b \\in \\mathrm{ob}\\ \\mathsf{C}$ and an arrow $f \\in \\mathsf{C}(a, b)$. In light of this, the associativity and unitality axioms can be rewritten as"
                    , .al
                        [ "\\forall a \\xrightarrow{f} b \\xrightarrow{g} c \\xrightarrow{h} d \\text{ in } \\mathsf{C},\\quad"
                        , "&(f \\circ g) \\circ h = f \\circ (g \\circ h)"
                        , "\\\\"
                        , "\\forall a \\xrightarrow{f} b \\text{ in } \\mathsf{C},\\quad"
                        , "&1_b \\circ f = f = f \\circ 1_a"
                        ]
                    , .s "In particular, the first condition states that any path $a_0 \\xrightarrow{f_1} a_1 \\xrightarrow{f_2} \\cdots \\xrightarrow{f_n} a_n$ can be composed together in a unique way: $a_0 \\xrightarrow{f_n \\circ \\cdots \\circ f_1} a_n$."
                    ]
                ]
            ]
        , .mk
            "Examples"
            [ .body
                [ .ps "By understanding categories in the abstract, we can apply our understandings to a diverse array of mathematical contexts."
                ]
            , .block
                { kind :=
                    .exa
                , title :=
                    "$\\mathbf{Set}$"
                , body :=
                    [ .p
                        [ .s "The most important example of a category"
                        , .sn
                            [ .s "The"
                            , .a "./yoneda-lemma" "Yoneda lemma"
                            , .s "makes this precise."
                            ]
                        , .s "is the category $\\mathbf{Set}$. Its objects are sets, and the collection $\\mathbf{Set}(X, Y) := Y^X$ is the set of all functions $X \\to Y$. The identity arrows $1_X := \\mathrm{id}_X$ are the identity functions, and the composition operation is function composition."
                        , .s "You should check that this is a category!"
                        ]
                    ]
                }
            , .block
                { kind :=
                    .exa
                , title :=
                    "$\\mathbf{Group}$"
                , body :=
                  [ .p
                      [ .s "As alluded to in the"
                      , .a "#Definition" "previous section"
                      , .s ", there is a category $\\mathbf{Group}$ whose objects are groups, and whose hom-sets $\\mathbf{Group}(G, H)$ consist of all group homomorphisms between them. The identity arrows $1_G := \\mathrm{id}_G$ and composition operations are the same as in $\\mathbf{Set}$."
                      ]
                  ]
                }
            , .block
                { kind :=
                    .exa
                , title :=
                    "Algebraic structures"
                , body :=
                    [ .p
                        [ .s "Generalising the previous example, many notions of"
                        , .a "https://en.wikipedia.org/wiki/Universal_algebra" "algebraic structures"
                        , .s "form categories. For instance, there are categoires $\\mathrm{Monoid}$, $\\mathrm{Ring}$, $\\mathrm{Algebra}$ etc. whose objects are monoids, rings, algebras etc. (respectively) and whose hom-sets consist of the homomorphisms between them. The identity arrows are the identity functions and the composition operations are function composition; these always turn out to produce homomorphisms."
                        ]
                    , .ps "A particular kind of algebraic structure you may not be familiar with is a <em>based set</em>. Each based set is a pair $(X, x)$ of a set $X$ and an element $x \\in X$, called its <em>basepoint</em>. A <em>based set homomorphism</em> from $(X, x)$ to $(Y, y)$ is a function $f : X \\to Y$ which preserves the endpoint: $x \\xmapsto{f} y$. These form a category $\\mathrm{Set}_{*}$ where the objects are based sets and the arrows between them are based set homomorphisms; as before, the identities and composition operations are given by identity functions and function composition."
                    , .ps "It is also worth noting that $\\mathrm{Set}$ can be described as a category of algebraic structures. Sets are algebraic structures with no operations. With no operations, the homomorphisms between sets don't need to preserve any structure at all; thus, they are simply the functions."
                    ]
                }
            , .block
                { kind :=
                    .exa
                , title :=
                    "Topological spaces"
                , body :=
                    [ .p
                        [ .s "Another important category is $\\mathrm{Top}$, whose objects are topological spaces and whose arrows are the continuous functions between them. $\\mathrm{Top}$ behaves quite differently to the categories of algebraic structures. For example, the"
                        , .a "./isomorphisms.html" "isomorphisms"
                        , .s "in algebraic categories are exactly the bijective homomorphisms, but there are bijective continuous functions in $\\mathrm{Top}$ which fail to be isomorphisms (homeomorphisms)."
                        ]
                    , .ps "If you are familiar with topology, is a good exercise to check that $\\mathrm{Top}$ is indeed a category."
                    , .ps "There are many other categories with geometric flavours. Topological/differentiable/smooth manifolds give rise to such categories."
                    ]
                }
            , .block
                { kind :=
                    .exa
                , title :=
                    "$\\mathbf{Vect}_K^{\\text{fd}}$ and $\\mathbf{Mat}_K$"
                , body :=
                    [ .ps "Another category of algebraic structures worth explicitly mentioning is the category $\\mathbf{Vect}_K^{\\text{fd}}$ whose objects are finite-dimensional vector spaces over the field $K$, and whose arrows are the linear transformations between them. If you have studied linear algebra, you will know that these linear transformations may be encoded using matrices. Accordingly, there is a category $\\mathbf{Mat}_K$ defined as follows. The collection $\\mathrm{ob}\\ \\mathbf{Mat}_K := \\mathbb{Z}_{\\geq 0}$ is the set of natural numbers, and each hom-set $\\mathbf{Mat}_K (n, k)$ is the set of $k \\times n$ matrices with elements in $K$. You could think of the objects $n, k$ as representing the standard vector spaces $K^n$ and $K^k$, and the matrices $M \\in \\mathbf{Mat}_K (n, k)$ as encoding linear transformations $K^n \\to K^k$. Can you guess what the identity and composite arrows are?"
                    , .p
                        [ .s "On the surface, these two categories seem very different. $\\mathbf{Vect}_K^{\\text{fd}}$ has as many objects as there are sets"
                        , .sn
                            [ .s "See the section on"
                            , .a "#Size-issues" "size issues"
                            ]
                        , .s "whereas $\\mathbf{Mat}_K$ only has countably many objects, and the arrows in $\\mathbf{Mat}_K$ aren't even functions. However, as any linear algebra student is acutely aware, <em>studying linear transformations is the same as studying matrices</em>. This idea appears in category theory as an"
                        , .a "./equivalences.html" "equivalence of categories"
                        , .s "between the categories $\\mathbf{Vect}_K^{\\text{fd}}$ and $\\mathbf{Mat}_K$."
                        ]
                    ]
                }
            , .block
                { kind :=
                    .exa
                , title :=
                    "Posets and preorders"
                , body :=
                    [ .ps "Akin to $\\mathbf{Mat}_K$, not all categories use functions as their arrows. There is no better example of this than the <em>poset and preorder categories</em>."
                    , .ps "Fix a poset $(P, \\leq)$. We can construct a category $\\mathsf{P}$ as follows."
                    , .ul
                        [ .s "The collection of objects is $\\mathrm{ob}\\ \\mathsf{P} := P$."
                        , .s "For each pair of objects $x, y \\in P$, if $x \\leq y$, then the hom-set $\\mathsf{P}(x, y) := \\left\\{ \\text{``Yep, } x \\leq y \\text{ alright!''} \\right\\}$ consists of a single element; otherwise, $\\mathsf{P}(x, y) := \\varnothing$. The particular name of the element isn't important, and henceforth we will abbreviate it to $(x \\leq y)$, enclosed in parentheses."
                        , .s "For each object $x \\in P$, the identity arrow $1_x := (x \\leq x)$ represents the fact that $x \\leq x$. The identity arrows therefore encode <em>reflexivity</em>."
                        , .s "For objects $x \\xrightarrow{(x \\leq y)} y \\xrightarrow{(y \\leq z)} z \\text{ in } \\mathsf{P}$, the composite arrow $(y \\leq z) \\circ (x \\leq y) := (x \\leq z)$ represents the fact that $x \\leq y \\leq z \\implies x \\leq z$. The composition operation therefore encodes <em>transitivity</em>."
                        ]
                    , .p
                        [ .s "The associativity and unitality equations are trivial &mdash; since each hom-set consists of at most one element, any two elements of the same hom-set are equal. Because the description above makes use only of reflexivity and transitivity, it also holds for a"
                        , .a "https://en.wikipedia.org/wiki/Preorder" "preorder"
                        , .s "."
                        ]
                    , .p
                        [ .s "A few poset categories are interesting for categorical reasons. The ordinal $0$, also known as the <em>empty poset</em>, yields the <em>empty category</em> $\\mathbf{0}$. The ordinal $1$ (which contains a single element) yields the <em>terminal category</em> $\\mathbf{1}$. The ordinal $2$ defines a category $\\mathbf{2} = (\\bullet \\to \\bullet)$ which contains two objects and a single arrow between them. We can use this category and the idea of a"
                        , .a "./functors.html" "functor"
                        , .s "to inspect the arrows within a category of interest."
                        ]
                    , .p
                        [ .s "The fact that preorders form categories allows us to apply category theory to"
                        , .a "https://en.wikipedia.org/wiki/Order_theory" "order theory"
                        , .s ", and it allows us to borrow ideas from order theory when developing category theory. For example,"
                        , .a "./adjunctions.html" "adjunctions"
                        , .s "can be inspired by"
                        , .a "https://en.wikipedia.org/wiki/Galois_connection" "Galois connections"
                        , .s ", and the fact that"
                        , .a "../proof/rapl.html" "right adjoints preserve limits"
                        , .s "can be used to establish that upper/lower adjoints of Galois connections are semilattice homomorphisms."
                        ]
                    , .p
                        [ .s "Preorders also represent an extreme kind of category when discussing"
                        , .a "#Size-issues" "size issues"
                        , .s ". For example, any $\\kappa$-small category that admits all $\\kappa$-small"
                        , .a "./limits.html" "limits"
                        , .s "is a preorder"
                        , .sn [.a "../proof/kappa-small-with-kappa-small-limits-implies-preorder.html" "Proof"]
                        , .s "."
                        ]
                    ]
                }
            ]
        , .mk
            "Size issues"
            [ .body
                [ .p
                    [ .s "Many categories that arise 'in nature' have at least as many objects as there are sets. The most important category, $\\mathbf{Set}$, is such an example. Of course, there is no set of all sets, so we cannot expect $\\mathbf{Set}$ to have a <em>set</em> of objects."
                    , .s "There are a couple of solutions. Perhaps the easiest to explain is the idea of a"
                    , .a "https://en.wikipedia.org/wiki/Grothendieck_universe" "Grothendieck universe"
                    , .sn [.s "I hate these, though"]
                    , .s ", although there are other solutions offered, for instance, by"
                    , .a "https://en.wikipedia.org/wiki/Type_theory" "type theories"
                    , .s "."
                    ]
                , .p
                    [ .s "In any case, it is worth making the following definition. Fix a cardinal $\\kappa$. A set is <strong>$\\kappa$-small</strong> when its cardinality is $< \\kappa$. A category $\\mathsf{C}$ is <strong>$\\kappa$-small</strong> just when the cardinality of the union of all its hom-sets is $\\kappa$-small:"
                    , .eqn "\\left\\lvert \\bigcup_{x, y \\in \\mathrm{ob}\\ \\mathsf{C}} \\left( \\mathsf{C}(x, y) \\right) \\right\\rvert < \\kappa"
                    , .s "In practice, we fix an"
                    , .a "https://en.wikipedia.org/wiki/Inaccessible_cardinal" "inaccessible cardinal"
                    , .s "$\\kappa$, use the word <strong>small</strong> to mean <em>$\\kappa$-small</em>, and immediately forget about the cardinal $\\kappa$. We then adjust our definitions &mdash; $\\mathbf{Set}$ is redefined to be the category of <em>small</em> sets and functions between them, $\\mathbf{Group}$ is the category of <em>small</em> groups and their homomorphisms, etc. A <strong>large</strong> set is one that is not small."
                    , .s "This also allows us to make an important definition. A category $\\mathsf{C}$ is <strong>locally small</strong> just when each hom-set $\\mathsf{C}(x, y)$ is small. Whilst many categories do not have a small collection of objects, they turn out to be locally small. All of the categories listed in the"
                    , .a "#Examples" "previous section"
                    , .s "are locally small. It is somewhat fruitless to think of large categories; for a different choice of the cardinal $\\kappa$ (which we immediately forgot about), some previously large categories may be small categories. In general, results that hold for small or locally small hold for slightly larger categories or those with slightly larger hom-sets if you pass to a larger inaccessible cardinal."
                    ]
                , .ps "As a related point, it is worth emphasising that the term 'hom-set' can be somewhat misleading. The hom-sets $\\mathsf{C}$ of a category $\\mathsf{C}$ are only ever required to be <em>collections</em> &mdash; a catch-all term to evade size issues. In particular, they need not form (small) sets. It is exactly the <em>locally small categories</em> for which the name 'hom-set' is not misleading."
                ]
            ]
        ]
    , seeAlso :=
        { readNext :=
            some ("./functors.html", "Functors")
        , links :=
            [ .mk "./isomorphisms.html" "Isomorphisms"
            , .mk "./equivalences.html" "Equivalences of Categories"
            ]
        }
    }
end Categories
