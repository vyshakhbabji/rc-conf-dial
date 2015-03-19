# rc-conf-dial

This is a collection of `AppleScript`, er, scripts to make it a bit easier to join RingCentral conference calls and meetings (screen shares).

The first one is `autodial.scpt`, which dials into a conference line, and takes two parameters:

* a phone number
* a conference code

I keep this file in my path, along with simple shell scripts like e.g. `dave-voice`:

```sh
#!/bin/sh
autodial.scpt 1234567890 123456789
```

and the second is `joinmeeting.scpt`, which joins a screen sharing meeting, and takes one parameter:

* the meeting id

`dave-screen`:

```sh
#!/bin/sh
joinmeeting.scpt 123456789
```



