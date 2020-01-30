'reinit'
*open files
'open XLOR1'
'open YLOR1'
'open ZLOR1'
'open XLOR2'
'open YLOR2'
'open ZLOR2'

*minmax
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
xmax=math_nint(x1max)+2
else
xmax=math_nint(x2max)+2
endif
if (x1min<x2min)
xmin=math_nint(x1min)-2
else
xmin=math_nint(x2min)-2
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
ymax=math_nint(y1max)+2
else
ymax=math_nint(y2max)+2
endif
if (y1min<y2min)
ymin=math_nint(y1min)-2
else
ymin=math_nint(y2min)-2
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
zmax=math_nint(z1max)+2
else
zmax=math_nint(z2max)+2
endif
if (z1min<z2min)
zmin=math_nint(z1min)-2
else
zmin=math_nint(z2min)-2
endif

*misc
fmt = '%.3f'
offset = 1
count = offset
while(count<maxtime)
  'set gxout scatter'
  'set vpage 0 8.25 5 11'
  'set vrange 'xmin' 'xmax
  'set vrange2 'ymin' 'ymax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'set cmark 3'
  'set digsiz 0.05'
  'set ccolor 1'
  'd data.1;data.2'
  'draw title Lorenz attractor (1963) - XY variables \ initial cond (INITX1,INITY1,INITZ1) & (INITX2,INITY2,INITZ2)'
  'set vpage 0 8.25 0 6 '
  'set vrange 'xmin' 'xmax
  'set vrange2 'ymin' 'ymax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'set cmark 3'
  'set digsiz 0.05'
  'set ccolor 2'
  'd data.4;data.5'
  'set t 'count
  'define dist=sqrt(pow((data.1-data.4),2)+pow((data.2-data.5),2))'
  'd dist'
  dist = subwrd(result,4)
  rc = math_format(fmt,dist)
  'draw string 0.25 5.5 dist(P1,P2)='rc
  if (count<10)
    'printim farfallaxy_000'count'.png x600 y900 white'
  endif
  if (count>=10 &count<100)
    'printim farfallaxy_00'count'.png x600 y900 white'
  endif
  if (count>=100 & count<1000)
    'printim farfallaxy_0'count'.png x600 y900 white'
  endif
  if (count>=1000)
    'printim farfallaxy_'count'.png x600 y900 white'
  endif
  'c'
  'set gxout scatter'
  'set vpage 0 8.25 5 11'
  'set vrange 'xmin' 'xmax
  'set vrange2 'zmin' 'zmax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'set cmark 3'
  'set digsiz 0.05'
  'set ccolor 1'
  'd data.1;data.3'
  'draw title Lorenz attractor (1963) - XZ variables \ initial cond (INITX1,INITY1,INITZ1) & (INITX2,INITY2,INITZ2)'
  'set vpage 0 8.25 0 6 '
  'set vrange 'xmin' 'xmax
  'set vrange2 'zmin' 'zmax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'set cmark 3'
  'set digsiz 0.05'
  'set ccolor 2'
  'd data.4;data.6'
  'set t 'count
  'define dist=sqrt(pow((data.1-data.4),2)+pow((data.3-data.6),2))'
  'd dist'
  dist = subwrd(result,4)
  rc = math_format(fmt,dist)
  'draw string 0.25 5.5 dist(P1,P2)='rc
  if (count<10)
    'printim farfallaxz_000'count'.png x600 y900 white '
  endif
  if (count>=10 &count<100)
    'printim farfallaxz_00'count'.png x600 y900 white '
  endif
  if (count>=100 & count<1000)
    'printim farfallaxz_0'count'.png x600 y900 white '
  endif
  if (count>=1000)
    'printim farfallaxz_'count'.png x600 y900 white '
  endif
  'c'
  'set gxout scatter'
  'set vpage 0 8.25 5 11'
  'set vrange 'ymin' 'ymax
  'set vrange2 'zmin' 'zmax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'set cmark 3'
  'set digsiz 0.05'
  'set ccolor 1'
  'd data.2;data.3'
  'draw title Lorenz attractor (1963) - YZ variables \ initial cond (INITX1,INITY1,INITZ1) & (INITX2,INITY2,INITZ2)'
  'set vpage 0 8.25 0 6 '
  'set vrange 'ymin' 'ymax
  'set vrange2 'zmin' 'zmax
  'set t 1 'count
  'set grads off'
  'set grid off'
  'set cmark 3'
  'set digsiz 0.05'
  'set ccolor 2'
  'd data.5;data.6'
  'set t 'count
  'define dist=sqrt(pow((data.2-data.5),2)+pow((data.3-data.6),2))'
  'd dist'
  dist = subwrd(result,4)
  rc = math_format(fmt,dist)
  'draw string 0.25 5.5 dist(P1,P2)='rc
  if (count<10)
    'printim farfallayz_000'count'.png white '
  endif
  if (count>=10 &count<100)
    'printim farfallayz_00'count'.png white '
  endif
  if (count>=100 & count<1000)
    'printim farfallayz_0'count'.png white '
  endif
  if (count>=1000)
    'printim farfallayz_'count'.png white '
  endif
  'c'
********************************************
  'define dist3D = sqrt(pow((data.1-data.4),2)+pow((data.2-data.5),2)+pow((data.3-data.6),2))'
  'd dist3D'
  dist3D = subwrd(result,4)
  say dist3D
  'set gxout print'
  'set prnopts %.6f 1 1'
  write('err_traiettorie.txt', dist3D, append)
********************************************
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

