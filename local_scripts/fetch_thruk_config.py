#!/usr/bin/env python3
import pprint, sys, requests, json, optparse

URI = '/thruk/r/config/files'

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
    print(data)

if __name__ == '__main__':
        main()
