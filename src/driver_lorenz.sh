#!/bin/bash

##########################################################################
#            23-11-2015
#            Valerio Capecchi - Consorzio LaMMA
#            capecchi@lamma.rete.toscana.it

#            Trova le traiettorie del sistema Lorenz 1963 date
#            le condizioni iniziali X0, Y0, Z0
#            utilizzando un sorgente in f90
#            Quindi plotta gli output utilizzando GrADS
##########################################################################

# check for the appropriate environment
os=`uname`
if [ "$os" != "Linux" ]; then
  echo "ops, this procedure is tested only under a Linux environment"
  exit 1;
fi

# check for pre-requisities: a fortran compiler (gfortran), perl, grads, mencoder, vlc
# 1. a fortran compiler is mandatory (only GNU Fortran [gfortran] is tested; perhaps every other fortran comiler should work...)
# 2. perl is mandatory if you want to produce the images (and thus the movies)
# 3. grads is mandatory if you want to produce the images (and thus the movies)
# 4. mencoder is mandatory if you want to produce the movies
# 5. vlc is mandatory if you want to display the movies

# gfortran
FC=gfortran
type $FC >/dev/null 2>&1 || { echo >&2 "I require $FC but it's not installed. Aborting."; exit 1; }
# perl
type perl > /dev/null
if [ $? -eq 0 ]; then
  perl_is_on=1
else
  perl_is_on=0
  echo "perl is not present; will not produce images & movies" 
fi
# grads
type grads > /dev/null
if [ $? -eq 0 ]; then
  grads_is_on=1 
else
  grads_is_on=0
  echo "grads is not present; will not produce images & movies" 
  echo "you may want to:"
  echo "sudo yum install grads"
fi
# mencoder
type mencoder > /dev/null
if [ $? -eq 0 ]; then
  mencoder_is_on=1
else
  mencoder_is_on=0
  echo "mencoder is not present; will not produce movies" 
  echo "you may want to:"
  echo "sudo yum install mencoder"
fi
# vlc
type vlc > /dev/null
if [ $? -eq 0 ]; then
  vlc_is_on=1 
  display_mov=0
  echo "do you wwant to view the movies at the end of the procedure? [y/n]"
  read resp
  if [ "$resp" = "y" ]; then
    display_mov=1
  fi
else
  vlc_is_on=0
  echo "vlc is not present; will not display movies" 
  echo "you may want to:"
  echo "sudo yum install vlc"
fi

# global directories
cdir=`pwd`
SCRPDIR=$cdir

# namelist.lor
if [ ! -e $cdir/namelist.lor ]; then
  echo "opss...missing $cdir/namelist.lor"
  exit 1;
fi
DATADIR=`cat $cdir/namelist.lor | grep outdir | cut -d'=' -f2 | sed -e "s!'!!g" | sed -e "s!,!!g" | sed -e "s! !!g"`
if [ ! -e $DATADIR ]; then
  echo "$DATADIR is missing"
  echo "do you want to create it? [y/n]"
  read resp
  if [ "$resp" = "y" ]  ; then
    mkdir -p $DATADIR
    echo "created output directory $DATADIR"
  else
    echo "ok..exit.."
    exit 0;
  fi
else
  if [ ! -d $DATADIR ]; then
    echo "$DATADIR is present but it is not a directory...exit..."
    exit 1;
  fi
fi
TSTEPS=`cat $cdir/namelist.lor | grep maxiter | cut -d'=' -f2 | sed -e "s!,!!g"`

# fortran srs && exe
src_f90=$cdir'/lorenz63.f90'
if [ ! -e $src_f90 ]; then
  echo "opss...missing $src_f90"
  exit 1;
fi
exe=`basename $src_f90 .f90`.exe

# compile fortran source with $FC
echo "++++++++++++++++++++++++++++++++++++++++"
echo "Compiling $src_f90 ---> $exe "
echo "++++++++++++++++++++++++++++++++++++++++"
rm -fv $exe
$FC $src_f90 -o $exe
if [ $? -eq 0 ]
then
  echo "Compilation ok!"
else
  echo "----------------------------------------"
  echo "Compilation error: $?"
  echo "----------------------------------------"
  exit 1
fi

# run exe file
echo "++++++++++++++++++++++++++++++++++++++++"
echo "Running $exe in `pwd`"
echo "++++++++++++++++++++++++++++++++++++++++"
./$exe
if [ $? -eq 0 ]
then
  echo "Execution ok!"
#  rm -f ./$exe
else
  echo "----------------------------------------"
  echo "Execution error: $?"
  echo "----------------------------------------"
  exit 1
fi

# convert to binary file
if [ $perl_is_on -eq 1 ]; then
  echo "++++++++++++++++++++++++++++++++++++++++"
  echo "Converting data files to bin file format"
  echo "++++++++++++++++++++++++++++++++++++++++"
  perl_util='./ascii2bin.pl'
  if [ ! -e $perl_util ]; then
    echo "opss...missing $perl_util"
    echo "cannot going ahead"
    exit 1;
  fi
  X0=`cat $cdir/namelist.lor | grep X0 | cut -d'=' -f2 | sed -e "s/ //g" | sed -e "s!,!!g"`
  Y0=`cat $cdir/namelist.lor | grep Y0 | cut -d'=' -f2 | sed -e "s/ //g" | sed -e "s!,!!g"`
  Z0=`cat $cdir/namelist.lor | grep Z0 | cut -d'=' -f2 | sed -e "s/ //g" | sed -e "s!,!!g"`
  X1=`cat $cdir/namelist.lor | grep X1 | cut -d'=' -f2 | sed -e "s/ //g" | sed -e "s!,!!g"`
  Y1=`cat $cdir/namelist.lor | grep Y1 | cut -d'=' -f2 | sed -e "s/ //g" | sed -e "s!,!!g"`
  Z1=`cat $cdir/namelist.lor | grep Z1 | cut -d'=' -f2 | sed -e "s/ //g" | sed -e "s!,!!g"`
  for var in xlorenz ylorenz zlorenz
  do
    perl $perl_util $DATADIR/${var}.txt $DATADIR/${var}_${X0}-${Y0}-${Z0}.bin
    if [ $? -eq 0 ]
    then
      echo "Convert ${var} ok!!"
    else
      echo "----------------------------------------"
      echo "Convert error: $?"
      echo "----------------------------------------"
      exit 1
    fi
  done
  for var in xlorenzpert ylorenzpert zlorenzpert
  do
    perl $perl_util $DATADIR/${var}.txt $DATADIR/${var}_${X1}-${Y1}-${Z1}.bin
    if [ $? -eq 0 ]
    then
      echo "Convert ${var} ok!!"
    else
      echo "----------------------------------------"
      echo "Convert error: $?"
      echo "----------------------------------------"
      exit 1
    fi
  done
fi

# create ctl files
if [ $perl_is_on -eq 1 ]; then
  echo "++++++++++++++++++++++++++++++++++++++++"
  echo "Creating control data files"
  echo "++++++++++++++++++++++++++++++++++++++++"
  perl_util='./bin2ctl.pl'
  if [ ! -e $perl_util ]; then
    echo "opss...missing $perl_util"
    echo "cannot going ahead"
    exit 1;
  fi
  maxiter=`cat $cdir/namelist.lor | grep maxiter | cut -d'=' -f2 | sed -e "s/ //g" | sed -e "s!,!!g"`
  for var in xlorenz ylorenz zlorenz
  do
    perl $perl_util $DATADIR/${var}_${X0}-${Y0}-${Z0}.bin $maxiter
    if [ $? -eq 0 ]
    then
      echo "Create $var ok!!"
    else
      echo "----------------------------------------"
      echo "Create error: $?"
      echo "----------------------------------------"
      exit 1
    fi
  done
  for var in xlorenzpert ylorenzpert zlorenzpert
  do
    perl $perl_util $DATADIR/${var}_${X1}-${Y1}-${Z1}.bin $maxiter
    if [ $? -eq 0 ]
    then
      echo "Create $var ok!!"
    else
      echo "----------------------------------------"
      echo "Create error: $?"
      echo "----------------------------------------"
      exit 1
    fi
  done
fi

# create images
if [ $grads_is_on -eq 1 ]; then
  echo "++++++++++++++++++++++++++++++++++++++++"
  echo "Creating time series imgs"
  echo "++++++++++++++++++++++++++++++++++++++++"
  grads_util='./plot_ts.gs'
  if [ ! -e $grads_util ]; then
    echo "opss...missing $grads_util"
    echo "cannot going ahead"
    exit 1;
  fi
  cat $grads_util | sed -e "s!XLOR1!xlorenz_$X0-$Y0-$Z0.ctl!g" | \
                    sed -e "s!YLOR1!ylorenz_$X0-$Y0-$Z0.ctl!g" | \
                    sed -e "s!ZLOR1!zlorenz_$X0-$Y0-$Z0.ctl!g" | \
                    sed -e "s!XLOR2!xlorenzpert_$X1-$Y1-$Z1.ctl!g" | \
                    sed -e "s!YLOR2!ylorenzpert_$X1-$Y1-$Z1.ctl!g" | \
                    sed -e "s!ZLOR2!zlorenzpert_$X1-$Y1-$Z1.ctl!g" | \
                    sed -e "s!INITX1!$X0!g" | \
                    sed -e "s!INITY1!$Y0!g" | \
                    sed -e "s!INITZ1!$Z0!g" | \
                    sed -e "s!INITX2!$X1!g" | \
                    sed -e "s!INITY2!$Y1!g" | \
                    sed -e "s!INITZ2!$Z1!g" > puppa.gs
  mv puppa.gs $DATADIR
  cd $DATADIR
  rm -f ${DATADIR}/lor*.png
  rm -f ${DATADIR}/lor*.png
  rm -f ${DATADIR}/lor*.png
  grads -bpc puppa.gs
  rm -f puppa.gs
  cd -
fi

# create movie
if [ $mencoder_is_on -eq 1 ]; then
  echo "++++++++++++++++++++++++++++++++++++++++"
  echo "Creating movie"
  echo "++++++++++++++++++++++++++++++++++++++++"
  fmovie_ts='lorenz_ts_'$X0'-'$Y0'-'$Z0'_'$X1'-'$Y1'-'$Z1'.avi'
  rm -fv $DATADIR/$fmovie_ts
  mencoder -ovc lavc -lavcopts vcodec=mpeg4:mbd=1:vbitrate=2800 -mf type=png:w=600:h=900:fps=30 -o /dev/null mf://${DATADIR}/lory*.png
  mencoder -ovc lavc -lavcopts vcodec=mpeg4:mbd=1:vbitrate=2800 -mf type=png:w=600:h=900:fps=30 -o $DATADIR/$fmovie_ts mf://${DATADIR}/lory*.png
  if [ $? -eq 0 ]
  then
    echo "Create movie ok!!"
  else
    echo "----------------------------------------"
    echo "Create error: $?"
    echo "----------------------------------------"
  fi
  for var in x y z
  do
    finalf=`ls -r ${DATADIR}/lor${var}*.png | head -n 1`
    cp $finalf ${DATADIR}/${var}_ts.png
    rm -f ${DATADIR}/lor${var}*.png
  done
fi

# display movies
if [ $vlc_is_on -eq 1 ] && [ $display_mov -eq 1 ]; then
  vlc $DATADIR/$fmovie_ts &
fi

# create images
if [ $grads_is_on -eq 1 ]; then
  echo "++++++++++++++++++++++++++++++++++++++++"
  echo "Creating butterfly's flap images"
  echo "++++++++++++++++++++++++++++++++++++++++"
  grads_util='./plot_btrfl.gs'
  if [ ! -e $grads_util ]; then
    echo "opss...missing $grads_util"
    echo "cannot going ahead"
    exit 1;
  fi
  cat $grads_util | sed -e "s!XLOR1!xlorenz_$X0-$Y0-$Z0.ctl!g" | \
                    sed -e "s!YLOR1!ylorenz_$X0-$Y0-$Z0.ctl!g" | \
                    sed -e "s!ZLOR1!zlorenz_$X0-$Y0-$Z0.ctl!g" | \
                    sed -e "s!XLOR2!xlorenzpert_$X1-$Y1-$Z1.ctl!g" | \
                    sed -e "s!YLOR2!ylorenzpert_$X1-$Y1-$Z1.ctl!g" | \
                    sed -e "s!ZLOR2!zlorenzpert_$X1-$Y1-$Z1.ctl!g" | \
                    sed -e "s!INITX1!$X0!g" | \
                    sed -e "s!INITY1!$Y0!g" | \
                    sed -e "s!INITZ1!$Z0!g" | \
                    sed -e "s!INITX2!$X1!g" | \
                    sed -e "s!INITY2!$Y1!g" | \
                    sed -e "s!INITZ2!$Z1!g" > puppa.gs
  mv puppa.gs $DATADIR
  cd $DATADIR
  rm -f ${DATADIR}/farfalla*.png
  rm -f ${DATADIR}/farfalla*.png
  rm -f ${DATADIR}/farfalla*.png
  grads -bpc puppa.gs
  rm -f puppa.gs
  cd -
fi

# create movie
if [ $mencoder_is_on -eq 1 ]; then
  echo "++++++++++++++++++++++++++++++++++++++++"
  echo "Creating movie"
  echo "++++++++++++++++++++++++++++++++++++++++"
  fmovie_att='lorenz_att_'$X0'-'$Y0'-'$Z0'_'$X1'-'$Y1'-'$Z1'.avi'
  rm -fv $DATADIR/$fmovie_att
  mencoder -ovc lavc -lavcopts vcodec=mpeg4:mbd=1:vbitrate=2800 -mf type=png:w=600:h=900:fps=10 -o /dev/null mf://${DATADIR}/farfallaxz*.png
  mencoder -ovc lavc -lavcopts vcodec=mpeg4:mbd=1:vbitrate=2800 -mf type=png:w=600:h=900:fps=10 -o $DATADIR/$fmovie_att mf://${DATADIR}/farfallaxz*.png
  if [ $? -eq 0 ]
  then
    echo "Create movie ok!!"
  else
    echo "----------------------------------------"
    echo "Create error: $?"
    echo "----------------------------------------"
  fi
  for var in xy yz xz
  do
    finalf=`ls -r ${DATADIR}/farfalla${var}*.png | head -n 1`
    cp $finalf ${DATADIR}/far${var}.png
    rm -f ${DATADIR}/farfalla${var}*.png
  done
fi

# display movies
if [ $vlc_is_on -eq 1 ] && [ $display_mov -eq 1 ]; then
  vlc $DATADIR/$fmovie_att &
fi

# ciao
exit 0

