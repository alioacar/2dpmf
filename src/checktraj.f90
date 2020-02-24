module checktraj
        implicit none
contains

subroutine readtraj(numberoffiles)

        implicit none
        character(len=255) :: currentpath
        integer :: line
        integer, intent(out) :: numberoffiles
        
        call getcwd(currentpath)

open(unit=9,file=TRIM(currentpath)//'/src/density_dist.inp',status='old')
line = 0
    do
    read(9,*,end=10)
       line = line +1
    end do
10 close(9)
numberoffiles=line

end subroutine

subroutine readmain(line1,line2,line3,line4,&
                line5,line6,line7,line8,line9,line10)

        !line1:number of total files
        !line2:number of frames on each file
        !line3:number of total trajectory files

        implicit none
        integer,intent(out) :: line1,line2,line3
        real,intent(out) :: line4,line5,line6,line7,line8,line9,line10
        character(len=255) :: currentpath
        real,dimension(10) :: mainlines

        call getcwd(currentpath)

open(unit=12,file=TRIM(currentpath)//'/src/main.inp',status='old')
read(12,*,end=13) mainlines
13 close(12)
        
        line1=nint(mainlines(1))
        line2=nint(mainlines(2))
        line3=nint(mainlines(3))
        line4=mainlines(4)
        line5=mainlines(5)
        line6=mainlines(6)
        line7=mainlines(7)
        line8=mainlines(8)
        line9=mainlines(9)
        line10=mainlines(10)

end subroutine

end module checktraj
