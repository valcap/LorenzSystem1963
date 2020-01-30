program lorenz63

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! valcap74@gmail.com
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  implicit none

  integer :: i
  integer :: funit
  integer :: maxiter            ! from namelist 'namelist.lor'

  double precision :: sigma, erre, bi       ! from namelist 'namelist.lor'
  double precision :: X0, Y0, Z0            ! from namelist 'namelist.lor'
  double precision :: X1, Y1, Z1            ! from namelist 'namelist.lor'
  double precision :: dt                    ! from namelist 'namelist.lor'
  double precision :: xcur,ycur,zcur
  double precision :: xcur_pert,ycur_pert,zcur_pert
  double precision :: xlor,ylor,zlor
  double precision :: dist,distance
  
  character (len=128) :: outdir,outfile
  logical :: is_used
  
  namelist /init/ X0, Y0, Z0, X1, Y1, Z1
  namelist /misc/ maxiter, dt
  namelist /para/ sigma, erre, bi
  namelist /dire/ outdir

! Read parameters from namelist
  do funit=10,100
     inquire(unit=funit, opened=is_used)
     if (.not. is_used) exit
  end do
  open(funit,file='namelist.lor',status='old',form='formatted',err=1000)
  read(funit,init)
  read(funit,misc)
  read(funit,para)
  read(funit,dire)
  close(funit)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Open output text files
  outfile=trim(outdir)//'/xlorenz.txt'
  open(unit = 10, status='replace',file=trim(outfile),form='formatted', &
     access='sequential',err=1001)
  outfile=trim(outdir)//'/ylorenz.txt'
  open(unit = 11, status='replace',file=trim(outfile),form='formatted', &
    access='sequential',err=1001)
  outfile=trim(outdir)//'/zlorenz.txt'
  open(unit = 12, status='replace',file=trim(outfile),form='formatted', &
    access='sequential',err=1001)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Open output text files (perturbed run)
  outfile=trim(outdir)//'/xlorenzpert.txt'
  open(unit = 13, status='replace',file=trim(outfile),form='formatted', &
     access='sequential',err=1001)
  outfile=trim(outdir)//'/ylorenzpert.txt'
  open(unit = 14, status='replace',file=trim(outfile),form='formatted', &
    access='sequential',err=1001)
  outfile=trim(outdir)//'/zlorenzpert.txt'
  open(unit = 15, status='replace',file=trim(outfile),form='formatted', &
    access='sequential',err=1001)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Open output text file for writing distance
  outfile=trim(outdir)//'/err_traiettorie.txt'
  open(unit = 16, status='replace',file=trim(outfile),form='formatted', &
     access='sequential',err=1001)

! Main loop  
  xcur=X0
  ycur=Y0
  zcur=Z0 
  xcur_pert=X1
  ycur_pert=Y1
  zcur_pert=Z1
  do i = 1, maxiter
!   write unperturbed trajectory
    write(10,"(F14.10)") xcur
    write(11,"(F14.10)") ycur
    write(12,"(F14.10)") zcur
    xcur=xlor(xcur,ycur,dt,sigma)
    ycur=ylor(xcur,ycur,zcur,dt,erre)
    zcur=zlor(xcur,ycur,zcur,dt,bi)
!   write perturbed trajectory
    write(13,"(F14.10)") xcur_pert
    write(14,"(F14.10)") ycur_pert
    write(15,"(F14.10)") zcur_pert
    xcur_pert=xlor(xcur_pert,ycur_pert,dt,sigma)
    ycur_pert=ylor(xcur_pert,ycur_pert,zcur_pert,dt,erre)
    zcur_pert=zlor(xcur_pert,ycur_pert,zcur_pert,dt,bi)
!   calc distance between perturbed and unperturbed
    dist=distance(xcur,ycur,zcur,xcur_pert,ycur_pert,zcur_pert)
    write(16,"(F14.10)") dist
  end do

! Close output files    
close(10) ! close the file
close(11) ! close the file
close(12) ! close the file
close(13) ! close the file
close(14) ! close the file
close(15) ! close the file
close(16) ! close the file

! Return/Stop/End and error handling
  return
1000 write (*,*) 'cannot open namelist...exit...'
1001 write (*,*) 'cannot open file/files for output...exit...'
  stop
end

!!!!!!!!!!!!!
! Functions !
!!!!!!!!!!!!!

function xlor (xprec,yprec,ts,sigma0)
        double precision :: xlor
        double precision :: xprec,yprec,ts
        double precision :: sigma0
  
  xlor = xprec + sigma0*(yprec - xprec)*ts
end function xlor

function ylor (xprec,yprec,zprec,ts,erre0)
        double precision :: ylor
        double precision :: xprec,yprec,zprec,ts
        double precision :: erre0

  ylor = yprec + (-xprec*zprec+erre0*xprec-yprec)*ts
end function ylor

function zlor (xprec,yprec,zprec,ts,bi0)
        double precision :: zlor
        double precision :: xprec,yprec,zprec,ts
        double precision :: bi0
  
  zlor = zprec + (-bi0*zprec+xprec*yprec)*ts
end function zlor

function distance (a1,a2,a3,b1,b2,b3)
        double precision :: distance
        double precision :: a1,a2,a3,b1,b2,b3
  
  distance = sqrt((a1-b1)**2+(a2-b2)**2+(a3-b3)**2)
end function distance

