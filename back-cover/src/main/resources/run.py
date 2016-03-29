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
import re
from pathlib import Path

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
    
    book_id = os.path.relpath(fullpaths[0], "/tmp/input").rsplit("/")[0]
    assert book_id != None and len(book_id) > 0, "Unable to determine book ID based on path"
    
    source_audio = pick_back_cover(fullpaths)
    
    if source_audio != None:
        print(source_audio+_(" will be used as input"))
        
        shutil.copy(source_audio, "/tmp/output/"+book_id+".mp3")
        sys.stdout.flush()
        os.chmod("/tmp/output/"+book_id+".mp3", 0o666)
    else:
        print(_("Unable to find a back cover for")+" "+book_id)
        
        Path("/tmp/output/"+book_id+".missing").touch()
        sys.stdout.flush()
        os.chmod("/tmp/output/"+book_id+".missing", 0o666)
    
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
        botname = config.get("back-cover-botname", "back-cover-bot")
        channel = config.get("back-cover-channel", "#general")
        if not 'NOTIFY_SLACK_WHEN_NOT_AVAILABLE' in os.environ or str(os.environ['NOTIFY_SLACK_WHEN_NOT_AVAILABLE']).lower() != "false":
            slack.chat.post_message(
                                    channel,
                                    (_('Audio back cover is ready for') if source_audio != None else _('Audio back cover is not available for'))+' '+book_id+book_title,
                                    botname
                                    )
    else:
        print("(no slack token in /tmp/config/slack.token; won't post to slack)")


def pick_back_cover(fullpaths):
    ET.register_namespace("d", "http://www.daisy.org/ns/pipeline/data")
    fileset = ET.Element('{http://www.daisy.org/ns/pipeline/data}fileset')
    for fullpath in fullpaths:
        item = ET.SubElement(fileset, '{http://www.daisy.org/ns/pipeline/data}file', href=fullpath)
    fileset_document = ET.ElementTree(fileset)
    fileset_document.write("/tmp/fileset.xml")
    sys.stdout.flush()
    source_audio = None
    try:
        check_call(["saxon", "-s:/tmp/fileset.xml", "-xsl:/tmp/script/fileset-pick-back-cover.xsl", "-o:/tmp/back-cover.xml"], timeout=300)
        spine_document = ET.parse('/tmp/back-cover.xml').getroot()
        for item in spine_document.findall('{http://www.daisy.org/ns/pipeline/data}file'):
            source_audio = re.sub("^file:/+", "/", item.get("href"))
            break
    except:
        print(_("XSLT failed"))
        sys.exit(1)
    
    return source_audio


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
