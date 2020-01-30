'reinit'
*open files
'open XLOR1'
'open YLOR1'
'open ZLOR1'
'open XLOR2'
'open YLOR2'
'open ZLOR2'

* statistics
'set t last'
'q dims'
line=sublin(result,5)
maxtime = subwrd(line,9)
'set t 1 last'
'set gxout stat'
*
'd data.1'
line=sublin(result,8)
x1max = subwrd(line,5)
x1min = subwrd(line,4)
'd data.4'
line=sublin(result,8)
x2max = subwrd(line,5)
x2min = subwrd(line,4)
if (x1max>x2max)
xmax=math_nint(x1max)+1
else
xmax=math_nint(x2max)+1
endif
if (x1min<x2min)
xmin=math_nint(x1min)-1
else
xmin=math_nint(x2min)-1
endif
*
'd data.2'
line=sublin(result,8)
y1max = subwrd(line,5)
y1min = subwrd(line,4)
'd data.5'
line=sublin(result,8)
y2max = subwrd(line,5)
y2min = subwrd(line,4)
if (y1max>y2max)
ymax=math_nint(y1max)+1
else
ymax=math_nint(y2max)+1
endif
if (y1min<y2min)
ymin=math_nint(y1min)-1
else
ymin=math_nint(y2min)-1
endif
*
'd data.3'
line=sublin(result,8)
z1max = subwrd(line,5)
z1min = subwrd(line,4)
'd data.6'
line=sublin(result,8)
z2max = subwrd(line,5)
z2min = subwrd(line,4)
if (z1max>z2max)
zmax=math_nint(z1max)+1
else
zmax=math_nint(z2max)+1
endif
if (z1min<z2min)
zmin=math_nint(z1min)-1
else
zmin=math_nint(z2min)-1
endif
*
'set gxout contour'

fmt = '%.4f'
offset = 2
count = offset
while (count < maxtime)
********************************************
*draw data x
  'set vpage 0 8.25 5 11 '
  'set vrange 'xmin' 'xmax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'draw ylab X'
  'set cmark 0'
  'set cthick 4'
  'set ccolor 2'
  'd data.1'
  'draw title Traiettorie (X) del sistema di Lorenz (1963) con \ initial cond (INITX1,INITY1,INITZ1) & (INITX2,INITY2,INITZ2)'
  'set vpage 0 8.25 0 6 '
  'set vrange 'xmin' 'xmax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'draw ylab X'
  'set xlab on'
  'draw xlab time'
  'set cmark 0'
  'set cthick 3'
  'set ccolor 1'
  'd data.4'
  'set t 'count
  'define err=(data.1-data.4)'
  'd err'
  err = subwrd(result,4)
  rc = math_format(fmt,err)
  'draw string 0.25 5.5 diffX='rc
  if (count<10)
    'printim lorx_000'count'.png png x600 y900 white'
  endif
  if (count>=10 &count<100)
    'printim lorx_00'count'.png png x600 y900 white'
  endif
  if (count>=100 & count<1000)
    'printim lorx_0'count'.png png x600 y900 white'
  endif
  if (count>=1000)
    'printim lorx_'count'.png png x600 y900 white'
  endif
  'c'
********************************************
*draw data y
  'set vpage 0 8.25 5 11 '
  'set vrange 'ymin' 'ymax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'draw ylab Y'
  'set xlab off'
  'set cmark 0'
  'set cthick 4'
  'set ccolor 2'
  'd data.2'
  'draw title Traiettorie (Y) del sistema di Lorenz (1963) con \ initial cond (INITX1,INITY1,INITZ1) & (INITX2,INITY2,INITZ2)'
  'set vpage 0 8.25 0 6 '
  'set vrange 'ymin' 'ymax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'draw ylab Y'
  'set xlab on'
  'draw xlab time'
  'set cmark 0'
  'set cthick 3'
  'set ccolor 1'
  'd data.5'
  'set t 'count
  'define err=(data.2-data.5)'
  'd err'
  err = subwrd(result,4)
  rc = math_format(fmt,err)
  'draw string 0.25 5.5 diffY='rc
  if (count<10)
    'printim lory_000'count'.png png x600 y900 white'
  endif
  if (count>=10 &count<100)
    'printim lory_00'count'.png png x600 y900 white'
  endif
  if (count>=100 & count<1000)
    'printim lory_0'count'.png png x600 y900 white'
  endif
  if (count>=1000)
    'printim lory_'count'.png png x600 y900 white'
  endif
  'c'
********************************************
*draw data z
  'set vpage 0 8.25 5 11 '
  'set vrange 'zmin' 'zmax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'draw ylab Z'
  'set xlab on'
  'draw xlab time'
  'set cmark 0'
  'set cthick 4'
  'set ccolor 2'
  'd data.3'
  'draw title Traiettorie (Z) del sistema di Lorenz (1963) con \ initial cond (INITX1,INITY1,INITZ1) & (INITX2,INITY2,INITZ2)'
  'set vpage 0 8.25 0 6 '
  'set vrange 'zmin' 'zmax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'set cmark 0'
  'set cthick 3'
  'set ccolor 1'
  'd data.6'
  'set t 'count
  'define err=(data.3-data.6)'
  'd err'
  err = subwrd(result,4)
  rc = math_format(fmt,err)
  'draw string 0.25 5.5 diffZ='rc
********************************************
  if (count<10)
    'printim lorz_000'count'.png png x600 y900 white'
  endif
  if (count>=10 &count<100)
    'printim lorz_00'count'.png png x600 y900 white'
  endif
  if (count>=100 & count<1000)
    'printim lorz_0'count'.png png x600 y900 white'
  endif
  if (count>=1000)
    'printim lorz_'count'.png png x600 y900 white'
  endif
  'c'
  check=100+offset
  while (check < maxtime)
    if (count = check)
      tmp = ((count - offset)/maxtime)*100
      say 'completed 'tmp'%'
    endif
    check=check+100
  endwhile
  count = count + 10
endwhile
say 'completed 100%'

*close files
'close 6'
'close 5'
'close 4'
'close 3'
'close 2'
'close 1'

*quit
'quit'
