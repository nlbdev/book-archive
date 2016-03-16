#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import os
import shutil
from pprint import pprint
from subprocess import call, check_call, check_output
import xml.etree.ElementTree as ET
from mutagen.mp3 import MP3
from slacker import Slacker
import yaml
import gettext

global config
global translation
global _


def main(argv):
    config = load_config("/tmp/config/config.yml")
    if config:
        translation = gettext.translation('messages', os.path.join(os.path.dirname(__file__), "i18n"), [config["language"]])
    else:
        translation = gettext.translation('messages', os.path.join(os.path.dirname(__file__), "i18n"), ["en"])
    translation.install()
    
    fullpaths = list_files("/tmp/input")
    print(str(len(fullpaths))+translation.ngettext(" file in fileset", " files in fileset", len(fullpaths)))
    
    spine = fileset_to_spine(fullpaths)
    print(str(len(spine))+translation.ngettext(" audio file in spine", " audio files in spine", len(spine)))
    
    source_audio = pick_abstract(spine)
    print(source_audio+_(" will be used as input"))
    
    book_id = os.path.relpath(source_audio, "/tmp/input").rsplit("/")[0]
    assert book_id != None and len(book_id) > 0, "Unable to determine book ID based on path"
    
    shutil.copy(source_audio, "/tmp/source_audio.mp3")
    sys.stdout.flush()
    check_call(["mp3splt", "/tmp/source_audio.mp3", "-o", "output/"+book_id, "0.00.00", "1.15.00"], timeout=300)
    os.chmod("/tmp/output/"+book_id+".mp3", 0o666)
    
    # Send message to Slack if there's a slack token available
    if os.path.exists("/tmp/config/slack.token"):
        with open("/tmp/config/slack.token", 'r') as f:
            slack_token = f.readline().rstrip()
        book_title = None
        for path in fullpaths:
            if os.path.basename(path) == "ncc.html":
                try:
                    with open(path, 'r') as f:
                        lines = f.readlines()
                    for line in lines:
                        if "<title" in line:
                            book_title = line
                            book_title = line.split("<title",1)[1].split(">",1)[1].split("<",1)[0]
                            break
                except UnicodeDecodeError as e:
                    print(e)
        slack = Slacker(slack_token)
        if book_title == None or len(book_title) == 0:
            book_title = ""
        else:
            book_title = " ("+book_title+")"
        botname = config.get("abstracts-botname", "abstracts-bot")
        channel = config.get("abstracts-channel", "#general")
        slack.chat.post_message(
                                channel,
                                _('Audio abstract is ready for')+' '+book_id+book_title,
                                botname
                                )
    else:
        print("(no slack token in /tmp/config/slack.token; won't post to slack)")


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
            print(_("strategy for picking abstract")+": "+_("first of the longest files that are in the middle of the book"))
            source_audio = mp3_filepath
            break
    if source_audio == None and len(spine_longest_files) > 0:
        print(_("strategy for picking abstract")+": "+_("first of the longest files in the book"))
        source_audio = spine_longest_files[0]
    if source_audio == None:
        print(_("strategy for picking abstract")+": "+_("the longest file in the book"))
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
    sys.stdout.flush()
    spine = []
    try:
        check_call(["saxon", "-s:/tmp/fileset.xml", "-xsl:/tmp/script/fileset-to-spine.xsl", "-o:/tmp/spine.xml"], timeout=300)
        spine_document = ET.parse('/tmp/spine.xml').getroot()
        for item in spine_document.findall('{http://www.daisy.org/ns/pipeline/data}file'):
            if len(item.get("href")) > 0:
                spine.append(item.get("href"))
    except:
        print(_("XSLT failed; fall back to alphabetical listing of MP3s"))
        for fullpath in fullpaths:
            if fullpath.endswith(".mp3"):
                spine.append(fullpath)
        spine.sort
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


def load_config(config_file):
    if os.path.exists(config_file):
        try:
            with open(config_file, 'r') as config_file:
                config = yaml.load(config_file)
        except:
            config = None
    return config


if __name__ == "__main__":
    main(sys.argv[1:])
