{- 
    wrapHtml content = "<html><body>" <> content <> "</body></html>"
    main = putStrLn (wrapHtml "Hello World!")
-}

{- 
    Exercise 1

    Separate the functionality of wrapHtml to two functions:

    One that wraps content in html tag
    one that wraps content in a body tag
    Name the new functions html_ and body_.
 -}

{- 
    Exercise 1 - answer

    html_ body = "<html>" <> body <> "</html>"
    body_ content = "<body>" <> content <> "</body>"

    main = putStrLn (html_ (body_ "Hello World!"))
 -}

 {- 
    Exercise 2

    Change myhtml to use these two functions.
 -}

{-
    Exercise 2 - answer

    html_ body = "<html>" <> body <> "</html>"
    body_ content = "<body>" <> content <> "</body>"

    myhtml = html_ (body_ "Hello World!")

    main = putStrLn myhtml
-}

{-
    Exercise 3 

    Add another two similar functions for the tags <head> and <title> and name them head_ and title_.

    head_ content = "<head>" <> content <> "</head>"
    title_ content = "<title>" <> content <> "</title>"
-}


{- 
    Exercise 4

    Create a new function, makeHtml, which takes two strings as input:

    1. One string for the title
    2. One string for the body content

    And construct an HTML string using the functions implemented in the previous exercises.

    The output for:
    -> makeHtml "My page title" "My page content"

    should be:
    -> <html><head><title>My page title</title></head><body>My page content</body></html>
-}

{-
    Exercise 4 - answer

    html_ head = "<html>" <> head  <> "</html>"
    body_ content = "<body>" <> content <> "</body>"
    head_ content = "<head>" <> content <> "</head>"
    title_ content = "<title>" <> content <> "</title>"

    makeHtml title body = html_ (head_ (title_ title) <> body_ body)
-}

{-
    Exercise 5

    Use makeHtml in myhtml instead of using html_ and body_ directly
-}

{-
    myhtml = makeHtml "My page title" "My page content"
    main = putStrLn myhtml
-}
