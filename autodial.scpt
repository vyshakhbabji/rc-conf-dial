#!/usr/bin/osascript
-- This script is required because RingCentral doesn't support dialing
-- numbers containing commas or pound signs, which are necessary in
-- order to quickly dial into conference calls. AKA every modem, ever,
-- can do this, but a fancy cloud service can't?!
--
-- This script requires `cliclick` which is available through Homebrew:
-- $ brew install cliclick
--
-- This script also requires that the RingCentral app window be as small
-- as possible, otherwise the clicks aimed at the "dial" and "keypad"
-- buttons will probably miss. To change the size, drag the bottom right
-- corner up towards the top left corner, as far as it will go.
--
-- Patches accepted.
--

-- how to specify arguments to an applescript ... script:
-- http://stackoverflow.com/a/16977401/857156
on run { dialme, confcode }
-- validate dialme (10 digits)
if not isNumericString(dialme, 10) and not isNumericString(dialme, 13) then
  return "ERROR: first argument must be a 10- or 13-digit phone number!"
end if
-- validate confcode (9 digits)
if not isNumericString(confcode, 9) then
  return "ERROR: second argument must be a 9-digit conference code!"
end if

tell application "RingCentral for Mac.app"
  activate
  delay 0.2
  -- activate dial pad
  tell application "System Events" to tell process "RingCentral for Mac"
    -- open keypad
    keystroke "d" using command down
    -- dial conf line
    keystroke dialme

    -- get position and size of application window
    tell window 1
      set p to position
      set px to (item 1 of p)
      set py to (item 2 of p)

      set s to size
      set sx to (item 1 of s)
      set sy to (item 2 of s)
    end tell

    -- click green "dial" button
    set cmd to "cliclick c:=" & (px + (sx * 0.5)) & ",=" & (py + (sy * 0.85))
    --set output to output & " " & cmd
    do shell script cmd

    -- click keypad
    delay 1
    set cmd to "cliclick c:=" & (px + (sx * 0.7)) & ",=" & (py + (sy * 0.7))
    --set output to output & " " & cmd
    do shell script cmd

    -- wait for conference robot to pick up
    delay 5

    -- then dial the conference code
    -- TODO: get conference code from somewhere more exciting than command line
    -- `delay 0.2` is too short, the receiving end mixes up digit order
    repeat with i from 1 to (length of confcode)
      keystroke (character i of confcode)
      delay 0.3
    end repeat
    keystroke "#"

  end tell
end tell

end run

-- validation functions:
on isNumericString(str, len)
  set {n, isOk} to {length of str, true}
  if n is not equal to len then return false
  try
    repeat with i from 1 to n
      set isOk to ((character i of str) is in "0123456789+")
      if isOk = false then return false
    end repeat
    return true
  on error
    return false
  end try
end isNumericString

