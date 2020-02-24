program main

        use checktraj
        use freengfunc, only: calcfree

        implicit none
        integer,dimension(:),allocatable :: atom_nr
        integer,dimension(:),allocatable :: residue_nr
        integer :: numberoftrajfiles,numberofcations,i,j,k,nx,ny,nz,m
        integer :: numberoftrajfilescheck,numberofframes,numberoftottrjpts
        integer :: boxminx,boxmaxx,boxminy,boxmaxy,boxminz,boxmaxz,ioncount
        character(len=6),dimension(:),allocatable :: record_name
        character(len=5),dimension(:),allocatable :: atom_name
        character(len=3),dimension(:),allocatable :: residue_name
        character(len=1),dimension(:),allocatable :: chain_name
        character(len=255) :: currentpath
        character(len=255) :: trj_file
        character(len=15) :: entry
        real,dimension(:),allocatable :: occupatin,tempFactor
        real,dimension(:,:),allocatable :: rhoxz,rhoyz
        real(kind=8),dimension(:,:),allocatable :: xyz
        real :: resolution,minx,maxx,miny,maxy,minz,maxz,xzfree,yzfree
        character :: bsp = char(8)
        
        logical :: DEBUG

        !comment out to close DEBUGGING
        DEBUG=.true.

        call readtraj(numberoftrajfiles)
              !readed from directory
        call readmain(numberoftrajfilescheck,numberofframes,numberofcations,resolution,&
                minx,maxx,miny,maxy,minz,maxz)
              !readed from input
              boxminx=nint(minx/resolution)
              boxmaxx=nint(maxx/resolution)
              boxminy=nint(miny/resolution)
              boxmaxy=nint(maxy/resolution)
              boxminz=nint(minz/resolution)
              boxmaxz=nint(maxz/resolution)

        allocate (rhoxz(boxminx:boxmaxx,boxminz:boxmaxz))
        allocate (rhoyz(boxminy:boxmaxy,boxminz:boxmaxz))

        if (DEBUG) then
                if (numberoftrajfiles .eq. numberoftrajfilescheck) then
                        print *,"...File numbers are correct"
                else
                        print *,"...mismatch of file numbers"
                end if
        end if

        !each file contains 1000 frames in our system
        numberoftottrjpts=numberoftrajfilescheck*numberofframes 

        call getcwd(currentpath)

        open(unit=9,file=TRIM(currentpath)//'/src/density_dist.inp',status='old')

                                if (DEBUG) then
                                        print *,"...Reading pdb files"
                                end if
                                if (DEBUG) then
                                        print *,"...Total Trajectory Files :",numberoftrajfiles
                                end if

        ioncount=0
        rhoxz=1.0
        rhoyz=1.0

17 format('# of files opened',I5)
27 format(5A1,I5)
write(*,17,advance='no')1

        do j = 1,numberoftrajfiles
                read (9,*) trj_file
                write(*,27,advance='no')(bsp,m=1,5),j

                        open(unit=12,file=trj_file,status='old')
                        read(12,*)entry
                                do k=1,numberofframes

                                     allocate (record_name(numberofcations),atom_nr(numberofcations),&
                                             residue_nr(numberofcations),atom_name(numberofcations),&
                                             residue_name(numberofcations),chain_name(numberofcations),&
                                             occupatin(numberofcations),tempfactor(numberofcations))

                                     allocate (xyz(numberofcations,3))

                                        do i=1,numberofcations

                                          read(12,'(a6,i5,a5,x,a3,x,a1,i4,4x,f8.3,f8.3,f8.3,2f6.2)') &
                                          record_name(i),atom_nr(i),atom_name(i),residue_name(i),chain_name(i), &
                                          residue_nr(i),xyz(i,1),xyz(i,2),xyz(i,3),occupatin(i),tempFactor(i)

                                          nx=nint(xyz(i,1)/resolution)
                                          ny=nint(xyz(i,2)/resolution)
                                          nz=nint(xyz(i,3)/resolution)

                                                if( (nx .ge. boxminx .and. nx .le. boxmaxx) .and. &
                                                    (ny .ge. boxminy .and. ny .le. boxmaxy) .and. &
                                                    (nz .ge. boxminz .and. nz .le. boxmaxz) ) then
                                                    rhoxz(nx,nz)=rhoxz(nx,nz)+1.0
                                                    rhoyz(ny,nz)=rhoyz(ny,nz)+1.0
                                                    ioncount=ioncount+1
                                                end if

                                        end do

                                     deallocate (record_name,atom_nr,residue_nr,atom_name,residue_name,chain_name,&
                                             occupatin,tempfactor,xyz)
                                     read(12,*)entry

                                end do
        end do
                                if (DEBUG) then
                                        print *,"...Probability Densities are calculated"
                                end if

         
                                open(13, file=TRIM(currentpath)//'/results/XZplane2dpmf.dat', status='replace') 
                                open(14, file=TRIM(currentpath)//'/results/YZplane2dpmf.dat', status='replace') 
        do i = boxminx,boxmaxx
                do j = boxminz,boxmaxz                                
                        call calcfree(rhoxz(i,j),rhoyz(i,j),xzfree,yzfree)
                        write (13,'(2f9.4,203f7.1)') i*resolution, j*resolution, xzfree 
                        write (14,'(2f9.4,203f7.1)') i*resolution, j*resolution, yzfree 
                end do
                write (13,*)
                write (14,*)
        end do
close(13)
close(14)
                                if (DEBUG) then
                                        print *,"...PMF profiles are calculated"
                                        print *,"...Please check the results directory"
                                end if

end program main
