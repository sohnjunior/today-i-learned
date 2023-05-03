{-
    Exercise 1

    Add types for all of the functions we created until now
-}

{-
    Exercise 1 - answer

    html_ :: String -> String
    html_ head = "<html>" <> head  <> "</html>"

    body_ :: String -> String
    body_ content = "<body>" <> content <> "</body>"
    head_ :: String -> String
    head_ content = "<head>" <> content <> "</head>"
    title_ :: String -> String
    title_ content = "<title>" <> content <> "</title>"

    makeHtml :: String -> String -> String
    makeHtml title body = html_ (head_ (title_ title) <> body_ body)
-}

{-
    Exercise 2

    Change the implementation of the HTML functions we built to use el instead
-}

{-
    Exercise 2 - answer

    el :: String -> String -> String
    el tag content = "<" <> tag <> ">" <> content <> "</" <> tag <> ">"

    html_ :: String -> String
    html_ = el "html"

    body_ :: String -> String
    body_ = el "body"

    title_ :: String -> String
    title_ = el "title"

    head_ :: String -> String
    head_ = el "head"
-}

{-
    Exercise 3

    Add a couple more functions for defining paragraphs and headings:

    1. p_ which uses the tag <p> for paragraphs
    2. h1_ which uses the tag <h1> for headings
-}

{-
    Exercise 3 - answer

    p_ :: String -> String
    p_ = el "p"

    h1_ :: String -> String
    h1_ = el "h1"
-}

{-
    Exercise 4

    Replace our Hello, world! string with richer content, use h1_ and p_. We can append HTML strings created by h1_ and p_ using the append operator <>.
-}

{-
    Exercise 4 - answer

    el :: String -> String -> String
    el tag content = "<" <> tag <> ">" <> content <> "</" <> tag <> ">"

    html_ :: String -> String
    html_ = el "html"

    body_ :: String -> String
    body_ = el "body"

    title_ :: String -> String
    title_ = el "title"

    head_ :: String -> String
    head_ = el "head"

    p_ :: String -> String
    p_ = el "p"

    h1_ :: String -> String
    h1_ = el "h1"

    makeHtml :: String -> String -> String
    makeHtml title body = html_ (head_ (title_ title) <> body_ body)

    myhtml = makeHtml "Hello World!" (h1_ "Hello Haskell" <> p_ "This is Paragraph")
    main = putStrLn myhtml
-}
