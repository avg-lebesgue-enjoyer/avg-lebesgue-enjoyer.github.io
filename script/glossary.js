document.addEventListener('DOMContentLoaded', () => {
  /* SECTION: Page list */
  // TODO: Try and move this into an `import` statement. Firefox is blocking them on my machine.

  /** This is a `const` to guarantee no typos in the definition of `pages`. */
  const topicCategoriesFunctorsNaturalTransformations = "Categories, Functors and Natural Transformations";
  /** This is a `const` to guarantee no typos in the definition of `pages`. */
  const topicUniversalConstructions = "Universal Constructions";

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
      topicCategoriesFunctorsNaturalTransformations,
      topicUniversalConstructions,
    ],
    pages: [
      { title:  "Categories",
        topic:  topicCategoriesFunctorsNaturalTransformations,
        href:   "discussion/categories.html",
        tags:   [ "category",
                  "categories", ],
      },
      { title:  "Functors",
        topic:  topicCategoriesFunctorsNaturalTransformations,
        href:   "discussion/functors.html",
        tags:   [ "functors", ],
      },
      { title:  "Natural Transformations",
        topic:  topicCategoriesFunctorsNaturalTransformations,
        href:   "discussion/natural-transformations.html",
        tags:   [ "natural transformation", ], // also matches "natural"
      },
      { title:  "Duality",
        topic:  topicCategoriesFunctorsNaturalTransformations,
        href:   "discussion/duality.html",
        tags:   [ "duality", ],
      },
      { title:  "Initial and Terminal Objects",
        topic:  topicUniversalConstructions,
        href:   "discussion/initial-terminal-objects.html",
        tags:   [ "initial and terminal objects" ],  // also matches "initial", "terminal" and "object"
      },
      { title:  "Limits",
        topic:  topicUniversalConstructions,
        href:   "discussion/limits.html",
        tags:   [ "limits" ],
      },
      { title:  "Adjunctions",
        topic:  topicUniversalConstructions,
        href:   "discussion/adjunctions.html",
        tags:   [ "adjunctions",
                  "adjoints", ],
      },
      { title:  "Absolute Limits",
        topic:  topicUniversalConstructions,
        href:   "discussion/absolute-limits.html",
        tags:   [ "absolute limits", ], // Also matches "absolute" and "limit"
      },
      { title:  "Right Adjoints Preserve Limits",
        topic:  topicUniversalConstructions,
        href:   "proof/right-adjoints-preserve-limits.html",
        tags:   [ "adjunctions",
                  "right adjoints preserve limits", ], // Also matches "adjoints" and "limits"
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
    if (transformations.length === 0) {
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
    if (list.length === 0) {
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



  /* SECTION: Split the `pages` into groups to be rendered */

  /**
   * Compare strings lexicographically. To be used with `Array.prototype.sort`.
   * @param {string} a
   *  First string to be compared
   * @param {string} b 
   *  Second string to be compared
   * @returns {number}
   *  A negative value if `a` is lexicographically before `b`; zero if `a === b`; a positive value otherwise
   */
  function compare(a, b) {
    return (
      a < b
      ? -1
      : a === b
      ? 0 
      : 1
    );
  }

  /**
   * Sort a given array of `pages` by their `title`s.
   * Modifies `pages`.
   * @param {{ title: string }[]} pages 
   *  The pages to sort
   * @returns {{ title: string }[]}
   *  The pages, sorted alphabetically by `title`
   */
  function sortAlphabetically(pages) {
    pages.sort((a, b) => (compare(a.title, b.title)));
    return pages;
  }

  /**
   * Given an array of `pages`, group them by the first letter of their `title`s.
   * Fail if any page has an empty `title`.
   * @param {{ title: string }[]} pages
   *  Pages to group alphabetically
   * @returns {{ groupName: string, pages: { title: string }[]}[] | null}
   *  Array containing page groups
   */
  function groupAlphabetically(pages) {
    return pages.reduce((groupsSoFar, page) => {
      // Bail if something has gone wrong
      if (groupsSoFar === null || !page.title || page.title.length === 0) {
        return null;
      }
      // Find the group whose name is the first character of the `title` of the current `page`
      const firstTitleCharacter = page.title.charAt(0);
      const groupIndex = groupsSoFar.findIndex((group) => (group.groupName === firstTitleCharacter));
      // Add the `page` to that group, creating a new group if necessary
      if (groupIndex === -1) {
        groupsSoFar.push({ groupName: firstTitleCharacter, pages: [page] });
      } else {
        groupsSoFar[groupIndex].pages.push(page);
      }
      return groupsSoFar;
    }, []);
  }

  /**
   * Given an array of `pages`, group them by their `topic`s.
   * @param {{ topic: string }[]} pages
   *  Pages to group alphabetically
   * @returns {{ groupName: string, pages: { topic: string }[]}[] | null}
   *  Array containing page groups
   */
  function groupByTopic(pages) {
    return pages.reduce((groupsSoFar, page) => {
      // Bail if something has gone wrong
      if (groupsSoFar === null || !page.topic) {
        return null;
      }
      // Find the group whose name is the `topic` of the current `page`
      const groupIndex = groupsSoFar.findIndex((group) => (group.groupName === page.topic));
      // Add the `page` to that group, creating a new group if necessary
      if (groupIndex === -1) {
        groupsSoFar.push({ groupName: page.topic, pages: [page] });
      } else {
        groupsSoFar[groupIndex].pages.push(page);
      }
      return groupsSoFar;
    }, []);
  }



  /* SECTION: Produce page list */
  // NOTE: Code for this kind of task is far more readable with JSX. Perhaps a direction for
  //       future development, if this website actually gets used by someone other than me :)

  /**
   * Given a list of `pagesToRender`, render the pages.
   * @param {{ groupName: string, pages: { title: string, href: string }[] }[]} pagesToRender
   *  Array of groups of pages. Each group is specified by a `groupName`, which is used to render the title
   *  appearing above the group. The `pages` within each group are specified by a `title` to be rendered and
   *  a `href` to redirect to.
   */
  function overridePageList(pagesToRender) {
    const pageList = document.getElementById("page-list");
    pageList.textContent = ""; // Clear current page list; trick from SOURCE: https://stackoverflow.com/a/3955238
    // Create HTML for each group of pages
    pagesToRender.forEach((group) => {
      // Create `<div>` holding the content
      const div = document.createElement("DIV");
      pageList.appendChild(div);
      div.classList.add("glossary-group");
      // Create `<h2>` holding the `groupName`
      const h2 = document.createElement("H2");
      div.appendChild(h2);
      h2.appendChild(document.createTextNode(group.groupName));
      // Create the `<ul>` holding the `pages`
      const ul = document.createElement("UL");
      div.appendChild(ul);
      // Create the `pages`
      group.pages.forEach((page) => {
        const li = document.createElement("LI");
        ul.appendChild(li);
        const a = document.createElement("A");
        li.appendChild(a);
        a.setAttribute("href", page.href);
        a.innerHTML = page.title;
      });
    });
  }



  /* SECTION: Event handlers */

  /** String designating alphabetical sorting of the glossary. */
  const sortAlphabetical = "sort-alphabetical";

  /**
   * Get "Sort by:" radio buttons.
   * This is a thunk so that their current state of them may be retrieved at multiple different times.
   * @returns {HTMLElement[]}
   *  An array holding all of the "Sory by:" `<input type="radio">`s
   */
  const getSortByRadioInputs = () => (
    Array.from(
      document
      .getElementById("sort-by-container")
      .children
    ).filter((element) => (element.tagName === "DIV"))
    .flatMap((element) => (Array.from(element.children)))
    .filter((element) => (element.tagName === "INPUT" && element.type === "radio"))
  );

  /**
   * MUTABLE STATE capturing the state of the items shown on the glossary, shared amongst `updateGlossary`,
   * `handleSortBy` and `handleSearchBar`.
   * Type: `{ sortBy: string,
   *          filteredPages: { title: string,   // Page title
   *                           topic: string,   // Page topic
   *                           href:  string,   // Page URL
   *                           tags:  string[]  // Array of tags for the page (used by `handleSearchBar`)
   *                         }[]
   *        }`
   */
  let glossaryState = {
    sortBy: sortAlphabetical,
    filteredPages: pages.pages
  };

  /**
   * Update the glossary page to match the current `glossaryState`.
   */
  const updateGlossary = () => {
    try {
      const groups =
        glossaryState.sortBy === sortAlphabetical
        ? groupAlphabetically(glossaryState.filteredPages)
        : groupByTopic(glossaryState.filteredPages)
      ;
      if (groups === null) {
        throw new Error("Groups were unable to be formed!");
      }
      overridePageList(
        groups
        .sort((a, b) => (compare(a.groupName, b.groupName)))
        .map((group) => ({ groupName: group.groupName, pages: sortAlphabetically(group.pages) }))
      );
    } catch (exception) {
      showErrorMessage();
    }
  };

  /**
   * Handle change on "Sort by:" field, producing a list of pages for the user.
   * @param {string} sortMethod
   *  Method to switch to sorting to
   */
  const handleSortBy = (sortMethod) => {
    glossaryState.sortBy = sortMethod;
    updateGlossary();
  };

  /** Handle change in the search bar, producing a list of pages for the user. */
  const handleSearchBar = () => {
    const searchValue = document.getElementById("search-bar").value;
    glossaryState.filteredPages = fuzzilySearchForPage(searchValue); // NOTE: This isn't dangerous ONLY BECAUSE we're not passing this to an external API. If that chagnes in the future, THIS MUST BE REVIEWED TOO.
    updateGlossary();
  }

  /**
   * Handle keypresses by the user, by jumping to the search bar if an alphanumeric key is pressed.
   * @param {KeyboardEvent} e
   *  The event triggering this callback 
   */
  const handleKeyDown = (e) => {
    if (e.key.match(/^[0-9a-zA-Z]$/)) {
      document.getElementById("search-bar").focus();
    }
  }




  /* SECTION: Error handling */

  /**
   * Show an error message to the user.
   */
  function showErrorMessage() {
    document.getElementById("glossary-error-message").classList.remove("hidden");
    document.getElementById("glossary-error-timestamp").innerText = `Timestamp: ${new Date().toString()}`;
    handleSortBy(sortAlphabetical);
  }



  /* LAUNCH: Actions to be taken once the DOM is loaded */

  // Add event listener for changes to the "Sort by:" field
  getSortByRadioInputs()
    .forEach((radio) => {
      radio.addEventListener("click", (e) => handleSortBy(radio.value));
    })
  ;
  // Add event listener for changes to the search bar
  document.getElementById("search-bar").addEventListener("input", (e) => handleSearchBar());
  // Add event listener for key down to jump to search bar
  document.addEventListener("keydown", handleKeyDown);

  // Clear out search bar
  document.getElementById("search-bar").value = "";
  // Produce default list of pages
  handleSortBy(sortAlphabetical);
  // Show results to the user
  document.getElementById("loading-spinner").classList.add("hidden");
  document.getElementById("sort-by-container").classList.remove("hidden");
  document.getElementById("page-list").classList.remove("hidden");
  document.getElementById("search-container").classList.remove("hidden");
});
