#!/usr/bin/osascript
-- This script exists because RingCentral's "launch from browser"
-- doesn't currently work with Google Chrome (2015-03-19).
--
-- Patches accepted.
--

-- how to specify arguments to an applescript ... script:
-- http://stackoverflow.com/a/16977401/857156
on run { meetcode }
-- validate meetcode (10 digits)
if not isNumericString(meetcode, 10) then
  return "ERROR: second argument must be a 10-digit meeting code!"
end if

tell application "RingCentral Meetings.app"
  activate
  tell application "System Events" to tell process "RingCentral Meetings"
    -- use "Window" menu to make sure "RingCentral Meetings" is focused
    -- since it gets auto-minimized sometimes
    tell menu 1 of menu bar item "Window" of menu bar 1
      click
      -- GRR: why doesn't this work?!
      --set xxx to menu item whose name contains "RingCentral Meetings"
      -- sigh, get the menu item indirectly
      set separator to last menu item where title is ""
      click menu item after separator
    end tell
    tell menu bar item "RingCentral Meetings" of menu bar 1
      click
      click menu item "Join Meeting..." of menu 1
    end tell

    keystroke meetcode
    --key code 48 -- tab
    --keystroke "a" using {command down}
    --keystroke "Your Full Name"
    key code 36 -- enter

  end tell
end tell
return -- default to empty return value

end run

-- validation functions:
on isNumericString(str, len)
  set {n, isOk} to {length of str, true}
  if n is not equal to len then return false
  try
    repeat with i from 1 to n
      set isOk to ((character i of str) is in "0123456789")
      if isOk = false then return false
    end repeat
    return true
  on error
    return false
  end try
end isNumericString

