program synthetic
implicit none
real :: t,fc
real :: om,snn
real :: f,fmax,ome=0.0
real :: up,down,minn,omega
real :: aval,rms,sumT=0.0
real :: pi=3.1415926
integer :: a,i,x,k,n
integer :: nmax
real,allocatable :: amp(:),hz(:),snr(:)
real,allocatable :: samp(:),shz(:)
character (len=200) :: aname
character (len=500) :: input
write(*,*)'begin frequency'
read(*,*)f
write(*,*)'max frequency'
read(*,*)fmax
write(*,*)'t*'
read(*,*)t
write(*,*)'fc'
read(*,*)fc
write(*,*)'output file name.'
read(*,'(a)') aname
write(*,*)'input amp site'
read(*,'(a)') input
write(*,*)'nmax?'
read(*,*) nmax
!-------------------------
!!!parameter setting
allocate(amp(nmax))
allocate(hz(nmax))
allocate(samp(nmax))
allocate(shz(nmax))
allocate(snr(nmax))
minn = 1e+30
!!! read spetrum
open(109,file=trim(input),status='old')
snn=0.0
do k = 1,nmax
 read(109,*,END=887)hz(k),amp(k),snr(k)
 snn=snn+snr(k)
  if( hz(k) <= 1. )then
  ome=ome+amp(k)
  end if
 enddo
887 continue
close(109)
ome=ome/5

!!! synthetic spectrum
n=1
do while ( f < fmax )
 up=exp(-pi*f*t)
 down=((f/fc)**2)+1
 samp(n)=up/down
 shz(n)=f
 f=f+0.20
 n=n+1
enddo
n=n-1

!!! mistfit 
do Om = ome*(1e-1),ome*(30),ome*(1e-1)
 a=1
 sumT=0.0
 do a = 1,n
  aval=log10(amp(a))-log10(Om*samp(a))
  sumT = sumT + snr(a)*(aval**2)
 enddo
 rms = sqrt(sumT/snn)
 if ( rms < minn ) then
  minn = rms
  omega=Om
 end if
enddo
write(*,*)"omega",omega,"min_rms",minn

!!!print out
a=1
open(77,file=aname,status="replace")
do a  = 1,n
write(77,4455)shz(a),samp(a)*omega
enddo
4455      format(e15.8,1x,e12.5)
close(77)

open(771,file='omg.log',status="replace")
write(771,*)omega
close(771)
stop
end program synthetic
