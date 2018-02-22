#!/usr/bin/env python3

###-------------------------------------------------------------------
### This file is part of the CernVM File System.
###-------------------------------------------------------------------

from optparse import OptionParser
import requests

def do_trigger(token, branches, verbose):

    data = {'token' : token,
            'branches' : branches}
    headers = {'Content-type' : 'application/json'}

    url = 'https://readthedocs.org/api/v2/webhook/cvmfs/27468/'

    reply = requests.post(url, json = data, headers = headers)

    if verbose:
        print('Reply: status: {}, json: {}'.format(reply.status_code, reply.json()))
    else:
        print(reply.json())

def main():
    usage = "{}\n\n{}".format("Usage: %prog [options] TOKEN [BRANCHES]",
                            "Ex: %prog <API_TOKEN> stable master")

    parser = OptionParser(usage)
    parser.add_option("-v", "--verbose", dest="verbose", action="store_true",
                      help="verbose output")

    (options, args) = parser.parse_args()
    if len(args) < 1 :
        parser.error("incorrect number of arguments")

    token = args[0]
    branches = ["latest"]
    if len(args) > 1 :
        branches = args[1:]

    if options.verbose:
        print("Token: {}".format(token))
        print("Branches: {}".format(branches))
        print()

    do_trigger(token, branches, options.verbose)

if __name__ == '__main__':
    main()

