# coding: utf-8

import urllib.request, urllib.parse, urllib.error

url_prefix = 'http://edh-www.adw.uni-heidelberg.de/fotos/'

url_suffix = '.JPG'

import os

import time

indir = 'edhFotoXMLDump'

count = 1

for root, dirs, filenames in os.walk(indir):
    for file in filenames:
        filename,extension = file.split('.')
        url = url_prefix + filename + url_suffix
        try:
            f = urllib.request.urlopen(url)
        except:
            continue
        image = f.read()
        with open(filename + url_suffix, "wb") as code:
            code.write(image)
            if (count < 200):
                count = count + 1
            else:
                count = 1
                time.sleep(30)