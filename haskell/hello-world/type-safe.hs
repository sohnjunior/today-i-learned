{-
  For now, let's create a couple of types for our use case. We want two separate types to represent:

  A complete Html document
  A type for html structures such as headings and paragraphs that can go inside the tag
  We want them to be distinct because we don't want to mix them together.
-}

{-
  newtype Html = Html String
  newtype Structure = Structure String
-}

{-
  Appending Structure

  append_ should take two Structures, and return a third Structure, appending the inner String 
  in the first Structure to the second and wrapping the result back in Structure.

  implement append_
-}

{-
  newtype Structure = Structure String
  append_ (Structure a) (Structure b) = Structure (a <> b)
-}

{-
  Converting back Html to String

  we need a function that takes an Html and converts it to a String, which we can then pass to putStrLn.
  Implement the render function.
-}

{-
  newtype Html = Html String

  render :: Html -> String
  render html = 
      case html of
        Html str -> str
-}

{-
  The rest of the owl
-}

newtype Html = Html String
newtype Structure = Structure String

getStructureString :: Structure -> String
getStructureString content = 
  case content of
    Structure str -> str

append_ :: Structure -> Structure -> Structure
append_ s1 s2 = Structure(getStructureString s1 <> getStructureString s2)


type Title = String

el :: String -> String -> String
el tag content = "<" <> tag <> ">" <> content <> "</" <> tag <> ">"

p_ :: String -> Structure
p_ = Structure . el "p"

h1_ :: String -> Structure
h1_ = Structure . el "h1"

html_ :: String -> Structure -> Html
html_ title content = 
  Html (el "html" (el "head" ( el "title" title ) <> el "body" (getStructureString content) ))

render :: Html -> String
render html = 
  case html of
    Html str -> str
  
myhtml = html_ "Title" (append_ (h1_ "header") (append_ (p_ "paragraph 1") (p_ "paragraph 2")))
main = putStrLn (render myhtml)
