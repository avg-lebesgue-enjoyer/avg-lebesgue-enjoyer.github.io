document.addEventListener('DOMContentLoaded', () => {
  /* SECTION: Page list */
  // TODO: Try and move this into an `import` statement. Firefox is blocking them on my machine.

  /**
   * An object capturing all pages on the website and their topics.
   * Type: `{ topics: string[],           // Array of topics that will get rendered on "Sort by: Topic"
   *          pages:  { title: string,    // Page title
   *                    topic: string,    // Page topic (to match the `topics` field above)
   *                    href:  string,    // Page URL
   *                    tags:  string[]   // Array of tags for the page (to help with searching)
   *                  }[]
   *        }`
   * The `tags` field is used by the search feature. It should give a minimal list of keywords for the appropriate
   * page, and no more. For example:
   *    "adjunction" and "adjoint" are both tags of "Adjunctions"
   *      This is so that a user who searches "adjoint" will also find the "Adjunctions" page
   *    "universal" is not a tag of "Adjunctions"
   *      This is so that a user who searches "universal" will not have to sift past the "Adjunctions" page to
   *      find the "Universal Constructions" page
   * Due to the fuzzy searching algorithm, substrings will be matched automatically. Hence:
   *    "functor" does not need to be a tag if "functors" is already present
   *      This is because the fuzzy searching algorithm will fuzzily match a query pattern "functor"
   *      against the tag text "functors"
   *    "category" still needs to be a tag even if "categories" is already present
   *      This is because the fuzzy searching algorithm will not fuzzily match a query pattern "category"
   *      against the tag text "categories"
   */
  const pages = {
    topics: [
      "Categories, Functors and Natural Transformations",
      "Universal Constructions",
    ],
    pages: [
      // TESTING:: I put adjunctions at the top to ensure that sorting is being tested appropriately
      // TODO: Move this back into a sensible spot
      { title:  "Adjunctions",
        topic:  "Universal Constructions",
        href:   "discussion/adjunctions.html",
        tags:   ["adjunctions",
                  "adjoints" ],
      },
      // ::TESTING
      { title:  "Categories",
        topic:  "Categories, Functors and Natural Transformations",
        href:   "discussion/categories.html",
        tags:   [ "category",
                  "categories" ],
      },
      { title:  "Functors",
        topic:  "Categories, Functors and Natural Transformations",
        href:   "discussion/functors.html",
        tags:   [ "functors" ],
      },
      { title:  "Natural Transformations",
        topic:  "Categories, Functors and Natural Transformations",
        href:   "discussion/natural-transformations.html",
        tags:   [ "natural transformation" ],
      },
      { title:  "Duality",
        topic:  "Categories, Functors and Natural Transformations",
        href:   "discussion/duality.html",
        tags:   [ "duality" ],
      },
      { title:  "Initial and Terminal Objects",
        topic:  "Universal Constructions",
        href:   "discussion/initial-terminal-objects.html",
        tags:   [ "initial objects",    // also matches "initial" and "initial object"
                  "terminal objects" ]  // also matches "terminal"
      },
      { title:  "Right Adjoints Preserve Limits",
        topic:  "Universal Constructions",
        href:   "proof/right-adjoints-preserve-limits.html",
        tags:   [ "adjunctions",
                  "right adjoints", // Also matches "adjoint"
                  "limits" ]
      },
    ]
  };



  /* SECTION: Fuzzy string matching algorithm */
  // The purpose of this section is to develop the function `fuzzySearch`, which is able to do "fuzzily" search
  // for a string in an array of strings.

  /**
   * Given an `initialValue` and a list of `transformations` to do to it, perform each transformation sequentially.
   * The `transformations` may fail by returning `null`; if this occurs, return `null`.
   * @param {((value: a) => a | null)[]} transformations
   *  Array of transformations to apply to the `initialValue`
   * @param {a} initialValue
   *  Initial value to be transformed
   * @returns {a | null}
   *  Final transformed value
   */
  function doAll(transformations, initialValue) {
    if (transformations.length == 0) {
      return initialValue;
    } else {
      const [transformation, ...nextTransformations] = transformations;
      const nextValue = transformation(initialValue);
      return nextValue === null ? null : doAll(nextTransformations, nextValue);
    }
  }

  /**
   * Given a `value` and a `list` of values of the same type, skip to the spot immediately after where the `value`
   * first appears in the `list`. If the `value` never appears in the `list`, return `null`.
   * @param {a} value
   *  Value to skip until
   * @param {a[]} list
   *  List in which to skip
   * @returns {list | null}
   *  List obtained by dropping all the elements up to and including the first occurance of the `value`, or `null`
   *  if the `value` does not occur in the `list`
   */
  function skipJustPast (value, list) {
    if (list.length == 0) {
      return null;
    } else {
      const [head, ...tail] = list;
      if (value === head) {
        return tail;
      }
      return skipJustPast(value, tail);
    }
  }

  /**
   * Given some `values` and a `list` of interest, skip through the `list` until all of the given `values` have been
   * found (in the order they were provided).
   * If this is impossible (because not all of the `values` occur within the `list` in their given order), then return
   * `null`.
   * @param {a[]} values
   *  Values to skip until
   * @param {a[]} list
   *  List in which to skip
   * @returns {a[] | none}
   *  List obtained by skipping past all of the given `values`, or `null` if this cannot be done
   */
  function skipAll (values, list) {
    return doAll(
      values.map((value) => ((list) => skipJustPast(value, list))), 
      list
    );
  }

  /**
   * Given a `haystack` and a `needle` to find, compute whether the characters appearing in the `needle` appear in the
   * `haystack` (in the same order as which they appear in `needle`).
   * This function works for `haystack : a[]` and `needle : a[]`. See `almostContains` for a more specialised variant
   * where the types are `haystack : string` and `needle : string` instead.
   * @param {a[]} haystack
   *  Text in which to search
   * @param {a[]} needle
   *  String to search for
   * @returns {boolean}
   *  `true` just when the `haystack` contains each character of the `needle` in the order that they appear in
   *  `needle`
   */
  function arrayAlmostContains(haystack, needle) {
    if (skipAll(needle, haystack) === null) {
      return false;
    }
    return true;
  }

  /**
   * Given a `haystack` and a `needle` to find, compute whether all the characters appearing in the `needle` appear
   * in the `haystack` (in the same order as which they appear in `needle`).
   * This function works for `haystack : string` and `needle : string`. See `arrayAlmostContains` for a more general
   * variant where the types are `haystack : a[]` and `needle : a[]` instead.
   * @param {string} haystack
   *  Text in which to search
   * @param {string} needle
   *  String to search for
   * @returns {boolean}
   *  `true` just when the `haystack` contains each character of the `needle` in the order that they appear in
   *  `needle`
   */
  function almostContains(haystack, needle) {
    return arrayAlmostContains([...haystack], [...needle]);
  }

  /**
   * Forget some details about the given `string` to make it more amenable to fuzzy matching.
   * Any characters which are not alphanumeric are removed from the `string`.
   * Any alphabetic characters are converted to lower case.
   * @param {string} string
   *  String to forget details of
   * @returns {string}
   *  Result after forgetting string details
   */
  function forget(string) {
    return [...string]
      .filter((character) => (character.match(/^[0-9a-zA-Z]$/)))
      .map((character) => (character.toLowerCase()))
      .join("")
    ;
  }

  /**
   * Given a `haystack` and a `needle`, compute whether most of the characters appearing in the `needle` appear
   * in the `haystack`.
   * Any non-alphanumeric characters in the `needle` are forgotten.
   * Any alphabetic characters are compared case-insensitively.
   * Characters must appear in the `haystack` in the order that they appear in the `needle`.
   * @param {string} haystack
   *  Text in which to search
   * @param {string} needle
   *  String to search for
   * @returns {boolean}
   *  `true` just when the `needle` is "fuzzily" found within the `haystack`
   */
  function fuzzilyContains(haystack, needle) {
    return almostContains(forget(haystack), forget(needle));
  }

  /**
   * Given a list (`haystack`) of strings and a `needle` to find among them, filter the `haystack` down to just
   * those strings in which most of the characters appearing in the `needle` can be found.
   * Any non-alphanumeric characters in the `needle` are forgotten.
   * Any alphabetic characters are compared case-insensitively.
   * Characters must appear in the order that they appear in the `needle`.
   * @param {string[]} haystack
   *  Array of texts in which to search
   * @param {string} needle
   *  String to search for
   * @returns {string[]}
   *  Those elements of the `haystack` in which the `needle` is "fuzzily" found
   */
  function fuzzilySearch(haystack, needle) {
    return haystack.filter((hay) => (fuzzilyContains(hay, needle)));
  }



  /* SECTION: Applying `fuzzilySearch` to search for `pages` by `tags` */

  /**
   * Fuzzily search for a page by its `tags`.
   * @param {string} userPattern
   *  String to fuzzily search for
   * @returns {{ title: string, topic: string, href: string, tags: string[] }[]}
   *  Those pages which contain a tag in which the `userPattern` is fuzzily matched
   */
  function fuzzilySearchForPage(userPattern) {
    return pages
      .pages
      .filter((page) => (
        fuzzilySearch(page.tags, userPattern).length != 0
      ))
    ;
  }



  // DEBUG::
  console.debug(pages);
  console.debug(
    fuzzilySearch(
      pages.pages.map((page) => (page.title)),
      "adj"
    )
  );
  console.debug(
    fuzzilySearchForPage("adjunction")
  );
  // ::DEBUG
});
