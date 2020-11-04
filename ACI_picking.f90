program ACI_picking
implicit none
integer, parameter :: max=8640010
integer :: i, nerr, nlen, ios, k
integer :: ttt,nn1
integer :: site(1),s2(1)
real, dimension(max) :: yarray
real :: beg, del, dist
real :: par
character (len=200) :: kname,aname
character (len=8) :: kstnm
real,allocatable :: ACI(:)
real,external :: var
write(*,*)'Please input SAC file name.'
read(*,'(a)')kname
write(*,*)'output file name.'
read(*,'(a)') aname
open(77,file=aname)
!!! read sac file
call rsac1(trim(kname),yarray,nlen,beg,del,max,nerr)
if ( nerr /= 0 ) then
write(*,*)'error,no this file'
stop
endif
!!! prepare
ttt=AINT(real(0-beg)/del)+1
allocate(ACI(int(nlen)-ttt-1000))
nn1=INT(nlen)-1000
!open(56,file='dr.log')
!------- ACI
do k=ttt,nn1
ACI(k-ttt+1)=k*var(k,yarray(1:k))+(nn1-k-1)*var(nn1-k,yarray(k+1:nn1))
write(77,'(I6,1x,e16.7)')k-ttt+1,ACI(k-ttt+1)
!write(*,*)k,ACI(k-ttt+1)
enddo

site=maxloc(ACI(1:nn1-ttt))
s2=minloc(ACI(1:site(1)))
deallocate(ACI)
par=s2(1)*del


close(77)
stop
end program ACI_picking
!-------------------------------
function var(n,a)
integer,intent(in) :: n
real,dimension(n) :: a
real :: avg,sta,xx
avg=sum(a)/n
xx=0.0
do i=1,n
xx=xx+abs((a(i)-avg))**2.
enddo
var=log(xx/(n-1))
endfunction

