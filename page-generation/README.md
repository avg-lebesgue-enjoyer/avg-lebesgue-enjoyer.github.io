# What is this?
A small `Lean4` project for representing pages in Empty Limit (without the HTML/CSS boilerplate), and writing their HTML automatically (with all the boilerplate thrown in automatically).

# How do I use it?
- Execute from **WITHIN THE `/page-generation/` DIRECTORY**.
- To build new pages, add to `/page-genreation/Pages/`. See `/page-generation/Pages/Basic.lean` for more details.
- To change how pages are rendered to HTML, modify `/page-generation/Inset/BuildPages.lean`.

# Why the name?
The empty limit in Set is the singleton, which is a generator for Set. Hence, "Empty Limit in Set"; "inset".
