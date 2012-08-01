#!/usr/bin/env python

import sys
import json
import urllib
import subprocess
import shutil

src = sys.argv[1]
rsp = urllib.urlopen(src)
font = json.loads("".join(rsp.readlines()))

for f in font.get("fonts"):
  name = f.get("filename")
  fonturl = src.replace("METADATA.json", name)
  local, _ = urllib.urlretrieve(fonturl)
  shutil.move(local,"fonts/%s" % name)
