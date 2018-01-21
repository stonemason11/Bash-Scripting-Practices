#!/bin/python 

# Wensheng Sun
# insertion sort

import sys
import numpy as np

def showlist(lst,ind,char1,char2):
  """ Shows the list, marking the element whose index is ind
  by surrounding it with two chars passed as char1
  and Whole line prefixed with char2 """
  print(char2,end=' '),
  i = 0;
  for i, item in enumerate(lst):
     if i == ind:
       print(char1[0],end=''), print(item,end=''),
     elif i == ind+1:
       print(char1[1],end=','), print(item,end=','),
     else:
       print(item,end=','),
  print('')

def insert_sort(targetlist):
  num_el = len(targetlist)
  i = 0;
  while i<num_el:
    #showlist(targetlist,i,['[',']'],'')
    j = i 
    while j >0:
      if targetlist[j-1] > targetlist[j]:
        temp1 = targetlist[j]
        temp2 = targetlist[j-1]
        targetlist[j-1] = temp1
        targetlist[j] = temp2
      j -= 1
    i += 1
    #showlist(targetlist,i,['[',']'],'*')
  return targetlist

def main():
  if len(sys.argv)<2:
    print('Usage:{} [-t]|[an array] !'.format(sys.argv[0]))
    sys.exit(1)
  if sys.argv[1] == '-t':
    print('testing the model...')
    target = np.random.rand(10)*10	# random list [0 - 10] float type
  else:
    target = [ float(item) for item in sys.argv[1:]]

  print(insert_sort(target))
 

#print(insert_sort([3 2 1 5 9 7 8]))  

if __name__ == '__main__':
 # showlist([1,2,3.0,5],0,['[',']'],'*')
  main()
