grabhdrraw
==========

Utility tool to retrieve only raw pictures taken in bracketing mode for HDR from a given directory.

Simply works by finding series of photos with EV values `[0.0, -0.66, 0.66, -1.33, 1.33]`.

Example usage:

```bash
./grabhdrraw.rb --input /Volumes/SD_CARD_42/DCIM/ --output ~/hdr-raw-source/
```

# Dependencies

This tool requires `exiftool` in order to retrieve the `Exposure Compensation` exif information.

exiftool official website: http://www.sno.phy.queensu.ca/~phil/exiftool/
