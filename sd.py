#!/bin/python

import os
import sys
import numpy as np

def read_datafile(fn):
  f = open(fn)
  data = [float(item) for item in f]
  f.close()
  return data

def mean(data_list):
  sum = 0
  for ii in data_list:
    sum = sum + ii
  avg=sum/len(data_list)
  return avg


def std(data_list):
  m=mean(data_list)
  zms_data=mean([ (item -m)**2 for item in data_list])
  return np.sqrt(zms_data)
  

def main():
  if len(sys.argv)==1:
    datafile = "sample.dat"
  elif len(sys.argv)==2:
    datafile = sys.argv[1]
  else:
    print('USAGE:{0:s} [data file]'.format(sys.argv[0]))
    exit(1)

  if not os.path.exists(datafile):
    print('{0:s} does not exist' .format(str(datafile)))
    exit(2)

  data=read_datafile(datafile)
  sdev=std(data)
  print('The standard deviation is {0:f}' .format(sdev))


if __name__=='__main__':
  main()
