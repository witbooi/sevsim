class window.Helper

  @declOfNum: (number, titles) ->
    cases = [2, 0, 1, 1, 1, 2]
    index = if ( ((number%100) > 4) && ((number%100) < 20) )
      2
    else
      cases[if ((number%10)<5) then (number%10) else 5]

    titles[index]
