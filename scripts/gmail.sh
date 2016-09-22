#!/usr/bin/env sh

from urllib.request import FancyURLopener
import sys

email = 'thlst1101' # @gmail.com can be left out
password  = sys.argv[1]

url = 'https://%s:%s@mail.google.com/mail/feed/atom' % (email, password)

opener = FancyURLopener()
page = opener.open(url)

contents = page.read().decode('utf-8')

ifrom = contents.index('<fullcount>') + 11
ito   = contents.index('</fullcount>')

fullcount = contents[ifrom:ito]

print(fullcount)
