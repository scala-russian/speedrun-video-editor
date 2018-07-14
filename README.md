# Speedrun Video Editor
## Description
Tiny util to postprocess speedrun videos. 
## Requirements
Requires ffmpeg and ffprobe (from the same package)
## Building
`stack build`
## Functionality
Takes a file with list of commands and process video correspondingly. See `speedrun-video-editor --help`.
* `delete 1:12:00.2 - 1:22:02:4` Time interval to cut off.
* `label 1:00:02.1 "video mark"` Update label time due to cutting and return a list of labels after video processing. [Not implemented]
* `blur 2:23:45 - 2:30:41` Blur image in specified time range. [Not implemented]

### !Important
It's a minimalistic application and suppose a correct list of commands. Right now there are no
* Check of time interval order. For example `02:40 - 01:59` is not reversed or error is printed.
* ...