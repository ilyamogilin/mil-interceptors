#!/usr/bin/python
# -*- coding: utf-8 -*-

import io
import random
import itertools
import decimal

textfile = io.open("data.sql", "w", encoding='utf-8')

#surnames = [u'Романов', u'Иванов', u'Травин', u'Филимонов', u'Замятин', u'Сидоров', u'Субботин', u'Александров', u'Решетов', u'Макаров', u'Волков', u'Казанский']
#statuses = ['1', '1', '1', '1', '1', '2', '1', '3', '1', '1']
#lists = [names, surnames]
#cartesian = list(itertools.product(*lists))

#weapons = range(1, 5)
#targets = range(1, 54)
#lists = [weapons, targets]
#cartesian = list(itertools.product(*lists))

#while(len(cartesian) > 0):
#    entry = cartesian[random.randint(0, len(cartesian) - 1)]
#    textfile.write(u'INSERT INTO \"Applicable_weapons\" (weapon_id, target_id) VALUES (' + str(entry[0]) + ', ' + str(entry[1]) + ');\n')
#    cartesian.remove(entry)

for i in range(100):
    textfile.write(u'INSERT INTO \"Planes\" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (' + str(random.randint(1, 3)) + ', ' + str(random.randint(1, 160)) + ', ' + str(decimal.Decimal(random.randrange(100))/100) + ', ' + str(random.randint(5, 6)) + ', ' + str(random.randint(1, 4)) + ', ' + str(decimal.Decimal(random.randrange(100000))/100) + ', ' + str(decimal.Decimal(random.randrange(100000))/100) + ', ' + str(decimal.Decimal(random.randrange(10000))/100) + ');\n')



textfile.close()
