#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import datetime

print 'Generating GraphQLConstants'

template = '''//
//  Generated code do not edit
//
//  GraphQLConstants.swift
//  Leem
//
//  Copyright © %s Svedm. All rights reserved.
//

enum GraphQLConstants {
''' % datetime.datetime.now().year

graphql_extension = '.graphql'
for root, dirs, files in os.walk('.'):
    for file in files:
        if file.endswith(graphql_extension):
            print 'Found %s' % file
            graphql_file = open(root + '/' + file)
            file_name = file.split('.')[0]
            template += '    static let %s = """\n%s\n"""\n' % (
                file_name[0].lower() + file_name[1:], graphql_file.read()
            )
            graphql_file.close()

template += '}'

generated_file = open('./ToDo-legacy/Generated/GraphQLConstants.swift', 'w+')
generated_file.write(template)
generated_file.close()

print 'Done'
