$.fn.setCursorPosition = (pos) ->
  @each (index, elem) ->
    if elem.setSelectionRange
      elem.setSelectionRange pos, pos
    else if elem.createTextRange
      range = elem.createTextRange()
      range.collapse true
      range.moveEnd "character", pos
      range.moveStart "character", pos
      range.select()
  
  this