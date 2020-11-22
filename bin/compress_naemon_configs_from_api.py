#!/usr/bin/env python3
import os, sys, json, subprocess, tarfile, io, gzip
from io import StringIO
from io import BytesIO

tar_file = 'test.tar'
targz_file = 'test.tar.gz'
json_file = './.configs.json'

with open(json_file,'r') as f:
  dat = json.loads(f.read())

configs = {}
for c in dat:
  configs[c['path']] = c['content']

total_bytes = 0
for path in configs.keys():
  content = configs[path]
  msg = f'{path} => {len(content)} bytes'
  total_bytes += len(content)


with tarfile.TarFile(tar_file, 'w') as tar:
  for path in configs.keys():
    npath = path
    if path[0] == '/':
      npath = path[1:]
    data = configs[path].encode()
    info = tarfile.TarInfo(name=npath)
    info.size = len(data)
    tar.addfile(info, io.BytesIO(data))


f_in = open(tar_file, 'rb')
with gzip.open(targz_file, 'w')  as wz:
    wz.writelines(f_in)

os.remove(tar_file)
targz_file_size = os.path.getsize(targz_file)

stat_info = os.stat(targz_file)
size = stat_info.st_size

msg = f'wrote {len(configs)} configs of {total_bytes} to {targz_file} of {size} bytes'
print(msg)
