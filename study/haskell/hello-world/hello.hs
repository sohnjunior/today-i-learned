import Html

myhtml = html_ "Title" (append_ (h1_ "header") (append_ (p_ "paragraph 1") (p_ "paragraph 2")))
main = putStrLn (render myhtml)
