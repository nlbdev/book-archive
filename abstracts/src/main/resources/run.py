#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
#from urllib.parse import urlparse
#import argparse
import os
import shutil
#import re
#import json
#import tempfile
#import time
#import traceback
#from dateutil import parser
#from datetime import datetime, timedelta
from pprint import pprint
from subprocess import call, check_call, check_output
#import socket
import xml.etree.ElementTree as ET
from mutagen.mp3 import MP3


def main(argv):
    fullpaths = list_files("/tmp/input")
    print(str(len(fullpaths))+" files in fileset")
    
    spine = fileset_to_spine(fullpaths)
    print(str(len(spine))+" audio files in spine")
    
    source_audio = pick_abstract(spine)
    print(source_audio+" will be used as input")
    
    book_id = os.path.relpath(source_audio, "/tmp/input").rsplit("/")[0]
    assert book_id != None and len(book_id) > 0, "Unable to determine book ID based on path"
    
    shutil.copy(source_audio, "/tmp/source_audio.mp3")
    check_call(["mp3splt", "/tmp/source_audio.mp3", "-o", "output/"+book_id, "0.00.00", "1.15.00"], timeout=300)

def pick_abstract(spine):
    # list which files are longest and which files are in the middle of the book
    spine_longest_files = []
    spine_middle_files = []
    total_time = 0.0
    for mp3_filepath in spine:
        info = MP3(mp3_filepath).info
        total_time += info.length
        if info.length > 120:
            spine_longest_files.append(mp3_filepath)
    start_time = 0
    for mp3_filepath in spine:
        info = MP3(mp3_filepath).info
        if start_time >= total_time / 5 and start_time <= total_time - total_time / 5:
            spine_middle_files.append(mp3_filepath)
        start_time += info.length
    
    # pick a file for producing the abstract
    source_audio = None
    for mp3_filepath in spine:
        if mp3_filepath in spine_longest_files and mp3_filepath in spine_middle_files:
            print("strategy for picking abstract: first of the longest files that are in the middle of the book")
            source_audio = mp3_filepath
            break
    if source_audio == None and len(spine_longest_files) > 0:
        print("strategy for picking abstract: first of the longest files in the book")
        source_audio = spine_longest_files[0]
    if source_audio == None:
        print("strategy for picking abstract: the longest file in the book")
        longest = -1.0
        for mp3_filepath in spine:
            info = MP3(mp3_filepath).info
            if info.length > longest:
                source_audio = mp3_filepath
                longest = info.length
    assert source_audio != None, "Unable to pick an audio file for producing the abstract."
    
    return source_audio
    

def fileset_to_spine(fullpaths):
    ET.register_namespace("d", "http://www.daisy.org/ns/pipeline/data")
    fileset = ET.Element('{http://www.daisy.org/ns/pipeline/data}fileset')
    for fullpath in fullpaths:
        item = ET.SubElement(fileset, '{http://www.daisy.org/ns/pipeline/data}file', href=fullpath)
    fileset_document = ET.ElementTree(fileset)
    fileset_document.write("/tmp/fileset.xml")
    check_call(["saxon", "-s:/tmp/fileset.xml", "-xsl:/tmp/script/fileset-to-spine.xsl", "-o:/tmp/spine.xml"], timeout=300)
    shutil.copy("/tmp/fileset.xml", "/tmp/output/")
    shutil.copy("/tmp/spine.xml", "/tmp/output/")
    spine_document = ET.parse('/tmp/spine.xml').getroot()
    spine = []
    for item in spine_document.findall('{http://www.daisy.org/ns/pipeline/data}file'):
        spine.append(item.get("href"))
    pprint(spine)
    return spine


def list_files(directory):
    files = []
    for item in os.listdir(directory):
        item_fullpath = os.path.join(directory, item)
        if os.path.isfile(item_fullpath):
            files.append(item_fullpath)
        elif os.path.isdir(item_fullpath):
            files.extend(list_files(item_fullpath))
    return files


if __name__ == "__main__":
    main(sys.argv[1:])
