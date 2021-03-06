C-----------------------------------------------------------------------
c
c	Ramesh's Periodic Hill w/ wall shape function & ~ target res
c
C
C  user specified routines:
C     - userbc : boundary conditions
C     - useric : initial conditions
C     - uservp : variable properties
C     - userf  : local acceleration term for fluid
C     - userq  : local source term for scalars
C     - userchk: general purpose routine for checking errors etc.
C
C-----------------------------------------------------------------------
#define DELTA 0.2
#define XLEN 1.
#define YLEN 1.
#define ZLEN 1.
C-----------------------------------------------------------------------
      include 'scatter.usr'
      include 'wall.usr'
C-----------------------------------------------------------------------
      subroutine uservp(ix,iy,iz,eg) ! set variable properties
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer ie,f,eg
c     ie = gllel(eg)

      udiff  = 0.0
      utrans = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userf(ix,iy,iz,eg) ! set acceleration term
c
c     Note: this is an acceleration term, NOT a force!
c     Thus, ffx will subsequently be multiplied by rho(x,t).
c
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer e,f,eg
c     e = gllel(eg)

      ffx = 0.0
      ffy = 0.0
      ffz = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userq(ix,iy,iz,eg) ! set source term
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer e,f,eg
c     e = gllel(eg)

      qvol   = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userbc(ix,iy,iz,iside,ieg) ! set up boundary conditions
c     NOTE ::: This subroutine MAY NOT be called by every process
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

c      if (cbc(iside,gllel(ieg),ifield).eq.'v01')

c	Empty/no call to with BCs P, W, SYM!

      ux   = 0.0
      uy   = 0.0
      uz   = 0.0
      temp = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine useric(ix,iy,iz,ieg) ! set up initial conditions
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer idum
      save    idum 
      data    idum / 0 /

      integer ie

      ie = gllel(ieg)

      x = xm1(ix,iy,iz,ie)
      y = ym1(ix,iy,iz,ie)
      z = zm1(ix,iy,iz,ie)
 
      ux = x**2 + y**3 + z**4
      uy = 0.
      uz = 0.

      return
      end
c-----------------------------------------------------------------------
      subroutine userchk()
c     implicit none
      include 'SIZE'
      include 'TOTAL'

      character*3 bctyp
      integer ifld,nel,n

      bctyp = 'W  '
      ifld  = 1
      nel   = nelfld(ifld)
      n     = lx1*ly1*lz1*nel

      call comp_uplus(vx,vy,vz,bctyp,ifld)

      call exitt

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat()   ! This routine to modify element vertices
      include 'SIZE'
      include 'TOTAL'

      common /cdsmag/ ediff(lx1,ly1,lz1,lelv)

      n = nx1*ny1*nz1*nelt 
      call cfill(ediff,param(2),n)  ! initialize viscosity

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat2()  ! This routine to modify mesh coordinates
      include 'SIZE'
      include 'TOTAL'

       nt = nx1*ny1*nz1*nelt
 
       call rescale_x(xm1, 0.0, 1.0)
       call rescale_x(ym1, 0.0, 1.0)
       call rescale_x(zm1, 0.0, 1.0)

       del = 0.2
       do i=1,nt
         x  = xm1(i,1,1,1)
         y  = ym1(i,1,1,1)
         z  = zm1(i,1,1,1)
 
         yw = ss(x,DELTA)
 
         yy = (1. - yw/1.0)*y + yw
         ym1(i,1,1,1) = yy
       enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat3()
      include 'SIZE'
      include 'TOTAL'

      return
      end
c-----------------------------------------------------------------------
      function ss(x,d)          ! bottom surface y = ss(x,d)

      ss = 1.0 - (2.0*x-1.0)**2
      ss = ss*d

c     ss = 0.

      return
      end
C=======================================================================

c automatically added by makenek
      subroutine usrsetvert(glo_num,nel,nx,ny,nz) ! to modify glo_num
      integer*8 glo_num(1)

      return
      end

c automatically added by makenek
      subroutine userqtl

      call userqtl_scig

      return
      end
