program lorenz63

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! valcap74@gmail.com
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  implicit none

  integer :: i
  integer :: funit
  integer :: maxiter            ! from namelist 'namelist.lor'

  real :: sigma, erre, bi       ! from namelist 'namelist.lor'
  real :: X0, Y0, Z0            ! from namelist 'namelist.lor'
  real :: X1, Y1, Z1            ! from namelist 'namelist.lor'
  real :: dt                    ! from namelist 'namelist.lor'
  real :: xcur,ycur,zcur
  real :: xlor,ylor,zlor
  
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

! Main loop  
  xcur=X0
  ycur=Y0
  zcur=Z0 
  do i = 1, maxiter
!    write(*,*) xcur
    write(10,"(F10.6)") xcur
    write(11,"(F10.6)") ycur
    write(12,"(F10.6)") zcur
    xcur=xlor(xcur,ycur,dt,sigma)
    ycur=ylor(xcur,ycur,zcur,dt,erre)
    zcur=zlor(xcur,ycur,zcur,dt,bi)
  end do

! Close output files    
close(10) ! close the file
close(11) ! close the file
close(12) ! close the file

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Open output text files (perturbed run)
  outfile=trim(outdir)//'/xlorenzpert.txt'
  open(unit = 10, status='replace',file=trim(outfile),form='formatted', &
     access='sequential',err=1001)
  outfile=trim(outdir)//'/ylorenzpert.txt'
  open(unit = 11, status='replace',file=trim(outfile),form='formatted', &
    access='sequential',err=1001)
  outfile=trim(outdir)//'/zlorenzpert.txt'
  open(unit = 12, status='replace',file=trim(outfile),form='formatted', &
    access='sequential',err=1001)

! Main loop  
  xcur=X1
  ycur=Y1
  zcur=Z1
  do i = 1, maxiter
!    write(*,*) xcur
    write(10,"(F10.6)") xcur
    write(11,"(F10.6)") ycur
    write(12,"(F10.6)") zcur
    xcur=xlor(xcur,ycur,dt,sigma)
    ycur=ylor(xcur,ycur,zcur,dt,erre)
    zcur=zlor(xcur,ycur,zcur,dt,bi)
  end do

! Close output files    
close(10) ! close the file
close(11) ! close the file
close(12) ! close the file


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
  real :: xlor
  real :: xprec,yprec,ts
  real :: sigma0
  
  xlor = xprec + sigma0*(yprec - xprec)*ts
end function xlor

function ylor (xprec,yprec,zprec,ts,erre0)
  real :: ylor
  real :: xprec,yprec,zprec,ts
  real :: erre0

  ylor = yprec + (-xprec*zprec+erre0*xprec-yprec)*ts
end function ylor

function zlor (xprec,yprec,zprec,ts,bi0)
  real :: zlor
  real :: xprec,yprec,zprec,ts
  real :: bi0
  
  zlor = zprec + (-bi0*zprec+xprec*yprec)*ts
end function zlor

