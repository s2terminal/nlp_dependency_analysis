import urllib.request
import zipfile
from os.path import join, exists
import re

def load_aozora():
    # 太宰治「走れメロス」 https://www.aozora.gr.jp/cards/000035/card1567.html
    url = 'https://www.aozora.gr.jp/cards/000035/files/1567_ruby_4948.zip'
    download_filepath = '/tmp/1567_ruby_4948.zip'

    if not exists(download_filepath):
        urllib.request.urlretrieve(url, download_filepath)

    with zipfile.ZipFile(download_filepath, 'r') as myzipfile:
        myzipfile.extractall('/tmp')
        for myfile in myzipfile.infolist():
            with open(join('/tmp', myfile.filename), encoding='sjis') as file:
                text = file.read()
    # 参考: https://qiita.com/makaishi2/items/63b7986f6da93dc55edd?utm_source=pocket_mylist#step1
    text = re.split('\-{5,}',text)[2]
    text = re.split('底本：',text)[0]
    text = text.replace('|', '')
    text = re.sub('《.+?》', '', text)
    text = re.sub('［＃.+?］', '',text)
    text = re.sub('\n\n', '\n', text)
    text = re.sub('\r', '', text)
    text = "".join(text.split())

    return text.split("。")
