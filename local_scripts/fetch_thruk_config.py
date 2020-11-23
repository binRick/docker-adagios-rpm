#!/usr/bin/env python3
import pprint, sys, requests, json, optparse
import os, sys, json, subprocess, tarfile, io, gzip
from io import StringIO
from io import BytesIO

tar_file = 'test.tar'
targz_file = 'test.tar.gz'
json_file = './.configs.json'

URI = '/thruk/r/config/files'

def save_configs(config_objects):
    dat = config_objects

    configs = {}
    for c in config_objects:
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

def grabJson(options):
    nagios_host = 'http://{}:{}'.format(options.host, options.port)
    url = '{}{}'.format(
      nagios_host,
      URI,
    )
    params = (
            ('columns', 'path,content'),
    )
    headers = {
        'user-agent': 'curl',
        'X-Thruk-Auth-Key': options.auth_key,
        'X-Thruk-Auth-User': options.auth_user,
    }
    r = requests.get(url, params=params, headers=headers)
    return r.text

def main():
    p = optparse.OptionParser(description='Command line Thruk display tool',prog='thruk_cl',version='0.1',usage='%prog -h')
    p.add_option("--host", dest="host", type="string", help="Thruk hostname")
    p.add_option("--port", dest="port", type="int", help="Thruk port")
    p.add_option("--auth-user", dest="auth_user", type="string", help="Thruk User")
    p.add_option("--auth-key", dest="auth_key", type="string", help="Thruk Key")
    options, arguments = p.parse_args()
    json_file=grabJson(options)
    data = json.dumps(json.loads(json_file))
    save_configs(json.loads(data))

if __name__ == '__main__':
        main()
