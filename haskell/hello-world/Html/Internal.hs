module Html.Internal where

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
p_ = Structure . el "p" . escape

h1_ :: String -> Structure
h1_ = Structure . el "h1" . escape

ul_ :: [Structure] -> Structure
ul_ = Structure . el "ul" . concat . map (el "li" . getStructureString)

ol_ :: [Structure] -> Structure
ol_ = Structure . el "ol" . concat . map (el "li" . getStructureString)

code_ :: String -> Structure
code_ = Structure . el "pre" . escape

html_ :: String -> Structure -> Html
html_ title content = 
  Html (el "html" (el "head" ( el "title" (escape title) ) <> el "body" (getStructureString content) ))

render :: Html -> String
render html = 
  case html of
    Html str -> str

escape :: [Char] -> [Char]
escape = 
  let
    escapeChar c = 
      case c of
        '<' -> "&lt;"
        '>' -> "&gt;"
        '&' -> "&amp;"
        '"' -> "&quot;"
        '\'' -> "&#39;"
        _ -> [c]
  in
    concat . map escapeChar
