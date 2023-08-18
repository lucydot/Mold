	include 'parametros_NpT.inc'
	include 'common.inc'

      open(2,file='todaslasconf.dat',status='unknown')
      open(3,file='sali1.dat',status='unknown')
      open(4,file='gss.dat',status='unknown')
      open(20,file='control1.dat',status='unknown')
      open(21,file='control2.dat',status='unknown')
      open(25,file='widomav.dat',status='unknown')
      open(989,file='meansqdisp.dat',status='unknown')
      open(270,file='peli_solids.xyz')
      open(70,file='peli_biggestcl.xyz')
      open(570,file='peli_color.xyz')
      open(670,file='peli_mroc.xyz')
      open(770,file='peli_fcc.xyz')
      open(170,file='peli_pressure.xyz')
      !open(370,file='peli_solids.xyz')
      open(470,file='peli_vicinispaccati.xyz')
      open(84,file='pressure.dat')
      open(863,file='nclbiggerthan10.dat')
      open(864,file='nclbiggerthan50.dat')
      open(865,file='nclbiggerthan100.dat')
      open(866,file='nclbiggerthan250.dat')
      open(867,file='nclbiggerthan500.dat')
      open(555,file='nvstime.dat')
      open(773,file='densityboxes.dat')
      open(515,file='crystallizedhere.dat')
      open(938,file='analizaestas.dat')
      open(663,file='fracsolanalizaestas.dat')
      open(719,file='q6bar.dat')
      open(910,file='seguimiento.dat')
      open(219,file='q3bar.dat')
      open(621,file='qmediovst.dat')

c	print*,'What is the alpha time?'
c	read*,rtimealpha
	rtimealpha=0.0d0

c	print*,'Cuantas dejo fuera'
c	read*,ileaveout
	ileaveout=0

c        print*,'Cuantas configuraciones'
c        read*,ibuclefin
        ibuclefin=99999
      
	call entrada(seed,rhog)

	do i=1,100000

	ibucle=i

c *** Puesta a punto del sistema antes de empezar
     
      call inicio(rhog)

      call decidethereissolid

        if(ibucle.eq.ibuclefin)then 
	call salida(seed)
	stop
	endif

	enddo

c *** calculo del parametro de orden de la configuracion inicial

!      call order

c *** puesta a punto del cristal de einstein 

!	if(ifree.eq.1)then
!	 call albert
!	 call inulat
!	endif
	
c *** comienzo del bucle principal

!1000  if(ntot.eq.nmax) stop 'fin del batch'

!      call move(seed)

c *** analisis de los promedios globales y de bloque

!      call promedios

!      if(mod(ntot,njob).ne.0) go to 1000

c ***  SALIDA DE RESULTADOS FINALES

!      call salida(seed)
c
!      call xyztorasmol
c
      end
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lattice
c
c     sets up initial coordinates.
c     Coordinates in units of box sides are meassured from a
c     reference frame placed at one of the corners. i.e.: for
c     each direction, the units range from 0 to 1.
c

	include 'parametros_NpT.inc'
	include 'common.inc'


      dimension x(nmmax),y(nmmax),z(nmmax)
      dimension phi(nmmax),ct(nmmax)
c
      sidea = 0.
      sideb = 0.
      sidec = 0.

      do i=1,3
      sidea=sidea+h(i,1)**2
      sideb=sideb+h(i,2)**2
      sidec=sidec+h(i,3)**2
      end do 

      sidea = sqrt(sidea)
      sideb = sqrt(sideb)
      sidec = sqrt(sidec)

      if(ilatt.ne.0) then
c
c     code for three close packed lattices
c
ccj2  las estructuras de closepacking  estan sin extender a mezclas
ccj2
      fact=0.0
      if(ilatt.eq.3) fact=0.5
      xbox=1.0/nx
      ybox=1.0/ny
      zbox=1.0/nz
c
      i=0
c
      do 1 k1=1,nx
      xinc=xbox*(k1-1)
c
      do 2 k2=1,ny
      yinc=ybox*(k2-1)
c
      do 3 k3=1,nz
      zinc=zbox*(k3-1)
c
      i=i+1
      x(i)=xinc
      y(i)=yinc
      z(i)=zinc
      ct(i)=ctlatt
      phi(i)=philatt
      if(mod(k3,2).ne.0) phi(i)=philatt+fact
c
3     continue
2     continue
1     continue
c
      else
c
c     code for alpha-nitrogen lattice
c
ccj2  Modificada para mezclas para ello divido el array de posiciones 
ccj2  en 4 partes y coloco en cada caja una molecula de cada parte,
ccj2  asi como las moleculas van a estar ordenadas por tipo , aseguro
ccj2  que las moleculas van a estar imas o menos bien 'mezcladas'.
ccj2
      rt3inv=1.0/sqrt(3.0)
      nbox=(part/4.0)**(1.0/3.0)+0.1
      box=1.0/float(nbox)
      box2=box*0.5
c
       ih=nmoltot/4
       j=1
c
      do 5 k1=1,nbox
      xinc=box*(k1-1)
c
      do 6 k2=1,nbox
      yinc=box*(k2-1)
c
      do 7 k3=1,nbox
      zinc=box*(k3-1)
c
      i=j
      x(i)=xinc
      y(i)=yinc
      z(i)=zinc
      ct(i)=rt3inv
      phi(i)=7.0/8.0
c
      i=j+ih
      x(i)=xinc+box2
      y(i)=yinc+box2
      z(i)=zinc
      ct(i)=rt3inv
      phi(i)=1.0/8.0
c
      i=j+2*ih
      x(i)=xinc
      y(i)=yinc+box2
      z(i)=zinc+box2
      ct(i)=rt3inv
      phi(i)=3.0/8.0
c
      i=j+3*ih
      x(i)=xinc+box2
      y(i)=yinc
      z(i)=zinc+box2
      ct(i)=rt3inv
      phi(i)=5.0/8.0
c
      j=j+1
c
7     continue
6     continue
5     continue
c
      endif
c
      do 4 i=1,nmoltot
c
      ic=class(i)
      cp=cos(phi(i)*pi2)
      sp=sin(phi(i)*pi2)
      st=sqrt(1.0-ct(i)*ct(i))
C
c
      ai11=ct(i)*cp
      ai12=-sp
      ai13=st*cp
      ai21=ct(i)*sp
      ai22=cp
      ai23=st*sp
      ai31=-st
      ai32=0.0
      ai33=ct(i)
c
c
c      do is=1,nsites
c         iatm = (i-1)*nsites+is
c Julio change number 2 
c      tinvx=ai11*xb(is)+ai12*yb(is)+ai13*zb(is)
c      tinvy=ai21*xb(is)+ai22*yb(is)+ai23*zb(is)
c      tinvz=ai31*xb(is)+ai32*yb(is)+ai33*zb(is)
c
c      tinvxp=hinv(1,1)*tinvx+hinv(1,2)*tinvy+hinv(1,3)*tinvz
c      tinvyp=hinv(2,1)*tinvx+hinv(2,2)*tinvy+hinv(2,3)*tinvz
c      tinvzp=hinv(3,1)*tinvx+hinv(3,2)*tinvy+hinv(3,3)*tinvz
ccj
c      xa(iatm)=x(i)+tinvxp
c      ya(iatm)=y(i)+tinvyp
c      za(iatm)=z(i)+tinvzp
c
cl         xa(iatm)=ai11*xb(is)+ai12*yb(is)+ai13*zb(is)
cl         ya(iatm)=ai21*xb(is)+ai22*yb(is)+ai23*zb(is)
cl         za(iatm)=ai31*xb(is)+ai32*yb(is)+ai33*zb(is)
cl         xa(iatm)=x(i)+xa(iatm)/sidea
cl         ya(iatm)=y(i)+ya(iatm)/sideb
cl         za(iatm)=z(i)+za(iatm)/sidec
cl      
cl        end do
ccj2 el bucle anterior se debe comentar y sustituir por este
c Change 12 mixture
c
      do is=1,nsites(ic)
         iatm =puntero1(ic)+ (i-1-puntero2(ic))*nsites(ic)+is
c  Julio change number 2 
        tinvx=ai11*xb(ic,is)+ai12*yb(ic,is)+ai13*zb(ic,is)
        tinvy=ai21*xb(ic,is)+ai22*yb(ic,is)+ai23*zb(ic,is)
        tinvz=ai31*xb(ic,is)+ai32*yb(ic,is)+ai33*zb(ic,is)
c
        tinvxp=hinv(1,1)*tinvx+hinv(1,2)*tinvy+hinv(1,3)*tinvz
        tinvyp=hinv(2,1)*tinvx+hinv(2,2)*tinvy+hinv(2,3)*tinvz
        tinvzp=hinv(3,1)*tinvx+hinv(3,2)*tinvy+hinv(3,3)*tinvz
ccj2
        xa(iatm)=x(i)+tinvxp
        ya(iatm)=y(i)+tinvyp
        za(iatm)=z(i)+tinvzp
c
ccj2
      end do      
c
c     compute atom coords. in space fixed frame
c
4     continue


c   Se comprueba que no existe solapamiento intramolecular

	 do im=1,nmoltot
	 ic=class(im)
	nori=puntero1(ic)+(im-1-puntero2(ic))*nsites(ic)
	ifin=nori+nsites(ic)
	
	do i=nori+1,ifin-2
	  do j=i+2,ifin
	
            dxa=xa(i)-xa(j)
            dya=ya(i)-ya(j)
            dza=za(i)-za(j)

c *** convencion de imagen minima aplicada sobre los atomos

            dxmic=anint(dxa)
            dymic=anint(dya)
            dzmic=anint(dza)
c
c **distancia entre los site de referencia de acuerdo a la convencion 
c      de imagen minima
ccj
            tx=(dxa-dxmic)
            ty=(dya-dymic)
            tz=(dza-dzmic)
ccj
            txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
            typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
            tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
            dxcm=txp
            dycm=typ
            dzcm=tzp
            drcm=sqrt(dxcm**2+dycm**2+dzcm**2)
           enddo
	   enddo
	   enddo


c
      return
      end
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine move(seed)
c
	include 'parametros_NpT.inc'
	include 'common.inc'

      dimension recx(natmax),recy(natmax),recz(natmax)
      dimension xbo(nsmax),ybo(nsmax),zbo(nsmax)
      dimension xbt(nsmax),ybt(nsmax),zbt(nsmax)
      dimension xtcart(nsmax),ytcart(nsmax),ztcart(nsmax)
      dimension dside(3),ai(3,3),xc(3)

c     chantal sett 2011      
c      integer conta



1000  ntot=ntot+1

	 !print*,ntot,utot

       IF(ibrownian.eq.0)THEN
 167   do i=1,nmoltot
	
        gimove = ranf(seed) 

	   if (gimove.lt.frac_cm) then
	!print*,ufold
 		call cm_move(seed,cacc)

		atmptcm = atmptcm + 1.

	   else if (gimove.lt.frac_rot) then
		
                call rot_move(seed,racc)

		atmptro = atmptro + 1.
                         
           else if (gimove.lt.frac_int) then
            call intercambio(seed,tiacc)
                  
                atmptint = atmptint + 1.  

           else if (gimove.lt.frac_cb) then
         
                !call cb_move(seed,biacc)
		 call clmove(seed,biacc,intento)
	        if(intento.eq.1)then
                atmptcb = atmptcb + 1.
	        endif  
	   else

	        write(3,*) 'gimove larger than 1?'

	   end if


	end do

c *** tentativa de cambio de volumen

	if (inpt.eq.1) then

           call volume_move(seed,vacc)
            
	   atmptvo = atmptvo + 1.
           
	end if


c_________________________________________________________________________
C Solo en caso de que haya estudio de nucleacion se hace lo siguiente:
	IF(inucleacion.eq.1)THEN
	
	 icontanuc=icontanuc+1
	 if(mod(icontanuc,npr).ne.0)goto 167
	
	 call q6q4q3q2dot(nclbignew)

	 atmptnuc=atmptnuc+1.
 
	 ebiasnew=0.5*rkbias*((float(nclbignew)-rnclcero)**2.)
	
	 !bfe=beta*(ebiasnew-ebias) !Con rkbias en KT no hace falta multiplicar por beta
	 bfe=ebiasnew-ebias !Con rkbias en KT no hace falta multiplicar por beta
	
       if (bfe.gt.70.000) then
         bft=0.0000000000
       else if (bfe.lt.-70.00000000) then
         bft=1.1
       else
         bft=exp(-bfe)
       endif 
	
	 aln=ranf(seed)
	
	 if(bft.gt.aln)then
	   rnucacc=rnucacc+1.
	   ebias=ebiasnew
	   nclbig=nclbignew
	   call saveconf       
	 else
	   call restoreconf          
	 endif
	
	 if(ntot.gt.neq)then
	   nhistoclbig(nclbig)=nhistoclbig(nclbig)+1
	   histoclbigunb(nclbig)=histoclbigunb(nclbig)+
     >     1./exp(-beta*ebias)
	   sumexpbias=sumexpbias+1./exp(-beta*ebias)
	 endif

! Escribo lo mas importante de la nucleaci�n (salvolosmuebles):
	  
	 if(mod(ntot,1000).eq.0)then

	  nfile=nfile+1000

!          Escribo AG(n)

	  nt=0
	  do ij=1,nmmax 
	    nt=nt+nhistoclbig(ij)
	  enddo

	  do iy=1,nmmax 
	   rprob=float(nhistoclbig(iy))/float(nt)
	   if(nhistoclbig(iy).ne.0)then
	    !ag=-log(rprob)-beta*rkbias/2.*(float(iy)-rnclcero)**2.
	    ag=-log(rprob)-rkbias/2.*(float(iy)-rnclcero)**2.
	    write(nfile,*)iy,ag,rprob,ntot   
	   endif                    
	  enddo

!          Escribo la configuraci�n

	  open(69,file='lastconfig.dat')
	  rewind(69)
	write(69,*)'Paso',ntot

        numdesites=0
 
        do i8=1,ntipmol
         numdesites=nmol(i8)*nsites(i8)+numdesites
        enddo

        do ique=1,numdesites
           write(69,*) xa(ique),ya(ique),za(ique)
        end do
c
        do ique=1,3
         write(69,*)h(ique,1),h(ique,2),h(ique,3)
        end do

 	 endif


	ENDIF
!_______________!Fin de nucleacion
c_________________________________________________________________________


	 IF(iumbrella.eq.1)THEN !SOLO UMBRELLA
c CALCULO AHORA LA ENERGiA DEL SISTEMA CON POTENCIAL REAL:
c *** inicializando linked-list

      call make_cell_map(sidea,sideb,sidec,cutoff)

      call make_link_list(natoms)

c *** calculo de la energia de la configuracion (intermolecular) inicial

      call sysenergy(utotreal,iax)

c filtro de solapamiento en caso de modelo duro
c      if(iax.eq.1)then    !duro
c	expone_i=0.         !duro
c      goto 161            !duro
c      endif !duro

c*** Calculamos la energia intramolecular de la configuracion inicial,
c*** para ello se necesitan las coordenadas cartesianas de las moleculas.

        Uintranew=0.0
        do im=1,nmoltot

           ic=class(im)
           numori=puntero1(ic)+(im-1-puntero2(ic))*nsites(ic)
          do is=1,nsites(ic)
           i101=i101+1
             numsite=numori+is
             xtcart(is)=xa(numsite)*h(1,1)+ya(numsite)*h(1,2)
     >                                  +za(numsite)*h(1,3)
             ytcart(is)=xa(numsite)*h(2,1)+ya(numsite)*h(2,2)
     >                                  +za(numsite)*h(2,3)
             ztcart(is)=xa(numsite)*h(3,1)+ya(numsite)*h(3,2)
     >                                  +za(numsite)*h(3,3)
          end do

          sumamol=0.000
          do in=1,nsites(ic)-1
               call intramol(in,1,xtcart(in),ytcart(in),
     >            ztcart(in),nsites(ic),xtcart,ytcart,ztcart
     >           ,wintra,numori,energint,ulji)
               sumamol=sumamol+energint 
          enddo
          Uintranew=Uintranew+sumamol 

        enddo
        
      eint_o=uintranew

c*** Calculamos el término de superficie
	surface=0.
	if(iewald.eq.1)then
        i101=0
        qrxsuma=0.
        qrysuma=0.
        qrzsuma=0.
      pi=acos(-1.0000000) 
        
        do im=1,nmoltot

           ic=class(im)
           numori=puntero1(ic)+(im-1-puntero2(ic))*nsites(ic)
       
          do is=1,nsites(ic)
           i101=i101+1
             numsite=numori+is
             xtcart(is)=xa(numsite)*h(1,1)+ya(numsite)*h(1,2)
     >                                  +za(numsite)*h(1,3)
             ytcart(is)=xa(numsite)*h(2,1)+ya(numsite)*h(2,2)
     >                                  +za(numsite)*h(2,3)
             ztcart(is)=xa(numsite)*h(3,1)+ya(numsite)*h(3,2)
     >                                  +za(numsite)*h(3,3)

            qrx=cargatom(i101)*xtcart(is)
            qry=cargatom(i101)*ytcart(is)
            qrz=cargatom(i101)*ztcart(is)

            qrxsuma=qrxsuma+qrx
            qrysuma=qrysuma+qry
            qrzsuma=qrzsuma+qrz
            
          end do
        enddo
      sumqr2=qrxsuma**2.+qrysuma**2.+qrzsuma**2.
      surface=2.*pi/(3.*vol)*sumqr2
	endif
	
c *** reponiendo la link-cell-list

      call make_link_list(natoms)

c*** calculo la energía iónica de espacio recíproco

      ufold=0.
      if(iewald.eq.1)then 
      call ufourier(h,ufcalculo)
      ufold=ufcalculo
      endif

c*** calculo el self-term      
      
      self=0. 
      if(iewald.eq.1)then
      pi=acos(-1.0000000) 
      self=-alfa/sqrt(pi)*sumaq2
      endif

      ulong=ulrtot*rho*float(nmoltot) 
      u_current=beta*(utotreal+ufold+eint_o+self+ulong)

	diff_u=u_current-u_inicial
	
	expone_i=exp(-diff_u)

 161  expotot=expotot+expone_i
 	exposub=exposub+expone_i
	
	ENDIF      !FIN SOLO UMBRELLA

	ENDIF    !fin de movimientos tipo MC (no BD)
c

 	 if(ibrownian.eq.1)then 
         call browniandynamics(seed)

	  if (inpt.eq.1) then
           if(mod(ntot,10).eq.0)then
            call volume_move(seed,vacc)
	    atmptvo = atmptvo + 1.
           endif
	  end if

	 endif
	 
c ********************************************
c *** acumulando promedios
c ***

      voltot=voltot+vol/part
      volsub=volsub+vol/part
      rhotot=rhotot+part/vol
      RHO2TOT=RHO2TOT+(PART/VOL)**2
      rhosub=rhosub+part/vol
      UCONFI=UTOT/PART
      UNKTTOT=UNKTTOT+UCONFI
      UNKTSUB=UNKTSUB+UCONFI

	u_ljktot=u_ljktot+u_lj
	u_ljksub=u_ljksub+u_lj
     
       ebiasktot=ebiasktot+ebias
       ebiasksub=ebiasksub+ebias
 
ccccccccccccccccccccccccccccccccccccccccc
c Nuevos acumuladores de energia de Einstein
      sumat=0.00
      sumarr=0.00
	sumars=0.00
      do ip=1,nmoltot
      sumat=sumat+ulatt(ip)
      sumarr=sumarr+ulatrr(ip)
	sumars=sumars+ulatrs(ip)
      end do

      UCONFIet=sumat/float(nmoltot)
      UNKTTOTet=UNKTTOTet+UCONFIet
      UNKTSUBet=UNKTSUBet+UCONFIet
c
      UCONFIerr=sumarr/float(nmoltot)
      UNKTTOTerr=UNKTTOTerr+UCONFIerr
      UNKTSUBerr=UNKTSUBerr+UCONFIerr

      UCONFIers=sumars/float(nmoltot)
      UNKTTOTers=UNKTTOTers+UCONFIers
      UNKTSUBers=UNKTSUBers+UCONFIers

cccccccccccccccccccccccccccccccccccc

      do 10 i=1,3
      do 11 j=1,3
      subh(i,j)=subh(i,j)+h(i,j)
      toth(i,j)=toth(i,j)+h(i,j)
   11 continue
   10 continue
c
c      call order1(so)
c New order parameter from Carl
      call order2(so)
      sotot=sotot+so
      sosub=sosub+so
c Translational order parameter
c
      call order
c
      sl1tot=sl1tot+sl1
      sl1sub=sl1sub+sl1
c
      sl2tot=sl2tot+sl2
      sl2sub=sl2sub+sl2
c
      sl3tot=sl3tot+sl3
      sl3sub=sl3sub+sl3
C ANALIZANDO LA FUNCION DE DISTRIBUCION DE VOLUMENES A UNA P DADA
      IF (NTOT.GT.NEQ) THEN
      IRO=INT( RHO/drho)+1
      CONTARO(IRO)=CONTARO(IRO)+1.
      ENDIF 

      if (ntot.eq.neq) then

        voltot=0.0
        rhotot=0.0
        UNKTTOT=0.0
	  u_ljktot=0.0
	 ebiasktot=0. 
        RHO2TOT=0.0
	  vacctot=0.
	  cacctot=0.
	  racctot=0.
	  tiacctot=0.
	  cbacctot=0.
	  atmptcmtot=0.
	  atmptrotot=0.
	  atmptvotot=0.
	  atmptinttot=0.
	  atmptcbtot=0.
	  atmptnuctot=0. 
         sotot=0.0
         sl1tot=0.0
         sl2tot=0.0
         sl3tot=0.0
	 R1ntot=0.0
	 R1nvtot=0.0
	 unkttotet=0.
	 unkttoterr=0.
	 unkttoters=0.
         expotot=0.

c
         do i=1,3
         do j=1,3
            toth(i,j)=0.0
         end do
         end do

	   cacc = 0.
	   racc = 0.
           tiacc = 0.
	   biacc = 0.
	   vacc = 0.
	   rnucacc = 0.

	   atmptcm = 0.
	   atmptro = 0.
           atmptint= 0.
	   atmptvo = 0.
	   atmptcb = 0. 
	   atmptnuc=0. 

           if((inucleacion.eq.1).or.(iunbias.eq.1))then 
        
!          rkbias=0.15/beta

c Inicializacion del histograma de q6 y q4 
	if(ibucle.eq.1)then
          do io=-100,100
           nhistoq6(io)=0
           nhistoq4(io)=0
	   nhistoq3(io)=0
           nhistoq2(io)=0
          enddo
c Contador de productos escalares q6q6 y q4q4
          nnormal=0
 
c Inicializacion del histograma de numero de vecinos de nucleacion
c Inicializacion del histograma del cluster mas grande
c Inicializacion del histograma de tamanno de clusters
c Inicializaciond del histograma del numero de conexiones por particula
          do ip=0,nmmax 
           nvecinostot(ip)=0
            enddo

            do ip=1,nmmax 
           nhistoclbig(ip)=0
            enddo

            do ip=0,nmmax
           nhistoclus(ip)=0
            enddo

            do ip=0,nmmax
             nhistoconex(ip)=0
            enddo

	endif  !if del ibucle 1
           endif  !if del inucleacion 1


      end if    !if del equilibrado

c
3000  if(mod(ntot,npr).eq.0) then 
	 if((iwidom.eq.1).and.(ntot.ge.neq))then
	  call widom(seed)
	 endif

         if(iunbias.eq.1)then
          if(ntot.gt.neq)then
          call q6q4q3q2dot(nclbignew)
            nhistoclbig(nclbignew)=nhistoclbig(nclbignew)+1
            nclusters=nclusters+1
          endif
	  if(iffs.eq.1)call ffsrutine(seed)  
         endif

!Escribe la configuracion si toca
!(Si toca o no, depende de si se escribe lineal o logaritmicamente)
       if(iwrmode.eq.1)then

        rrr=float(ntot)
        if(log(rrr).ge.rnpwr*(float(iwr)))then
         call escribeconf(seed) !Escribe la conf
         !call xyztorasmol
         iwr=iwr+1
        endif

       elseif(iwrmode.eq.0)then

        if(mod(ntot,npwr).eq.0)then 
	 call escribeconf(seed) !Escribe la conf
         !call xyztorasmol
        endif

       endif

	 return
	endif
	
c
      if(ntot.eq.nmax) return


      go to 1000
c
      end


c **********************************************************
c *** Subrutina para la realizacion de un movimiento
c ***    de MonteCarlo del centro de traslacion
c ***
c *** Accion: Escoge una molecula al azar, intenta un
c ***         mvt de traslacion, lo acepta de acuerdo
c ***         a las reglas de Metropolis-MC, actualizando
c ***         la tasa de aceptacion, la energia, las coordenadas 
c ***         y la linked-cell list si se acepta el movimiento,
c ***         asi como el desplazamiento relativo a la posicion 
c ***		  original
c ***
c *** Condiciones:
c ***
c ***   1. Calculo de la energia adaptado a la linked-cell list
c ***   2. Coordenadas atomicas en unidades de caja
c ***   3. Solo valida para cajas ortogonales (pero los lados
c ***      pueden ser diferentes)   
cj **      cambiado a cajas no ortogonales  
c ***
c *** Entrada:
c ***
c *** A. como argumentos:
c ***
c ***  1. seed : numero semilla
c ***  2. sidea, sideb, sidec : longitud de las aristas de la caja
c ***					  en unidades de longitud
c ***  3. accpt : numero de mvts de traslacion aceptados antes de
c ***             entrar en la rutina
c ***  4. utot  : energia total del sistema antes del intento de
c ***		      movimiento, en unidades de kT
c ***
c *** B. como commons:
c ***
c ***  1. /atoms/  : coordenadas atomicas en unidades de caja
c ***  2. /msqdis/ : desplazamiento del centro de masas de las moleculas
c ***                relativo a su posicion original, en unidades de
c ***                longitud
c ***  3. /params/ : algunos datos necesarios:
c *** 
c ***	    i. beta  : inverso de la temperatura
c ***     ii. nmoltot : numero total de moleculas en el sistema
c ***
c ***  4. /geometry/ : 
c ***
c ***     i. nsites : numero de centros de interaccion por molecula
c ***
c ***  5. /delta/   : 
c ***
c ***     i. pshift : valor maximo del desplazamiento centro de masa
c ***  
c ***
c *** Salida :
c ***
c *** 1. como argumentos :
c ***
c ***   1. accpt : numero de mvts de centro de masa aceptados 
c ***   2. utot  : energia total del sistema, en unidades de kT
c ***
c *** 2. como common :
c ***
c ***   1. /atoms/  : coordenadas atomicas actualizadas en unidades
c ***                 de caja 	
c ***   2. /msqdis/ : desplazamiento del centro de masa de la molecula
c ***                 relativo a la posicion original en unidades de 
c ***                 longitud, actualizado.
c ***       
c ************************************************************


	subroutine cm_move(seed,accpt)

        include 'parametros_NpT.inc'
	include 'common.inc'

       dimension xatn(nsmax),yatn(nsmax),zatn(nsmax)
       dimension xato(nsmax),yato(nsmax),zato(nsmax)
       dimension csmemo(mxvct),snmemo(mxvct)
	 
        

	uiold=0.
	uinew=0.

c*** La llamada a cewmc machaca los valores de cssum y snsum por
c*** lo que los grabamos en memoria por si hay rechazo:

       if(iewald.eq.1)then
         do k = 1, maxvec
         csmemo(k) = cssum(k) 
         snmemo(k) = snsum(k) 
         enddo
	endif
	
c *** eleccion de una molecula al azar
      imol = int(nmoltot*ranf(seed)) + 1
      if (imol.gt.nmoltot) imol=nmoltot
	
ccj2  hay que saber que tipo de molecula es
        ic=class(imol)
	
c *** sacando esta molecula de la lista
      call take_outof_list(imol,ic)
	
c *** volcando las coordenadas de la molecula imol sobre las coordenadas
c *** de prueba    
      numori=puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)

      do is=1,nsites(ic)
	   numsite=numori+is
         xato(is)=xa(numsite)
         yato(is)=ya(numsite)
         zato(is)=za(numsite)
      end do

      dx=pshift*(2.0*ranf(seed)-1.0)/sidea
      dy=pshift*(2.0*ranf(seed)-1.0)/sideb
      dz=pshift*(2.0*ranf(seed)-1.0)/sidec

c *** calculando las coordenadas de la configuracion tentativa
      do is=1,nsites(ic)
         xatn(is)=xato(is)+dx
         yatn(is)=yato(is)+dy
         zatn(is)=zato(is)+dz
      end do

	IF(iumbrella.eq.0)THEN

C$OMP PARALLEL
C$OMP SECTIONS
C$OMP SECTION
c *** calculo de la energia de la conformacion original
      call inter_molecular1(xato,yato,zato,imol,ic,Uiold,iaxo,uljo)
C$OMP SECTION
      call inter_molecular1(xatn,yatn,zatn,imol,ic,Uinew,iaxn,uljn)
C$OMP END SECTIONS
C$OMP END PARALLEL

c *** calculando diferencia de energia entre conformaciones
c ... en espacio real:
c          if(iaxo.eq.1)then       ! duro
c         print*,'configuracion con solapamiento aceptada' !  duro
c                  stop      ! duro
c          endif             ! duro 
c           if(iaxn.eq.1)goto 323 ! duro 

c Cambio en la energí LJ del sistema:
      u_ljtrial=u_lj-uljo+uljn
	
	ENDIF

      deltau=UiNEW-UiOLD 

        deltaf=0.000000
	ufnew=0.
      if (iewald.eq.1) then 

c Calculando cambio de energia en la componente de Fourier
c Se van moviendo los atomos cargados de la molecula uno, a uno
c La subrutina ewmc va cambiando los valores de cssum y snsum
c de modo automatico

      do is=1,nsites(ic)
         numsite=numori+is
         xold=xato(is)
         yold=yato(is)
         zold=zato(is)
         xnew=xatn(is)
         ynew=yatn(is)
         znew=zatn(is)
         call cewmc(numsite,xold,yold,zold,xnew,ynew,znew,ufnew)
      end do
c Diferencia de energias en espacio de fourier 
      deltaf=ufnew-ufold 
      endif 

	if(iumbrella.eq.1)then
	deltaf=0.
	endif

c Calculo de la contribución a la energía de cristal 
c tipo Einstein. 

      deleins=0.

      if(ifree.eq.1)then

      dxcar=h(1,1)*dX+h(1,2)*dY+h(1,3)*dZ
      dycar=h(2,1)*dX+h(2,2)*dY+h(2,3)*dZ
      dzcar=h(3,1)*dX+h(3,2)*dY+h(3,3)*dZ

      dxfren=xcentro(imol)-redx(imol)-dxcm
      dyfren=ycentro(imol)-redy(imol)-dycm
      dzfren=zcentro(imol)-redz(imol)-dzcm

      dxfrencar=h(1,1)*dxfren+h(1,2)*dyfren+h(1,3)*dzfren
      dyfrencar=h(2,1)*dxfren+h(2,2)*dyfren+h(2,3)*dzfren
      dzfrencar=h(3,1)*dxfren+h(3,2)*dyfren+h(3,3)*dzfren

      contri1=2.*(dxfrencar*dxcar+dyfrencar*dycar+dzfrencar*dzcar)
	contri2=((part-1.)/part)*(dxcar*dxcar+dycar*dycar+dzcar*dzcar)

	deleins=xlan1*(contri1+contri2)
      endif  


c Diferencia total de energia , suma de componente
c de espacio real y de espacio reciproco
c y de cristal de einstein si procede
c y criterio metrópolis de aceptación

      deltab=Beta*(deltau+deltaf)+deleins

       if (deltab.gt.70.000) then
         ratio=0.0000000000
       else
           if (deltab.lt.-70.00000000) then
           ratio=1.1
           else
           ratio = exp(-deltab)
           endif
       endif

	trial = ranf(seed)

c*****************************************       
c*** actualizaciones en caso de aceptacion

        IF (trial.le.ratio) THEN
         accpt=accpt+1.0
         utot=utot+deltab
         ufold=ufnew
	   u_lj=u_ljtrial
         do is=1,nsites(ic)
	    numsite=numori+is
            xa(numsite)=xatn(is)
            ya(numsite)=yatn(is)
            za(numsite)=zatn(is)
         end do
	
         tx=dx
         ty=dy
         tz=dz
ccj
         txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
         typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
         tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
         dx1=txp
         dy1=typ
         dz1=tzp

         cdx(imol)=cdx(imol)+dx1
         cdy(imol)=cdy(imol)+dy1
         cdz(imol)=cdz(imol)+dz1
	   
	   if(ifree.eq.1)then
	     xcentro(imol)=xatn(1)
	     ycentro(imol)=yatn(1)
	     zcentro(imol)=zatn(1)

	     dxcm=dxcm+dx/part
	     dycm=dycm+dy/part
	     dzcm=dzcm+dz/part

	     ueinsold=ueinsold+deleins

	     ulatt(imol)=ulatt(imol)+deleins
	   endif

        ELSE

c Los valores actuales del espacio recíproco son los de la 
c configuración trial,por lo que en caso de rechazo hay que 
c deshacer el entuerto:

        if (iewald.eq.1) then 
         do k = 1, maxvec
           cssum(k)=csmemo(k)
           snsum(k)=snmemo(k)
         enddo
        endif


        END IF

c *** incluyendo la molecula en la lista
 323    call put_in_list(imol,ic)

 	return
	end
	
c **********************************************************
c *** Subrutina para la realizacion de un movimiento
c ***    de MonteCarlo del rotacion
c ***
c *** Accion: Escoge una molecula al azar, intenta un
c ***         mvt de rotacion, lo acepta de acuerdo
c ***         a las reglas de Metropolis-MC, actualizando
c ***         la tasa de aceptacion, la energia, las coordenadas
c ***         y la linked-cell list si se acepta el movimiento.
c ***
c *** Condiciones:
c ***
c ***   1. Calculo de la energia adaptado a la linked-cell list
c ***   2. Coordenadas atomicas en unidades de caja
c ***   3. Solo valida para cajas ortogonales (pero los lados
c ***      pueden ser diferentes)
c ***
c *** Entrada:
c ***
c *** A. como argumentos:
c ***
c ***  1. seed : numero semilla
c ***  2. sidea, sideb, sidec : longitud de las aristas de la caja
c ***                           en unidades de longitud
c ***  3. accpt : numero de mvts de traslacion aceptados antes de
c ***             entrar en la rutina
c ***  4. utot  : energia total del sistema antes del intento de
c ***             movimiento, en unidades de kT
c ***
c *** B. como commons:
c ***
c ***  1. /atoms/  : coordenadas atomicas en unidades de caja
c ***  3. /params/ : algunos datos necesarios:
c ***
c ***     i. beta  : inverso de la temperatura
c ***     ii. nmol : numero total de moleculas en el sistema
c ***     iii. pi2 : dos veces pi
c ***
c ***  4. /geometry/ :
c ***
c ***     i. nsites : numero de centros de interaccion por molecula
c ***
c ***  5. /delta/   :
c ***
c ***     i. ashift : valor maximo del desplazamiento angular en tanto
c ***                 por uno (es decir, el maximo desplazamiento 
c ***                 angular posible es 2*pi*ashift)
c ***
c *** Salida :
c ***
c *** 1. como argumentos :
c ***
c ***   1. accpt : numero de mvts de centro de masa aceptados
c ***   2. utot  : energia total del sistema, en unidades de kT
c ***
c *** 2. como common :
c ***
c ***   1. /atoms/  : coordenadas atomicas actualizadas en unidades
c ***                 de caja
c ***
c ************************************************************

      subroutine rot_move(seed,accpt)

	include 'parametros_NpT.inc'
	include 'common.inc'


      dimension xbo(nsmax),ybo(nsmax),zbo(nsmax)
      dimension xbt(nsmax),ybt(nsmax),zbt(nsmax)
      dimension ai(3,3),xc(3)
       dimension xatn(nsmax),yatn(nsmax),zatn(nsmax)
       dimension xato(nsmax),yato(nsmax),zato(nsmax)
       dimension csmemo(mxvct),snmemo(mxvct)


      

	uinew=0.
	uiold=0.

c*** La llamada a cewmc machaca los valores de cssum y snsum por
c*** lo que los grabamos en memoria por si hay rechazo:

       if(iewald.eq.1)then
         do k = 1, maxvec
         csmemo(k) = cssum(k) 
         snmemo(k) = snsum(k) 
         enddo
	endif
	
c *** eleccion de una molecula al azar

c Change mixtures 24
 231  imol = int(nmoltot*ranf(seed)) + 1
      if (imol.gt.nmoltot) imol=nmoltot
      ic=class(imol)

      if(nsites(ic).eq.1)goto 231

c *** sacando esta molecula de la lista
  
      call take_outof_list(imol,ic)
cl      call take_outof_list(imol,nsites)

c *** eleccion de un site al azar sobre el que rotar

	isiterot = int(nsites(ic)*ranf(seed)) + 1
 	if (isiterot.gt.nsites(ic)) isiterot=nsites(ic)

	if(ifree.eq.1)isiterot=1

	isiterot=1

c *** volcando las coordenadas de la molecula imol sobre las coordenadas
c *** de prueba

      numori=puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)

      do is=1,nsites(ic)
	 numsite=numori+is
         xato(is)=xa(numsite)
         yato(is)=ya(numsite)
         zato(is)=za(numsite)
      end do

c *** calculando las coordenadas relativas al sitio de rotacion

      xatref = xato(isiterot)
      yatref = yato(isiterot)
      zatref = zato(isiterot)

c *** nota: la rotacion se tiene que hacer en unidades absolutas
c ***       De lo contrario (unidades de caja) se distorsiona la
c ***       molecula

c Julio change number 5
       do is=1,nsites(ic)
       tx=(xato(is)-xatref)
       ty=(yato(is)-yatref)
       tz=(zato(is)-zatref)
ccj
       txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
       typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
       tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
       xbo(is)=txp
       ybo(is)=typ
       zbo(is)=tzp
       end do   
c ********************************
c *** rotando la molecula imol

c ***  1. select a randomly chosen unit vector

         call rnd_sphere(xc,seed)

c ***  2. select a randomly chosen angle of rotation

         gi=pi2*ashift*ranf(seed)

c ***  3. rotate the molecule around the chosen vector

         call magiro(xc,gi,ai)

c *** calculando los desplazamientos angulares
c Julio change number 6

c Change mixtures 26
      do is=1,nsites(ic)
ccj
      tinvx=(ai(1,1)*xbo(is)+ai(1,2)*ybo(is)+ai(1,3)*zbo(is))
      tinvy=(ai(2,1)*xbo(is)+ai(2,2)*ybo(is)+ai(2,3)*zbo(is))
      tinvz=(ai(3,1)*xbo(is)+ai(3,2)*ybo(is)+ai(3,3)*zbo(is))
ccj
      tinvxp=hinv(1,1)*tinvx+hinv(1,2)*tinvy+hinv(1,3)*tinvz
      tinvyp=hinv(2,1)*tinvx+hinv(2,2)*tinvy+hinv(2,3)*tinvz
      tinvzp=hinv(3,1)*tinvx+hinv(3,2)*tinvy+hinv(3,3)*tinvz
ccj
      xbt(is)=tinvxp
      ybt(is)=tinvyp
      zbt(is)=tinvzp
ccj
      end do


c *** calculando las coordenadas de la configuracion tentativa

      do is=1,nsites(ic)
         xatn(is)=xatref+xbt(is)
         yatn(is)=yatref+ybt(is)
         zatn(is)=zatref+zbt(is)
      end do


	if(iumbrella.eq.1)goto 565
c *********************************
c CALCULO DE LA DIFERENCIA DE ENERGÍAS

C$OMP PARALLEL
C$OMP SECTIONS
C$OMP SECTION
c *** calculo de la energia para la antigua posicion de la molec.
      call inter_molecular1(xato,yato,zato,imol,ic,Uiold,iaxo,uljo)
C$OMP SECTION
c *** calculo de la energía para la nueva posición de la molec.
      call inter_molecular1(xatn,yatn,zatn,imol,ic,Uinew,iaxn,uljn)
C$OMP END SECTIONS
C$OMP END PARALLEL
c           if(iaxo.eq.1)then   ! duro
c           print*,'configuracion con solapamiento aceptada' !duro
c           stop    ! duro
c           endif  ! duro
c           if(iaxn.eq.1) goto 323  ! duro
 
c *** calculando diferencia de energia entre conformaciones
c

c Cambio en la energí LJ del sistema:
      u_ljtrial=u_lj-uljo+uljn

 565      deltau=UiNEW-UiOLD 

c Calculando cambio de energia en la componente de Fourier
c Se van moviendo los atomos cargados de la molecula uno, a uno
c La subrutina ewmc va cambiando los valores de cssum y snsum
c de modo automatico
        deltaf=0.000000
	ufnew=0. 
      if (iewald.eq.1) then 
      do is=1,nsites(ic)
	 numsite=numori+is
         xold=xato(is)
         yold=yato(is)
         zold=zato(is)
         xnew=xatn(is)
         ynew=yatn(is)
         znew=zatn(is)
         call cewmc(numsite,xold,yold,zold,xnew,ynew,znew,ufnew)
      end do
c Diferencia de energias en espacio de fourier 
      deltaf=ufnew-ufold 
      endif 

	if(iumbrella.eq.1)deltaf=0.
c Diferencia de energía debida al cambio de orientacion
c respecto a la que tenía la molécula en el  cristal de 
c Einstein de mínima energía:

	deleins=0.
	if(ifree.eq.1)then
	  call uorientacional(xatn,yatn,zatn,imol,usuma,uresta)
	  deleins=usuma+uresta-ulatrr(imol)-ulatrs(imol)
	endif

c
c Diferencia total de energia , suma de componente
c de espacio real y de espacio reciproco
c
      deltab=Beta*(deltau+deltaf)+deleins

C ********************************************************************
C APLICACION DEL CRITERIO METRÓPOLIS PARA LA ACEPTACION DEL MOVIMIENTO

       if (deltab.gt.70.000) then
         ratio=0.0000000000
       else
           if (deltab.lt.-70.00000000) then
           ratio=1.1
           else
           ratio = exp(-deltab)
           endif
       endif

	trial = ranf(seed)

c********************************************************************
c*** actualizaciones en el caso de que se haya aceptado el movimiento
	IF (trial.le.ratio) THEN
         accpt=accpt+1.0
         utot=utot+deltab
         ufold=ufnew
	   u_lj=u_ljtrial
         do is=1,nsites(ic)
	    numsite=numori+is
            xa(numsite)=xatn(is)
            ya(numsite)=yatn(is)
            za(numsite)=zatn(is)
         end do
	     
	   if(ifree.eq.1)then
	     ulatrr(imol)=uresta
	     ulatrs(imol)=usuma
	      	
	     vrhx(imol)=vxnorr
	     vrhy(imol)=vynorr
	     vrhz(imol)=vznorr

	     vshx(imol)=vxnors
	     vshy(imol)=vynors
	     vshz(imol)=vznors
	     
	     ueinsold=ueinsold+deleins 
	   endif
	   
        ELSE
c Rechazo:
c Los valores actuales del espacio recíproco son los de la 
c configuración trial,por lo que en caso de rechazo hay que 
c deshacer el entuerto:

       if (iewald.eq.1) then 
         do k = 1, maxvec
           cssum(k)=csmemo(k)
           snsum(k)=snmemo(k)
         enddo
        endif

        ENDIF

 323    call put_in_list(imol,ic)

  	return
	end


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c   SUBRUTINA PARA INTERCAMBIAR DOS IONES

	subroutine intercambio(seed,acc)
	
      include 'parametros_NpT.inc'
      include 'common.inc'
	dimension recx(natmax),recy(natmax),recz(natmax)
	dimension csmemo(mxvct),snmemo(mxvct)
	dimension xtcart(nsmax),ytcart(nsmax),ztcart(nsmax)
	dimension xato(nsmax),yato(nsmax),zato(nsmax)
	dimension xatn(nsmax),yatn(nsmax),zatn(nsmax)

c Salvo variables 

      if(iewald.eq.1)then
         maxmemo=maxvec
         do k = 1, maxvec
         csmemo(k) = cssum(k)
         snmemo(k) = snsum(k)
         enddo
      endif

      utoto=utot
      u_ljo=u_lj

      do is=1,natoms
         recx(is)=xa(is)
         recy(is)=ya(is)
         recz(is)=za(is)
      end do


c Elegimos 2 iones 
c     chantal sett 2011: WATCH OUT BECAUSE ntipmolmax=1 in parametros_NpT.inc
	nions=nmol(2)

      ion1 = int(nions*ranf(seed)) + 1
      if (ion1.gt.nions) ion1=nions

      ion2 = int(nions*ranf(seed)) + 1
      if (ion2.gt.nions) ion2=nions

!indices de site
	!ind1=nmol(1)*nsites(1)+ion1
	!ind2=nmol(1)*nsites(1)+nions+ion2
	
	 ind1=ion1
	 ind2=nions+ion2
	
!indices de molecula
	!indmol1=nmol(1)+ion1
	!indmol2=nmol(1)+nmol(2)+ion2
	
	 indmol1=ion1
	 indmol2=nmol(1)+ion2

	 
!En el caso de mezclas AB de iones los indices in1 e ind2 coinciden con los
!indmol1 e indmol2 respectivamente. Se ha modificado lo menos posible la version
!pensada para intercambio de posicion de dos iones de una disolucion aquosa, 	
!para lo que se deberian descomentar los dos pares de lineas comentadas
!y comentar las descomentadas

c Calculamos la energ�a de las dos part�culas en 
c sus posiciones viejas

	!call take_outof_list(indmol1,2)
	call take_outof_list(indmol1,1)
	xato(1)=xa(ind1)
	yato(1)=ya(ind1)
	zato(1)=za(ind1)
      !call inter_molecular1(xato,yato,zato,indmol1,2,Uiold1,iaxo,uljo1)
      call inter_molecular1(xato,yato,zato,indmol1,1,Uiold1,iaxo,uljo1)
	!call put_in_list(indmol1,2)
	call put_in_list(indmol1,1)

	!call take_outof_list(indmol2,3)
	call take_outof_list(indmol2,2)
	xato(1)=xa(ind2)
	yato(1)=ya(ind2)
	zato(1)=za(ind2)
      !call inter_molecular1(xato,yato,zato,indmol2,3,Uiold2,iaxo,uljo2)
      call inter_molecular1(xato,yato,zato,indmol2,2,Uiold2,iaxo,uljo2)
	!call put_in_list(indmol2,3)
	call put_in_list(indmol2,2)


	uoldtwoions=uiold1+uiold2+ufold


c Cambiamos las coordenadas
        xsec=xa(ind1)
        ysec=ya(ind1)
        zsec=za(ind1)

        xa(ind1)=xa(ind2)
        ya(ind1)=ya(ind2)
        za(ind1)=za(ind2)

        xa(ind2)=xsec
        ya(ind2)=ysec
        za(ind2)=zsec



c Calculamos la energ�a de las dos part�culas con las
c nuevas posiciones

      call make_cell_map(sidea,sideb,sidec,cutoff)
      call make_link_list(natoms)

      !call take_outof_list(indmol1,2)
      call take_outof_list(indmol1,1)
      xatn(1)=xa(ind1)
      yatn(1)=ya(ind1)
      zatn(1)=za(ind1)
      !call inter_molecular1(xatn,yatn,zatn,indmol1,2,Uinew1,iaxo,uljn1)
      call inter_molecular1(xatn,yatn,zatn,indmol1,1,Uinew1,iaxo,uljn1)
      !call put_in_list(indmol1,2)
      call put_in_list(indmol1,1)

      !call take_outof_list(indmol2,3)
      call take_outof_list(indmol2,2)
      xatn(1)=xa(ind2)
      yatn(1)=ya(ind2)
      zatn(1)=za(ind2)
      !call inter_molecular1(xatn,yatn,zatn,indmol2,3,Uinew2,iaxo,uljn2)
      call inter_molecular1(xatn,yatn,zatn,indmol2,2,Uinew2,iaxo,uljn2)
      !call put_in_list(indmol2,3)
      call put_in_list(indmol2,2)

	u_ljtrial=u_lj+uljn1+uljn2-uljo1-uljo2


      ufnew=0.00000
c
      if (iewald.eq.1) then
      call ufourier(h,ufcalculo)
      ufnew=ufcalculo
      endif

      unewtwoions=uinew1+uinew2+ufnew

      
c Se acepta o rechaza conforme a criterio Metropolis

	rboltz1=beta*(unewtwoions-uoldtwoions)
	
c
       if (rboltz1.gt.70.000) then
         rboltz=0.0000000000
       else
           if (rboltz1.lt.-70.00000000) then
           rboltz=1.1
           else
           rboltz = exp(-rboltz1)
           endif
       endif


      test=ranf(seed)

c *** ACEPTACION:

      if(rboltz.gt.test) then
	
	acc=acc+1
      utot=utoto+beta*(unewtwoions-uoldtwoions)
      ufold=ufnew
	!u_lj=u_ljinter+u_ljintra
	   u_lj=u_ljtrial

       else     

c *** RECHAZO:  

      do is=1,natoms
         xa(is)=recx(is)
         ya(is)=recy(is)
         za(is)=recz(is)
      end do

       if (iewald.eq.1) then 
	   maxvec=maxmemo
         do k = 1, maxvec
           cssum(k)=csmemo(k)
           snsum(k)=snmemo(k)
         enddo
        endif

	u_lj=u_ljo
      call make_cell_map(sidea,sideb,sidec,cutoff)
      call make_link_list(natoms)

      endif    


	if(iewald.eq.1)then
         call ewstup(h) 
	endif
	
	return
	end


	
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Subrutina que evalua la energía debida al desplazamiento orientacional
c de la molécula im con respecto a su orientación de mínima energía en 
c el cristal de einstein
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


	subroutine uorientacional(x,y,z,im,usuma,uresta)

	include 'parametros_NpT.inc'
	include 'common.inc'
	dimension x(nmmax),y(nmmax),z(nmmax)
   
 
	   xatomico=x(1)
           yatomico=y(1)
           zatomico=z(1)
 
           xatomico1=x(2)
           yatomico1=y(2)
           zatomico1=z(2)

           xatomico2=x(3)
           yatomico2=y(3)
           zatomico2=z(3)

           ox=h(1,1)*xatomico+h(1,2)*yatomico+h(1,3)*zatomico
           oy=h(2,1)*xatomico+h(2,2)*yatomico+h(2,3)*zatomico
           oz=h(3,1)*xatomico+h(3,2)*yatomico+h(3,3)*zatomico

           txp1=h(1,1)*xatomico1+h(1,2)*yatomico1+h(1,3)*zatomico1-ox
           typ1=h(2,1)*xatomico1+h(2,2)*yatomico1+h(2,3)*zatomico1-oy
           tzp1=h(3,1)*xatomico1+h(3,2)*yatomico1+h(3,3)*zatomico1-oz
	     
           txp2=h(1,1)*xatomico2+h(1,2)*yatomico2+h(1,3)*zatomico2-ox
           typ2=h(2,1)*xatomico2+h(2,2)*yatomico2+h(2,3)*zatomico2-oy
           tzp2=h(3,1)*xatomico2+h(3,2)*yatomico2+h(3,3)*zatomico2-oz
	     
           vxr=txp2-txp1
           vyr=typ2-typ1
           vzr=tzp2-tzp1
	     
           vxs=txp2+txp1
           vys=typ2+typ1
           vzs=tzp2+tzp1
	     
           vmodr=sqrt(vxr**2.+vyr**2.+vzr**2.)
	     
           vmods=sqrt(vxs**2.+vys**2.+vzs**2.)
c
           vxnorr=vxr/vmodr
           vynorr=vyr/vmodr
           vznorr=vzr/vmodr
c
           vxnors=vxs/vmods
           vynors=vys/vmods
           vznors=vzs/vmods

           per=vxnorr*vrhx_0(im)+vynorr*vrhy_0(im)+vznorr*vrhz_0(im)
           pes=vxnors*vshx_0(im)+vynors*vshy_0(im)+vznors*vshz_0(im)

           uresta=xlan2*(1.-per**2.)
           usuma=xlan2*(acos(pes)/pi)**2.
!	     usuma=0.
	return
	end
c ****************************************************************
c *** Subrutina NpT para el cambio de volumen
c **ic*

	subroutine volume_move(seed,accpt)

	include 'parametros_NpT.inc'
	include 'common.inc'

      dimension xtcart(nsmax),ytcart(nsmax),ztcart(nsmax)
      dimension recx(natmax),recy(natmax),recz(natmax)
      dimension dside(3),ai(3,3),xc(3)
      dimension csmemo(mxvct),snmemo(mxvct)

c
      

c la llamada a ufourier para calcular la energia
c en espacio reciproco de la configuracion nueva , machaca
c la suma de vectores en espacio reciproco de la configuracion
c antigua, por lo que conviene guardarlos por si se rechaza
c el trial move
c 
	
	
	if(iewald.eq.1)then
	   maxmemo=maxvec
         do k = 1, maxvec
         csmemo(k) = cssum(k) 
         snmemo(k) = snsum(k) 
         enddo
	endif
	
	
C
c CAMBIO DE VOLUMEN 
C
C SE INICIA TODO EL PROTOCOLO DE CAMBIO DE VOLUMEN
   
      utoto=utot
	u_ljo=u_lj

	
      hrun=pstar*vol
      volt=vol
      rsidea = sidea
      rsideb = sideb
      rsidec = sidec


c ******************************************
c *** cambios aleatoreos en la matriz h  
c ***
c Isotropic scaling for Ntot<Neq/2 
c Rahman-Parrinello for Ntot>Neq/2
c The following sentence is good only for solids
c
c      IF (NTOT.LE.NEQHAL) THEN
c          ISCALE=2
c          ELSE
c          ISCALE=0
c      ENDIF
c

C ****************************
c CAMBIO DE LAS DIMENSIONES DE LA CAJA
      if(iscale.eq.0) then
      do 6 i=1,3
      do 7 j=1,3
        fact=dela
        if(i.ne.j) fact=dela1
        ht(i,j)=h(i,j)
c Julio change number 7
        hinvt(i,j)=hinv(i,j)
        h(i,j)=h(i,j)+fact*(2.0*ranf(seed)-1.0)
    7 continue
    6 continue

c     change all the h elements by a random displacement
c
      else if(iscale.eq.1) then
c
      dside(1)=(sidea+dela*(2.0*ranf(seed)-1.0))/sidea
      dside(2)=(sideb+dela*(2.0*ranf(seed)-1.0))/sideb
      dside(3)=(sidec+dela*(2.0*ranf(seed)-1.0))/sidec
c
      do 15 i=1,3
      do 16 j=1,3
      ht(i,j)=h(i,j)
ccj Julio change number 8
      hinvt(i,j)=hinv(i,j)
      h(i,j)=h(i,j)*dside(j)
   16 continue
   15 continue
c
c     scale the box sides but preserve orientations
c
      else if(iscale.eq.2) then
c
      ddd=dela*(2.0*ranf(seed)-1.0)
      dside(1)=(sidea+ddd)/sidea
      dside(2)=dside(1)
      dside(3)=dside(1)

      do 17 i=1,3
      do 18 j=1,3
       ht(i,j)=h(i,j)
c Julio change number 9
       hinvt(i,j)=hinv(i,j)
       h(i,j)=h(i,j)*dside(j)
   18 continue
   17 continue

c     reescalado que respeta la tetragonalidad de sistemas a=b
c
      else if(iscale.eq.3) then
c
      ddd=dela*(2.0*ranf(seed)-1.0)
      dside(1)=(sidea+ddd)/sidea
      dside(2)=dside(1)

      dside(3)=(sidec+dela*(2.0*ranf(seed)-1.0))/sidec


      do  i=1,3
      do  j=1,3
       ht(i,j)=h(i,j)
c Julio change number 9
       hinvt(i,j)=hinv(i,j)
       h(i,j)=h(i,j)*dside(j)
      enddo   
      enddo   

      endif
c 

c Julio change number 10
ccj 
ccj     detH lo podemos cambiar por vol hay que recordar que en abs() 
      detH=h(1,1)*(h(2,2)*h(3,3)-h(2,3)*h(3,2))-h(2,1)*(h(1,2)*h(3,3)
     *-h(1,3)*h(3,2))+h(3,1)*(h(1,2)*h(2,3)-h(1,3)*h(2,2))
ccj
c
       hinv(1,1)=(h(2,2)*h(3,3)-h(2,3)*h(3,2))/detH
       hinv(2,1)=-(h(2,1)*h(3,3)-h(3,1)*h(2,3))/detH
       hinv(3,1)=(h(2,1)*h(3,2)-h(3,1)*h(2,2))/detH
       hinv(1,2)=-(h(1,2)*h(3,3)-h(3,2)*h(1,3))/detH
       hinv(2,2)=(h(1,1)*h(3,3)-h(3,1)*h(1,3))/detH
       hinv(3,2)=-(h(1,1)*h(3,2)-h(3,1)*h(1,2))/detH
       hinv(1,3)=(h(1,2)*h(2,3)-h(2,2)*h(1,3))/detH
       hinv(2,3)=-(h(1,1)*h(2,3)-h(2,1)*h(1,3))/detH
       hinv(3,3)=(h(1,1)*h(2,2)-h(2,1)*h(1,2))/detH

c ***
c *** find de cambios aleatorios en h
c *******************************************
c
c
c *** calculo de las nuevas aristas

      sidea=0.0
      sideb=0.0
      sidec=0.0
c
      do 14 i=1,3
      sidea=sidea+h(i,1)**2
      sideb=sideb+h(i,2)**2
      sidec=sidec+h(i,3)**2
   14 continue
c
      sidea=sqrt(sidea)
      sideb=sqrt(sideb)
      sidec=sqrt(sidec)

c *****************************************
c *** test de caja no demasiado pequenha
c ***
c  Comprobando que es imposible solapamiento entre una molecula 
c  central, y una imagen periodica DIFERENTE DE LA QUE ES LA 
C  IMAGEN PERIODICA CON RESPECTO AL CENTRO DE MASAS .
C
      VOL2=VOL*VOL
C
      H11=H(1,1)
      H12=H(1,2)
      H13=H(1,3)
      H21=H(2,1)
      H22=H(2,2)
      H23=H(2,3)
      H31=H(3,1)
      H32=H(3,2)
      H33=H(3,3)
C
      ABMOD2=(H21*H32-H22*H31)**2+(H11*H32-H12*H31)**2+
     1       (H11*H22-H12*H21)**2
      BCMOD2=(H22*H33-H23*H32)**2+(H12*H33-H13*H32)**2+
     1       (H12*H23-H13*H22)**2
      ACMOD2=(H21*H33-H23*H31)**2+(H11*H33-H13*H31)**2+
     1       (H11*H23-H13*H21)**2
C
      ALTU12=VOL2/ABMOD2
      ALTU22=VOL2/BCMOD2
      ALTU32=VOL2/ACMOD2
C
      ALTUM=dMIN1(ALTU12,ALTU22,ALTU32)
      IF (ALTUM.LT.BOXLMI) THEN
      WRITE(3,*) 'ATENCION UNO DE LOS LADOS DE LA CAJA ES MUY PEQUENO'
      WRITE(3,*) 'NO PUEDO SABER SI HAY SOLAPAMIENTO CON ALGUNA DE '
      WRITE(3,*) 'LAS IMAGENES PERIODICAS, QUE NO SEA LA DEL CENTRO'
      WRITE(3,*) 'DE MASAS, ALTUM2  ',ALTUM
      STOP
      ENDIF

c ***
c *** fin de test de caja no demasiado pequenha

c *************************************************
c *** REESCALANDO LAS COORDENADAS en concordancia
c *** con nuevo tamanho de caja
c ***

c *** recordando el valor de las coordenadas antiguas

      do is=1,natoms
         recx(is)=xa(is)
         recy(is)=ya(is)
         recz(is)=za(is)
      end do

c *** recalculando las coordenadas nuevas

c  Change mixture 27
      do im=1,nmoltot
         jc=class(im)
         molref =puntero1(jc)+ (im-1-puntero2(jc))*nsites(jc) 
         iref = molref + isiteori(jc)

         do ir=1,nsites(jc)
           nsref = molref + ir

           tx=xa(nsref)-xa(iref)
           ty=ya(nsref)-ya(iref)
           tz=za(nsref)-za(iref)

ccj     Usamos la matriz h vieja para volver a laboratorio 
c
           txp=ht(1,1)*tx+ht(1,2)*ty+ht(1,3)*tz
           typ=ht(2,1)*tx+ht(2,2)*ty+ht(2,3)*tz
           tzp=ht(3,1)*tx+ht(3,2)*ty+ht(3,3)*tz
           xbois=txp
           ybois=typ
           zbois=tzp
ccj     usaremos la hinv (la trial) para obtener las coord. nuevas
           tinvx=xbois
           tinvy=ybois
           tinvz=zbois
c
           tinvxp=hinv(1,1)*tinvx+hinv(1,2)*tinvy+hinv(1,3)*tinvz
           tinvyp=hinv(2,1)*tinvx+hinv(2,2)*tinvy+hinv(2,3)*tinvz
           tinvzp=hinv(3,1)*tinvx+hinv(3,2)*tinvy+hinv(3,3)*tinvz
c          
           xa(nsref)=xa(iref) +tinvxp
           ya(nsref)=ya(iref) +tinvyp
           za(nsref)=za(iref) +tinvzp
c
       end do
      end do
c
c ***
c *** fin reescalado de coordenadas

c *******************************************
c  CALCULO DE LA ENERGÍA DEL  NUEVO SISTEMA

C ************* Parte intermolecular
 
      call make_cell_map(sidea,sideb,sidec,cutoff)
      call make_link_list(natoms)
      call sysenergy(utotn,iax)
	

	u_ljinter=u_lj

      
c ************* Parte intramolecular
c cálculo de la contribución intramolecular a la energía total
c del sistema.
c para ello se necesitan las coordenadas cartesianas de las moleculas.
c         if(iax.eq.1) goto 4000   ! duro 

	Uintranew=0.0
	u_ljintra=0.
	do im=1,nmoltot

	   ic=class(im)
           numori=puntero1(ic)+(im-1-puntero2(ic))*nsites(ic)

      do is=1,nsites(ic)

	 numsite=numori+is
         xtcart(is)=xa(numsite)*h(1,1)+ya(numsite)*h(1,2)
     >      				+za(numsite)*h(1,3)
         ytcart(is)=xa(numsite)*h(2,1)+ya(numsite)*h(2,2)
     >					+za(numsite)*h(2,3)
         ztcart(is)=xa(numsite)*h(3,1)+ya(numsite)*h(3,2)
     >					+za(numsite)*h(3,3)

      end do

	do in=1,nsites(ic)-1
             call intramol(in,1,xtcart(in),ytcart(in),
     >	          ztcart(in),nsites(ic),xtcart,ytcart,ztcart
     >            ,wintra,numori,energint,u_lji)
	     Uintranew=Uintranew+energint
	     u_ljintra=u_ljintra+u_lji
	enddo   
	enddo


c *** contribucion de espacio recÃ�proco a la energía de la nueva
c *** configuracion
             
      ufnew=0.00000
c
      if (iewald.eq.1) then
      call ufourier(h,ufcalculo)
      ufnew=ufcalculo
      endif
      
c*** contribución del self-term    
      
      self=0. 
      if(iewald.eq.1)then
      pi=acos(-1.0000000) 
      self=-alfa/sqrt(pi)*sumaq2
      endif

c      conv=6.022136E+23*1.380658E-23/beta/4.184/1000./nmoltot
c      print*,beta*conv*uintranew ,'engergia intra del vol'
c      print*,self*conv*beta,'sel del vol'
c      print*,utotn*conv*beta,'inter del vol'
c      print*,ufnew*conv*beta,'fourier del vol'
c      print*,'************************************'

      detH=h(1,1)*(h(2,2)*h(3,3)-h(3,2)*h(2,3))-h(2,1)*(h(1,2)*h(3,3)
     *-h(1,3)*h(3,2))+h(3,1)*(h(1,2)*h(2,3)-h(1,3)*h(2,2))
c
      vol=abs(detH)
      rho=part/vol

c la corrección de largo alcance depende de la densidad:
        ulong=ulrtot*rho*float(nmoltot)

	utotn=utotn+Uintranew+ufnew+self+ulong 

	utotn = beta*utotn

c *************************************************
c CRITERIO METRÓPOLIS PARA LA  ACEPTACION DE LA CONFIGURACION NUEVA
c
c

      htemp=pstar*vol

c
      rboltz1=htemp-hrun-part*(log(vol)-log(volt))+(UTOTN-UTOTO)  
c
       if (rboltz1.gt.70.000) then
         rboltz=0.0000000000
       else
           if (rboltz1.lt.-70.00000000) then
           rboltz=1.1
           else
           rboltz = exp(-rboltz1)
           endif
       endif
c
      test=ranf(seed)

c *** ACEPTACION:

      if(rboltz.gt.test) then

      hrun=htemp
      accpt=accpt+1.0
      utot=utotn
      ufold=ufnew
	u_lj=u_ljinter+u_ljintra

c *** control del tamanho de la caja
 
 	if ((0.5*sidea.lt.cutoff).or.
     >    (0.5*sideb.lt.cutoff).or.
     >    (0.5*sidec.lt.cutoff)) then
           write(3,*) 'box too small for cutoff'
       	   write(3,*) sidea,cutoff
 	    stop
 	end if
 
       go to 2000
       endif

c *** RECHAZO:  

 4000 vol=volt
      rho=part/vol
c
      do 8 i=1,3
      do 9 j=1,3
         h(i,j)=ht(i,j)
	 hinv(i,j)=hinvt(i,j)
    9 continue
    8 continue

      sidea = rsidea
      sideb = rsideb
      sidec = rsidec

      do is=1,natoms
         xa(is)=recx(is)
         ya(is)=recy(is)
         za(is)=recz(is)
      end do

c Los valores actuales del espacio recíproco son los de la 
c configuración trial,por lo que en caso de rechazo hay que 
c deshacer el entuerto:

      
       if (iewald.eq.1) then 
	   maxvec=maxmemo
         do k = 1, maxvec
           cssum(k)=csmemo(k)
           snsum(k)=snmemo(k)
         enddo
        endif

C Al llamar a sysenergy la energía LJ queda machacada por lo que hay
c que recuperar la vieja:
	u_lj=u_ljo

 2000	continue

      call make_cell_map(sidea,sideb,sidec,cutoff)
      call make_link_list(natoms)

	if(iewald.eq.1)then
      call ewstup(h) 
	endif

	return
	end
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
************************************************
        FUNCTION RANF(IDUM)
        !INCLUDE 'mcnptUv01_beta.inc'
*        PARAMETER (IM1=2147483563,IM2=2147483399,AM=1.0D00/IM1,
*     &  IMM1=IM1-1,IA1=40014,IA2=40692,IQ1=53668,IQ2=52774,IR1=12211,
*     &  IR2=3791,NTAB=32,NDIV=1+IMM1/NTAB)
        PARAMETER (IM1=2147483563,IM2=2147483399,
     &  IA1=40014,IA2=40692,IQ1=53668,IQ2=52774,IR1=12211,
     &  IR2=3791,NTAB=32)
        PARAMETER(EPS=1.2D-14,RNMX=1.0D00-EPS)
C RAN2 OF NUMERICAL RECIPES 2ND ED.
        DIMENSION IV(NTAB)
        SAVE IV,IY,IDUM2
        DATA IDUM2/123456789/,IV/NTAB*0/,IY/0/

             AM=1.d0/im1
             IMM1=IM1-1
             Ndiv=1+IMM1/NTAB
        IF (IDUM.LE.0)THEN
          IDUM=MAX(-IDUM,1)
          IDUM2=IDUM
          DO J=NTAB+8,1,-1
            K=IDUM/IQ1
            IDUM=IA1*(IDUM-K*IQ1)-K*IR1
            IF(IDUM.LT.0)IDUM=IDUM+IM1
            IF(J.LE.NTAB)IV(J)=IDUM
          ENDDO
          IY=IV(1)
        ENDIF
        K=IDUM/IQ1
        IDUM=IA1*(IDUM-K*IQ1)-K*IR1
        IF(IDUM.LT.0)IDUM=IDUM+IM1
        K=IDUM2/IQ2
        IDUM2=IA2*(IDUM2-K*IQ2)-K*IR2
        IF(IDUM2.LT.0)IDUM2=IDUM2+IM2
        J=1+IY/NDIV
        IY=IV(J)-IDUM2
        IV(J)=IDUM
        IF(IY.LT.1)IY=IY+IMM1
        RANF=MIN(AM*IY,RNMX)

        RETURN
        END
C
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c  A C-program for MT19937, with initialization improved 2002/1/26.
c  Coded by Takuji Nishimura and Makoto Matsumoto.
c
c  Before using, initialize the state by using init_genrand(seed)  
c  or init_by_array(init_key, key_length).
c
c  Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
c  All rights reserved.                          
c  Copyright (C) 2005, Mutsuo Saito,
c  All rights reserved.                          
c
c  Redistribution and use in source and binary forms, with or without
c  modification, are permitted provided that the following conditions
c  are met:
c
c    1. Redistributions of source code must retain the above copyright
c       notice, this list of conditions and the following disclaimer.
c
c    2. Redistributions in binary form must reproduce the above copyright
c       notice, this list of conditions and the following disclaimer in the
c       documentation and/or other materials provided with the distribution.
c
c    3. The names of its contributors may not be used to endorse or promote 
c       products derived from this software without specific prior written 
c       permission.
c
c  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
c  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
c  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
c  A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
c  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
c  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
c  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
c  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
c  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
c  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
c  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
c
c
c  Any feedback is very welcome.
c  http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html
c  email: m-mat @ math.sci.hiroshima-u.ac.jp (remove space)
c
c-----------------------------------------------------------------------
c  FORTRAN77 translation by Tsuyoshi TADA. (2005/12/19)
c
c     ---------- initialize routines ----------
c  subroutine init_genrand(seed): initialize with a seed
c  subroutine init_by_array(init_key,key_length): initialize by an array
c
c     ---------- generate functions ----------
c  integer function genrand_int32(): signed 32-bit integer
c  integer function genrand_int31(): unsigned 31-bit integer
c  double precision function genrand_real1(): [0,1] with 32-bit resolution
c  double precision function genrand_real2(): [0,1) with 32-bit resolution
c  double precision function genrand_real3(): (0,1) with 32-bit resolution
c  double precision function genrand_res53(): (0,1) with 53-bit resolution
c
c  This program uses the following non-standard intrinsics.
c    ishft(i,n): If n>0, shifts bits in i by n positions to left.
c                If n<0, shifts bits in i by n positions to right.
c    iand (i,j): Performs logical AND on corresponding bits of i and j.
c    ior  (i,j): Performs inclusive OR on corresponding bits of i and j.
c    ieor (i,j): Performs exclusive OR on corresponding bits of i and j.
c
c-----------------------------------------------------------------------
c     initialize mt(0:N-1) with a seed
c-----------------------------------------------------------------------
      subroutine init_genrand(s)
      integer s
      integer N
      integer DONE
      integer ALLBIT_MASK
      parameter (N=624)
      parameter (DONE=123456789)
      integer mti,initialized
      integer mt(0:N-1)
      common /mt_state1/ mti,initialized
      common /mt_state2/ mt
      common /mt_mask1/ ALLBIT_MASK
c
      call mt_initln
      mt(0)=iand(s,ALLBIT_MASK)
      do 100 mti=1,N-1
        mt(mti)=1812433253*
     &          ieor(mt(mti-1),ishft(mt(mti-1),-30))+mti
        mt(mti)=iand(mt(mti),ALLBIT_MASK)
  100 continue
      initialized=DONE
c
      return
      end
c-----------------------------------------------------------------------
c     initialize by an array with array-length
c     init_key is the array for initializing keys
c     key_length is its length
c-----------------------------------------------------------------------
      subroutine init_by_array(init_key,key_length)
      integer init_key(0:*)
      integer key_length
      integer N
      integer ALLBIT_MASK
      integer TOPBIT_MASK
      parameter (N=624)
      integer i,j,k
      integer mt(0:N-1)
      common /mt_state2/ mt
      common /mt_mask1/ ALLBIT_MASK
      common /mt_mask2/ TOPBIT_MASK
c
      call init_genrand(19650218)
      i=1
      j=0
      do 100 k=max(N,key_length),1,-1
        mt(i)=ieor(mt(i),ieor(mt(i-1),ishft(mt(i-1),-30))*1664525)
     &           +init_key(j)+j
        mt(i)=iand(mt(i),ALLBIT_MASK)
        i=i+1
        j=j+1
        if(i.ge.N)then
          mt(0)=mt(N-1)
          i=1
        endif
        if(j.ge.key_length)then
          j=0
        endif
  100 continue
      do 200 k=N-1,1,-1
        mt(i)=ieor(mt(i),ieor(mt(i-1),ishft(mt(i-1),-30))*1566083941)-i
        mt(i)=iand(mt(i),ALLBIT_MASK)
        i=i+1
        if(i.ge.N)then
          mt(0)=mt(N-1)
          i=1
        endif
  200 continue
      mt(0)=TOPBIT_MASK
c
      return
      end
c-----------------------------------------------------------------------
c     generates a random number on [0,0xffffffff]-interval
c-----------------------------------------------------------------------
      function genrand_int32()
      integer genrand_int32
      integer N,M
      integer DONE
      integer UPPER_MASK,LOWER_MASK,MATRIX_A
      integer T1_MASK,T2_MASK
      parameter (N=624)
      parameter (M=397)
      parameter (DONE=123456789)
      integer mti,initialized
      integer mt(0:N-1)
      integer y,kk
      integer mag01(0:1)
      common /mt_state1/ mti,initialized
      common /mt_state2/ mt
      common /mt_mask3/ UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
      common /mt_mag01/ mag01
c
      if(initialized.ne.DONE)then
        call init_genrand(21641)
      endif
c
      if(mti.ge.N)then
        do 100 kk=0,N-M-1
          y=ior(iand(mt(kk),UPPER_MASK),iand(mt(kk+1),LOWER_MASK))
          mt(kk)=ieor(ieor(mt(kk+M),ishft(y,-1)),mag01(iand(y,1)))
  100   continue
        do 200 kk=N-M,N-1-1
          y=ior(iand(mt(kk),UPPER_MASK),iand(mt(kk+1),LOWER_MASK))
          mt(kk)=ieor(ieor(mt(kk+(M-N)),ishft(y,-1)),mag01(iand(y,1)))
  200   continue
        y=ior(iand(mt(N-1),UPPER_MASK),iand(mt(0),LOWER_MASK))
        mt(kk)=ieor(ieor(mt(M-1),ishft(y,-1)),mag01(iand(y,1)))
        mti=0
      endif
c
      y=mt(mti)
      mti=mti+1
c
      y=ieor(y,ishft(y,-11))
      y=ieor(y,iand(ishft(y,7),T1_MASK))
      y=ieor(y,iand(ishft(y,15),T2_MASK))
      y=ieor(y,ishft(y,-18))
c
      genrand_int32=y
      return
      end
c-----------------------------------------------------------------------
c     generates a random number on [0,0x7fffffff]-interval
c-----------------------------------------------------------------------
      function genrand_int31()
      integer genrand_int31
      integer genrand_int32
      genrand_int31=int(ishft(genrand_int32(),-1))
      return
      end
c-----------------------------------------------------------------------
c     generates a random number on [0,1]-real-interval
c-----------------------------------------------------------------------
      function genrand_real1()
      double precision genrand_real1,r
      integer genrand_int32
      r=dble(genrand_int32())
      if(r.lt.0.d0)r=r+2.d0**32
      genrand_real1=r/4294967295.d0
      return
      end
c-----------------------------------------------------------------------
c     generates a random number on [0,1)-real-interval
c-----------------------------------------------------------------------
      function genrand_real2()
      double precision genrand_real2,r
      integer genrand_int32
      r=dble(genrand_int32())
      if(r.lt.0.d0)r=r+2.d0**32
      genrand_real2=r/4294967296.d0
      return
      end
c-----------------------------------------------------------------------
c     generates a random number on (0,1)-real-interval
c-----------------------------------------------------------------------
      function genrand_real3()
      double precision genrand_real3,r
      integer genrand_int32
      r=dble(genrand_int32())
      if(r.lt.0.d0)r=r+2.d0**32
      genrand_real3=(r+0.5d0)/4294967296.d0
      return
      end
c-----------------------------------------------------------------------
c     generates a random number on [0,1) with 53-bit resolution
c-----------------------------------------------------------------------
      function genrand_res53()
      double precision genrand_res53
      integer genrand_int32
      double precision a,b
      a=dble(ishft(genrand_int32(),-5))
      b=dble(ishft(genrand_int32(),-6))
      if(a.lt.0.d0)a=a+2.d0**32
      if(b.lt.0.d0)b=b+2.d0**32
      genrand_res53=(a*67108864.d0+b)/9007199254740992.d0
      return
      end
c-----------------------------------------------------------------------
c     initialize large number (over 32-bit constant number)
c-----------------------------------------------------------------------
      subroutine mt_initln
      integer ALLBIT_MASK
      integer TOPBIT_MASK
      integer UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
      integer mag01(0:1)
      common /mt_mask1/ ALLBIT_MASK
      common /mt_mask2/ TOPBIT_MASK
      common /mt_mask3/ UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
      common /mt_mag01/ mag01
      TOPBIT_MASK=1073741824
      TOPBIT_MASK=ishft(TOPBIT_MASK,1)
      ALLBIT_MASK=2147483647
      ALLBIT_MASK=ior(ALLBIT_MASK,TOPBIT_MASK)
      UPPER_MASK=TOPBIT_MASK
      LOWER_MASK=2147483647
      MATRIX_A=419999967
      MATRIX_A=ior(MATRIX_A,TOPBIT_MASK)
      T1_MASK=489444992
      T1_MASK=ior(T1_MASK,TOPBIT_MASK)
      T2_MASK=1875247104
      T2_MASK=ior(T2_MASK,TOPBIT_MASK)
      mag01(0)=0
      mag01(1)=MATRIX_A
      return
      end

c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine order

c
c     translational order parameters
c

	include 'parametros_NpT.inc'
	include 'common.inc'

      dimension x(nmmax),y(nmmax),z(nmmax)
c
      tpi=2.0*pi
      fpi=4.0*pi

       if(ilatt.ne.0) then


c
c Para el Ice Ih
c      ihh=8
c      ikk=0
c      ill=0
c Para el Ice II
c      ihh=16
c      ikk=4
c      ill=9
c Para el ice V
c	 ihh=4
c	 ikk=6
c	 ill=3
c Para el hielo Ic con 216 moléculas
c      ihh=0
c      ikk=6
c	 ill=6
c Para el hielo III con 324 moléculas
c      ihh=6
c      ikk=0
c      ill=3
c Para el hielo VI con 360 moléculas
       ihh=6
       ikk=6
       ill=16
c Para el hielo VII
c      ill=6



      nxauxi=1
      nyauxi=1
      nzauxi=1
c Los valores de ihh,ikk,ill con el maximo de 
c difraccion se encontraron utilizando nxauxi=nyauxi=nzauxi
c = 1 y lo mismo ha de hacerse aqui 
c
      xhh=ihh
      xkk=ikk
      xll=ill
        diffx=1.0/nxauxi
        diffy=1.0/nyauxi
        diffz=1.0/nzauxi
c
        op=0.0
        pq=0.0
c
c Change mixture 14
          do i=1,nmoltot
            ic=class(i)
c           iori=puntero1(ic)+(i-1)*nsites(ic)
            iori=puntero1(ic)+(i-1-puntero2(ic))*nsites(ic)
            i1   = iori +    1
c            iend = i1+nsites(ic)-1 
            iend=i1
c Calculo el centro de masas de la molecula
            xhelp=(xa(i1)+xa(iend))/2.
            yhelp=(ya(i1)+ya(iend))/2.
            zhelp=(za(i1)+za(iend))/2.
c Metemos el CM en la caja
            xpb = xhelp - anint( (xhelp-half) )
            ypb = yhelp - anint( (yhelp-half) )
            zpb = zhelp - anint( (zhelp-half) )
c
            op=op+cos(tpi*
     1 ( xhh*(xpb/diffx) + xkk*(ypb/diffy) + xll*(zpb/diffz) ) )
            pq=pq+sin(tpi*
     1 ( xhh*(xpb/diffx) + xkk*(ypb/diffy) + xll*(zpb/diffz) ) )
c          
        end do
c
        sl1=(op*op+pq*pq)/nmoltot/nmoltot
	  sl2=0.
	  sl3=0.

      else
c
        diff=1.0/((part/4.0)**(1.0/3.0))
c
        op=0.0
        pq=0.0
c
c Change mixture 17
        do 5 i=1,nmoltot
          ic=class(i)
          iori=puntero1(ic)+(i-1-puntero2(ic))*nsites(ic)
          i1   = iori +    1
c
cl      do 5 i=1,nmol
ccj2  Atencion que es lo que pasa con i1 
          op=op+cos(fpi*xa(i1)/diff)
          pq=pq+sin(fpi*xa(i1)/diff)
5       continue
        sl1=(op*op+pq*pq)/nmoltot/nmoltot
c
        op=0.0
        pq=0.0
c Change mixtures 18
        do 6 i=1,nmoltot
          ic=class(i)
          iori=puntero1(ic)+(i-1-puntero2(ic))*nsites(ic)
          i1   = iori +    1
cl      do 6 i=1,nmol
          op=op+cos(fpi*ya(i1)/diff)
          pq=pq+sin(fpi*ya(i1)/diff)
6       continue
        sl2=(op*op+pq*pq)/nmoltot/nmoltot
c
        op=0.0
        pq=0.0
c
c Change mixtures 19   ver za(i1?????)
        do 7 i=1,nmoltot
          ic=class(i)
          iori=puntero1(ic)+(i-1-puntero2(ic))*nsites(ic)
          i1   = iori +    1
cl      do 7 i=1,nmol
          op=op+cos(fpi*za(i1)/diff)
          pq=pq+sin(fpi*za(i1)/diff)
7       continue
        sl3=(op*op+pq*pq)/nmoltot/nmoltot
c
      endif
c
c     sl1,sl2 and sl3 are the translational order parameters for x,y,z
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      SUBROUTINE TERMO


	include 'parametros_NpT.inc'
	include 'common.inc'


      IRUN=IRUN+1 

      sidea=0.0
      sideb=0.0
      sidec=0.0
c
      do 10 i=1,3
      sidea=sidea+h(i,1)**2
      sideb=sideb+h(i,2)**2
      sidec=sidec+h(i,3)**2
   10 continue
c
      sidea=sqrt(sidea)
      sideb=sqrt(sideb)
      sidec=sqrt(sidec)

      SIDEMI=dMIN1(SIDEA,SIDEB,SIDEC)
      SIDEMI=SIDEMI/2.
      IF (SIDEMI.LT.RMAX) THEN 
      WRITE(3,*) ' RMAX IS BIGGER THAN THE HALF OF THE SHORTEST SIDE 
     1             OF THE BOX ' 
      STOP
      ENDIF 
C EVALUATING STRUCTURAL PROPERTIES 
C LOOP OVER PAIR OF MOLECULES 
c  Change mixture 12
      
      do 200 i=1,nmoltot-1     
      do 100 j=i+1,nmoltot
c
       ic=class(i)
       jc=class(j)
ccj2
       nrefi = puntero1(ic)+(i-1-puntero2(ic))*nsites(ic)
       nrefj = puntero1(jc)+(j-1-puntero2(jc))*nsites(jc)
       
ccj   Change virial 1
ccj Debido a esto sera conveniente definir el isiteori como 1 (casi el
ccj    centro de masas)
       
            ncmi=nrefi+1
            ncmj=nrefj+1
            dxa=xa(ncmj)-xa(ncmi)
            dya=ya(ncmj)-ya(ncmi)
            dza=za(ncmj)-za(ncmi)

c *** convencion de imagen minima aplicada sobre los atomos

            dxmic=anint(dxa)
            dymic=anint(dya)
            dzmic=anint(dza)
c
c **distancia entre los site de referencia de acuerdo a la convencion 
c      de imagen minima
ccj
            tx=(dxa-dxmic)
            ty=(dya-dymic)
            tz=(dza-dzmic)
ccj
            txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
            typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
            tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
            dxcm1=txp
            dycm1=typ
            dzcm1=tzp
            drcm1=sqrt(dxcm1**2+dycm1**2+dzcm1**2)
ccj   fin Change Virial 1       
cc
cc
c LOOP OVER SITES
c Change mixture 13
c
         do 50 ia=1,nsites(ic)
         do 40 ja=1,nsites(jc)
c
		maxsite = max(ia+puntero3(ic),ja+puntero3(jc))
		minsite = min(ia+puntero3(ic),ja+puntero3(jc))
ccj2
		kind = minsite + ((maxsite-1)*maxsite)/2

            nsi = nrefi + ia
            nsj = nrefj + ja

            dxa=xa(nsj)-xa(nsi)
            dya=ya(nsj)-ya(nsi)
            dza=za(nsj)-za(nsi)
c
c *** convencion de imagen minima aplicada sobre los atomos

            dxmic=anint(dxa)
            dymic=anint(dya)
            dzmic=anint(dza)
c
c **distancia entre los site de acuerdo a la convencion de imagen minima
c Julio change number 13
ccj
      tx=(dxa-dxmic)
      ty=(dya-dymic)
      tz=(dza-dzmic)
ccj
      txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
      typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
      tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
      dx1=txp
      dy1=typ
      dz1=tzp
ccj 
c
            RSS2=dx1*dx1+dy1*dy1+dz1*dz1
            RSS=SQRT(RSS2)

c Cálculo de la energía entre esos dos sites.  

          IF (RSS2.lt.rcut2) THEN
c***Cálculo de interacción ionica(espacio real)
              uion=0.
              if(iewald.eq.1)then
                 qiqj=cargatom(nsi)*cargatom(nsj)
                 rijsq=sqrt(rss2)
                 uion=qiqj*erfcc(alfa*rijsq)/rijsq
              endif                                
c***Cálculo de interacción lennard-Jones              
              sig_ij=0.5*(sigatom(nsi)+sigatom(nsj))
                   
              if(sig_ij.lt.0.000001)then
               uij=0.
	      else
              r2sig=RSS2/sig_ij**2
              Epsi_ij=(epsiatom(nsi)*epsiatom(nsj))**(1./2.)
                if (r2sig.le.coreduro) then
                 Uij=1.42e10*Epsi_ij
                else
                 r2i=1./r2sig
                 Uij = 4.*Epsi_ij*( R2i**6 - R2i**3 )
                endif
              endif
          ELSE
              uij=0.
	      uion=0.
          ENDIF
                 uij=uij+uion
	     
             Uinter(ic,jc)=Uinter(ic,jc)+Uij*beta

ccj   Change virial 2 
ccj    pero cuidado hay que revisar la normalizacion
            RCMEU=(dx1*dxcm+dy1*dycm+dz1*dzcm)/RSS

ccj   mucho cuidado con esta normalizacion     
            IF (RSS.LT.RMAX)  THEN 
               ISS=INT(  (RSS-0.)/DELTAR ) +1 
      	     GSS(ISS,kind)=GSS(ISS,kind)+1.
             R12EU(ISS,kind)=R12EU(ISS,kind)+RCMEU
             CONTA(ISS,kind)=CONTA(ISS,kind)+1.
            ENDIF 

 40      CONTINUE
 50      CONTINUE
 
 100  CONTINUE
 200  CONTINUE

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c	Calculo del numero de distancias entre sites de una 
c       misma molécula que caen en cada grid.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


	
	do im=1,nmoltot         !bucle sobre moléculas
	
	ic=class(im)
	nori=puntero1(ic)+(im-1-puntero2(ic))*nsites(ic)
	ifin=nori+nsites(ic)

	do nsi=nori+1,ifin-2     !bucle sobre sites de una molécula
	  do nsj=nsi+2,ifin
	
            dxa=xa(nsj)-xa(nsi)
            dya=ya(nsj)-ya(nsi)
            dza=za(nsj)-za(nsi)

c *** convencion de imagen minima aplicada sobre los atomos

            dxmic=anint(dxa)
            dymic=anint(dya)
            dzmic=anint(dza)

c **distancia entre los site de acuerdo a la convencion de imagen minima
c Julio change number 13
ccj
      tx=(dxa-dxmic)
      ty=(dya-dymic)
      tz=(dza-dzmic)
ccj
      txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
      typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
      tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
      dx1=txp
      dy1=typ
      dz1=tzp
ccj

            RSS2=dx1*dx1+dy1*dy1+dz1*dz1
            RSS=SQRT(RSS2)


c ********* calculo de la energia interatomica

	        Uij=0.
							
                if (RSS2.lt.rcut2) then

	           sig_ij=0.5*(sigatom(nsi)+sigatom(nsj))
                   r2sig=RSS2/sig_ij**2
                   Epsi_ij=(epsiatom(nsi)*epsiatom(nsj))**(1./2.)

                     if (RSS2.le.0.16) then
                        Uij=1.42e10*Epsi_ij
                     else
                        r2i=1./r2sig
                        Uij = 4.*Epsi_ij*( R2i**6 - R2i**3 )
                     endif

                end if

	     Uintra(ic)=Uintra(ic)+Uij*beta

	     
	if(RSS.lt.RMAX) then
	
	iss=int((RSS-0.)/DELTAR)+1
	GSSinterna(ic,iss)=GSSinterna(ic,iss)+1.

	endif
	
	enddo
	enddo
	enddo

c ****************************************************

c EVALUANDO :
C   * COS (VECTOR PERPENDICULAR AL PLANO A,B, EJE MOLECULAR )
C   * COS (VECTOR A , PROYECCION DEL EJE MOLECULAR EN EL PLANO A,B)

      H11=H(1,1)
      H12=H(1,2)
      H13=H(1,3)
      H21=H(2,1)
      H22=H(2,2)
      H23=H(2,3)
      H31=H(3,1)
      H32=H(3,2)
      H33=H(3,3)
C CONSTRUYENDO VECTOR UNITARIO PERPENDICULAR AL PLANO A,B
      ABMOD=SQRT( (H21*H32-H22*H31)**2+(H11*H32-H12*H31)**2+
     1       (H11*H22-H12*H21)**2   )
      abx=(H21*H32-H22*H31)/ABMOD
      aby=-(H11*H32-H12*H31)/ABMOD
      abz=(H11*H22-H12*H21)/ABMOD
C CONSTRUYENDO VECTOR UNITARIO EN LA DIRECCION DE A 
      AMOD=SQRT(H11**2+H21**2+H31**2)
      AX=H11/AMOD
      AY=H21/AMOD
      AZ=H31/AMOD 
C
      SUMA1=0.0
      SUMA2=0.0
      SUMA3=0.0
      SUMA4=0.0

ccj2
c Change mixtures 14
      do 400 kk=1,nmoltot
          ic=class(kk)
          iori = puntero1(ic)+(kk-1-puntero2(ic))*nsites(ic)
          i1   = iori +    1
          in   = iori +  nsites(ic)
ccj2
      tx=(xa(in)-xa(i1))
      ty=(ya(in)-ya(i1))
      tz=(za(in)-za(i1))
ccj
      txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
      typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
      tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
      vx=txp
      vy=typ
      vz=tzp
ccj


	   xnormi = 1./( vx*vx + vy*vy + vz*vz )**0.5

	   vx=vx*xnormi
	   vy=vy*xnormi
	   vz=vz*xnormi

      IF ( MOD(KK,2).EQ.0) THEN
      SUMA3=SUMA3+PROYE
      ELSE 
      SUMA1=SUMA1+PROYE
      ENDIF 
C PROYECTANDO U SOBRE EL PLANO AB 
      VXAB=VX-proye*abx
      VYAB=VY-proye*aby
      VZAB=VZ-proye*abz
C NORMALIZANDO EL VECTOR RESULTANTE 
      VABMO=SQRT(VXAB**2+VYAB**2+VZAB**2)
      VXAB=VXAB/VABMO
      VYAB=VYAB/VABMO
      VZAB=VZAB/VABMO
C PROYECTANDO SOBRE EL EJE A 
      PRODU=AX*VXAB+AY*VYAB+AZ*VZAB
C
      IF ( MOD(KK,2).EQ.0) THEN
      SUMA4=SUMA4+PRODU
      ELSE 
      SUMA2=SUMA2+PRODU 
      ENDIF 
C 
 400  continue
      suma1=suma1/float(nmoltot/2)
      SUMA2=SUMA2/FLOAT(NMOLtot/2)
      suma3=suma3/float(nmoltot/2)
      SUMA4=SUMA4/FLOAT(NMOLtot/2)
      angulo1=acos(suma1)
      ANGULO2=ACOS(SUMA2)
      angulo3=acos(suma3)
      ANGULO4=ACOS(SUMA4)
      SANGU1=SANGU1+ANGULO1
      sangu2=sangu2+angulo2
      SANGU3=SANGU3+ANGULO3
      sangu4=sangu4+angulo4

      RETURN
      END 
C *******************************************************
C SUBROUTINE TO EVALUATE THE RADIAL DISTRIBUTION FUNCTIONS

      SUBROUTINE SALI(RHOME)

	include 'parametros_NpT.inc'
	include 'common.inc'

c     chantal sett 2011
c	integer conta
c
	dimension grprom(ngrmax)
        dimension gssprotot(ngrmax)
	dimension gp(ntipmolmax,ntipmolmax,ngrmax)

	data grprom /ngrmax*0/

	do i=1,ngrid
         gssprotot(i)=0.
	enddo

	do i=1,ngrid
	do j=1,ntipmol

	auxir=(i-1)*deltar+deltar/2
	
	enddo
	enddo

	do i=1,ntipmolmax
	do j=1,ntipmolmax
	do k=1,ngrid
	 gp(i,j,k)=0.
	enddo
	enddo
	enddo

      PI=ACOS(-1.)
     
c *** escribiendo las gss brutas por si se necesita retomar el run

c	write(2) irun,gss
c m promedio = sumatorio especies quimicas (  m_i   x_i ) 

           xmprom=0.


           do jauxi=1,ntipmol
	    nmi=float(nmol(jauxi))
            nmt=float(nmoltot)
            xmprom=xmprom+float(nsites(jauxi))*nmi/nmt      
	   enddo

      DO  I=1,NGRID

      RR1=(I-1)*DELTAR
      RR2=I*DELTAR
      VV=4./3.*PI*(RR2**3-RR1**3)
      sumator=0.
	
	do isite=1,nsitestot             ! Bucle que abarca las todas las
                                         !         combinaciones sin repeticion
        do jsite=isite,nsitestot         ! de parejas de tipos de site. 

c
	   kind = isite + ((jsite-1)*jsite)/2
c          
           isuma=0
           do iauxi=1,ntipmol
            isuma=isuma+nsites(iauxi)
            if (isite.le.isuma) then
                itiposite=iauxi
                goto 777
            endif
           end do


777        continue

        nmolitipo=float(nmol(itiposite))


c
           jsuma=0
           do jauxi=1,ntipmol
            jsuma=jsuma+nsites(jauxi)
            if (jsite.le.jsuma) then
                jtiposite=jauxi
                goto 888
            endif
           end do

888        continue

          nmoljtipo=float(nmol(jtiposite))

C  (volav es el volumen promedio por molécula,
c  luego volav*nmoltot es el volúmen de la caja).

      FAC1=1.*volav*nmoltot/
     > (FLOAT(IRUN)*FLOAT(NMOL(itiposite))*nmoljtipo*VV)

      FAC2=2.*volav*nmoltot/
     > (FLOAT(IRUN)*FLOAT(NMOL(itiposite))*nmoljtipo*VV)

ccj Change viriales 3
           IF (CONTA(I,kind).EQ.0) THEN
            R12EU(I,kind)=0.
            ELSE
            R12EU(I,kind)=R12EU(I,kind)/CONTA(I,kind) 
           ENDIF 
	  

c   NORMALIZACION DE GSS

           if (isite.eq.jsite) then
            GSS(I,kind)=GSS(I,kind)*FAC2
	   else
            GSS(I,kind)=GSS(I,kind)*FAC1
	   end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c	calculamos la gss promedio total :gssprotot(I)
c       calculamos la gss promedio para cada pareja de tipo de 
c       moléculas (1-1,1-2,2-2,...): gp(it,jt,I)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

	it=itiposite
	jt=jtiposite


	if(it.eq.jt)then	
	rpeso=1./float(nsites(it)*nsites(jt))   
	else
	rpeso=1./(2*float(nsites(it)*nsites(jt)))   
	endif

	X1=nmolitipo/float(nmoltot)/xmprom
	X2=nmoljtipo/float(nmoltot)/xmprom

	if(isite.eq.jsite) then
	 gssprotot(I)=gssprotot(I)+X1*X2*GSS(I,kind)	
	 gp(it,jt,I)=gp(it,jt,I)+rpeso*GSS(I,kind)
	else
	 gssprotot(I)=gssprotot(I)+2*X1*X2*GSS(I,kind)
	 gp(it,jt,I)=gp(it,jt,I)+2*rpeso*GSS(I,kind)
	endif

	end do
	end do


        ENDDO
ccccccccccccccccccccccccccccccccccccccccccccccccccccc
c	Ahora se normalizan las gss intramoleculares
c       calculadas para cada tipo de molecula
ccccccccccccccccccccccccccccccccccccccccccccccccccccc
	
	do igr=1,ngrid

	do itp=1,ntipmol
	 
          RR1=(igr-1)*DELTAR
          RR2=(igr)*DELTAR
          VV=4./3.*PI*(RR2**3-RR1**3)

	  nsi=float(nsites(itp))
	  iru=float(irun)
	  nmo=float(nmol(itp))

	  GSSinterna(itp,igr)=GSSinterna(itp,igr)*2/(nmo*nsi*iru*VV)
	
c	  GSSinterna(itp,igr)=GSSinterna(itp,igr)*2/(nmo*iru*VV)
	enddo
	enddo

c      
      ipares=0

      do ii=1,ntipmol
         ipares=ipares+nsites(ii)
      enddo

      ipares=ipares+(ipares*(ipares-1))/2

      if (ipares.gt.max_pair) then
         write(3,*) 'Revisa tu numero de nsmax porque es pequeño'
         stop
      endif
 
c Change Virial 5 Escribe las gss(r) de todas las posibles parejas de sites.	

       do ikind=1,ipares
 	do iii=1,ngrid
        auxir=(iii-1)*deltar+deltar/2
 	write(4,1544) ikind,auxir,gss(iii,ikind),R12EU(iii,ikind),
     >      			gsspro(iii,ikind)
         end do
       end do
 
        write(4,*) ' m promedio = ', xmprom

c  Se escriben las energías promedio inter e intramoleculares

	do i=1,ntipmol   
	  write(3,*) 'Uintra',i,'=',Uintra(i)/(IRUN*nmoltot),'NKT'
	  write(3,*) 'Uintra',i,'=',Uintra(i)/(beta*IRUN*nmoltot),'N*Eps'
	enddo

	do i=1,ntipmol
	do j=i,ntipmol
      	  write(3,*) 'Uinter',i,j,'=',Uinter(i,j)/(IRUN*nmoltot),'NKT'
	  write(3,*) 'Uinter',i,j,'='
     >    ,Uinter(i,j)/(IRUN*beta*nmoltot),'N*Eps'
	enddo
	enddo

1544    format(i3,4x,f12.6,4x,f15.12,4x,f25.12,4x,f15.12)

889    format('O-O',4x,f12.6,4x,f15.12)
899    format('O-H',4x,f12.6,4x,f15.12)
999    format('H-H',4x,f12.6,4x,f15.12)

1546    format(4x,f12.6,4x,f15.12,6x,'grpromedio') 

1548	format(i3,i3,4x,f12.6,4x,f15.12,6x,'grintermolec.')

1550	format(i3,4x,f12.6,4x,f15.12,6x,'grintra.')

      RETURN 
      END 



c *********************************************************************
c *********************************************************************
c *********************************************************************
c *********************************************************************

      subroutine inicio(rhog)   

	include 'parametros_NpT.inc'
	include 'common.inc'

      real*8 ulrtot

	parameter (mom=ngrmax*max_pair)
c     chantal sett 2011
c      integer conta
      dimension xtcart(nsmax),ytcart(nsmax),ztcart(nsmax)
      dimension iatsol(natmax)
      dimension iatpc(natmax) 
      dimension iatbgc(natmax) 
      dimension isolidifico(natmax)
      dimension q6bartotprev(natmax)
      dimension rtimestep(5000)

	IF(ibucle.eq.1)THEN 
      data subh,toth/18*0.0/
      data cacc,vacc,tiacc,biacc/4*0.0/
      data rhosub,rhotot,RHO2TOT/3*0.0/
      DATA UNKTSUB,UNKTTOT/2*0.0/
      data enktsub,enkttot/2*0.0/
      data sosub,sotot/2*0.0/

	data u_ljktot,u_ljksub/2*0.0/

	data unkttotet,unktsubet/2*0./
	data unkttoterr,unktsuberr/2*0./
	data unkttoters,unktsubers/2*0./

      data expotot,exposub/2*0./

      data sl1sub,sl1tot/2*0.0/
      data sl2sub,sl2tot/2*0.0/
      data sl3sub,sl3tot/2*0.0/

      data utot,etot/2*0.0/
      data R1ntot,R1nvtot/2*0.0/
      data volsub,voltot,gntot,gnsub/4*0.0/
      data cacctot,vacctot,racctot,tiacctot,cbacctot,rnucacctot/6*0.0/
      data atmptvotot,atmptrotot,atmptcmtot,atmptinttot,
     >     atmptcbtot,atmptnuctot/6*0.0/
      data cdx/nmmax*0.0/
      data cdy/nmmax*0.0/
      data cdz/nmmax*0.0/
      data pi2,pi/6.283185308,3.141592654/
      data dxt/1.0,1.0,1.0,0.0,1.0,1.0,1.0,0.0,1.0,1.0,1.0,0.0,0.0/
      data dyt/-1.0,0.0,1.0,1.0,-1.0,0.0,1.0,1.0,-1.0,0.0,1.0,1.0,0.0/
      data dzt/1.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,-1.0,-1.0,-1.0,-1.0,1.0/
      data gss /mom*0./
	data dxcm,dycm,dzcm/3*0.0/

	nfile=0

	icontanuc=0
	
	utotn=0.	

	do it=1,max_pair
	  do in=1,ngrid
          gss(in,it)=0.
	  gsspro(in,it)=0.
	   R12EU(in,it)=0.
           CONTA(in,it)=0.0
          end do
        end do


	do i=1,ntipmolmax
	do j=1,ngrid
	 GSSinterna(i,j)=0.
	enddo
	enddo


	do i=1,ntipmolmax
	   Uintra(i)=0.
	do j=1,ntipmolmax
	   Uinter(i,j)=0.
	enddo
	enddo

	if(ibucle.eq.1)then

c Inicializacion del histograma de q6
        do io=-100,100
         nhistoq6(io)=0
        enddo
c Inicializacion del histograma de q4
        do io=-100,100
         nhistoq4(io)=0
        enddo
c Inicializacion del histograma de q3
        do io=-100,100
         nhistoq3(io)=0
        enddo
c Inicializacion del histograma de q2
        do io=-100,100
         nhistoq2(io)=0
        enddo
c Contador de productos escalares q6q6 y q4q4
        nnormal=0

c Inicializacion del histograma de numero de vecinos de nucleacion
        do ip=0,nmmax
         nvecinostot(ip)=0
        enddo
c Inicializacion del histograma del cluster mas grande
        do ik=1,nmmax 
         nhistoclbig(ik)=0
        enddo
c Inicializacion del histograma de tamanno de clusters
        do ik=0,nmmax
         nhistoclus(ik)=0
        enddo
c Inicializacion del histograma del cluster mas grande sin bias
        do ik=1,nmmax
         histoclbigunb(ik)=0.
        enddo
c Inicializacion del histograma del numero de conexiones por particula
        do ik=0,nmmax
         nhistoconex(ik)=0
        enddo

	endif

        sumexpbias=0.

        nclusters=0
c Inicializando las banderas de primera llamada a algunas subrutinas
	ifirstcallxyzto=0
	firstcallescri=0

	ENDIF


      if ((ilatt.eq.2).or.(ilatt.eq.3)) then
      write(3,*) 'atencion: version valida para cajas ortogonales y CP1'
      stop
      end if
      if (nmoltot.gt.nmmax) then
         write(3,*) 'nmmax too small' 
         stop
      end if

      if ((kstart.eq.0).and.(ilatt.ne.0)) then
      if(nx*ny*nz.ne.nmoltot) then
      write(3,*) ' '
      write(3,*) 'nx, ny, nz and nmoltot are not consistent '
      write(3,*) ' '
      stop
      endif
      endif

c *** numero total de atomos en la caja
c Change mixture 9
  	natoms=0
        do ic=1,ntipmol
        natoms=natoms+nmol(ic)*nsites(ic)
        end do
c *** calculo de la distancia de enlace 
c Change Mixture 10
      do i=1,ntipmol
      if(nsites(i).gt.1)then
      iref=2
      dtrans(i) = (xb(i,iref)-xb(i,1))**2 + (yb(i,iref)-yb(i,1))**2 +
     >         (zb(i,iref)-zb(i,1))**2
      dtrans(i) = dtrans(i)**0.5
      rlstar(i) = dtrans(i)
      endif
      end do

      RMAX=NGRID*DELTAR
      IRUN=0
      sangu1=0.0000
      sangu2=0.0000
      sangu3=0.0000
      sangu4=0.0000
      DO 336 I=1,nrhomax
      CONTARO(I)=0.00
 336  CONTINUE 

      part=float(nmoltot)
      part2=part/2.0
c
C
c CALCULANDO EL VALOR MINIMO DE LA LONGITUD DE LA CAJA QUE
C EVITA SOLAPAMIENTOS CON IMAGENES PERIODICAS DIFERENTES DE 
C LA MOLECULA CENTRAL: esta formula es valida para lineales 
c      boxlmi=(2.*((nsites-1)*RLSTAR+1.))**2
C
c     initialize atom coords. in body frame
c   
      NEQHAL=NEQ/2

	cacc = 0.
	racc = 0.
        tiacc = 0.
	biacc = 0.
	vacc = 0.
	rnucacc=0.
	
	do iti=1,ntipmol
	dcm(iti)=0.
        dcmcuad(iti)=0.
	contador(iti)=0.
	enddo

	atmptcm = 0.
	atmptro = 0.
        atmptint= 0.
	atmptvo = 0.
	atmptcb = 0.
	atmptnuc=0.
        
        i1=0
        i2=0
        i3=0
        i4=0
        i5=0

	   if(sumaq2.gt.0.000001)iewald=1

	sumlanda=xlan1+xlan2
	if(sumlanda.gt.0.0000001)ifree=1
	   
      i1=i1+nmol(ic)*nsites(ic)
      i2=i2+nmol(ic)
      i3=i3+nsites(ic)
      end do
      nsitestot=i3

      if (nsitestot.gt.ntipmol*nsmax) then
	 write(3,*) 'nsitestot',nsitestot
	 write(3,*) 'ntipmol',ntipmol,'nsmax',nsmax
         write(3,*) 'nsmax too small'
         stop
      end if

      call init_conf(rhog,rnstep)

      detH=h(1,1)*(h(2,2)*h(3,3)-h(3,2)*h(2,3))
     *-h(2,1)*(h(1,2)*h(3,3)
     *-h(1,3)*h(3,2))+h(3,1)*(h(1,2)*h(2,3)-h(1,3)*h(2,2))

      vol=abs(detH)

      rho=part/vol


      sidea=0.0
      sideb=0.0
      sidec=0.0

      do 14 i=1,3
      sidea=sidea+h(i,1)**2
      sideb=sideb+h(i,2)**2
      sidec=sidec+h(i,3)**2
   14 continue

      sidea=sqrt(sidea)
      sideb=sqrt(sideb)
      sidec=sqrt(sidec)

	

c     sideav=(sidea+sideb+sidec)/3.
c     
c     alfa=5.5/sideav

c	alfa=0.83/sigma(1)

c *** inicializando variables de control de la proporcion de mvts

	frac_cm  = patmp_cm
	frac_rot = patmp_cm + patmp_rot
        frac_int = patmp_cm + patmp_rot + patmp_int
	frac_cb  = patmp_cm + patmp_rot + patmp_int + patmp_cb


	if (frac_cb.ne.1.) then

	   write(3,*) 'OJO! suma de fraccion de mvts distinta de uno.'
	   write(3,*) 'suma =',frac_cb
	   write(3,*) 'correjida diferencia hasta 1'

	      frac_cb=1.

	end if

       rcut=sqrt(rcut2)
       ulrtot=0.
       do ic=1,ntipmol
        do il=1,ntipmol
         do ii=1,nsites(ic)
          do ij=1,nsites(il)
           sigma1=sigma(nordcar(ic,ii))
           sigma2=sigma(nordcar(il,ij))

           intid=min(int(sigma1),int(sigma2))*10+
     >           max(int(sigma1),int(sigma2))

	if(parpot(intid,7).lt.0.1)then  !para no Yukawas
          ulr=2.*PI*(
     >  -parpot(intid,3)/(parpot(intid,5)-3.)/rcut**(parpot(intid,5)-3.)
     >  -parpot(intid,4)/(parpot(intid,6)-3.)/rcut**(parpot(intid,6)-3.) 
     >  +parpot(intid,1)*parpot(intid,2)*(
     >  exp(-rcut/parpot(intid,2))*
     >  (rcut**2+2.*rcut*parpot(intid,2)+2.*parpot(intid,2)**2)))
	endif

	if(parpot(intid,7).gt.0.9)then  !para Yukawas
        ulr=2.*PI*(exp(-rcut/parpot(intid,2))*parpot(intid,2)
     >  *parpot(intid,1)*(rcut+parpot(intid,2)))
	endif



        xi=float(nmol(ic))/float(nmoltot)
        xj=float(nmol(il))/float(nmoltot)
        ulrtot=ulrtot+xi*xj*ulr
          enddo
         enddo
        end do
       end do
       !ulrtot=ulrtot*1000./rN_avo/rk_boltz

!Atencion hago igual a cero la correccion de largo alcance
!Esto solo vale si se hacen NVT o si es cero realmente
	ulrtot=0


c *** inicializando linked-list

      call make_cell_map(sidea,sideb,sidec,cutoff)

      call make_link_list(natoms)

c *** calculo de la energia de la configuracion (intermolecular) inicial

      !call sysenergy(utotreal,iax)
      !call syspressure(utotreal,rnstep,iax)
c *** reponiendo la link-cell-list

      if(iunbias.eq.1)then 
      call q6q4q3q2dot(nclbigdot,iatsol) 
      nclusters=nclusters+1
      endif


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11
!here we keep track of the configuration at
!which each particle became solid for the first
!time
! For a particle to be identified as having become
! solid it has to be solid for two steps in a row. 
! Otherwise a particle that was instantaneously 
! solid is counted. 
	rtimestep(ibucle)=rnstep
        if(ibucle.eq.1)then
         do iu=1,nmoltot
          isolidifico(iu)=0
	  q6bartotprev(iu)=q6bartot(iu)
         enddo
        endif

	if(ibucle.ge.2)then
        do iu=1,nmoltot
        if(((q6bartot(iu)-q6bartotprev(iu)).ge.0.1)
     >   .and.(q6bartot(iu).ge.0.33).and.(isolidifico(iu).eq.0))then
         isolidifico(iu)=ibucle-1
        endif
	 q6bartotprev(iu)=q6bartot(iu)
        enddo
	endif

        if(ibucle.eq.ibuclefin)then
         do iu=1,nmoltot
	  iaqui=isolidifico(iu)
          write(515,*)iaqui,rtimestep(iaqui)
	  write(719,*)q6bartot(iu),q4bartot(iu)
         enddo
        endif
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11
!  Here we plot the fraction of solid particles
!  for a certain set of particles

	is=0
	iss=0

	rewind(938)

	do i=1,nmoltot
	 is=is+1
	 read(938,*,end=44)ii 
	 if(iatsol(ii).eq.1)iss=iss+1
	enddo


  44    write(663,*)rnstep,float(iss)/float(is),iss,is	

	rewind(938)
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	if(rtimeblock.ge.rtimealpha)then
         call xyzsome(iatsol,2)
         do i=1,nmoltot
          iatpc(i)=1
	  iatbgc(i)=0
         enddo

	 do i=1,ncb
	   kk=indmolclbig(i)
	   iatbgc(kk)=1
	 enddo

         call xyzsome(iatpc,5)
         call xyzsome(isolmrco,6)
         call xyzsome(isolfcc,7)
         call xyzsome(isolgra,8)
         call xyzsome(iatbgc,0)

	endif
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1111

!	call boxdensity (iatsol)

	print*,utotreal,'en inicio'

	u_ljinter=u_lj
	  i101=0
        Uintranew=0.0
        do im=1,nmoltot

           ic=class(im)
           numori=puntero1(ic)+(im-1-puntero2(ic))*nsites(ic)
          do is=1,nsites(ic)
           i101=i101+1
             numsite=numori+is
             xtcart(is)=xa(numsite)*h(1,1)+ya(numsite)*h(1,2)
     >                                  +za(numsite)*h(1,3)
             ytcart(is)=xa(numsite)*h(2,1)+ya(numsite)*h(2,2)
     >                                  +za(numsite)*h(2,3)
             ztcart(is)=xa(numsite)*h(3,1)+ya(numsite)*h(3,2)
     >                                  +za(numsite)*h(3,3)
          end do

          sumamol=0.000
	    u_ljintra=0.
          do in=1,nsites(ic)-1
               call intramol(in,1,xtcart(in),ytcart(in),
     >            ztcart(in),nsites(ic),xtcart,ytcart,ztcart
     >           ,wintra,numori,energint,u_lji)
               sumamol=sumamol+energint 
	         u_ljintra=u_ljintra+u_lji
          enddo

          Uintranew=Uintranew+sumamol 

        enddo
        
      eint_o=uintranew

	u_lj=u_ljinter+u_ljintra
	
	
c*** Calculamos el término de superficie
	surface=0.
	if(iewald.eq.1)then
        i101=0
        qrxsuma=0.
        qrysuma=0.
        qrzsuma=0.
      pi=acos(-1.0000000) 
        
        do im=1,nmoltot

           ic=class(im)
           numori=puntero1(ic)+(im-1-puntero2(ic))*nsites(ic)
       
          do is=1,nsites(ic)
           i101=i101+1
             numsite=numori+is
             xtcart(is)=xa(numsite)*h(1,1)+ya(numsite)*h(1,2)
     >                                  +za(numsite)*h(1,3)
             ytcart(is)=xa(numsite)*h(2,1)+ya(numsite)*h(2,2)
     >                                  +za(numsite)*h(2,3)
             ztcart(is)=xa(numsite)*h(3,1)+ya(numsite)*h(3,2)
     >                                  +za(numsite)*h(3,3)

            qrx=cargatom(i101)*xtcart(is)
            qry=cargatom(i101)*ytcart(is)
            qrz=cargatom(i101)*ztcart(is)

            qrxsuma=qrxsuma+qrx
            qrysuma=qrysuma+qry
            qrzsuma=qrzsuma+qrz
            
          end do
        enddo
      sumqr2=qrxsuma**2.+qrysuma**2.+qrzsuma**2.
      surface=2.*pi/(3.*vol)*sumqr2
	endif
	

c*** calculo la energía iónica de espacio recíproco

      ufold=0.
      if(iewald.eq.1)then 
      call ufourier(h,ufcalculo)
      ufold=ufcalculo
      endif

c*** calculo el self-term      
      
      self=0. 
      if(iewald.eq.1)then
      pi=acos(-1.0000000) 
      self=-alfa/sqrt(pi)*sumaq2
      endif
      
c*** energía total del sistema en unidades de kT

      ulong=ulrtot*rho*float(nmoltot)
      utot=beta*(utotreal+ufold+eint_o+self+ulong)

	u_inicial=utot


      conv=6.022136E+23*1.380658E-23/beta/4.184/1000./nmoltot
      Ukcalmol=utot*conv
      print*,ulrtot*conv*beta*rho*float(nmoltot),'energia largo alcance'
      print*,beta*conv*eint_o ,'engergia intramolecular '
      print*,beta*conv*utotreal ,'engergia real inter'
      print*,beta*conv*ufold ,'engergia de fourier  '
      print*,beta*conv*self ,'engergia selfterm'
       print*,beta*conv*surface ,'engergia surface'
      print*,Ukcalmol,'energia inicial en Kcalmol'
      print*,utot ,'utotal del sistema en kT = (U/NkT)* Nmol,'
      print*,'maxvecrun=',maxvecrun
      write(*,112) utot
      
 112  format(f25.15)

	if(iwidom.eq.1)then
	 call widomsetup
	endif

        if(inucleacion.eq.1)then
         call q6q4q3q2dot(nclbig)
         ebias=0.5*rkbias*((nclbig-rnclcero)**2.)
         call saveconf 
        endif


      return 
      end


c *****************************************************************

      subroutine init_conf(rhog,rnstep)

	include 'parametros_NpT.inc'
	include 'common.inc'

 
      character*4 otra

      IF(kstart.eq.0)THEN 
      stlatt=rlstar(1)/sqrt(3.0)
      ctlatt=sqrt(1.0-stlatt**2)
       philatt=1.0/12.0
       if((ntipmol.ne.1).and.(ilatt.ne.0)) then
       write(3,*)  'lo siento para mezclas solo acepto alfa-N'
       stop
       end if

          if(ilatt.ne.0) then

      else
c
      vol=part/rhog
      side=exp(log(vol)/3.0)
c
      do 33 i=1,3
      do 44 j=1,3
      h(i,j)=0.0
   44 continue
   33 continue
c
      h(1,1)=side
      h(2,2)=side
      h(3,3)=side
c
ccj2  initialize h matrix for rhombohedron of volume nmoltot/rhog
c
      endif
c
c Julio change number 18
c
      detH=h(1,1)*(h(2,2)*h(3,3)-h(2,3)*h(3,2))
     1   -h(2,1)*(h(1,2)*h(3,3)
     1   -h(1,3)*h(3,2))+h(3,1)*(h(1,2)*h(2,3)-h(1,3)*h(2,2))
  
       hinv(1,1)=(h(2,2)*h(3,3)-h(2,3)*h(3,2))/detH
       hinv(2,1)=-(h(2,1)*h(3,3)-h(3,1)*h(2,3))/detH
       hinv(3,1)=(h(2,1)*h(3,2)-h(3,1)*h(2,2))/detH
       hinv(1,2)=-(h(1,2)*h(3,3)-h(3,2)*h(1,3))/detH
       hinv(2,2)=(h(1,1)*h(3,3)-h(3,1)*h(1,3))/detH
       hinv(3,2)=-(h(1,1)*h(3,2)-h(3,1)*h(1,2))/detH
       hinv(1,3)=(h(1,2)*h(2,3)-h(2,2)*h(1,3))/detH
       hinv(2,3)=-(h(1,1)*h(2,3)-h(2,1)*h(1,3))/detH
       hinv(3,3)=(h(1,1)*h(2,2)-h(2,1)*h(1,2))/detH

c
      call lattice
c
      ELSE
c

	if(kstart.eq.1)then
 	numdesites=0

        read(2,*)otra,rnstep
        !read(2,*)
        read(2,*)

	rporaquiva=rnstep

	print*,ibucle,ileaveout,rtimeblock,rtimealpha

	if((ibucle.gt.ileaveout).or.(rtimeblock.ge.rtimealpha))then
	print*,'se mete'
	  rtime0=rnstep
	  ileaveout=99999999 
	endif

	rtimeblock=rnstep-rtime0

	print*,rtimeblock,' el bloke' 

 
	do i8=1,ntipmol
 	numdesites=nmol(i8)*nsites(i8)+numdesites
 	enddo

        do ique=1,numdesites
         read(2,*) xa(ique),ya(ique),za(ique)
        end do
c
        do ique=1,3
         read(2,*)h(ique,1),h(ique,2),h(ique,3)
        end do

	endif
c
c        do ique=1,3
c            read(2,*)ht(ique,1),ht(ique,2),ht(ique,3)
c        end do
c
c        read(2,*)utot,etot,ngt
                                                                  

c
c      do ii=1,natmax
c      write(6,*) ii,xa(ii),ya(ii),za(ii)
c      end do
c      write(6,*) h(1,1),h(1,2),h(1,3)
c      write(6,*) h(2,1),h(2,2),h(2,3)
c      write(6,*) h(3,1),h(3,2),h(3,3)
c
      if(kstart.eq.2) then
	   read (2) xa,ya,za
     *   ,h,ht,utot,etot,ngt,subh,toth
     *   ,cacc,racc,pbacc,tbacc,biacc,vacc,gcacc,tiacc
     *   ,atmptcm,atmptro,atmptcb,atmpttcb,atmptvo,atmpttest
     *   ,atmptgcb,atmptint
     *   ,cdx,cdy,cdz
     *   ,voltot,volsub,RHOTOT,RHO2TOT,rhosub,UNKTTOT,UNKTSUB
     *   ,enkttot,enktsub,sotot,sosub 
     *   ,gntot,gnsub
     *   ,R1ntot,R1nvtot
     *   ,sangu1,sangu2,sangu3,sangu4
     *   ,contaro
	   read (2) irun,gss
	end if
c
c
c Julio change number 18 prima
c Tambien hay que inicializar hinv si leemos
c la configuracion 
c
      detH=h(1,1)*(h(2,2)*h(3,3)-h(2,3)*h(3,2))
     1   -h(2,1)*(h(1,2)*h(3,3)
     1   -h(1,3)*h(3,2))+h(3,1)*(h(1,2)*h(2,3)-h(1,3)*h(2,2))
  
       hinv(1,1)=(h(2,2)*h(3,3)-h(2,3)*h(3,2))/detH
       hinv(2,1)=-(h(2,1)*h(3,3)-h(3,1)*h(2,3))/detH
       hinv(3,1)=(h(2,1)*h(3,2)-h(3,1)*h(2,2))/detH
       hinv(1,2)=-(h(1,2)*h(3,3)-h(3,2)*h(1,3))/detH
       hinv(2,2)=(h(1,1)*h(3,3)-h(3,1)*h(1,3))/detH
       hinv(3,2)=-(h(1,1)*h(3,2)-h(3,1)*h(1,2))/detH
       hinv(1,3)=(h(1,2)*h(2,3)-h(2,2)*h(1,3))/detH
       hinv(2,3)=-(h(1,1)*h(2,3)-h(2,1)*h(1,3))/detH
       hinv(3,3)=(h(1,1)*h(2,2)-h(2,1)*h(1,2))/detH


      ENDIF
      return
      end

c *******************************************************************
c *** subrutina para la evaluacion de promedios globales e
c *** instantaneos

      subroutine promedios

	include 'parametros_NpT.inc'
	include 'common.inc'

c     chantal sett 2011      
c      integer conta


      if(ntot.le.neq) then
        tot=float(ntot)
      else
        tot=float(ntot-neq)
      end if

      volav=voltot/tot
      rhoav=rhotot/tot
      UNKTAV=UNKTTOT/TOT
      RHO2AV=RHO2TOT/TOT
      soav=sotot/tot
      sl1av=sl1tot/tot
      sl2av=sl2tot/tot
      sl3av=sl3tot/tot

      u_ljkav=u_ljktot/tot

      ebiaskav=ebiasktot/tot	

      unktavet=unkttotet/tot
      unktaverr=unkttoterr/tot
      unktavers=unkttoters/tot

      expoav=expotot/tot

      cacctot = cacc+cacctot
      racctot = racc+racctot
      tiacctot = tiacctot+tiacc
      vacctot = vacctot+vacc
      cbacctot = cbacctot+biacc
      rnucacctot = rnucacctot + rnucacc

      atmptcmtot = atmptcmtot+atmptcm
      atmptrotot = atmptrotot+atmptro
      atmptinttot=  atmptinttot+atmptint
      atmptvotot = atmptvotot+atmptvo
      atmptcbtot = atmptcbtot+atmptcb
      atmptnuctot = atmptnuctot+atmptnuc

      do 7 i=1,3
      do 8 j=1,3
      hav(i,j)=toth(i,j)/tot
    8 continue
    7 continue
c
      if (ntot.gt.neq) then
         ! CALL TERMO
      end if
      volavs=volsub/float(npr)
      rhoavs=rhosub/float(npr)
      UNKTAVS=UNKTSUB/FLOAT(NPR)

	u_ljkavs=u_ljksub/float(npr)

	ebiaskavs=ebiasksub/float(npr)

      unktavset=unktsubet/float(npr)
      unktavserr=unktsuberr/float(npr)
      unktavsers=unktsubers/float(npr)

      expoavs=exposub/float(npr)

      soavs=sosub/float(npr)
      sl1avs=sl1sub/float(npr)
      sl2avs=sl2sub/float(npr)
      sl3avs=sl3sub/float(npr)

      open(22,file='blockav.dat') !,position='append')
       !write(20,268) ntot,volav,unktav 
       !write(21,269) ntot,rat_cm,rat_ro,rat_vo,rat_int
       !write(22,270) ntot,rhoavs,soavs,sl1avs,sl2avs,sl3avs
       write(22,270) ntot,unktavs/beta,rhoavs,float(nsolid)

	!close(22)

	 if((iwidom.eq.1).and.(ntot.ge.neq))then  
        !rmu=-log(sumebdut/float(insertions))
	  rmu=-log(sumebdut/float(insperconf)/float((ntot-neq)/npr+1))	
        rmukjmol=rmu/beta*6.022136E+23*1.380658E-23/1000.
        write(25,271) ntot,rmu,rmukjmol,-log(sumebdutconfav),eperconfav,
     >                insexitoconf
	 endif

c *** calculando probabilidades de aceptacion

c *** para mvt cm

      if (atmptcm.gt.0) then
         rat_cm=cacc/atmptcm
      else
	 rat_cm=0.
      end if
 
c *** para mvt rot

      if (atmptro.gt.0) then
       rat_ro=racc/atmptro
      else
       rat_ro=0.
      end if

c *** para intercambios de identidad 

      if (atmptint.gt.0) then
         rat_int=tiacc/atmptint
      else
         rat_int=0.
      end if

c *** para cambio conformacional
	
      if (atmptcb.gt.0) then
	rat_cb = biacc/atmptcb
      else
	rat_cb = 0.
      end if
	 
     
c *** para cambio de volumen

	if (atmptvo.gt.0) then
           rat_vo=vacc/atmptvo
	else
	   rat_vo=0.
	end if

c *** para aceptacion de trayectorias en nucleacion
        if(inucleacion.eq.1)then
             rat_nuc=rnucacc/atmptnuc
        endif


c *** ajustando tamanho de las tobas si estamos equilibrando

	if (ntot.lt.neq) then

         ! ajuste de la toba de c.m.
         if (rat_cm.lt.0.35) then
		pshift = pshift/1.05
	   else if (rat_cm.gt.0.45) then
              
                if (pshift.lt.0.475) then
		   pshift = 1.05*pshift
                end if
	   end if
c
	   ! ajuste de la toba de rotacion
         if (rat_ro.lt.0.35) then
		ashift = ashift/1.05
	   else if (rat_ro.gt.0.45) then
                if (ashift.lt.0.475) then
		   ashift = 1.05*ashift
		end if
	   end if

	   ! ajuste de la toba de volumen
ccj Julio change number 19
ccj
         if (rat_vo.lt.0.35) then
		dela = dela/1.05
                dela1= dela1/1.05
	   else if (rat_vo.gt.0.45) then
		if (dela/vol.lt.0.04) then
		   dela = 1.05*dela
                   dela1= 1.05*dela1
                end if
	   end if

C Ajuste de la constante de bias
!       if(inucleacion.eq.1)then
!         if (rat_nuc.lt.0.35) then
!               rkbias=rkbias/1.05
!          else if (rat_nuc.gt.0.45) then
!               rkbias=1.05*rkbias
!          end if
!       endif
c
	end if

c *** acumuladores de bloque puestos a cero

      volsub=0.0
      rhosub=0.0
      UNKTSUB=0.0
      sosub=0.0
      sl1sub=0.0
      sl2sub=0.0
      sl3sub=0.0

	u_ljksub=0.0

	unktsuberr=0.
	unktsubers=0.
	unktsubet=0.

      exposub=0.

      racc=0.
      atmptro=0.
      cacc=0.
      rnucacc=0.
      atmptcm=0.
      vacc=0.
      biacc=0.
      atmptvo=0.
      tiacc=0.
      atmptint=0.
      atmptnuc=0.
      atmptcb=0.
c
      do 5 i=1,3
      do 6 j=1,3
      havs(i,j)=subh(i,j)/float(npr)
      subh(i,j)=0.0
    6 continue
    5 continue
c
c      write(6,220) tot,ratio,ratv
c      write(6,255) volav,volavs
c      write(6,265) rhoav,rhoavs
c      WRITE(6,266) rhoav,rhoavs
c      WRITE(6,267) UNKTAV,UNKTAVS
c      IF (NTOT.LE.NEQ) THEN
c      WRITE(6,*) ' DESVIACION ESTANDAR EN RHO =  0.00 '
c      ELSE 
c      RHOERR=SQRT(ABS(RHO2AV-RHOAV*RHOAV))
c      WRITE(6,*) ' DESVIACION ESTANDAR EN RHO = ',RHOERR
c      ENDIF 
c      write(6,274)
c      write(6,275) (hav(1,j),j=1,3),(havs(1,j),j=1,3)
c      write(6,275) (hav(2,j),j=1,3),(havs(2,j),j=1,3)
c      write(6,275) (hav(3,j),j=1,3),(havs(3,j),j=1,3)
c
      sideaav=0.0
      sidebav=0.0
      sidecav=0.0
      cosabav=0.0
      cosacav=0.0
      cosbcav=0.0
c
      do 9 i=1,3
      sideaav=sideaav+hav(i,1)**2
      sidebav=sidebav+hav(i,2)**2
      sidecav=sidecav+hav(i,3)**2
      cosabav=cosabav+hav(i,1)*hav(i,2)
      cosacav=cosacav+hav(i,1)*hav(i,3)
      cosbcav=cosbcav+hav(i,2)*hav(i,3)
    9 continue
c
      sideaav=sqrt(sideaav)
      sidebav=sqrt(sidebav)
      sidecav=sqrt(sidecav)
c
c
      if ( (sideaav.eq.0.00).or.(sidebav.eq.0.00).or.
     1     (sidecav.eq.0.00) ) then 
      cosabav=0.00
      cosacav=0.00
      cosbcav=0.00
c
      else 
c
      cosabav=cosabav/sideaav/sidebav
      cosacav=cosacav/sideaav/sidecav
      cosbcav=cosbcav/sidebav/sidecav
c
      end if
      call order
c
c     calculate order parameters for current configuration
c
      dsqx=0.0
      dsqy=0.0
      dsqz=0.0
c
c Change mixture 30
      do 2 i=1,nmoltot
      dsqx=dsqx+cdx(i)*cdx(i)
      dsqy=dsqy+cdy(i)*cdy(i)
      dsqz=dsqz+cdz(i)*cdz(i)
2     continue
c
      dsqx=dsqx/part
      dsqy=dsqy/part
      dsqz=dsqz/part
      dsq=dsqx+dsqy+dsqz
c
c     mean square displacements for x,y,z and r
c
      write(989,272)ntot,dsq,dsqx,dsqy,dsqz
c
265   format(1x,'cumula.<rho>*dhs**3=',f10.5,5x,'sub.<rho>*dhs**3=',
     *f10.5,/)
266   format(1x,'cumula.<rho>*sig**3=',f10.5,5x,'sub.<rho>*sig**3=',
     *f10.5,/)
267   format(1x,'cumula.U/NkT =',f10.5,5x,'sub.U/NkT = ',
     *f10.5,/)
268   format(i8,4(2x,f10.6))
269   format(i8,2x,6(f8.6,1x))
270   format(1x,i8,1x,5(1x,f11.5))
271   format(1x,i8,1x,3(1x,f11.5),1x,f20.5,1x,i8)
272   format(i8,1x,4(1x,f15.7))

      return
      end	

c *****************************************************************
c *** subrutina de salida de resultados finales

      subroutine salida(seed)

	include 'parametros_NpT.inc'
	include 'common.inc'

	dimension distcuadmed(ntipmolmax)
	dimension distmed(ntipmolmax)
c     chantal sett 2011
c      integer conta
      
      real*8 UtotalNeps
c
c *** cambio del modo kstart para que el eco modificado sirva de
c     fichero simulacion.inp de un nuevo run continuacion de este

      kstart=1

c *** eco
      write(3,*)
      write(3,*) 'Salida'
      write(3,*) 'alfa en sigmaunits=',alfa
      write(3,*) 'sumaq2 =',sumaq2
      write(3,*) pstar,rho,1./beta            ! estado termodinamico
      write(3,*) ntot,neq,nmax,njob           ! longitud simulacion
      write(3,*) pshift,ashift,dela,dela1     ! tamanho tobas MC
      write(3,*) seed                         ! numero semilla
c Change mixture 30
      write(3,*) kstart,nmoltot,ntipmol       ! modo de comienzo
      write(3,*) (nmol(i),i=1,ntipmol)
      write(3,*) (nsites(i),i=1,ntipmol)
c      write(3,*) kstart,nmol                  ! modo de comienzo
      write(3,*) ilatt,nx,ny,nz             ! modo de comienzo en solido
      write(3,*) npr,iscale,inpt    ! modo de funcionamiento
      write(3,*) patmp_cm,patmp_rot,patmp_int,patmp_cb
     >			 ! attempt probabilities
      write(3,*) deltar,ngrid                 ! parametros g(r)
      write(3,*) drho                         ! intervalos de rho
      write(3,*) inucleacion,rkbias,rnclcero,iunbias    ! se hace nucleacion?
                                                           ! constante bias potential
                                                           ! tamanno cluster origen

      write(3,*)


!        rewind 2

 	numdesites=0
 
	do i8=1,ntipmol
 	numdesites=nmol(i8)*nsites(i8)+numdesites
 	enddo

	open(unit=15,file='init.dat',status='unknown')

c En el fichero init.dat doy la presión en bares 
      factorp=1.E+5*beta/(1.380658E-23*1.E+30)
c Y la densidad en g/cm**3
       rho=rho*(rpesomolec*1.0E+24)/6.0221367E+23

	
c      write(15,44) pstar/factorp,rho,1./beta    ! estado termodinamico
      write(15,44) pstar/beta,rho,1./beta    ! estado termodinamico
      write(15,*) '0  ',neq,nmax,njob           ! longitud simulacion
      write(15,37) pshift,ashift,dela,dela1           ! tamanho tobas MC
      write(15,*) seed                         ! numero semilla
      write(15,*) kstart,nmoltot,ntipmol           ! modo de comienzo
      write(15,*) ilatt,nx,ny,nz          !modo de comienzo en solido
      write(15,*) npr,nwr
      write(15,*) iscale,inpt            ! modo de funcionamiento
      write(15,45) patmp_cm,patmp_rot,patmp_int,patmp_cb 
     >	! attempt probabilities
      write(15,*) deltar,ngrid                 ! parametros g(r)
      write(15,*) drho                         ! intervalos de rho
      write(15,*) xlan1,xlan2                 !lambda1,lambda2
      write(15,*) iumbrella                    !iumbrella     
	write(15,*) iwidom                  
        write(15,*) inucleacion,rkbias,rnclcero,iunbias    ! se hace nucleacion?
                                                           ! constante bias potential
                                                           ! tamanno cluster origen

	write(15,*)iffs,nextint
	write(15,*)ibrownian,deltatiempo


44    format(4x,f14.4,4x,f24.20,4x,f14.4)
45    format(6(2x,f6.4))	
37    format(f10.5,1x,f10.5,1x,f10.5,1x,f10.5)


C calculo y salida de las funciones de distribucion

       CALL SALI(RHOAV)
      
      write(3,220) tot

	
	   
	if (atmptcmtot.gt.0) then
	   rat_cm=cacctot/atmptcmtot
	   write(3,221) rat_cm           
	   write(3,*)cacctot,atmptcmtot,'acepto e intento cmmove'  
	end if
	if (atmptrotot.gt.0) then
	   rat_ro=racctot/atmptrotot
	   write(3,222) rat_ro               
	end if
        if (atmptinttot.gt.0) then
          rat_int=tiacctot/atmptinttot
           write(3,223) rat_int                 
        end if
	if (atmptcbtot.gt.0) then
	    rat_cb=cbacctot/atmptcbtot
	    write(3,226) rat_cb
	    write(3,*)cbacctot,atmptcbtot,'acepto e intento clmove'
	endif
	if (atmptvotot.gt.0) then
          rat_vo=vacctot/atmptvotot
         write(3,225) rat_vo               
	end if

	print*,atmptnuctot
        if (atmptnuctot.gt.0.) then
            rat_nuc=rnucacctot/atmptnuctot
            print*,rnucacctot,'acepta'
            print*,atmptnuctot, 'hace'
         write(3,227) rat_nuc
        endif



	write(3,*)
	write(3,*)
	write(3,*) '  All lengths in input length units'
	write(3,*) '------------------------------------'

      write(3,255) volav,volavs
      WRITE(3,266) rhoav,rhoavs
      WRITE(3,267) UNKTAV,UNKTAVS 
      
c Energia total
      UtotalNKT=UNKTAV
      UtotalNeps=UtotalNKT*1./beta
      Utotalkjmol=UtotalNKT*rN_avo*rk_boltz/beta/1000.
      write(3,*)'ENERGIA TOTAL'
      WRITE(3,*) UtotalNKT,'total NkT'
      WRITE(3,*) UtotalNeps,'total NK'
      WRITE(3,*) Utotalkjmol,'total KJ/mol'
c Correccion de largo alcance
      ulrtotnkt=ulrtot*beta*rhoav
      ulrtotkjmol=ulrtotnkt*rN_avo*rk_boltz/beta/1000.
      write(3,*)'Contribuci�n largo alcance'
      WRITE(3,*) ulrtotnkt,'lrange NKT'
      WRITE(3,*) ulrtotkjmol,'lrange KJ/mol'
c Energia tres cuerpos
c     u3nkt=utres_kav*beta/part
c     u3kjmol=utres_kav*rk_boltz/part*rN_avo/1000.
c     write(3,*)'Contribuci�n tres cuerpos'
c     write(3,*) u3nkt,'trescu NKT'
c     write(3,*) u3kjmol,'trescu KJ/mol'
c Energia LJ
      u_ljnktav=u_ljkav*beta/part+ulrtotnkt
      write(3,*)'Contribuci�n LJ a la energ�a es: '
      write(3,*) u_ljnktav,' lj NkT'
      write(3,*) u_ljnktav*rk_boltz*6.022136E+23*1./beta/1000.,'ljkJmol'
c Energia ionica
      uinkt=-u_ljnktav+utotalnkt !-u3nkt
      uikjmol=(uinkt)*rk_boltz*1./beta*rN_avo/1000.
      write(3,*)'Contribuci�n i�nica es: '
      write(3,*)uinkt,' ionica NKT'
      write(3,*)uikjmol,'ionica Kjmol'

        if(inucleacion.eq.1)then
c Energia de bias
         write(3,*) ebiaskav*beta/part, 'ebias NkT'
         write(3,*) ebiaskav*rk_boltz/part*rN_avo, 'ebias KJ/mol'
        endif



c
      conv2=6.022136E+23*1.380658E-23/beta/4.184/1000
      ukcalmol=utotalNKT*conv2 
      write(3,*) ' U/(Kcal/mol)',ukcalmol

      write(3,*) 'Numero max.de vectores utilizados en espa.recipro'
      write(3,*) 'maxvecrun=',maxvecrun


	if(ifree.eq.1)then
      write(3,*) '       '
      write(3,*) 'Lo concerniente al método Frenkel-Laad'   
      write(3,*) '--------------------------------------'
      write(3,*) 'xlan1/kT=',xlan1, 'xlan2/kT=',xlan2
      write(3,*) '       '
      write(3,762) unktavet,unktavset
      write(3,*) '   '
      write(3,763) unktaverr,unktavserr
      write(3,*) '   '
      write(3,964) unktavers,unktavsers
      write(3,*) '   '
 762  FORMAT(1X,'U_desp/NkT(cum)=',f12.7,5x,'U_desp/NKT(block)=',
     *F12.7,/)
      write(3,*) '   '
 763  FORMAT(1X,'U_r_r/NKT(cum)=',f12.7,5x,'U_r_r/NKT(block)=',
     *F12.7,/)
 964  FORMAT(1X,'U_r_s/NKT(cum)=',f12.7,5x,'U_r_s/NKT(block)=',
     *F12.7,/)
c
      if (xlan1.ne.0.000) then
      dest=unktavet/xlan1
      destvs=unktavset/xlan1
      endif
      if (xlan2.ne.0.000) then
      desrr=unktaverr/xlan2
      desrvsr=unktavserr/xlan2
      desrs=unktavers/xlan2
      desrvss=unktavsers/xlan2
      endif
c
      destot=dest+desrr+desrs
c
      write(3,*) '   '
      write(3,764) dest,destvs
      write(3,*) '   '
      write(3,765) desrr,desrvsr
      write(3,*) '   '
      write(3,767) desrs,desrvss
      write(3,*) '   '
      write(3,766) destot
c
c

c
	endif
      write(3,*) '--------------------------------------'
      write(3,*) '   '
	
	if(iumbrella.eq.1.)then
       AAumbrella=(-1./part)*(log(expoav)-u_inicial)
       AAumbrellasub=(-1./part)*(log(expoavs)-u_inicial)
       
       write(3,777) AAumbrella,AAumbrellasub
       write(3,*) 'U_red', U_inicial/part
  	 write(3,*)
	endif



! Lo concerniente al test de widom
	if(iwidom.eq.1)then
	write(3,*) '------------------------------------------'
	write(3,*) 'Lo concerniente al test de Widom'
	rmu=-log(sumebdut/float(insertions))
	write(3,*) 'mu/KT=',rmu
	rmukjmol=rmu/beta*6.022136E+23*1.380658E-23/1000.
	write(3,*) 'mu/Kj/mol=',rmukjmol
	write(3,*) 'Numero de inserciones=',insertions
	rmulong=beta*ulongtest
	rmulongjkmol=rmulong/beta*6.022136E+23*1.380658E-23/1000.
	write(3,*)'Tail correct.:',rmulong,'/kT;',rmulongjkmol,'/kj/mol'
	perinsexito=(float(insexito)/float(insertions))*100.
	write(3,*)'Hubo un',perinsexito,'% de ins. que no solaparon' 
	write(3,*) '------------------------------------------'
	endif

	
 764  FORMAT(1X,'CUMU. <(r-r0)**2>=',f13.8,'SUB <(r-r0)**2>=',f13.8)
 767  FORMAT(1X,'CUMU.<PHY**2/PI>=',f13.8,'SUB<PHY**2/PI>=',f13.8)
 765  FORMAT(1X,'CUMU.<(1-CTETA**2)>=',f13.8,'SUB<(1-CTETA**2)>=',f13.8)
 766  FORMAT(1X,'CUM.<(r-r0)**2>+<(1-CTETA**2)>+<PHY**2/PI>=',f13.8)
 777  FORMAT(1X,'CUM.Del_umb',f13.8,'SUB.Del_umb',f13.8,'NKT')
cccccccccccc

      RHOERR=SQRT(ABS(RHO2AV-RHOAV*RHOAV))
      WRITE(3,*) ' DESVIACION ESTANDAR EN RHO = ',RHOERR

      write(3,269) cutoff

	 
      write(3,274)
      write(3,275) (hav(1,j),j=1,3),(havs(1,j),j=1,3)
      write(3,275) (hav(2,j),j=1,3),(havs(2,j),j=1,3)
      write(3,275) (hav(3,j),j=1,3),(havs(3,j),j=1,3)
      write(3,276) sideaav,sidebav,sidecav,cosabav,cosacav,cosbcav
      write(3,277) soav,soavs
      write(3,290) sl1av,sl2av,sl3av
      write(3,230) dsqx,dsqy,dsqz,dsq
c *** angulo medio 
      angum1=sangu1/float(irun)*180./pi
      angum2=sangu2/float(irun)*180./pi
      angum3=sangu3/float(irun)*180./pi
      angum4=sangu4/float(irun)*180./pi
      write(3,*) ' Promedios angulares moleculas impares '
      write(3,*) 'angulo medio (vec.per.pla.ab,umol)  ',angum1
      write(3,*) 'angulo medio (acaja,Proyec.umol plano ab)',angum2
      write(3,*) ' Promedios angulares moleculas pares '
      write(3,*) 'angulo medio (vec.per.pla.ab,umol) ',angum3
      write(3,*) 'angulo medio (acaja,Proyec.umol plano ab)',angum4
C
C SALIDA DE FUNCION DE DISTRIBUCION DE DENSIDADES 
      write(3,*)
	write(3,*) ' Histograma de densidades '
	write(3,*) '--------------------------'
	write(3,*)
      DO 555 IRO=1,nrhomax
      AUXI=(IRO-1)*drho+0.5*drho
      IF (CONTARO(IRO).NE.0.) THEN
      WRITE(3,*) AUXI,CONTARO(IRO)
      ENDIF 
 555  CONTINUE
c
        do i=1,ntipmol

	distcuadmed(i)=dcmcuad(i)/contador(i)
 	write(3,*) 'distancia ext-ext cuadrática media='
     >  ,distcuadmed(i),i
	distmed(i)=dcm(i)/contador(i)
        write(3,*) 'distancia ext-ext media           =',distmed(i),i
	enddo

	dgrcm3=rhoav*rpesomolec*1.E+24/6.0221367E+23
	uint=UtotalNKT
	Ukcalmol=uint*6.022136E+23*1.380658E-23/beta/4.184/1000.
c       write(3,*),'grafi',rhoav,utotalneps
        write(3,*)'grafi',dgrcm3,Ukcalmol  
c       print*,Ukcalmol,'Energía final en Kcal/mol'        

	if((iunbias.eq.1).or.(inucleacion.eq.1))then
c  Escribo las funciones de distribucion de q6, q4 y del numero de
c  vecinos

        open(47,file='histoclbig.dat',status='unknown')
        open(48,file='histoclust.dat',status='unknown')
        open(50,file='histoclustfrenk.dat',status='unknown')
        open(49,file='histoclbigunbias.dat',status='unknown')
        open(556,file='histoq6.dat',status='unknown')
        open(557,file='histoq4.dat',status='unknown')
        open(558,file='histoq3.dat',status='unknown')
        open(559,file='histoq2.dat',status='unknown')
        open(65,file='histovec.dat',status='unknown')
        open(68,file='histoconex.dat',status='unknown')
        open(66,file='AGn.dat',status='unknown')

	print*,'nsolid,ncb',nsolid,ncb

        nclustbig=0
        nclust=0
        do ioh=1,nmmax
         nclustbig=nclustbig+nhistoclbig(ioh)
        enddo

        nconex=0
        do ioh=0,nmmax
         nclust=nclust+nhistoclus(ioh)
         nconex=nconex+nhistoconex(ioh)
        enddo

        do ioh=1,nmmax
         write(47,*) ioh,float(nhistoclbig(ioh))/float(nclustbig)
         write(49,*) ioh,histoclbigunb(ioh)/sumexpbias
         write(66,*) ioh,-log(histoclbigunb(ioh)/sumexpbias)
        enddo

        if(ntipmolmax.eq.3)then
          npartanuc=nmoltot-nmol(1)
        else
          npartanuc=nmoltot
        endif

      do ioh=0,nmmax
         write(48,*) ioh,float(nhistoclus(ioh))/float(nclust)
         write(50,*)ioh,float(nhistoclus(ioh))
     >  /float(nclusters)/float(npartanuc)
         write(68,*) ioh,float(nhistoconex(ioh))/float(nconex)
        enddo

        deltaq6=2./201.
        ip4=0
        ip6=0
        ip3=0
        ip2=0
        do io=-100,100
          ip4=ip4+nhistoq4(io)
          ip6=ip6+nhistoq6(io)
          ip3=ip3+nhistoq3(io)
          ip2=ip2+nhistoq2(io)
        enddo

        do io=-100,100
         rq6q6=float(io)*deltaq6
         write(556,*)rq6q6,float(nhistoq6(io))/float(nnormal)
      enddo

        do io=-100,100
         rq4q4=float(io)*deltaq6
         write(557,*)rq4q4,float(nhistoq4(io))/float(nnormal)
      enddo

        do io=-100,100
         rq3q3=float(io)*deltaq6
         write(558,*)rq3q3,float(nhistoq3(io))/float(nnormal)
      enddo

        do io=-100,100
         rq2q2=float(io)*deltaq6
         write(559,*)rq2q2,float(nhistoq2(io))/float(nnormal)
      enddo

        nvecimax=nmmax

        do ii=0,nvecimax
         write(65,*)ii,nvecinostot(ii) !numero de veces que aparecen ii vecinos
        enddo

        print*, 'voy deentro en salida'
	endif  !fin de escritura de los ficheros de nucleaci�n

	return

200   format(///,5x,'M. C. Hard Diatomics',
     */,4x,22('*'),/,4x,22('*'),
     *//,1x,'Bond length = ',f8.5,//,1x,'Pressure = ',f8.5,
     *//,1x,'Number of molecules = ',i5,5x,' Nx, Ny, Nz :',3i5,/)
205   format(1x,'max. shift in x y z = ',f6.3,5x,'max. angle shift = ',
     *f6.3,/)
210   format(1x,'max. change in h matrix elements = ',2f10.5
     *,//,1x,65('='),/)
220   format(1x,65('='),//,1x,'total no. of configs. =',f10.0,//)
221   format(1x,'acceptance ratio - cm -mvts =',f6.3)
222   format(1x,'acceptance ratio - rot-mvts =',f6.3)
223   format(1x,'acceptance ratio - interchanges =',f6.3)
225   format(1x,'acceptance ratio - vol-mvts =',f6.3)
226   format(1x,'acceptance ratio - cb-mvts =',f6.3)
227   format(1x,'acceptance ratio - nuc-mvts =',f6.3)
230   format(1x,'mean sq. disps. for x,y,z and r =',4g10.3)
255   format(//,1x,'cumulative < v >    =',f10.5,5x,'sub < v >    ='
     *,f10.5)
260   format(//,1x,'initial configuration',///)
265   format(1x,'cumula.<rho>       =',f10.5,5x,'sub.<rho>       =',
     *f10.5,/)
266   format(1x,'cumula.<rho>       =',f10.5,5x,'sub.<rho>       =',
     *f10.5,/)
267   format(1x,'cumula.U_inter/NkT =',f10.5,5x,'sub.U_inter/NkT = ',
     *f10.5,/)
269   format(/,1x,'cutoff=',f6.3,2x)
270   format(1x,'cumula.U_intra/NkT =',f10.5,5x,'sub.U_intra/NkT = ',
     *f10.5,/)
274   format(/,1x,'Cum. and sub avg. h matrix :',/)
275   format(5x,3f10.5,5x,3f10.5)
276   format(/,1x,'Box sides from avg. h matrix:'
     *,3f10.5,//,1x,'Cosines of box angles:',3f10.5,/)
277   format(1x,'cumulative < so >  =',f10.5,5x,'sub < so >  =',
     *f10.5,/)
280   format(//,1x,'final configuration',///)
290   format(1x,'transltnl. order parameters =',3f10.5,/)
300   format(10f7.3)

      return
      end

c *******************************************************************

      subroutine entrada(seed,rhog)


	include 'parametros_NpT.inc'
	include 'common.inc'
       
c *** lectura del fichero 'simulacion.inp'

      open(1,file='simulacion.inp',status='unknown')
C OJO PSTAR LO LEO EN UNIDADES DE EPSILON/SIGMA**3
      read(1,*) pstar,rhog,temperature       ! estado termodinamico
      read(1,*) ntot,neq,nmax,njob           ! longitud simulacion
ccj   Julio change number 20
      read(1,*) pshift,ashift,dela,dela1     ! tamanho tobas MC
      read(1,*) seed                         ! numero semilla
      read(1,*) kstart,nmoltot               ! modo de comienzo
      read(1,*) ilatt,nx,ny,nz              ! modo de comienzo en solido
      read(1,*) npr,nwr,iwrmode                  !numero de pasos para promediar,numero de veces que escribe configuracion y modo de hacerlo (lineal o logaritmico)
                                         !numero de configuraciones que escribe 
      read(1,*) iscale,inpt               ! modo de funcionamiento
      read(1,*) patmp_cm,patmp_rot,patmp_int,patmp_cb 
     >	! attempt probabilities 
      read(1,*) deltar,ngrid                 ! parametros g(r)
      read(1,*) drho                         ! intervalos de rho
	read(1,*) xlan1,xlan2                  ! lambda1, lambda2
	read(1,*) iumbrella                    ! ¿se hace un umbrella?
	read(1,*) iwidom                       ! ¿se hace widom test?
        read(1,*) inucleacion,rkbias,rnclcero,iunbias    ! se hace nucleacion?
                                                           ! constante bias potential
                                                           ! tamanno cluster origen
	read(1,*)iffs,nextint
 	read(1,*)ibrownian,deltatiempo

	close(1)


c Se lee la presión en bares y se pasa a kT/amgstrons**3 que es en lo
c que trabaja el programa.

c       factor=1.E+5/(1.380658E-23*temperature*1.E+30)
c       pstar=pstar*factor

c Se lee la densidad en g/cm**3 y se pasa a moleculas/amstrons**3:
      
ccccccccccccccccccccccccc       rhog=rhog*6.0221367E+23/(rpesomolec*1.0E+24)


        rhog = 1

c EL PROGRAMA DEFINE PSTAR COMO P/(KT/SIGMA**3)
C PARA LA VARIANTE LJ ME ES MAS COMODO LEER EN UNIDADES 
C DE EPSILON/SIGMA**3 Y NADA MAS LEIDO, PASARLO A UNIDADES
C DE KT/SIGMA**3, AQUI ESTA EL CAMBIO 
C (lo mismo vale para Yukawa)
        pstar=pstar/temperature

        beta = 1./temperature

c Se calcula cada cuantos pasos se ecribe una configuracion
c Este numero de pasos sera un multiplo de npr
c Esto dependera de si se escribe linealmente (iwrmode = 0)
c o logaritmicamente (iwrmode = 1)

	if(iwrmode.eq.0)then

	 if(nwr.eq.0)then
           npwr=njob+1
	 else
	   npwr=njob/nwr
	   npwr=int(npwr/npr+1)*npr
	 endif

	elseif(iwrmode.eq.1)then

         if(nwr.eq.0)then
           rrr=float(njob+1)
           rnpwr=log(rrr)
           iwr=0
         else
           rrr=float(njob)
           rnpwr=log(rrr)/float(nwr)
           iwr=0
         endif

	endif


	if(nwr.gt.njob)then
	 print*,'No se pueden escribir mas configuraciones que ciclos'
	 stop
	endif

c Algunas cosas que hacer y advertir si se hace FFS
	iseed0=int(seed)
	IF(iffs.eq.1)THEN 
	  if((iunbias.ne.1).or.(neq.ne.0).or.(nwr.ne.0))then 
	    print*,'para el FFS debes hacer iunbias=1,'
            print*,'neq=0 y nwr=0, gracias'
	    stop
	  endif

c Comprobaciones si hay dinamica browniana

	if(ibrownian.eq.1)then
	  
      if(patmp_cm+patmp_rot+patmp_int+patmp_cb.gt.0.00001)then
	 print*,'atencion, con dinamica browniana no se puede hacer MC'
	 stop
	endif
			
	endif



!Lectura del fichero cumulativa.dat 
	  isalgo=0
	  irecordcumliq=-1
	  open(78,file='probnmaxliq.dat')
	  !Contamos cuantas lineas tiene el fichero
	  do while(isalgo.eq.0)
	    irecordcumliq=irecordcumliq+1
	    read(78,*,end=178)ikk,rkk                          
	  enddo
 178      continue
!Como el primer valor de tamagno de cluster es 0, hay 
!que sustraerle 
!1 al n�mero de l�neas para saber el tamagno m�ximo que aparecio
!en el l�quido.

	   irecordcumliq=irecordcumliq-1

	  !Ahora las leemos
	  rewind(78)
	  print*,irecordcumliq
	  do i=0,irecordcumliq
	   read(78,*)ikk,cumulative(i)
	  enddo 
	  do i=0,irecordcumliq
	    do j=i+1,irecordcumliq
	      cumulative(i)=cumulative(i)+cumulative(j)
	    enddo
	  enddo
	ENDIF

!Aviso de nucleacion
	if((iunbias.eq.1).and.(inucleacion.eq.1))then
	  print*,'no pongas nucleacion y no bias a la vez'
	  stop
	endif

c *** lectura del fichero 'modelo.inp'

	open(unit=15,file='modelo.inp',status='old')

	read(15,*) sigma
	read(15,*)
        read(15,*) Epsilon
	read(15,*)
        read(15,*) carga
	read(15,*)
        read(15,*) cutoff
	read(15,*)
        read(15,*) alfa   
	read(15,*)

c Change 4 mezclas
ccj2  Aqui lee el nº de tipos de moleculas y cuantas son de cada tipo
ccj2    y el numero de atomos de cada una nsites(i), y cual tomamos 
ccj2    como referencia para el cambio de volumen


        read(15,*) ntipmol
        do ic=1,ntipmol
	read(15,*)
        read(15,*) nmol(ic),nsites(ic),isiteori(ic)
	read(15,*)
        read(15,*) (nordcar(ic,j),j=1,nsites(ic))
        end do	

       do ic=1,ntipmol
	   do i=1,nsites(ic)
	      read(15,*)
              read(15,*) xb(ic,i)
	      read(15,*) yb(ic,i)
	      read(15,*) zb(ic,i)
	   end do
	end do 

	      read(15,*)
	   read(15,*),coreduro

      read(15,*)
      do i=1,intidmax
         read(15,*)parpot(i,1),parpot(i,2),parpot(i,3),
     >             parpot(i,4),parpot(i,5),parpot(i,6),
     >             parpot(i,7)

      if(parpot(i,7).lt.0.1)then
!      parpot(i,1)=parpot(i,1)/rN_avo*1000./rk_boltz
!      parpot(i,3)=parpot(i,3)/rN_avo*1000./rk_boltz
!      parpot(i,4)=parpot(i,4)/rN_avo*1000./rk_boltz
!          if((rN_avo.lt.1.1).or.(rk_boltz.lt.1.1))then
!           print*,'Tines bien rN_avo y rk_boltz?'
!           STOP
!          endif

      endif
          
	 if(parpot(i,7).gt.0.9)then !Yukawa case

	  parpot(i,1)=parpot(i,1)*exp(parpot(i,2)) !/1000.
        parpot(i,2)=1/parpot(i,2)
	 
	  if((rN_avo.gt.1.1).or.(rk_boltz.gt.1.1))then 
	   print*,'No has hecho 1 N_avo o K_boltz'  
	   STOP
	  endif

	 endif


      enddo



	close(15)

c*** pasamos el cutoff y alfa a unidades de amstrons que es con lo 
c*** que va a trabajar el progama. Para ello utilizamos el primer
c*** diámetro definido en la tabla de diámetros del modelo.inp

c     cutoff=cutoff*sigma(1)

      rcut2=cutoff*cutoff

c       alfa=alfa/sigma(1)

c*** Se ha introducido la carga en electrones. Para tener la
c*** energía culómbica en unidades de K hay que multiplicar las
c*** cargas por 408.778672043

	do isi=1,nsisperio
	  carga(isi)=carga(isi)*408.778672043
	enddo
	    

c *** eco

      rewind 3

      write(3,*) 'Entrada'
      write(3,*) pstar,rhog,temperature       ! estado termodinamico
      write(3,*) ntot,neq,nmax,njob           ! longitud simulacion
ccj Julio change number 21
      write(3,*) pshift,ashift,dela,dela1     ! tamanho tobas MC
      write(3,*) seed                         ! numero semilla
      write(3,*) kstart,nmoltot,ntipmol       ! modo de comienzo
      write(3,*) (nmol(i),i=1,ntipmol)
      write(3,*) (nsites(i),i=1,ntipmol)
c      write(3,*) kstart,nmol                  ! modo de comienzo
      write(3,*) ilatt,nx,ny,nz             ! modo de comienzo en solido
      write(3,*) npr,iscale,inpt  ! modo de funcionamiento
      write(3,*) patmp_cm,patmp_rot,patmp_int,patmp_cb 
     >  	! attempt probabilities 
      write(3,*) deltar,ngrid                 ! parametros g(r)
      write(3,*) drho                         ! intervalos de rho
      write(3,*)

	call init_genrand(seed)

	return
      end 


c *****************************************************************
c *** Routine to create a matrix that rotates a given vector
c *** by phi degrees around a unit vector u.
c *** The rotation is permormed anticlockwise
c ***
c *** u   : vector parallel to the axis of gyration
c *** gi  : gyration angle in radians
c *** rot : the matrix of rotation
c ***
c *** The matrix rot multiplies a column vector to give the
c *** desired rotated vector
c ***
c *** Reference: Tesis de Noe
c ***

      subroutine magiro(u,gi,rot)
      include 'parametros_NpT.inc'

      dimension u(3),rot(3,3)

c *** cosine and sine of the angle of gyration

      cosg = cos(gi)
      seng = sin(gi)      
      cosm = 1.-cosg

c *** turn array to normal variables

      cx = u(1)
      cy = u(2)
      cz = u(3)

c *** square of the components of c

      cx2 = cx**2  
      cy2 = cy**2 
      cz2 = cz**2  

c *** squared sines

      sx2 = 1. - cx2
      sy2 = 1. - cy2
      sz2 = 1. - cz2

c *** some operations for the off diagonal components

      a12a = cx*cy*cosm
      a12b = cz*seng
 
      a13a = cx*cz*cosm
      a13b = cy*seng

      a23a = cy*cz*cosm
      a23b = cx*seng

c *** elements of the rotation matrix

c *** first row

      rot(1,1) = cx2 + sx2*cosg
      rot(1,2) = a12a - a12b
      rot(1,3) = a13a + a13b

c *** second row

      rot(2,1) = a12a + a12b
      rot(2,2) = cy2 + sy2*cosg
      rot(2,3) = a23a - a23b

c *** third row

      rot(3,1) = a13a - a13b
      rot(3,2) = a23a + a23b
      rot(3,3) = cz2 + sz2*cosg

c *** ready

      return
      end


c ******************************************************************* 
c *** Routine to generate a unit vector chosen at random 
c *** from a uniform distribution.
c ***
c *** Method of Marsaglia as explained in Allen and Tildesley's book
c ***
c *** Input:
c ***     seed : random seed number
c *** Output :
c ***     u    : The random unit vector 
c ***
c *** En ender, este metodo es un 30% mas rapido que el metodo
c *** trivial de calculo al azar de fi y cos(theta)

      subroutine rnd_sphere(u,seed)

      include 'parametros_NpT.inc'
      
	  

      dimension u(3)

1     continue

c *** generate two random numbers in [0,1]

      gi1 = ranf(seed)
      gi2 = ranf(seed)

c *** calculate two auxiliary numbers from gi1 and gi2

      psi1 = 1. - 2.*gi1
      psi2 = 1. - 2.*gi2

c *** calculate the sum of squares

      psisq = psi1**2 + psi2**2

c *** test if greater than 1

      if (psisq.gt.1.) goto 1

      aux = 2.*(1.-psisq)**(1./2.)

      u(1) = psi1*aux
      u(2) = psi2*aux
      u(3) = 1.-2.*psisq

      return
      end



c *********************************************************
c *** Conjunto de programas para la gestion de una linked-cell list
c ***
c *** Las rutinas que hay son:
c ***
c *** make_cell_map : esta rutina genera una lista con las celdillas
c ***                 vecinas de una dada. Es necesario invocarla
c ***                 justo antes de make_cell_list cada vez que
c ***                 cambia el volumen del sistema
c *** make_cell_list : esta rutina genera la linked-cell list de
c ***                  un sistema 
c *** take_out_of_list : quita de la linked-cell list todos los
c ***                    atomos pertenecientes a una molecula dada
c *** put_in_list : pone en la lista todos los atomos de una molecula
c ***               dada
c ***
c *** inter_molecular : calcula la energia inter-molecular de una
c ***                   molecula dada
c *** sysenergy : calcula la energia inter-molecular de todo el sistema
c ***             Importante: a la salida de esta rutina, la lista
c ***             de vecinos queda vaciada y es necesario invocar de
c ***             nuevo a la rutina make_cell_list
c ***
c ***
c *** Las rutinas take_out_of_list y put_in_list se utilizan para
c ***
c *** 1. evitar que al calcular la energia inter-molecular de una
c ***    molecula o un atomo se consideren tambien interacciones
c ***    intra-moleculares.
c *** 2. Al calcular la energia inter-molecular de todo el sistema
c ***    se cuenten dos veces las mismas interacciones.
c ***
c *** El esquema de funcionamiento seria:
c ***
c *** Inicio del programa:
c ***
c ***    call make_cell_map      ! genera el mapa de celdillas vecinas
c ***    call make_cell_list     ! genera la lista de todo el sistema
c ***
c *** Movimientos locales:
c ***
c ***    call take_out_of_list   ! elimina de la lista los atomos de la
c ***				           molecula que se va a mover
c ***
c ***    call movimiento         (incluye evaluacion de la energia)
c ***
c ***    call put_in_list        ! reincorpora la molecula a la lista,
c ***			             tanto si se ha aceptado como si no.
c ***
c *** Cambios de volumen:
c ***
c ***   Si cambia el volumen, hay que recalcular entera la cell_list
c ***   asi como el mapa de celdas vecinas
c ***
c ***    call make_cell_map      ! genera el mapa de celdillas vecinas
c ***    call make_cell_list     ! genera la lista de todo el sistema
c ***
c ***
c *** Nota sobre el funcionamiento de la rutina sysenergy
c ***
c ***   El esquema de calculo es de la forma:
c ***
c ***   do imol=1,nmoltot
c ***
c ***      take_out_of_list(imol)
c ***
c ***      calcula la energia de imol con el resto de moleculas
c ***
c ***      Etot = Etot + Emol
c ***
c ***   end do
c ***
c *** Al calcular la energia inter-molecular de la molecual imol,
c *** quito sus atomos de la lista para que no se calculen las
c *** interacciones intra-moleculares.
c *** Despues de calcular su energia, NO repongo la molecula,
c *** y asi garantizo que no calculo la energia entre dos moleculas
c *** mas de una vez. 
c *** Por lo tanto, cada vez que se sale de la rutina sysenergy,
c *** es necesario recalcular la lista mediante la rutina make_cell_list
c ***
c ***
c ***
c *********************************************************
c *** Rutina para la inicializacion de la Link-list
c ***
c *** Accion: Dadas las longitudes de las aristas de la caja
c ***         de simulacion, el radio de truncamiento del
c ***         potencial y el numero de celdas:
c ***
c ***	        1. Calcula la longitud de las aristas de las celdas
c ***           2. Calcula una lista con las celdas vecinas de una
c ***              dada
c ***
c *** Condiciones: El numero de celdas en las que se divide la
c ***		       caja se especifica como parametro
c ***
c *** Input:
c ***
c ***   A. Como argumentos:
c ***
c ***	 1. xside, yside, zside: longitud de las aristas en unidades
c ***				         de longitud
c ***    2. rcut : radio de truncamiento del potencial en unidades
c ***              de longitud
c ***
c ***   B. Como parametros:
c ***
c ***      nxcell,nycell,nzcell : numero de celdas en las que se divide
c ***				   la caja de simulacion en cada una de
c ***					    las direcciones
c ***				          Se recomienda que sean impares
c ***
c *** Output:
c ***
c ***   A. Como common:
c ***
c ***   1. link_list_par : parametros de la link-list
c ***
c ***      i. xlcell,ycell,zcell : Longitud de las aristas de las
c ***				       celdas en unidades de las aristas
c ***					     de la caja de simulacion
c ***      ii. neighbour_cell(j,i) : Lista que especifica cual es la
c ***		                     j-esima celda vecina de la celda i 
c ***
c *** Nota: Como celda vecina de i se entiende cualquier celda 
c ***       perteneciente a la caja de celdas necesaria para inscribir
c ***       a una esfera de coordinacion centrada en la celda i
c ***       
c
***********************************************************************



	subroutine make_cell_map(xside,yside,zside,rcut)

	include 'parametros_NpT.inc'
	include 'common.inc'

      logical flagx,flagy,flagz
c
c      data nxold,nyold,nzold /0,0,0/
c
c Julio change number 24
c Determinacion de vectores unitarios en las direcciones
c de a,b,c
C CONSTRUYENDO VECTOR UNITARIO EN LA DIRECCION DE A

      AMOD=SQRT(H(1,1)**2+H(2,1)**2+H(3,1)**2)
      AX=H(1,1)/AMOD
      AY=H(2,1)/AMOD
      AZ=h(3,1)/AMOD
C CONSTRUYENDO VECTOR UNITARIO EN LA DIRECCION DE B 
      BMOD=SQRT(H(1,2)**2+H(2,2)**2+H(3,2)**2)
      bX=H(1,2)/bMOD
      bY=H(2,2)/bMOD
      bZ=h(3,2)/bMOD
C CONSTRUYENDO VECTOR UNITARIO EN LA DIRECCION DE C 
      cMOD=SQRT(H(1,3)**2+H(2,3)**2+H(3,3)**2)
      cX=H(1,3)/cMOD
      cY=H(2,3)/cMOD
      cZ=h(3,3)/cMOD
c
      coseab=ax*bx+ay*by+az*bz
c Julio change 
c Para simular una caja cubica, donde coseab=0
c al hacer iscale=0 Rahmann Parrinelo, la caja
c se hace no cubica con angulo ab= 90.1 grados
c y el coseno se hace negativo.
c Se vio que las formulas correctas se recuperaban
c con coseab=abs(coseab)
c Por tanto
      coseab=abs(coseab)
c 
      senoab=sqrt(1.-coseab**2)
c
      H11=H(1,1)
      H12=H(1,2)
      H13=H(1,3)
      H21=H(2,1)
      H22=H(2,2)
      H23=H(2,3)
      H31=H(3,1)
      H32=H(3,2)
      H33=H(3,3)

C Ab is the vectorial product of a and b
c
      ABMOD=sqrt( (H21*H32-H22*H31)**2+(H11*H32-H12*H31)**2+
     1       (H11*H22-H12*H21)**2 )
      abx=(H21*H32-H22*H31)
      aby=-(H11*H32-H12*H31)
      abz=(H11*H22-H12*H21)
c
      abx=abx/abmod
      aby=aby/abmod
      abz=abz/abmod
c
      auxi1=abx*cx+aby*cy+abz*cz
      cosecab=abs(abx*cx+aby*cy+abz*cz)
c
c *** Determinacion de la longitud de las aristas de cada celda
c *** en unidades de las aristas de la caja de simulacion

	xlcell = 1./nxcell
	ylcell = 1./nycell
	zlcell = 1./nzcell

c *** Determinacion del numero de aristas de celda que hacen falta
c *** para abarcar el rango del potencial
ccj Julio change number 25
      if ((coseab.lt.0.0000).or.(auxi1.lt.0.000)) then
      write(3,*) ' coseab o auxi1 negativos en '
      write(3,*) ' subrutina make_cell map '
      write(3,*) ' coseab  auxi1 = ',coseab,auxi1
      stop
      endif
c 
      nxrange = int(rcut/xside*nxcell/senoab) + 1
      nyrange = int(rcut/yside*nycell/senoab) + 1
      nzrange = int(rcut/zside*nzcell/cosecab) + 1
      nxmemo= nxrange
      nymemo= nyrange
      nzmemo= nzrange
c

      if ((nxrange.ne.nxold).or.
     >    (nyrange.ne.nyold).or.
     >    (nzrange.ne.nzold)) then
c *** Determinacion de la longitud, en unidades de arista de la celda,
c *** de la caja que inscribe a la esfera de coordinacion de un atomo

      nxb = 2*nxrange + 1
      nyb = 2*nyrange + 1
      nzb = 2*nzrange + 1
c 
c *** Comprobando que la caja de simulacion no es demasiado pequenha

      flagx=.false.
      flagy=.false.
      flagz=.false.
      if (nxb.gt.nxcell) then
         nxb=nxcell
c         nxrange = int(rcut/xside*nxcell/senoab) + 1 -1
         nxrange=nxcell/2
         flagx=.true.
      end if
      if (nyb.gt.nycell) then
c        write(3,*) 'eje y de la caja demasiado peqhenho'
c        write(3,*) 'nyb,nycell',nyb,nycell
         nyb=nycell
c         nyrange = int(rcut/yside*nycell/senoab) + 1 -1
         nyrange=nycell/2
         flagy=.true.
      end if
      if (nzb.gt.nzcell) then
c        write(3,*) 'eje z de la caja demasiado peqhenho'
c        write(3,*) 'nzb,nzcell',nzb,nzcell
         nzb=nzcell
c         nzrange = int(rcut/zside*nzcell/cosecab) + 1 -1
         nzrange=nzcell/2
         flagz=.true.
      end if

c *** Numero total de celdas necesarias para inscribir la esfera de
c *** coordinacion
      ntb=nxb*nyb*nzb


c *********************************************************
c *** Creacion del mapa de celdas
c *********************************************************

c *** Nota: Al rango de los indices internos (l,m,n) se le suma
c ***       nxcell, nycell o nzcell para poder aplicar las condiciones
c ***       de contorno sobre las cajas sin que den problemas 

	icell = 0

	do k=1,nzcell

	   kral = nzcell - nzrange + k
	   krar = nzcell + nzrange + k

	do j=1,nycell

	   jral = nycell - nyrange + j
	   jrar = nycell + nyrange + j

	do i=1,nxcell

	   iral = nxcell - nxrange + i
	   irar = nxcell + nxrange + i

	   icell = icell + 1
	   jcell = 0

	   do n=kral,krar
	   do m=jral,jrar
	   do l=iral,irar

	      jcell = jcell + 1

		lpbc = l - nxcell*int( (l-1)/nxcell )
		mpbc = m - nycell*int( (m-1)/nycell )
		npbc = n - nzcell*int( (n-1)/nzcell )

		neighbour_cell(jcell,icell) = lpbc + (mpbc-1)*nxcell + 
     >						 (npbc-1)*nxcell*nycell

     	   end do
	   end do
	   end do

	end do
	end do
	end do
       if(flagx) then
	  nxold = nxmemo 
       else
	  nxold = nxrange
       endif
       if(flagy) then
	  nyold = nymemo 
       else
	  nyold = nyrange
       endif
       if(flagz) then
	  nzold = nzmemo 
       else
	  nzold = nzrange
       endif

	end if

	return
	end




	   
c *********************************************************
c *** Rutina para la creacion de una link-list
c ***
c *** Accion : inicializa los array head, next y previous para
c ***		   la evaluacion de interacciones pares mediante
c ***		   una link-list
c ***
c *** Condiciones :
c ***
c ***  1. Es necesario que se haya pasado por la rutina cell_map
c ***  2. Se tienen que haber dado previamente valores a las coordenadas 
c ***  3. Es necesario asignar los parametros natmax y ntcell
c ***  4. Las coordenadas estan dadas en unidades de las aristas de la
c ***     caja de simulacion
c ***
c *** Entrada:
c ***
c ***  A. como argumento:
c ***
c ***    1. El numero de atomos del sistema
c ***
c ***  B. Como common:
c ***
c ***    1. atoms : contiene las coordenadas de los atomos del sistema
c ***    2. link_par : contiene la longitud de las aristas de 
c ***		           las celdas
c ***
c *** Salida:
c *** 
c ***  A. Como common
c ***
c ***   1. link_list: common con los arrays de la link_list
c ***
c ***      i. head(i) : Senhala al primer atomo (cabeza de lista)
c ***                   de la celda i. Si no hay ningun atomo en
c ***                   dicha celda, head(i)=0
c ***     ii. next(i) : indica que atomo de la celda viene despues
c ***			      del atomo i. Cuando no hay ningun atomo
c ***		            a continuacion, entonces next(i)=0
c ***    iii. previous(i) : indica que atomo precedia al atomo i en
c ***                       la celda. Cuando i es cabeza de lista,
c ***				    entonces ningun atomo lo precede y
c ***				    previous(i)=0
c ***

	subroutine make_link_list(natm)


      include 'parametros_NpT.inc'
	include 'common.inc'
	

	integer head,next,previous

	do icell = 1,ntcell
	   head(icell) = 0
	end do

	do iatm = 1,natm

	   xpbc = xa(iatm) - anint( (xa(iatm)-half) )
	   ypbc = ya(iatm) - anint( (ya(iatm)-half) )
	   zpbc = za(iatm) - anint( (za(iatm)-half) )

	   i = int(xpbc/xlcell) + 1
	   j = int(ypbc/ylcell) + 1
	   k = int(zpbc/zlcell) + 1

	   icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

	   next(iatm)           = head(icell)
	   previous(next(iatm)) = iatm
	   head(icell)          = iatm
	   previous(iatm)       = 0

	end do

	return
	end

c *******************************************************************
c *** Rutina para eliminar de la Link-list todos los atomos
c *** de una molecula
c ***
c *** Accion : para cada atomo, isite, de la molecula, 
c ***          1. si isite no es cabeza de lista
c ***             asigna el valor next(isite) a next(previous(isite))
c ***             y el valor previous(isite) a previous(next(isite))
c ***          2. si isite es cabeza de lista
c ***             convierte en cabeza de lista al atomo next(isite)
c ***             y asigna el valor cero a previous(next(isite))
c ***
c *** Ejemplo:
c ***
c ***          iatm      next     previous
c ***           3          8          0
c ***           8          5          3
c ***           5          1          8
c ***           1          0          5
c ***
c *** La cabeza de lista es el atomo 3, al que le sucede el 8,
c *** luego el 5 y luego el 1.
c ***
c *** Si isite es 8, entonces asigno al atomo 5 (next(8)) como
c *** sucesor de 3 (previous(8)) y asigno el atomo 3 como antecesor
c *** de 5. Los valores de next y previous para el atomo 8 no cambian.
c ***
c *** Si isite es 3 (cabeza de lista) entonces asigno como cabeza de
c *** lista al sucesor de 3, es decir, a next(3)=8 y asigno al atomo
c *** 0 (no antecesor) como el antecesor de 8.
c ***
c ***
c *** Condiciones:
c ***
c ***  1. Se supone que se ha pasado por las rutinas make_cell_map
c ***     y make_link_list 
c ***
c ***  2. Se supone que se dispone de las coordenadas atomicas
c ***     en el common /atoms/
c ***
c ***  3. Se supone que se han definido los parametros natmax y ntcell
c ***
c ***  4. Las coordenadas estan dadas en unidades de las aristas de la
c ***     caja de simulacion
c ***  
c *** 
c *** Entrada:
c ***
c *** A. Como argumentos:
c ***
c ***   1. imol   : indice de la molecula que se quiere suprimir
c ***   2. nsites : numero de atomos de la molecula
c ***
c *** B. Como common:
c ***
c ***   1. atoms : contiene las coordenadas de los atomos 
c ***
c ***   2. link_par : contiene la longitud de las aristas de las
c ***		           celdas
c ***
c ***   3. link_list : Link list sin modificar
c ***
c ***      i. head : cabeza de lista
c ***     ii. next : siguiente atomo a uno dado en la celda
c ***    iii. prevuous : atomo anterior a uno dado en la celda
c ***         (ver cabecera de la rutina make_link_list para
c ***		   mas detalles)
c ***
c *** Salida:
c ***
c *** A. Como common:
c ***
c ***   1. link_list : Link list con referencia a los atomos
c ***                  de imol suprimidas
c ***
c ***
c Change mixture 36
        subroutine take_outof_list(imol,ic)

cl	subroutine take_outof_list(imol,nsites)

      include 'parametros_NpT.inc'
	include 'common.inc'
	

	integer head,next,previous

c Change mixture 40
        natm0 =puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)
c	natm0 = (imol-1)*nsites

        do isite = 1,nsites(ic)
	   
	   iatm = natm0 + isite

	   ihead = previous(iatm)
	   itail = next(iatm)

	   if (ihead.ne.0) then

	      next(ihead)     = itail
	      previous(itail) = ihead

	   else

	     xi = xa(iatm) - anint( (xa(iatm)-half) )
	     yi = ya(iatm) - anint( (ya(iatm)-half) )
	     zi = za(iatm) - anint( (za(iatm)-half) )

	     i = int(xi/xlcell) + 1
	     j = int(yi/ylcell) + 1
	     k = int(zi/zlcell) + 1

     	     icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

	     head(icell)     = itail
	     previous(itail) = 0

	   end if

	end do

	return
	end

c ************************************************************
c *** Rutina para incluir en la Link-list los atomos de una molecula
c ***
c *** Accion : Para cada atomo isite de la molecula,
c ***          1. convierte a isite en la cabeza de lista de
c ***		   la celda en la que se encuentra, 2. a la cabeza
c ***          anterior la convierte en su sucesor 3. asigna a isite
c ***          como predecesor de la cabeza original
c ***
c *** Condiciones :
c ***
c ***    1. Es necesario haber pasado por la rutina make_cell_map
c ***    2. Se supone que se conocen las coordenadas de las moleculas
c ***    3. Se supone que se han definido los parametros natmax y
c ***       ntcell apropiadamente
c ***    4. Las coordenadas estan dadas en unidades de las aristas de la
c ***       caja de simulacion
c ***
c *** Entrada:
c ***
c ***  A. Como argumentos
c ***
c ***    1. imol   : molecula que se quiere anhadir a la lista
c ***    2. nsites : numero de atomos de la molecula
c ***
c ***  B. Como common:
c ***
c ***    1. atoms : common con las coordenadas de los atomos
c ***    2. link_par : common con las longitudes de las aristas de
c ***                  las celdas
c ***    3. link_list : link-list sin referencia a los atomos de la
c ***                   molecula imol
c ***
c *** Salida:
c ***
c ***  A. Como common:
c ***
c ***    1. link_list : link-list en la que se incluye a los atomos
c ***			      de la molecula imol
c ***

c Change mixture 37
      subroutine put_in_list(imol,ic) 

cl	subroutine put_in_list(imol,nsites)

      include 'parametros_NpT.inc'
	include 'common.inc'
	

	integer head,next,previous

        natm0 =puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)
c	natm0 = (imol-1)*nsites

        do isite = 1,nsites(ic)

	   iatm = natm0 + isite

	   xi = xa(iatm) - anint( (xa(iatm)-half) )
	   yi = ya(iatm) - anint( (ya(iatm)-half) )
	   zi = za(iatm) - anint( (za(iatm)-half) )

	   i = int(xi/xlcell) + 1
	   j = int(yi/ylcell) + 1
	   k = int(zi/zlcell) + 1

     	   icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

	   itail = head(icell)

	   head(icell) = iatm
	   previous(iatm)  = 0
	   next(iatm)      = itail
	   previous(itail) = iatm

	end do

	return
	end 

c **********************************************************
c *** Calculo de la energia inter-molecular de una molecula
c ***
c *** Accion : Calcula la energia de la molecula imol
c ***          con las restantes moleculas de la link-list
c ***
c *** Condiciones:
c ***
c ***  1. Hay que haber pasado previamente por make_cell_map
c ***  2. Hay que haber pasado previamente por make_link_list
c ***  3. La interfaz con el programa de simulacion se hace
c ***     a traves de /orden/,  /Lennard_Jones/, /atomos/ y
c ***     /coor_temp/. /atoms/ contiene todas las coordenadas atomicas
c ***     del sistema mientras que /coor_temp/ contiene las coordenadas
c ***     temporales de la molecula imol.
c ***  4. Las coordenadas estan dadas en unidades de las aristas de la
c ***     caja de simulacion
c ***     
c ***
c *** Entrada :
c ***
c *** A. Como argumentos:
c ***
c ***  1. imol   : indice de site de la molecula cuya energia se quiere
c ***              calcular 
c ***
c ***  2. nsites : numero total de sites de la molecula
c ***
c ***  3. rcut2  : radio de truncamiento al cuadrado, en unidades de
c ***              longitud
c ***
c ***  4. sidea, sideb, sidec : Longitud de las aristas de la caja de
c ***		                    simulacion, en unidades de longitud
c ***
c *** B. Como common:
c ***
c ***  1. atoms         : contiene las coordenadas de todos los atomos
c ***				  del sistema
c ***  2. coor_temp     : contiene las coordenadas temporales de
c ***			        la molecula imol
c ***  3. Lennard_Jones : parametros del potencial Lennard-jones
c ***  4. orden         : contiene nordcar, matriz que especifica
c ***		 	        el orden de cada uno de los carbonos de
c ***			        la molecula
c ***                    
c ***  6. link_par : parametros de las celdas
c ***  7. cell_map : 
c ***     
c ***	  i. ntb : numero de celdas de la caja de coordinacion
c ***	  ii. neighbour_cell(k,l) : espefica el indice del vecino numero
c ***		                         k de la celda l
c ***  8. link_list: lista  link-list
c ***
c *** Salida
c ***
c *** A. Como argumento
c ***
c ***  1. Emol : energia de la molecula en unidades de k_B
c ***
c ***

c***************************************************
      subroutine inter_molecular1(xt,yt,zt,imol,ic,Emol,iax,u_lnn)


      include 'parametros_NpT.inc'
	include 'common.inc'


	integer head,next,previous
        dimension xt(nsmax),yt(nsmax),zt(nsmax)

	Emol = 0.

	iax = 0
	u_lnn= 0.

	numori=puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)
	

c *** bucle sobre todos los sites de la molecula imol
        do isite = 1,nsites(ic)

	iatm=numori+isite
	

	   Eatm = 0.

	   xi = xt(isite) - anint( (xt(isite)-half) )
	   yi = yt(isite) - anint( (yt(isite)-half) )
	   zi = zt(isite) - anint( (zt(isite)-half) )

c ****** calculando de que tipo es el site i

           nordi = nordcar(ic,isite)

c ****** calculando en que celda esta el site i

         i = int(xi/xlcell) + 1
         j = int(yi/ylcell) + 1
         k = int(zi/zlcell) + 1

	   icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

	   xi = xt(isite)
	   yi = yt(isite)
	   zi = zt(isite)

c **** Bucle sobre las ntb celdas de la caja de celdas centrada en icell

	   do ncell = 1,ntb
             
	      jcell = neighbour_cell(ncell,icell)
	      jatm = head(jcell)

c ******** bucle sobre todos los atomos en el interior de la celda jcell
	      
             do while (jatm.ne.0)

	         sig_ij = 0.5*(sigma(nordi)+sigatom(jatm))

c ********* distancias interatomicas en convencion mic

	       dx = xa(jatm) - xi
		 dy = ya(jatm) - yi
		 dz = za(jatm) - zi
ccj Julio change number 22
       tx=(dx - anint(dx))
       ty=(dy - anint(dy))
       tz=(dz - anint(dz))
ccj
       txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
       typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
       tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
       dxmic = txp
       dymic = typ
       dzmic = tzp

	         r2 = (dxmic**2 + dymic**2 + dzmic**2)
	         rjust=sqrt(r2)
c                 ** bandera de solapamiento
c             if(r2.lt.sig_ij**2.)then  !duro 
c                  iax=1         !duro 
c                  return        !duro 
c             endif              !duro 

!Esta bandera indica si se forman nuevos clusters
             if(r2.lt.rneigcl**2.)then  !duro 
                  iax=1         !duro 
                  !return        !duro 
             endif              !duro 


           IF (r2.lt.rcut2) THEN
	       call interaccionpar(nordi,iatm,jatm,rjust,uij,dummy)
             !u_lnn=u_lnn+uij
 	       Eatm = Eatm + Uij
           END IF



c ********* a por el siguiente atomo de esta caja

		   jatm = next(jatm)

	      end do

	   end do

	   Emol = Emol + Eatm

	end do
	
	return 
	end



c **********************************************************
c *** Calculo de la energia inter-molecular total del sistema
c ***
c *** Accion : Calcula la energia total del sistema mediante
c ***          el calculo de la energia inter-molecular de sus
c ***          moleculas, haciendo uso de una Link-list.  
c ***          Antes de empezar el calculo de la energia de una
c ***	         molecula, la elimina de la Link-list y no vuelve
c ***          a reponerla. Esto evita el calculo de las interacciones
c ***          dos veces. Al final del proceso, Link-list se queda
c ***          vacia (en verdad permanece la ultima molecula).
c ***		   Ej: para imol=1, calcula la energia de imol con las
c ***		     (nmol-1) moleculas restantes. Para imol=2, calcula
c ***		      la energia con las (nmol-2) moleculas restantes
c ***			 (queda excluida imol=1) y asi sucesivamente.
c ***		   
c ***
c *** Condiciones:
c ***
c ***  1. Hay que haber pasado previamente por make_cell_map
c ***  2. Hay que haber pasado previamente por make_link_list
c ***  3. La interfaz con el programa de simulacion se hace
c ***     a traves de /orden/,  /Lennard_Jones/ y /atoms/ 
c ***  4. Las coordenadas estan dadas en unidades de las aristas de la
c ***     caja de simulacion
c ***     
c ***
c *** Entrada :
c ***
c *** A. Como argumentos:
c ***
c ***  1. nmol   : numero total de moleculas del sistema
c ***
c ***  2. nsites : numero total de sites de la molecula
c ***
c ***  3. rcut2  : radio de truncamiento al cuadrado, en unidades de
c ***              longitud
c ***
c ***  4. sidea, sideb, sidec : Longitud de las aristas de la caja de
c ***		                    simulacion, en unidades de longitud
c ***
c *** B. Como common:
c ***
c ***  1. atoms         : contiene las coordenadas de todos los atomos
c ***				  del sistema
c ***  3. Lennard_Jones : parametros del potencial Lennard-jones
c ***  4. orden         : contiene nordcar, matriz que especifica
c ***		 	        el orden de cada uno de los carbonos de
c ***			        la molecula
c ***  5. shape1        : longitud de las aristas de la caja de
c ***                     simulacion en unidades de longitud
c ***                    
c ***  6. link_par : parametros de las celdas
c ***  7. cell_map : 
c ***     
c ***	  i. ntb : numero de celdas de la caja de coordinacion
c ***	  ii. neighbour_cell(k,l) : espefica el indice del vecino numero
c ***		                         k de la celda l
c ***  8. link_list: lista  link-list
c ***
c ***
c *** Salida
c ***
c *** A. Como argumento
c ***
c ***  1. Esys: energia intermolecular total del sistema en unidades k_B
c ***
c *** B. Como common
c ***
c ***  1. link_list: lista link_list vacia (hay que recalcularla despues
c ***                                       de pasar por esta rutina)
c ***
c ***
c
c Change mixture 39

       subroutine sysenergy(Esys,iax)


      include 'parametros_NpT.inc'
	include 'common.inc'

	integer head,next,previous

	Esys = 0.
	U_lj = 0.

	iax = 0

       if(ibrownian.eq.1)then
        do i=1,natoms
         fuerzaextxa(i)=0.
         fuerzaextya(i)=0.
         fuerzaextza(i)=0.
        enddo
       endif

c *** bucle sobre todas las moleculas del sistema

      do  imol = 1,nmoltot-1        
          ic=class(imol)
           call take_outof_list(imol,ic) 

	   Emol = 0.
	   u_ljmol=0.

           natm0 = puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)

c *** Interacción Lennard-Jones
c *** bucle sobre todos los sites de la molecula imol
C$OMP  PARALLEL DEFAULT(PRIVATE) 
C$OMP+ SHARED(natm0,xa,ya,za,half,nordcar,ic,nsites)
C$OMP+ SHARED(xlcell,ylcell,zlcell,nxcell,nycell,nzcell)
C$OMP+ SHARED(ntb,neighbour_cell,head,sigma,sigatom,h)
C$OMP+ SHARED(sidea,sideb,sidec,rcut2,epsilon,epsiatom,next)
C$OMP+ SHARED(iewald,carga,cargatom,alfa,iax)
c$OMP+ shared(emol,U_ij,u_ljmol)
c$OMP+ shared(coreduro)
C$OMP  DO  reduction(+:emol,u_ljmol) 

        do isite = 1,nsites(ic)

	      Eatm = 0.
	      u_ljatm=0.

		iatm = natm0 + isite

	      xi = xa(iatm) - anint( (xa(iatm)-half) )
	      yi = ya(iatm) - anint( (ya(iatm)-half) )
	      zi = za(iatm) - anint( (za(iatm)-half) )

c ****** calculando de que tipo es el site i

              nordi = nordcar(ic,isite)

c ****** calculando en que celda esta el site i

            i = int(xi/xlcell) + 1
            j = int(yi/ylcell) + 1
            k = int(zi/zlcell) + 1

	      icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell


c **** Bucle sobre las ntb celdas de la caja de celdas centrada en icell

	 do ncell = 1,ntb

	         jcell = neighbour_cell(ncell,icell)

	         jatm = head(jcell)

c ******** bucle sobre todos los atomos en el interior de la celda jcell

	         do while (jatm.ne.0)
                 sig_ij = 0.5*(sigma(nordi)+sigatom(jatm))

c ********* distancias interatomicas en convencion mic

 
	        call distanciasites(iatm,jatm,x,y,z,r2)

	        rjust=sqrt(r2)
	
	        call interaccionpar(nordi,iatm,jatm,rjust,uij,fij)

	        if(ibrownian.eq.1)then
                fuerzaextxa(iatm)=fuerzaextxa(iatm)+fij*x
                fuerzaextya(iatm)=fuerzaextya(iatm)+fij*y
                fuerzaextza(iatm)=fuerzaextza(iatm)+fij*z
                
                fuerzaextxa(jatm)=fuerzaextxa(jatm)-fij*x
                fuerzaextya(jatm)=fuerzaextya(jatm)-fij*y
                fuerzaextza(jatm)=fuerzaextza(jatm)-fij*z
	        endif

     	        Eatm = Eatm + Uij

c ********* a por el siguiente atomo de esta caja

		      jatm = next(jatm)

	  end do
	 end do
	      Emol = Emol + Eatm
	      u_ljmol=u_ljmol+u_ljatm
	end do

C$OMP END  DO
C$OMP END PARALLEL 

c             if(iax.eq.1)then  ! duro
c                   return                ! duro
c             endif                      ! duro
 		
       Esys = Esys + Emol
	 u_lj=u_lj+u_ljmol

      end do
      return 
      end
ccccccccccccccccccccccccccccccccc
       subroutine syspressure(Esys,rnstep,iax)


      include 'parametros_NpT.inc'
	include 'common.inc'

	integer head,next,previous
	dimension ishighpress(natmax)


	Esys = 0.
	U_lj = 0.

	iax = 0


	svir=0.
	svirx=0.
	sviry=0.
	svirz=0.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Intialize values to calculate pressure 
	if((rtimeblock.ge.rtimealpha).or.(ibucle.eq.1))then
	do i = 1,natoms
	  vir(i)=0.
	  virx(i)=0.
	  viry(i)=0.
	  virz(i)=0.
	enddo
	endif 

        xsi=0.002  
        deltarp=1./(1.-xsi)**(1./3.) - 1.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


       if(ibrownian.eq.1)then
        do i=1,natoms
         fuerzaextxa(i)=0.
         fuerzaextya(i)=0.
         fuerzaextza(i)=0.
        enddo
       endif

c *** bucle sobre todas las moleculas del sistema

      do  imol = 1,nmoltot-1        
          ic=class(imol)
           call take_outof_list(imol,ic) 

	   Emol = 0.
	   u_ljmol=0.

           natm0 = puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)

c *** Interacción Lennard-Jones
c *** bucle sobre todos los sites de la molecula imol
C$OMP  PARALLEL DEFAULT(PRIVATE) 
C$OMP+ SHARED(natm0,xa,ya,za,half,nordcar,ic,nsites)
C$OMP+ SHARED(xlcell,ylcell,zlcell,nxcell,nycell,nzcell)
C$OMP+ SHARED(ntb,neighbour_cell,head,sigma,sigatom,h)
C$OMP+ SHARED(sidea,sideb,sidec,rcut2,epsilon,epsiatom,next)
C$OMP+ SHARED(iewald,carga,cargatom,alfa,iax)
c$OMP+ shared(emol,U_ij,u_ljmol)
c$OMP+ shared(coreduro)
C$OMP  DO  reduction(+:emol,u_ljmol) 

        do isite = 1,nsites(ic)

	      Eatm = 0.
	      u_ljatm=0.

		iatm = natm0 + isite

	      xi = xa(iatm) - anint( (xa(iatm)-half) )
	      yi = ya(iatm) - anint( (ya(iatm)-half) )
	      zi = za(iatm) - anint( (za(iatm)-half) )

c ****** calculando de que tipo es el site i

              nordi = nordcar(ic,isite)

c ****** calculando en que celda esta el site i

            i = int(xi/xlcell) + 1
            j = int(yi/ylcell) + 1
            k = int(zi/zlcell) + 1

	      icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell


c **** Bucle sobre las ntb celdas de la caja de celdas centrada en icell

	 do ncell = 1,ntb

	         jcell = neighbour_cell(ncell,icell)

	         jatm = head(jcell)

c ******** bucle sobre todos los atomos en el interior de la celda jcell

	         do while (jatm.ne.0)
                 sig_ij = 0.5*(sigma(nordi)+sigatom(jatm))

c ********* distancias interatomicas en convencion mic

 
	        call distanciasites(iatm,jatm,x,y,z,r2)
	        rjust=sqrt(r2)

	        call distanciasitesp(iatm,jatm,1,xsi,x,y,z,r2x)
	        rjustx=sqrt(r2x)
	        call distanciasitesp(iatm,jatm,2,xsi,x,y,z,r2y)
	        rjusty=sqrt(r2y)
	        call distanciasitesp(iatm,jatm,3,xsi,x,y,z,r2z)
	        rjustz=sqrt(r2z)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Calculo la presion:

          if(rjust-deltarp<1.)then
           vir(iatm) = vir(iatm) + 1./3./deltarp
           vir(jatm) = vir(jatm) + 1./3./deltarp
	   svir=svir + 1./3./deltarp
          endif

           if(rjustx<1.)then
           virx(iatm) = virx(iatm) + 1./xsi
           virx(jatm) = virx(jatm) + 1./xsi
           svirx=svirx + 1./xsi
           endif

           if(rjusty<1.)then
           viry(iatm) = viry(iatm) + 1./xsi
           viry(jatm) = viry(jatm) + 1./xsi
           sviry=sviry + 1./xsi
           endif

           if(rjustz<1.)then
           virz(iatm) = virz(iatm) + 1./xsi
           virz(jatm) = virz(jatm) + 1./xsi
           svirz=svirz + 1./xsi
           endif
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



	
	        call interaccionpar(nordi,iatm,jatm,rjust,uij,fij)

	        if(ibrownian.eq.1)then
                fuerzaextxa(iatm)=fuerzaextxa(iatm)+fij*x
                fuerzaextya(iatm)=fuerzaextya(iatm)+fij*y
                fuerzaextza(iatm)=fuerzaextza(iatm)+fij*z
                
                fuerzaextxa(jatm)=fuerzaextxa(jatm)-fij*x
                fuerzaextya(jatm)=fuerzaextya(jatm)-fij*y
                fuerzaextza(jatm)=fuerzaextza(jatm)-fij*z
	        endif

     	        Eatm = Eatm + Uij

c ********* a por el siguiente atomo de esta caja

		      jatm = next(jatm)

	  end do
	 end do
	      Emol = Emol + Eatm
	      u_ljmol=u_ljmol+u_ljatm
	end do



C$OMP END  DO
C$OMP END PARALLEL 

c             if(iax.eq.1)then  ! duro
c                   return                ! duro
c             endif                      ! duro
 		
       Esys = Esys + Emol
	 u_lj=u_lj+u_ljmol

      end do
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Calculo la presion total por el teorema del virial
      detH=h(1,1)*(h(2,2)*h(3,3)-h(3,2)*h(2,3))
     *-h(2,1)*(h(1,2)*h(3,3)
     *-h(1,3)*h(3,2))+h(3,1)*(h(1,2)*h(2,3)-h(1,3)*h(2,2))

      V=abs(detH)

      r_p  = float(nmoltot)/V + svir/V  

      r_px= float(nmoltot)/V + svirx/V
      r_py= float(nmoltot)/V + sviry/V
      r_pz= float(nmoltot)/V + svirz/V

      r_p_an = 1./3.*(r_px+r_py+r_pz)

	if(rtimeblock.ge.rtimealpha)then
        call mostest(vir,ishighpress)
        call xyzsome(ishighpress,1)
	endif

	write(84,*),rnstep,r_p,r_p_an
	print*,rnstep,r_p,r_p_an,r_px,r_py,r_pz
	print*,'presion"!""""'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      return 
      end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!____________________________________________
       subroutine xyzsome(ipinto,iesc)
	include 'parametros_NpT.inc'
	include 'common.inc'
        dimension ipinto(natmax)
	
	cero=0.
!Escribo en coords de caja


	numdesites=0
        do i=1,nmoltot
        if(ipinto(i).eq.1)numdesites=numdesites+1
	enddo

	if(iesc.eq.0)then 
	nfile=70
	elseif(iesc.eq.1)then
	nfile=170
	elseif(iesc.eq.2)then
	nfile=270
	elseif(iesc.eq.3)then
	  nfile=470
	elseif(iesc.eq.4)then
	  nfile=470
	elseif(iesc.eq.5)then
	  nfile=570
	elseif(iesc.eq.6)then
	  nfile=670
	elseif(iesc.eq.7)then
	  nfile=770
	elseif(iesc.eq.8)then
	  nfile=870
	endif
	
! Escribo configuraciones para pelicula
      write(nfile,*)numdesites+8,"     tiempos",rporaquiva
	write(nfile,*)
      write(nfile,601)'Li',cero,cero,cero,cero
      write(nfile,601)'Li',h(1,1),h(2,1),h(3,1),cero
      write(nfile,601)'Li',h(1,2),h(2,2),h(3,2),cero
      write(nfile,601)'Li',h(1,3),h(2,3),h(3,3),cero

      write(nfile,601)'Li',(h(1,1)+h(1,2)),
     .                 (h(2,1)+h(2,2)),
     .                 (h(3,1)+h(3,2)),cero
      write(nfile,601)'Li',(h(1,1)+h(1,3)),
     .                 (h(2,1)+h(2,3)),
     .                 (h(3,1)+h(3,3)),cero
      write(nfile,601)'Li',(h(1,2)+h(1,3)),
     .                 (h(2,2)+h(2,3)),
     .                 (h(3,2)+h(3,3)),cero

      write(nfile,601)'Li',(h(1,1)+h(1,2)+h(1,3)),
     .                 (h(2,1)+h(2,2)+h(2,3)),
     .                 (h(3,1)+h(3,2)+h(3,3)), cero

	

	do ii=1,nmoltot


	 if(ipinto(ii).eq.1)then
	    xar=xa(ii)
            yar=ya(ii)
            zar=za(ii)
            xar = xar - anint((xar-half) )
            yar = yar - anint((yar-half) )
            zar = zar - anint((zar-half) )
            call caja_cart(xar,yar,zar,xr,yr,zr)
            
	    if(iesc.eq.0)then                                                
            write(nfile,600)'F',xr,yr,zr,ii
	    elseif(iesc.eq.1)then
            write(nfile,600)'K',xr,yr,zr,ii
	    elseif(iesc.eq.2)then
            write(nfile,600)'Cl',xr,yr,zr,ii
	    elseif(iesc.eq.3)then
            write(nfile,600)'Br',xr,yr,zr,ii
	    elseif(iesc.eq.4)then
            write(nfile,600)'Na',xr,yr,zr,ii

	    elseif(iesc.eq.6)then

	     if(isolfcc(ii).eq.1)then
             write(nfile,600)'O',xr,yr,zr,ii
	     else
             write(nfile,600)'Na',xr,yr,zr,ii
	     endif

	    elseif(iesc.eq.7)then
            write(nfile,600)'Cl',xr,yr,zr,ii
c     scrivi graphitic-like particles
	    elseif(iesc.eq.8)then
            write(nfile,600)'P',xr,yr,zr,ii

	    endif

!           if(iesc.eq.5)then
!
!             if(Q_P(ii).lt.0.2)then
!              write(nfile,600)'Na',xr,yr,zr,ii
!             elseif((Q_P(ii).lt.0.4).and.(Q_P(ii).ge.0.2))then
!              write(nfile,600)'Cl',xr,yr,zr,ii
!             elseif((Q_P(ii).lt.0.6).and.(Q_P(ii).ge.0.4))then
!              write(nfile,600)'Br',xr,yr,zr,ii
!             elseif((Q_P(ii).lt.0.8).and.(Q_P(ii).ge.0.6))then
!              write(nfile,600)'Li',xr,yr,zr,ii
!             elseif(Q_P(ii).ge.0.8)then
!              write(nfile,600)'O',xr,yr,zr,ii
!             endif
!            endif

            if(iesc.eq.5)then

	!rcolor=q6bartot(ii)-q4bartot(ii)
	rcolor=q6bartot(ii)


	if(ii.lt.24000)then	
             if(rcolor.lt.0.375)then
              write(nfile,600)'Na',xr,yr,zr,ii
             elseif(rcolor.ge.0.375)then
              write(nfile,600)'O',xr,yr,zr,ii
             endif
            endif
	endif


	 endif    
	enddo

	  	    
	
 600  format(2x,1A,2x,3(F14.7,2x),I8)
 601  format(2x,1A,4(F14.7,2x))
       return
       end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	subroutine mostest(valores,imost)
	include 'parametros_NpT.inc'
	include 'common.inc'
!Input un set de valores asociados a cada molecula, que pueden ser, por ejemplo, 
!la presion o el desplazamiento de cada particula. En array "valores(i)"
!Output: array imost(i) que es 1 si la molecula i esta entre el 5 por ciento
!de las que mas alto valor tiene y 0 si no. 

	dimension imost(natmax),valores(natmax)

	nsucento=5
	nmost=nmoltot*nsucento/100

	do i=1,natmax
	 imost(i)=0
	enddo


	do j=1,nmost

	valmax=0.
	iestmost=0
	do i=1,nmoltot
	if(valores(i).gt.valmax)then
	 if(imost(i).eq.0)then
	  valmax=valores(i)
	  iestmost=i
	 endif
	endif
	enddo
	 
	imost(iestmost)=1
	enddo


	return
	end

c Parametro de orden de tipo 2
c ....................................................................
c ********************************************************************
c ....................................................................
c ********************************************************************
c ....................................................................
c ********************************************************************
c ....................................................................
c ********************************************************************
c ....................................................................
c ********************************************************************
c ....................................................................

c label carl 
	subroutine order2(so)

	include 'parametros_NpT.inc'
	include 'common.inc'
                                                                        
      integer         n,  nat, small, largest
      doubleprecision  wlarge,smalli
      integer i,j,k,k1,l
      integer index(natmax)
      integer         ia, iv, num
      integer lwork,ifail
	doubleprecision x(natmax),y(natmax),z(natmax)
      doubleprecision comx, comy, comz, xmass(natmax)
      doubleprecision xmol(nsmax),ymol(nsmax),zmol(nsmax)
      doubleprecision xmom(3,3), v(3,3), r(3),e(3)
      doubleprecision p(3,3)
      doubleprecision mw
      doubleprecision q(3,3)
      doubleprecision a(nmmax,3)
      doubleprecision norm,so
      parameter (lwork=64*3)
      doubleprecision W(3),work(lwork)
C***********************************************************************
ccarl      norm=(1.0d0/real(nmmax))
c 
c Change mixture 34 
           norm=(1.0d0/real(nmoltot))


C***********************************************************************
C***********************************************************************
C***********************************************************************
C***********************************************************************
C     flush the order tensor q
C***********************************************************************
      do  i=1,3
        do  j=1,3
          q(i,j)=0.0d0
        enddo
      enddo


C***********************************************************************
C     assign masses
C***********************************************************************
      do i=1,natmax
        xmass(i)=1.
      enddo

C***********************************************************************
C     start loop over all nmol molecules
C***********************************************************************
      k1 = 0
c Change mixtures 35
      do l = 1, nmoltot 
      ic=class(l)
C***********************************************************************
C        assign coordinates of molecule l
C***********************************************************************
         do k = 1,nsites(ic) 
            k1 = k1 + 1
ccarl            xmol(k) = xa(k1)
ccarl            ymol(k) = ya(k1)
ccarl            zmol(k) = za(k1)
c
      tx=xa(k1)
      ty=ya(k1)
      tz=za(k1)
ccj
      txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
      typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
      tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
      xmol(k)=txp
      ymol(k)=typ
      zmol(k)=tzp 
c           xmol(k) = h(1,1)*xa(k1)
c           ymol(k) = h(2,2)*ya(k1)
c           zmol(k) = h(3,3)*za(k1)
         enddo

C***********************************************************************
C     calculate the  inertia tensor
C***********************************************************************
C***********************************************************************
C     set initial moment of inertia matrix to zero
C***********************************************************************
      do i = 1, 3
         do j = 1, 3
            xmom(i,j) = 0.0d0
         enddo
      enddo

C***************************
********************************************
C     calculate centre of mass
C***********************************************************************
      comx = 0.0d0
      comy = 0.0d0
      comz = 0.0d0
      mw   = 0.0d0
c Change mixture 36
      do i = 1, nsites(ic) 
         comx = comx + xmol(i) * xmass(i)
         comy = comy + ymol(i) * xmass(i)
         comz = comz + zmol(i) * xmass(i)
         mw   = mw + xmass(i)
      enddo

      comx = comx / mw
      comy = comy / mw
      comz = comz / mw

C***********************************************************************
C     convert coordinates into distances w.r.t. centre of mass
C***********************************************************************
c Change mixture 37
      do i = 1, nsites(ic) 
         x(i) = xmol(i) - comx
         y(i) = ymol(i) - comy
         z(i) = zmol(i) - comz
      enddo

C***********************************************************************
c     make moment of inertia matrix
C***********************************************************************
c Change mixture 38
      do k = 1, nsites(ic) 

         p(1,1) = y(k)**2 + z(k) **2
         p(2,2) = x(k)**2 + z(k) **2
         p(3,3) = x(k)**2 + y(k)**2
         p(1,2) = - (x(k)*y(k))
         p(1,3) = - (x(k)*z(k))
         p(2,1) = p(1,2)
         p(2,3) = - (y(k)*z(k))
         p(3,1) = p(1,3)
         p(3,2) = p(2,3)


         do i = 1, 3
            do j = 1, 3
               xmom(i,j) = xmom(i,j) + xmass(k) * p(i,j)
            enddo
         enddo

      enddo

cwrite(*,*)'The xmom  matrix :-'
cwrite(*,fmt='(3f10.5)') (xmom(1,j),j=1,3)
cwrite(*,fmt='(3f10.5)') (xmom(2,j),j=1,3)
cwrite(*,fmt='(3f10.5)') (xmom(3,j),j=1,3)

      num = 3      ! order of the matrix a
      ifail = 0
      ia = 3
      iv = 3

c      call   F02ABF(xmom,ia, num, r,    v,iv,e, ifail)
c      subroutine rsm(nm,  n,  a,   w,m,z, fwork,iwork,ierr)
c%%%%%%%%%%%%%%%%%% input %%%%%%%%%%%%%%%%%%%%
cwrite(*,*)'dimensions ',ia
cwrite(*,*)'order of matrix  ',num
cwrite(*,*)'the matrix ',xmom
cwrite(*,*)'eigen vectors to be computed ',num
c     call       rsm(ia,  num,xmom,r,num,v,e, iv,ifail)

      call jacobi(xmom,num,num,r,v,nrot)
c%%%%%%%%%%%%%%%%%%% output %%%%%%%%%%%%%%%%%%%%%%%%
cwrite(*,*)'eigen values '
cwrite(*,fmt='(3f10.5)') (r(j),j=1,3)
cwrite(*,*)'eigen vectors '
cwrite(*,fmt='(3f10.5)') (v(1,j),j=1,3)
cwrite(*,fmt='(3f10.5)') (v(2,j),j=1,3)
cwrite(*,fmt='(3f10.5)') (v(3,j),j=1,3)


cwrite(*,*)ifail
c     if ( ifail .ne. 0 )then
cwrite(*,*)'ifail error in first call '
cwrite(*,*)ifail
cstop
cendif

c****************************************************+
C	the routine JACOBI does no sorting
c	of the eigen values, so I have to do it.
c	remmeber: I want the eigen vector
c	associated with the smallest eigen value.
c****************************************************+
c	assume that r(1) is the smallest
c****************************************************+
csmall=1
cif(r(2).lt.r(1)) then
c       small=2
celseif(r(3).lt.r(2)) then
c       small=3
celseif(r(3).lt.r(1))  then
c       small=3
cendif
cwrite(*,*)'want smallest eval'
cwrite(*,*)r

        smalli= 9.e5
        do  i=1,3
         if(r(i).lt.smalli) then
          smalli=r(i)
          small=i
         endif
        enddo
	
cwrite(*,*)'small is ',small
cwrite(*,*)r(small)
cwrite(*,*)'choosing eigen value number ',small

	a(l,1)=v(1,small)
	a(l,2)=v(2,small)
	a(l,3)=v(3,small)

            q(1,1)=q(1,1)+(((1.5d0)*a(l,1)*a(l,1))-0.5d0)
            q(2,2)=q(2,2)+(((1.5d0)*a(l,2)*a(l,2))-0.5d0)
            q(3,3)=q(3,3)+(((1.5d0)*a(l,3)*a(l,3))-0.5d0)
            q(2,1)=q(2,1)+((1.5d0)*a(l,2)*a(l,1))
            q(3,1)=q(3,1)+((1.5d0)*a(l,3)*a(l,1))
            q(3,2)=q(3,2)+((1.5d0)*a(l,3)*a(l,2))

      q(1,2)=q(2,1)
      q(1,3)=q(3,1)
      q(2,3)=q(3,2)

C***********************************************************************
C     end loop over nmol molecules
C***********************************************************************
      enddo

      do  i=1,3
        do  j=1,3
          q(i,j)=q(i,j)*norm
	enddo
	enddo

cwrite(*,*)'The q matrix :-'
cwrite(*,fmt='(3f10.5)') (q(1,j),j=1,3)
cwrite(*,fmt='(3f10.5)') (q(2,j),j=1,3)
cwrite(*,fmt='(3f10.5)') (q(3,j),j=1,3)
C***********************************************************************
C     use EISPACK routine rsm to calculate the eigen values and
C     eigen vectors, i.e. the director (n) and order parameter (o)
C***********************************************************************
c     ifail=0
c     call f02faf('v','l',3,q,3,W,work,lwork,ifail)
c     call rsm   (        3,q,3,w,3,a,fwork,iwork,ifail)
c     call       rsm(ia,  num,q,r,num,v,e, iv,ifail)
c     subroutine rsm(nm,n,a,w,m,z,fwork,iwork,ierr)
c     if (ifail.ne.0) then
c       print '("error in second call. ifail =")',ifail
c     stop
c     endif

      call jacobi(q,num,num,W,v,nrot)

C***********************************************************************
C     wind up the program
C***********************************************************************
cwrite(*,*)'calculating order paameter'
cwrite(*,*)'eigen values '
cwrite(*,fmt='(3f10.5)') (w(j),j=1,3)
cwrite(*,*)'calculating op'
c****************************************************+
C       the routine JACOBI does no soeting
c       of the eigen values, so I have to do it.
c       remmeber: I want the eigen vector
c       associated with the largest eigen value.
c****************************************************+
c       assume that W(1) is the largest
c****************************************************+
clargest=1
cif(r(2).gt.r(1)) then
c       largest=2
celseif(r(3).gt.r(2)) then
c       largest=3
celseif(r(3).gt.r(1))  then
c       largest=3
cendif


        wlarge=w(1)
        do  i=2,3
         if(w(i).gt.wlarge) then
          wlarge=w(i)
         endif
        enddo

cwrite(*,*)'wlarge is ',wlarge



cwrite(*,*)'choosing eigen value number ',largest
c     so= W(largest)
      so= wlarge

cwrite(*,*)'the op is ',so


      return
      end

C***********************************************************+yy
C***********************************************************+yy
C***********************************************************+yy
C***********************************************************+yy

      SUBROUTINE jacobi(a,n,np,d,v,nrot)
            include 'parametros_NpT.inc'

      INTEGER n,np,nrot,NMAX
      real*8 a(np,np),d(np),v(np,np)
      PARAMETER (NMAX=500)
      INTEGER i,ip,iq,j
      real*8 c,g,h,s,sm,t,tau,theta,tresh,b(NMAX),z(NMAX)
      do 12 ip=1,n
        do 11 iq=1,n
          v(ip,iq)=0.
11      continue
        v(ip,ip)=1.
12    continue
      do 13 ip=1,n
        b(ip)=a(ip,ip)
        d(ip)=b(ip)
        z(ip)=0.
13    continue
      nrot=0
      do 24 i=1,50
        sm=0.
        do 15 ip=1,n-1
          do 14 iq=ip+1,n
            sm=sm+abs(a(ip,iq))
14        continue
15      continue
        if(sm.eq.0.)return
        if(i.lt.4)then
          tresh=0.2*sm/n**2
        else
          tresh=0.
        endif
        do 22 ip=1,n-1
          do 21 iq=ip+1,n
            g=100.*abs(a(ip,iq))
            if((i.gt.4).and.(abs(d(ip))+
     *g.eq.abs(d(ip))).and.(abs(d(iq))+g.eq.abs(d(iq))))then
              a(ip,iq)=0.
            else if(abs(a(ip,iq)).gt.tresh)then
              h=d(iq)-d(ip)
              if(abs(h)+g.eq.abs(h))then
                t=a(ip,iq)/h
              else
                theta=0.5*h/a(ip,iq)
                t=1./(abs(theta)+sqrt(1.+theta**2))
                if(theta.lt.0.)t=-t
              endif
              c=1./sqrt(1+t**2)
              s=t*c
              tau=s/(1.+c)
              h=t*a(ip,iq)
              z(ip)=z(ip)-h
              z(iq)=z(iq)+h
              d(ip)=d(ip)-h
              d(iq)=d(iq)+h
              a(ip,iq)=0.
              do 16 j=1,ip-1
                g=a(j,ip)
                h=a(j,iq)
                a(j,ip)=g-s*(h+g*tau)
                a(j,iq)=h+s*(g-h*tau)
16            continue
              do 17 j=ip+1,iq-1
                g=a(ip,j)
                h=a(j,iq)
                a(ip,j)=g-s*(h+g*tau)
                a(j,iq)=h+s*(g-h*tau)
17            continue
              do 18 j=iq+1,n
                g=a(ip,j)
                h=a(iq,j)
                a(ip,j)=g-s*(h+g*tau)
                a(iq,j)=h+s*(g-h*tau)
18            continue
              do 19 j=1,n
                g=v(j,ip)
                h=v(j,iq)
                v(j,ip)=g-s*(h+g*tau)
                v(j,iq)=h+s*(g-h*tau)
19            continue
              nrot=nrot+1
            endif
21        continue
22      continue
        do 23 ip=1,n
          b(ip)=b(ip)+z(ip)
          d(ip)=b(ip)
          z(ip)=0.
23      continue
24    continue
!     chantal sett 2011
!      pause 'too many iterations in jacobi'
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software 3Y'1.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c	Subrrutina que cambia la conformación de una molécula 
c	escogida aleatoriamente y que decide la aceptacion de la
c	nueva configuracion del sistema tras el cambio conformacional
c	de dicha molécula. Devuelve la energía de la vieja 
c	configuración si la nueva no fue aceptada o de la nueva si lo
c 	fue. 
c       Para cambiar de angulos de enlace fijos a libres buscar la
c       palabra clave 'anglechan'.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine cb_move(seed,accpt)
		
	include 'parametros_NpT.inc'
	include 'common.inc'

      dimension xato(nsmax),yato(nsmax),zato(nsmax)
      dimension xatn(nsmax),yatn(nsmax),zatn(nsmax)
      dimension xbo(nsmax),ybo(nsmax),zbo(nsmax)
      dimension xbt(nsmax),ybt(nsmax),zbt(nsmax)
      dimension ai(3,3),xc(3),vec(3),vect(3)
      dimension r_i(3),r_j(3),r_k(3),rt_p(3),rt_o(3),At(3,3)
      dimension semillas(nktrial)
        real*8  sumdis,cre,Wnew,Wold,w,suma,rill,acepta
        real*8  compara,dis,r2,ranf
	real*8 xenl,yenl,zenl,denla,x_o1,y_o1,z_o1
	real*8 x_o3,y_o3,z_o3,r_i,r_j,r_k,rmod,vec,vect,At
        integer  ic,n,niter,iiii,isite,nflag,ial,j,itrial,ip
        integer  iw,ii,jj,jup,icon,kk,itr,ij,ji,i
        integer  a1site,a2sites,a3sites,sit3,sit4
	integer  eth,inc,limsup,liminf
	integer  imol,nmoltot
        dimension prob(nktrial),proba(nktrial),t(nktrial)
        dimension xtr(nktrial),ytr(nktrial),ztr(nktrial)
        dimension xtcart(nsmax),ytcart(nsmax),ztcart(nsmax)
	dimension x(nsmax),y(nsmax),z(nsmax)
	dimension a(nsmax),b(nsmax),c(nsmax)
        dimension xcm1(nsmax),ycm1(nsmax),zcm1(nsmax) 
        dimension xcm2(nsmax),ycm2(nsmax),zcm2(nsmax)
        dimension un(3),Ros(2)
 
c

cccccccccccccccccccccccccccccccccccccccccc
c *** eleccion de una molecula al azar
cccccccccccccccccccccccccccccccccccccccccc

      imol = int(nmoltot*ranf(seed)) + 1

      if (imol.gt.nmoltot) imol=nmoltot

      ic=class(imol)

cccccccccccccccccccccccccccccccccccccccccc
c *** sacando esta molecula de la lista
cccccccccccccccccccccccccccccccccccccccccc  

      call take_outof_list(imol,ic)

cccccccccccccccccccccccccccccccccccccccccccccccccccc
c *** eleccion de un site al azar sobre el que crecer
cccccccccccccccccccccccccccccccccccccccccccccccccccc

9	isite = int(nsites(ic)*ranf(seed)) + 1
	if (isite.gt.nsites(ic)) isite=nsites(ic)


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Eleccion de direccion de crecimiento al azar
c y asignación de valores que algunas variables toman 
c en función del valor de nflag.  
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

             cre=ranf(seed)

             if(cre.gt.0.5) then 

               nflag=0   !Crece desde isite hasta el site n
	       liminf=isite+1
	       limsup=nsites(ic)
	       inc=1
	       eth=2
	       sit3=3
	       sit4=4

             else

               nflag=1   !Crece desde isite hasta el 1
	       liminf=isite-1
	       limsup=1
	       inc=-1
	       eth=nsites(ic)-1
	       sit3=nsites(ic)-2
	       sit4=nsites(ic)-3

             endif

c

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Si la direccion de crecimiento es hacia n y el site escogido
c es el n vuelve a escoger site y direccion de crecimiento.
c idem para el site 1. 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

            if((isite.eq.1).and.(nflag.eq.1))goto 9
            if((isite.eq.nsites(ic)).and.(nflag.eq.0))goto 9  

      numori=puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Almacenado de coordenas cartesiana y caja que luego serán 
c necesarias.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do is=1,nsites(ic)
         numsite=numori+is
         xat(is)=xa(numsite)
         yat(is)=ya(numsite)
         zat(is)=za(numsite)
         xato(is)=xa(numsite)
         yato(is)=ya(numsite)
         zato(is)=za(numsite)
      end do

      do is=1,nsites(ic)
	 numsite=numori+is
         xtcart(is)=xa(numsite)*h(1,1)+ya(numsite)*h(1,2)
     >      				+za(numsite)*h(1,3)
         ytcart(is)=xa(numsite)*h(2,1)+ya(numsite)*h(2,2)
     >					+za(numsite)*h(2,3)
         ztcart(is)=xa(numsite)*h(3,1)+ya(numsite)*h(3,2)
     >					+za(numsite)*h(3,3)
         xcm1(is)=xtcart(is)
         ycm1(is)=ytcart(is)
         zcm1(is)=ztcart(is)
         xcm2(is)=xtcart(is)
         ycm2(is)=ytcart(is)
         zcm2(is)=ztcart(is)
      end do


c***********************************************************************
c BUCLE QUE CALCULA LOS FACTORES DE ROSENBLUTH DE LA VIEJA CONFORMACION
c (irosen=1) Y DE LA CONFORMACION TRIAL (irosen=2).     
c***********************************************************************
             Ros(1)=1.
             Ros(2)=1.

      DO irosen=2,1,-1

             suma=0.
             
       do j=liminf,limsup,inc 

	if(nflag.eq.0)then

	   a1site=j-1
	   a2sites=j-2
	   a3sites=j-3

	   if(j.ge.sit4)then
             ihaz=1
           else
	     ihaz=0
           endif

	else

	   a1site=j+1
	   a2sites=j+2
	   a3sites=j+3
         
	   if(j.le.sit4)then
             ihaz=1
           else
	     ihaz=0
           endif

	endif

cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c       Se calcula la distancia entre los sites j-1 y j
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

	 xenl=xb(ic,j)-xb(ic,a1site)
	 yenl=yb(ic,j)-yb(ic,a1site)
	 zenl=zb(ic,j)-zb(ic,a1site)
	
	 denla=(xenl**2+yenl**2+zenl**2)**(1./2.)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c  Ahora dependiendo de si el trial site j es el tercero o tiene un
c  indice mayor, hay que hacer una cosa u otra para construir los
c  ejes de Flory intramoleculares con origen coincidente con el
c  sistema cartesiano original.
c  x_oi   es la coordenada x del i-esimo site anterior al trial j
c  referida a un sistema de coordenadas paralelo al sistema
c  original pero con el origen en el 2º site anterior a j.
c  La subrrutina prod_vec(a,b,c) hace el producto vectorial de
c  a * b (en ese orden) y devuelve c que es el vector producto.
c  La subrrutina rnd_alcanos devuelve las coordenadas del trial
c  site en referencia a los ejes intramoleculares de Flory.
c  Se pretende encontrar los vectores unitarios del sistema de
c  coordenadas del enlace (j-1)-(j-2) (convenio
c  Flory pg. 20) cuyo origen sea coincidente con el origen del
c  sistema de coordenadas cartesiano original.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

             if(j.eq.sit3)then
 
               x_o1  =xtcart(a1site)-xtcart(a2sites)
               y_o1  =ytcart(a1site)-ytcart(a2sites)
               z_o1  =ztcart(a1site)-ztcart(a2sites)

               rmod=sqrt(x_o1**2+y_o1**2+z_o1**2)

                 r_i(1)=x_o1  /rmod  !vector unitario de eje flory
                 r_i(2)=y_o1  /rmod
                 r_i(3)=z_o1  /rmod

c              call rnd_sphere(un,seed)

 	        un(1)=1.
        	un(2)=0.
        	un(3)=0.

               call prod_vec(r_i,un,vec)

               rmod=sqrt(vec(1)**2+vec(2)**2+vec(3)**2)

               r_j(1)=vec(1)/rmod
               r_j(2)=vec(2)/rmod
               r_j(3)=vec(3)/rmod


               call prod_vec(r_i,r_j,r_k)

               At(1,1)=r_i(1)
               At(2,1)=r_i(2)
               At(3,1)=r_i(3)
               At(1,2)=r_j(1)
               At(2,2)=r_j(2)
               At(3,2)=r_j(3)
               At(1,3)=r_k(1)
               At(2,3)=r_k(2)
               At(3,3)=r_k(3)

c        Ya tenemos los vectores directores de los ejes de flory de
c        molecula desplazados al origen, y construida la matriz de
c        transformación.Vamos a hacer lo mismo pero en
c        el caso de que el trial site tenga un índice igual o mayor
c        que cuatro:

               else if(ihaz.eq.1)then


               x_o1  =xtcart(a1site)-xtcart(a2sites)
               y_o1  =ytcart(a1site)-ytcart(a2sites)
               z_o1  =ztcart(a1site)-ztcart(a2sites)

               x_o3  =xtcart(a3sites)-xtcart(a2sites)
               y_o3  =ytcart(a3sites)-ytcart(a2sites)
               z_o3  =ztcart(a3sites)-ztcart(a2sites)


               rmod=sqrt(x_o1**2+y_o1**2+z_o1**2)

                 r_i(1)=x_o1  /rmod  !vector unitario de eje flory
                 r_i(2)=y_o1  /rmod
                 r_i(3)=z_o1  /rmod

               vect(1)=x_o3
               vect(2)=y_o3
               vect(3)=z_o3

               call prod_vec(vect,r_i,vec)

               rmod=sqrt(vec(1)**2+vec(2)**2+vec(3)**2)

               r_k(1)=vec(1)/rmod
               r_k(2)=vec(2)/rmod
               r_k(3)=vec(3)/rmod

               call prod_vec(r_k,r_i,r_j)


               At(1,1)=r_i(1)
               At(2,1)=r_i(2)
               At(3,1)=r_i(3)
               At(1,2)=r_j(1)
               At(2,2)=r_j(2)
               At(3,2)=r_j(3)
               At(1,3)=r_k(1)
               At(2,3)=r_k(2)
               At(3,3)=r_k(3)

               endif
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c si el bucle va por irosen=1 se necesitan las coordenadas
c cartesianas viejas:

               if (irosen.eq.1) then 
                  do ik1=1,nsites(ic)
                  xtcart(ik1)=xcm1(ik1)
                  ytcart(ik1)=ycm1(ik1)
                  ztcart(ik1)=zcm1(ik1)
                  enddo
               endif 

ccccccccccccccccccccccccccccc
c se generan nktrial semillas:

         do ise=1,nktrial
          rcaca=ranf(seed)
          semillas(ise)=seed
         enddo

c**********************************
c BUCLE EN EL QUE SE GENERAN NKTRIAL POSICIONES PARA EL SITE j

C$OMP  PARALLEL  DEFAULT(PRIVATE) 
C$OMP+ SHARED(irosen,eth,denla,pi,nflag,numori,nktrial)
C$OMP+ SHARED(imol,ic,sidea,sideb,sidec,j,a1site)
C$OMP+ shared(xtcart,ytcart,ztcart)
C$OMP+ SHARED(semillas,nsites,At,hinv)
C$OMP+ SHARED(xtr,ytr,ztr,t,xcm1,ycm1,zcm1)
C$OMP+ SHARED(suma)
C$OMP  DO REDUCTION(+:suma)

      do itrial=1,nktrial
   
                 semi=semillas(itrial)
                 if((itrial.eq.1).and.(irosen.eq.1))goto 125
                        
c anglechan
c para angulos de enlace fijo la siguiente linea ha de estar comentada
c        if(j.eq.eth)then

c Se genera un vector unitario

             call rnd_sphere(un,semi)

c Vector de módulo igual a la distancia entre los sites j y j-1

	     desp1=un(1)*denla 
	     desp2=un(2)*denla 
	     desp3=un(3)*denla

c Genero unas coordenadas trial             
	  
             xtr(itrial)=xtcart(a1site)+desp1
	     ytr(itrial)=ytcart(a1site)+desp2
	     ztr(itrial)=ztcart(a1site)+desp3

ccccccccccccccccccccccccccccccccccccccccccccc
c   Caso de que j no sea 2
cccccccccccccccccccccccccccccccccccccccccccccc
c   Si se quiere hacer modelo rosario siempre la
c   Parte anterior.          
cccccccccccccccccccccccccccccccccccccccccccccc             
ccccccccccccccccccccccccccccccccccccccccccccccccccc
c   anglechan
c   Para angulos de enlace libre desde la siguiente
c   hasta donde pone 'sacabo' debe estar comentado 
c           else
c 
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Se elige un angulo al azar entre -180 y +180
c 
c             rran=ranf(semi)
c             fi=rran*180.
c             rran=ranf(semi)
c 
c             if(rran.ge.0.5)then
c              fi=fi*pi/180.
c             else
c              fi=-fi*pi/180.
c             endif
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Se llama a rnd_alcanos que devuelve el vector rt_p, que une
c el trial site con el site anterior,  con referencia
c a los ejes intramoleculares de Flory para el enlace (j-1)-(j-2)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c 
c 
c             call rnd_alcanos(denla,fi,rt_p)
c 
c 
c             do isl=1,3
c                 sumae=0.000
c               do jsl=1,3
c                  sumae=sumae+At(isl,jsl)*rt_p(jsl)
c               enddo
c                  rt_o(isl)=sumae
c             enddo
c 			
c 
c              xtr(itrial)=rt_o(1)+xtcart(a1site)
c              ytr(itrial)=rt_o(2)+ytcart(a1site)
c              ztr(itrial)=rt_o(3)+ztcart(a1site)
c 
c 
c 
c              endif
c
cc    sacabo 


  125         if((itrial.eq.1).and.(irosen.eq.1))then            
              xtr(itrial)=xcm1(j)
              ytr(itrial)=ycm1(j)
              ztr(itrial)=zcm1(j)
              endif

cccccccccccccccccccccccccccccccccccccccccccccccccc
c        Se calcula el sumatorio de exp(-beta u)
c        del trial itrial del site j
c        con todos los sites anteriores
ccccccccccccccccccccccccccccccccccccccccccccccccccc

         call intramol(j,nflag,xtr(itrial),ytr(itrial),ztr(itrial),
     >    nsites(ic),xtcart,ytcart,ztcart,wintra,numori,energint,kk)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c	 ahora hay que calcular el w intermolecular que se evalua
c        mediante el calculo de la interaccion del site j con el 
c        resto de sites del resto de las moléculas
c        Para ello, antes de la llamada hay que pasar a coordenadas de
c        caja las coordenadas del trial site cuyas interacciones 
c        vamos a calcular.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
        xtrlocal=xtr(itrial)
        ytrlocal=ytr(itrial)
        ztrlocal=ztr(itrial)
c
	xatnewl=hinv(1,1)*xtrlocal+hinv(1,2)*ytrlocal
     >            +hinv(1,3)*ztrlocal
        yatnewl=hinv(2,1)*xtrlocal+hinv(2,2)*ytrlocal
     >            +hinv(2,3)*ztrlocal
        zatnewl=hinv(3,1)*xtrlocal+hinv(3,2)*ytrlocal
     >            +hinv(3,3)*ztrlocal
 
         call inter_molecular_cb1(xatnewl,yatnewl,zatnewl,winter,ic,j) 
c
	 w=winter*wintra
         t(itrial)=w
         suma=suma+t(itrial)

      enddo
C$OMP END DO
C$OMP END PARALLEL

c************************************************
c SI ESTAMOS CONSTRUYENDO UNA NUEVA MOLECULA HAY QUE ESCOGER UNO
c DE LOS NKTRIAL GENERADOS

        IF(irosen.eq.2)THEN

           if(suma.eq.0.)then
                goto 100      !si todos las posiciones trial solapan
           end if              !directamente me quedo con lo que tengo.

c        Se calcula ahora la probabilidad de aceptar cada trial

         do ip=1,nktrial
          prob(ip)=t(ip)/suma
         enddo


c        Se elige uno de los trial con probabilidad prob(ip)

         do iw=1,nktrial
           proba(iw)=0.
         enddo

         proba(1)=prob(1)

         do ii=nktrial,2,-1
          do jj=ii,1,-1
            proba(ii)=proba(ii)+prob(jj)
          enddo
         enddo

         jup=0
         icon=0
         rill=ranf(seed)

        Do while(jup.ne.1)
         icon=icon+1
         if(rill.le.proba(icon))then
           jup=1
         end if
        enddo
	

c   Se almacenan las coord trial triunfadoras del site j
c

        xtcart(j)=xtr(icon)
        ytcart(j)=ytr(icon)
        ztcart(j)=ztr(icon)

        xcm2(j)=xtcart(j)
        ycm2(j)=ytcart(j)
        zcm2(j)=ztcart(j)
	 
c   Además hay que dejar los array xat() y cia. de manera adecuada
c   dado que en estos momentos tienen para el site j el valor de
c   las coordenadas del ultimo trial, que es muy probable que no
c   sea el elegido.

	  xw=xtr(icon)
	  yw=ytr(icon)
	  zw=ztr(icon)

          xat(j)=xw*hinv(1,1)+yw*hinv(1,2)+zw*hinv(1,3)
          yat(j)=xw*hinv(2,1)+yw*hinv(2,2)+zw*hinv(2,3)
          zat(j)=xw*hinv(3,1)+yw*hinv(3,2)+zw*hinv(3,3)

      ENDIF !fin del if de escogida de un trial.
c**************************************************       
c   Se va calculando el factor de Rosenbluth de la conformacion
c   en crecimiento.

        Ros(irosen)=Ros(irosen)*suma
        suma=0.
        
       enddo !fin del bucle que va desde isite +/- 1 hasta n/1
      ENDDO !fin del bucle sobre irosen


c******************************************************************
c    Tenemos ya calculados los factores de Rosenbluth viejo y nuevo
c    vamos a ver si se acepta la nueva conformacion generada

        acepta=ranf(seed)
        compara=Ros(2)/Ros(1)

C******************************************************************
c SI SE ACEPTA HAY QUE ACTUALIZAR LAS COORDENADAS Y LA ENERGIA

        IF(acepta.lt.compara)THEN

           accpt=accpt+1.

            do is7=1,nsites(ic)
              xtcart(is7)=xcm2(is7)
              ytcart(is7)=ycm2(is7)
              ztcart(is7)=zcm2(is7)
           enddo
c
c
             if(nflag.eq.0)then
                do ij=isite+1,nsites(ic)
	           numsite=numori+ij
                  xa(numsite)=xtcart(ij)*hinv(1,1)+ytcart(ij)*hinv(1,2)+
     >		                          ztcart(ij)*hinv(1,3)
                  ya(numsite)=xtcart(ij)*hinv(2,1)+ytcart(ij)*hinv(2,2)+
     >		                          ztcart(ij)*hinv(2,3)
                  za(numsite)=xtcart(ij)*hinv(3,1)+ytcart(ij)*hinv(3,2)+
     >		                          ztcart(ij)*hinv(3,3)
                enddo

             else
                do ji=isite-1,1,-1
                   numsite=numori+ji
                  xa(numsite)=xtcart(ji)*hinv(1,1)+ytcart(ji)*hinv(1,2)+
     >                                      ztcart(ji)*hinv(1,3)
                  ya(numsite)=xtcart(ji)*hinv(2,1)+ytcart(ji)*hinv(2,2)+
     >                                      ztcart(ji)*hinv(2,3)
                  za(numsite)=xtcart(ji)*hinv(3,1)+ytcart(ji)*hinv(3,2)+
     >                                      ztcart(ji)*hinv(3,3)
                enddo
             endif

      do is=1,nsites(ic)
         numsite=numori+is
         xatn(is)=xa(numsite)
         yatn(is)=ya(numsite)
         zatn(is)=za(numsite)
      end do

c********************************
c CALCULO DEL CAMBIO DE ENERGÍA ASOCIADO AL CAMBIO DE CONFORMACION
c
C$OMP PARALLEL
C$OMP SECTIONS
C$OMP SECTION
c *** calculo de la energia de la conformacion original
      call inter_molecular1(xato,yato,zato,imol,ic,uinterold,iax,uljo)

        Uintraold=0.
	  u_ljintraold=0.
        do ini=1,nsites(ic)-2
	  call intramol(ini,1,xcm1(ini),ycm1(ini),zcm1(ini),
     >       nsites(ic),xcm1,ycm1,zcm1,wo,numori,energinto,u_ljio)
          Uintraold=Uintraold+energinto
	    u_ljintraold=u_ljintraold+u_ljio
        enddo
	  
C$OMP SECTION
c *** calculo de la energía de la conformación nueva
      call inter_molecular1(xatn,yatn,zatn,imol,ic,uinternew,iax,uljn)

        Uintranew=0.
	  u_ljintranew=0.
        do ini=1,nsites(ic)-2
	  call intramol(ini,1,xcm2(ini),ycm2(ini),zcm2(ini),
     >       nsites(ic),xcm2,ycm2,zcm2,wn,numori,energintn,u_ljin)
          Uintranew=Uintranew+energintn
	    u_ljintranew=u_ljintranew+u_ljin
        enddo
	      
C$OMP END SECTIONS
C$OMP END PARALLEL
c Evaluamos el cambio en energía LJ y energía total

	u_lj=u_lj-u_ljintraold+u_ljintranew
	
	deltau=Uintranew+Uinternew-Uintraold-Uinterold
      deltau=deltau*beta       	
	utot=utot+deltau
c********************************
	
        ENDIF  !Fin del if que engloba las actualizaciones  
	       !por aceptacion
C*********************************************************

 100    call put_in_list(imol,ic)



cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c	Calculo de la distancia extremo-extremo promedio
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

	if(ntot.gt.neq)then

	contador(ic)=contador(ic)+1.
	
	denx=xa(numori+1)-xa(numori+nsites(ic))
	deny=ya(numori+1)-ya(numori+nsites(ic))
	denz=za(numori+1)-za(numori+nsites(ic))

	dxr=h(1,1)*denx+h(1,2)*deny+h(1,3)*denz
	dyr=h(2,1)*denx+h(2,2)*deny+h(2,3)*denz
	dzr=h(3,1)*denx+h(3,2)*deny+h(3,3)*denz

	dr=dxr**2+dyr**2+dzr**2

	dcm(ic)=dcm(ic)+sqrt(dr)
        dcmcuad(ic)=dcmcuad(ic)+dr  
        
         endif
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

	return
	end

        
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Subrrutina para evaluar el sumatorio exp(beta*u) de un site con
c los sites posteriores o los anteriores segun sea nflag=1 o 0
c respectivamente. (INTRAMOLECULAR)    
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        subroutine intramol (j,nflag,xs,ys,zs,n,xt,yt,zt,w,numori,
     >				energint,uljintra)

       include 'parametros_NpT.inc'
	include 'common.inc'


        real*8 xs,ys,zs
        integer n,j
        dimension xt(nsmax),yt(nsmax),zt(nsmax)
        real*8 w,r2
        real*8 d,expon,epsilon
        integer i


        w=1.
	energint=0.
        uion=0.
        u_lenjo=0.
	  uljintra=0.
        
	sig_a=sigatom(numori+j)
	eps_a=epsiatom(numori+j)

        IF(nflag.eq.1)THEN   !Si crece en un sentido las interacciones

           if(j.eq.n)then
             goto 10
           endif

           DO i=j+1,n        !se calculan en el sentido contrario.
	
	      sig_b=sigatom(numori+i)
              sig_ij=0.5*(sig_a+sig_b)
  	    
	
	      dxcart=xt(i)-xs 		
	      dycart=yt(i)-ys
	      dzcart=zt(i)-zs


	    dxcaja=hinv(1,1)*dxcart+hinv(1,2)*dycart+hinv(1,3)*dzcart
	    dycaja=hinv(2,1)*dxcart+hinv(2,2)*dycart+hinv(2,3)*dzcart
	    dzcaja=hinv(3,1)*dxcart+hinv(3,2)*dycart+hinv(3,3)*dzcart	

	    dxmic=dxcaja-anint(dxcaja)
	    dymic=dycaja-anint(dycaja)
	    dzmic=dzcaja-anint(dzcaja)

	    xmicart=h(1,1)*dxmic+h(1,2)*dymic+h(1,3)*dzmic
	    ymicart=h(2,1)*dxmic+h(2,2)*dymic+h(2,3)*dzmic
	    zmicart=h(3,1)*dxmic+h(3,2)*dymic+h(3,3)*dzmic

             r2=xmicart**2+ymicart**2+zmicart**2
             
             IF (r2.lt.rcut2) THEN 
c *** Interacción culómbica (contribución espacio real)
               if(iewald.eq.1)then
                 qiqj=cargatom(numori+i)*cargatom(numori+j)
                 rijsq=sqrt(r2)
                 uion=qiqj*erfcc(alfa*rijsq)/rijsq-qiqj/rijsq
               endif                           
c *** Interacción Lennard-Jones
               if(abs(j-i).ne.1)then   !evita el calculo en intercacc.
                                         !entre sites contiguos
                 if(sig_ij.lt.0.0000001)then 
                   u_lenjo=0.
                 else
                     r2sig=r2/sig_ij**2
                     Epsi_ij=(eps_a*epsiatom(numori+i))**(1./2.)
  
                     if (r2sig.le.0.16) then   
                       u_lenjo=1.42e10*Epsi_ij
                     else
                       r2i=1./r2sig
                       u_lenjo = 4.*Epsi_ij*( R2i**6 - R2i**3 ) 
                     endif    
                 endif
                  
               elseif(abs(j-i).eq.1)then
                  u_lenjo=0.      
               endif                   
c *** Si no se calculan                 
             ELSE
                 uion=0.       
                 u_lenjo=0.
             ENDIF   
c             write(6,*) u_lenjo,uion 
              u_ij=u_lenjo+uion
	        uljintra=uljintra+u_lenjo
              energint=energint+u_ij

           ENDDO

        ELSE

          if(j.eq.1)then
            w=1.
            goto10
          endif

          DO i=j-1,1,-1
	   
	     sig_b=sigatom(numori+i)
             sig_ij=0.5*(sig_a+sig_b)

              dxcart=xt(i)-xs
              dycart=yt(i)-ys
              dzcart=zt(i)-zs


            dxcaja=hinv(1,1)*dxcart+hinv(1,2)*dycart+hinv(1,3)*dzcart 
            dycaja=hinv(2,1)*dxcart+hinv(2,2)*dycart+hinv(2,3)*dzcart 
            dzcaja=hinv(3,1)*dxcart+hinv(3,2)*dycart+hinv(3,3)*dzcart 

            dxmic=dxcaja-anint(dxcaja)
            dymic=dycaja-anint(dycaja)
            dzmic=dzcaja-anint(dzcaja)

            xmicart=h(1,1)*dxmic+h(1,2)*dymic+h(1,3)*dzmic
            ymicart=h(2,1)*dxmic+h(2,2)*dymic+h(2,3)*dzmic
            zmicart=h(3,1)*dxmic+h(3,2)*dymic+h(3,3)*dzmic

             r2=xmicart**2+ymicart**2+zmicart**2


             IF (r2.lt.rcut2) THEN
c *** Interacción culómbica (contribución espacio real)
               if(iewald.eq.1)then
                 qiqj=cargatom(numori+i)*cargatom(numori+j)
                 rijsq=sqrt(r2)
                 uion=qiqj*erfcc(alfa*rijsq)/rijsq-qiqj/rijsq
               endif                                
c *** Interacción Lennard-Jones
              if(abs(j-i).ne.1)then
                       
                 if(sig_ij.lt.0.000001)then
                  u_lenjo=0.
                 else
                  r2sig=r2/sig_ij**2
                  Epsi_ij=(eps_a*epsiatom(numori+i))**(1./2.)     
 
                    if (r2.le.0.16) then
                      u_lenjo=1.42e10*Epsi_ij
                    else
                      r2i=1./r2sig
                       u_lenjo = 4.*Epsi_ij*( R2i**6 - R2i**3 ) 
                    endif
                     
                 endif 
                  
              elseif(abs(j-i).eq.1)then
                  u_lenjo=0.
              endif
             ELSE
                 uion=0.
	         u_lenjo=0.
             ENDIF
              u_ij=u_lenjo+uion
	        uljintra=uljintra+u_lenjo
		  energint=energint+u_ij
          ENDDO

        ENDIF
	          w=exp(-beta*energint)  !parte intramolecular del factor
                                         !de Rosenbluth del site j.

 10     return                        
	end 

                                         
ccccccccccccccccccccccccccccccccccccccccccccccccc
c Programa para convertir binarios en ficheros tipo
c rasmol
c
      subroutine xyztorasmol
	include 'parametros_NpT.inc'
	include 'common.inc'
       dimension xxxx(natmax),yyyy(natmax),zzzz(natmax)
c
       nlimit=natoms

        cero=0.0000000
c	fscal=2.72 
	fscal=1.000

c
      open(32,file='job1.pdb2',form='formatted',position='append')
      open(33,file='job1sol.pdb2',form='formatted',position='append')
c
c Revobino los ficheros en la primera llamada
      if(ifirstcallxyzto.eq.0)then
	 rewind(32)
	 rewind(33)
	 ifirstcallxyzto=1
       endif
c______________________________________________!Escritura solo del cluster
        !IF((inucleacion.eq.1).or.(iunbias.eq.1))then
        IF(inucleacion.eq.1)then
c
      write(33,*) ncb !+8
      write(33,*) '   '
c      write(33,100)'F',cero,cero,cero,cero
c      write(33,100)'F',h(1,1)*fscal,h(2,1)*fscal,h(3,1)*fscal,cero
c      write(33,100)'F',h(1,2)*fscal,h(2,2)*fscal,h(3,2)*fscal,cero
c      write(33,100)'F',h(1,3)*fscal,h(2,3)*fscal,h(3,3)*fscal,cero
c
c      write(33,100)'F',(h(1,1)+h(1,2))*fscal,
c    .                 (h(2,1)+h(2,2))*fscal,
c    .                 (h(3,1)+h(3,2))*fscal,cero
c     write(33,100)'F',(h(1,1)+h(1,3))*fscal,
c    .                 (h(2,1)+h(2,3))*fscal,
c    .                 (h(3,1)+h(3,3))*fscal,cero
c     write(33,100)'F',(h(1,2)+h(1,3))*fscal,
c    .                 (h(2,2)+h(2,3))*fscal,
c    .                 (h(3,2)+h(3,3))*fscal,cero
c
cc    write(33,100)'F',(h(1,1)+h(1,2)+h(1,3))*fscal,
cc   .                 (h(2,1)+h(2,2)+h(2,3))*fscal,
cc   .                 (h(3,1)+h(3,2)+h(3,3))*fscal, cero
!La molecula de referencia es la indexada como uno en el vector
!que almacena el indice de las moleculas que pertenecen al
!cluster.
        imleref=indmolclbig(1)
!Hallo el indice que corresponde a esa molecula en el
!vector de coordenadas atomicas.
         ic=class(imleref)
       numori=puntero1(ic)+(imleref-1-puntero2(ic))*nsites(ic)
         indref=numori+1

!Meto en la caja
        xar=xa(indref)
        yar=ya(indref)
        zar=za(indref)
        xar = xar - anint((xar-half) )
        yar = yar - anint((yar-half) )
        zar = zar - anint((zar-half) )
          call caja_cart(xar,yar,zar,xr,yr,zr)

!Bucle sobre todas las particulas del cluster
      do iuj=1,ncb
!Hallo en indice en el vector de coordenadas atomicas que
!corresponde a la molecula iuj del cluster
        imle=indmolclbig(iuj)
        ic=class(imle)
      numori=puntero1(ic)+(imle-1-puntero2(ic))*nsites(ic)
        ind=numori+1


c Metemos atomos en la caja

        xxyztoras = xa(ind) - anint( (xa(ind)-half) )
        yxyztoras = ya(ind) - anint( (ya(ind)-half) )
        zxyztoras = za(ind) - anint( (za(ind)-half) )

c ********* distancias interatomicas en convencion mic
         dx = xxyztoras - xa(indref)
         dy = yxyztoras - ya(indref)
         dz = zxyztoras - za(indref)


c
ccj Julio change number 23
       tx=dx-anint(dx)
       ty=dy-anint(dy)
       tz=dz-anint(dz)
ccj
       txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
       typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
       tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz

ccj
      if(ntipmolmax.eq.2)then
       if (ic.eq.1) then
       write(33,100) 'K',txp+xr,typ+yr,tzp+zr
       elseif(ic.eq.2)then
       write(33,100) 'F',txp+xr,typ+yr,tzp+zr
       endif
      endif


        if(ntipmolmax.eq.3)then
       if (ic.eq.2) then
       write(33,100) 'K',txp+xr,typ+yr,tzp+zr
       elseif(ic.eq.3)then
       write(33,100) 'F',txp+xr,typ+yr,tzp+zr
         endif 
        endif

      end do
        ENDIF
c______________________________________________!Fin de escritura solo del cluster


C______________________________________________!Ahora todas las particulas
c*****************************************************************
c     unbox the coords
c*****************************************************************
      CALL UNBOX
c*****************************************************************
c     write out the pdb file
c*****************************************************************
c


      write(32,*) nlimit+8
      write(32,*) '   '
      write(32,100)'F',cero,cero,cero,cero
      write(32,100)'F',h(1,1)*fscal,h(2,1)*fscal,h(3,1)*fscal,cero
      write(32,100)'F',h(1,2)*fscal,h(2,2)*fscal,h(3,2)*fscal,cero
      write(32,100)'F',h(1,3)*fscal,h(2,3)*fscal,h(3,3)*fscal,cero

      write(32,100)'F',(h(1,1)+h(1,2))*fscal,
     .                 (h(2,1)+h(2,2))*fscal,
     .                 (h(3,1)+h(3,2))*fscal,cero
      write(32,100)'F',(h(1,1)+h(1,3))*fscal,
     .                 (h(2,1)+h(2,3))*fscal,
     .                 (h(3,1)+h(3,3))*fscal,cero
      write(32,100)'F',(h(1,2)+h(1,3))*fscal,
     .                 (h(2,2)+h(2,3))*fscal,
     .                 (h(3,2)+h(3,3))*fscal,cero

      write(32,100)'F',(h(1,1)+h(1,2)+h(1,3))*fscal,
     .                 (h(2,1)+h(2,2)+h(2,3))*fscal,
     .                 (h(3,1)+h(3,2)+h(3,3))*fscal, cero
c
      isuma=0
      do ic=1,ntipmol

c *** sacando esta molecula de la lista
         do ij=1,nmol(ic)
c         ires=mod(ij,4)

          do is=1,nsites(ic)
c          isuma=isuma+is
c
           isuma=isuma+1
            xxxx(isuma)=xanew(isuma)*fscal
            yyyy(isuma)=yanew(isuma)*fscal
            zzzz(isuma)=zanew(isuma)*fscal

       if(ic.eq.1)then
         if (is.eq.1) then 
         write(32,100) 'O',xxxx(isuma),yyyy(isuma),zzzz(isuma),cero
         else 
         write(32,100) 'H',xxxx(isuma),yyyy(isuma),zzzz(isuma),cero
         endif  
	endif

	if(ic.eq.2)then
	 write(32,100) 'Na',xxxx(isuma),yyyy(isuma),zzzz(isuma),cero
	endif

	if(ic.eq.3)then
	 write(32,100) 'Cl',xxxx(isuma),yyyy(isuma),zzzz(isuma),cero
	endif
c
c       if (ires.eq.0) then
c       write(32,100) 'O',xxxx(isuma),yyyy(isuma),zzzz(isuma),cero
c       endif
c       if (ires.eq.1) then
c       write(32,100) 'N',xxxx(isuma),yyyy(isuma),zzzz(isuma),cero
c       endif
c       if (ires.eq.2) then
c       write(32,100) 'F',xxxx(isuma),yyyy(isuma),zzzz(isuma),cero
c       endif
c       if (ires.eq.3) then
c       write(32,100) 'N',xxxx(isuma),yyyy(isuma),zzzz(isuma),cero
c       endif
c
        end do

         end do
      end do
c
 100  format(2x,1A,4(F14.7,2x))
      return 
      END

C***********************************************************************
C     this is the routine that does all the work
C***********************************************************************
      SUBROUTINE UNBOX 

      include 'parametros_NpT.inc'
	include 'common.inc'
c
c
c
      K = 0

      do ic=1,ntipmol
c *** sacando esta molecula de la lista
         do ij=1,nmol(ic)
c      DO I = 1, NMOL

          K1 = K + 1
c
c Mete el atomo uno en la caja
c Primero lo metemos en la caja
        xpb = xa(k1) - anint( (xa(k1)-half) )
        ypb = ya(k1) - anint( (ya(k1)-half) )
        zpb = za(k1) - anint( (za(k1)-half) )
c       write(6,*) xpb,ypb,zpb 
c Ahora lo ponemos en coordenadas absolutas
c     if ((xpb.lt.0.000).or.(xpb.gt.1.000)) then
c     write(6,*) 'pbc wrong for x '
c     stop
c     endif 
c
c     if ((ypb.lt.0.000).or.(ypb.gt.1.000)) then
c     write(6,*) 'pbc wrong for y '
c     stop
c     endif 
c
c     if ((zpb.lt.0.000).or.(zpb.gt.1.000)) then
c     write(6,*) 'pbc wrong for z '
c     stop
c     endif 
c
c
      tx=xpb 
      ty=ypb
      tz=zpb
ccj
      txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
      typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
      tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
      xori=txp
      yori=typ
      zori=tzp 
c
 
c
          DO J = 1, nsites(ic) 

             K = K + 1
c
                XX = Xa(K) - Xa(K1)
                YY = Ya(K) - Ya(K1)
                ZZ = Za(K) - Za(K1)
c Relative coordinates in simulation box units

      tx=xx 
      ty=yy
      tz=zz
ccj
      txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
      typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
      tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
      xmod=sqrt(txp**2+typ**2+tzp**2)
c
c
      xanew(k)=xori+txp
      yanew(k)=yori+typ
      zanew(k)=zori+tzp 
c
           ENDDO

       ENDDO
       enddo
       RETURN
       END
c***************************


       
        subroutine rnd_alcanos(xl2,fia,cor)

	include 'parametros_NpT.inc'
	include 'common.inc'

         dimension tnew(3,3)
         dimension cor(3)

        pi=acos(-1.00)

c       tetain=109.5
        teta=(180.-tetain)*pi/180.
        coteta=cos(teta)
        seteta=sin(teta)


        tnew(1,1)=coteta
        tnew(1,2)=seteta
        tnew(1,3)=0.000
        tnew(2,1)=seteta*cos(fia)
        tnew(2,2)=-coteta*cos(fia)
        tnew(2,3)=sin(fia)
        tnew(3,1)=seteta*sin(fia)
        tnew(3,2)=-coteta*sin(fia)
        tnew(3,3)=-cos(fia)

        vx=xl2*tnew(1,1)
        vy=xl2*tnew(2,1)
        vz=xl2*tnew(3,1)


        cor(1)=vx
        cor(2)=vy
        cor(3)=vz

          return
        end

cccccccccccccccccccccccccccccccccccccccccccccccccccccc

        subroutine prod_vec(a,b,c)
      include 'parametros_NpT.inc'

        dimension a(3),b(3),c(3)

        c(1)=a(2)*b(3)-a(3)*b(2)
        c(2)=-(a(1)*b(3)-a(3)*b(1))
        c(3)=a(1)*b(2)-a(2)*b(1)


        return
        end

cccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c	Subrutina para evaluar exp(-beta*u)=winter, siendo
c	u la energía de interaccion del site isite de la molecula
c	imol de clase ic con los sites de las otras moléculas.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine inter_molecular_cb1(xatnewl,yatnewl,zatnewl,winter,
     1ic,isite) 
      include 'parametros_NpT.inc'
	include 'common.inc'

	integer head,next,previous

	   Eatm = 0.

	   xi = xatnewl - anint( (xatnewl-half) )
	   yi = yatnewl - anint( (yatnewl-half) )
	   zi = zatnewl - anint( (zatnewl-half) )
c ****** calculando de que tipo es el site i

           nordi = nordcar(ic,isite)

c ****** calculando en que celda esta el site i

         i = int(xi/xlcell) + 1
         j = int(yi/ylcell) + 1
         k = int(zi/zlcell) + 1

	   icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

	   xi = xatnewl
	   yi = yatnewl
	   zi = zatnewl

c **** Bucle sobre las ntb celdas de la caja de celdas centrada en icell

	   do ncell = 1,ntb
            
	      jcell = neighbour_cell(ncell,icell)
	      jatm = head(jcell)

c ******** bucle sobre todos los atomos en el interior de la celda jcell
	      
             do while (jatm.ne.0)

	         sig_ij = 0.5*(sigma(nordi)+sigatom(jatm))

c ********* distancias interatomicas en convencion mic

	         dx = xa(jatm) - xi
		 dy = ya(jatm) - yi
		 dz = za(jatm) - zi
ccj Julio change number 22
       tx=(dx - anint(dx))
       ty=(dy - anint(dy))
       tz=(dz - anint(dz))
ccj
       txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
       typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
       tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
       dxmic = txp
       dymic = typ
       dzmic = tzp

	         r2 = (dxmic**2 + dymic**2 + dzmic**2)

c ********* calculo de la energia interatomica

		   
		IF (r2.lt.rcut2) THEN
c *** Interacción culómbica (contribución espacio real)
             if(iewald.eq.1)then
               qiqj=carga(nordi)*cargatom(jatm)
               rijsq=sqrt(r2)
               uij=qiqj*erfcc(alfa*rijsq)/rijsq
               eatm=eatm+uij
             endif                                
c *** Interacción Lennard-Jones
        Epsi_ij=(Epsilon(nordi)*epsiatom(jatm))**(1./2.)

                   if (r2.le.0.16) then
                      Uij=1.42e10*Epsi_ij
         	   else
                      r2i=sig_ij**2./r2
                      Uij = 4.*Epsi_ij*( R2i**6 - R2i**3 ) !+ Epsi_ij
         	   endif

 		   Eatm = Eatm + Uij

 		ENDIF  

c ********* a por el siguiente atomo de esta caja

		   jatm = next(jatm)

	      end do 
	     

c ******** a por la siguiente caja

	   end do



	        winter=exp(-beta*Eatm)

	return 
	end
c......................................................................
      FUNCTION erfcc(x)
       real*8 erfcc,x
       real*8 t,z
       z=abs(x)
       t=1./(1.+0.5*z)
       erfcc=t*exp(-z*z-1.26551223+t*(1.00002368+t*(.37409196+t*
     * (.09678418+t*(-.18628806+t*(.27886807+t*(-1.13520398+t*
     * (1.48851587+t*(-.82215223+t*.17087277)))))))))
       if (x.lt.0.) erfcc=2.-erfcc
       return
      END
                               

***************************
      subroutine ufourier(hcalculo,ufcalculo)
      include 'parametros_NpT.inc'
	include 'common.inc'
c bloque mio
      real*8    cssum, snsum, csdel, sndel
      real*8    pewfou, pewslf, rkvec 
      integer ktx,    kty,    ktz,    maxvec
      real*8 oxt, oyt, ozt, x1int, y1int, z1int, pewnew
      integer tp
      integer i, j, k
c
c Matriz h para la que se desea hacer el calculo
      dimension hcalculo(3,3)
c
c ******** ATENCION CREO QUE ES IMPORTANTE 
C ******** QUE LOS ATOMOS ESTEN DENTRO DE LA CAJA
C ******** ANTES DE LLAMAR A CEWFOR
c
c Variables necesitadas en esta subrutina 
c     xa,ya,za,cargatom,h,natoms,alfa
c
      nsit=natoms
                     !facur1=1.
      ewalpha=alfa 
c
c
c Comienza el calculo de los lados de la caja
c Este bloque lo necesito hasta en que 
c ewstup haga las cosas como dios manda y suprima
c boxx, boxy y boxz por 
c |b1|   |b2|   |b3|  donde |b1| es el modulo 
c del vector |b1| del espacio reciproco
c
c
      sidea = 0.
      sideb = 0.
      sidec = 0.

      do i=1,3
      sidea=sidea+hcalculo(i,1)**2
      sideb=sideb+hcalculo(i,2)**2
      sidec=sidec+hcalculo(i,3)**2
      end do 

      sidea = sqrt(sidea)
      sideb = sqrt(sideb)
      sidec = sqrt(sidec)
c
      boxx=sidea
      boxy=sideb
      boxz=sidec
c
c
c Calculando los vectores de la red reciproca
c ktx(i),kty(i),ktz(i)),i=1,maxvec)
c necesarios. El numero de vectores utilizados 
c sera maxvec 
c Esta subrutina necesita, boxx,boxy,boxz
c y ewalpha y devuelve ktx(i), kty(i),ktz(i)
c
      call ewstup(hcalculo)
c
c       write(6,*) 'maxvec=',maxvec
c
c Transfiriendo las coordenadas a las variables
c del programa de ewald
c
            do k=1,natoms
c
c Condiciones de contorno periodicas (los iones han
c de estar dentro de la caja)
c             
            xfour(k) =  xa(k) - anint( (xa(k)-half) ) 
            yfour(k) =  ya(k) - anint( (ya(k)-half) ) 
            zfour(k) =  za(k) - anint( (za(k)-half) ) 
c
            end do
c
c Calculando la energia total en espacio reciproco
c Ademas inicializa las importantes variables
c cssum(k) y sinsum(k)
c 
c       
      call cewfor
c
c El output es pewfou 
c
      ufcalculo=pewfou
c
      return
      end
c *****************************************
c ewstup : Set up Ewald summation                                 
      subroutine ewstup(hcalculo)
c      implicit none
	include 'parametros_NpT.inc'
	include 'common.inc'
c
c bloque mio
      real*8    cssum, snsum, csdel, sndel
      real*8    pewfou, pewslf, rkvec 
      integer ktx,    kty,    ktz,    maxvec
         real*8    b, rkx, rky, rkz, rksq
         integer is, ik
         integer nmin, mmin
         integer kx, ky, kz, ksq
       dimension hcalculo(3,3)
c
c ! Setup the wave-vectors for the ewald sum
c ! The length to reduce alpha parameter is that of 
c ! x axe = 1 (box units).     

c **** Atencion ***********
c A su debido tiempo calcularemos los vectores 
c de la red reciproca a partir de la matriz hcalculo
c en lugar de esos boxx, boxy que aparecen por ahi
c 1./boxx = se reemplazara por |b1| modulo del vector
c b1 de la red reciproca
c

         b = -4.0 * ewalpha * ewalpha

         ! Vector generation
         ik   = 0
         nmin = 1
         mmin = 0 

c Vectores del espacio real
      a1x=hcalculo(1,1)
      a1y=hcalculo(2,1)
      a1z=hcalculo(3,1)
c
      a2x=hcalculo(1,2)
      a2y=hcalculo(2,2)
      a2z=hcalculo(3,2)
c
      a3x=hcalculo(1,3)
      a3y=hcalculo(2,3)
      a3z=hcalculo(3,3)
c Volumen de la celdilla unidad
      bpcx=a2y*a3z-a3y*a2z
      bpcy=-(a2x*a3z-a3x*a2z)
      bpcz=a2x*a3y-a3x*a2y      
      vc=a1x*bpcx+a1y*bpcy+a1z*bpcz
c      write(6,*) ' vc=',vc
c
c Hallando los vectores b1,b2,b3 del espacio
c reciproco y su modulo
      pi=acos(-1.000000000)
      b1x=2.*pi*(a2y*a3z-a3y*a2z)/vc
      b1y=-2.*pi*(a2x*a3z-a3x*a2z)/vc
      b1z=2.*pi*(a2x*a3y-a3x*a2y)/vc 
      b1mod=sqrt(b1x**2+b1y**2+b1z**2)     
c
      b2x=2.*pi*(a3y*a1z-a1y*a3z)/vc
      b2y=-2.*pi*(a3x*a1z-a1x*a3z)/vc
      b2z=2.*pi*(a3x*a1y-a1x*a3y)/vc
      b2mod=sqrt(b2x**2+b2y**2+b2z**2)     
c            
      b3x=2.*pi*(a1y*a2z-a2y*a1z)/vc
      b3y=-2.*pi*(a1x*a2z-a2x*a1z)/vc
      b3z=2.*pi*(a1x*a2y-a2x*a1y)/vc
      b3mod=sqrt(b3x**2+b3y**2+b3z**2)     
c Cambio 
            h11=b1x
            h21=b1y
            h31=b1z
            h12=b2x
            h22=b2y
            h32=b2z
            h13=b3x
            h23=b3y
            h33=b3z
c
c      write(6,*) 'b1mod b2mod b3mod',b1mod,b2mod,b3mod
c
         do kx = 0, lmx 

c            rkx = 6.283185308 * kx / boxx
c            rkx =  kx * b1mod 
            do ky = mmin, mmx 

c               rky = 6.283185308 * ky / boxy

c               rky =  ky *b2mod 
               do kz = nmin, nmx 

c                  rkz = 6.283185308 * kz / boxz
c Este modo de calcular rx,rky,rkz estaba mal para cajas no ortogonales
c                 rkz =  kz *b3mod 
c Cambio .Este es el modo correcto.
            rkx=h11*kx+h12*ky+h13*kz
            rky=h21*kx+h22*ky+h23*kz
            rkz=h31*kx+h32*ky+h33*kz
            rksq=rkx*rkx+rky*rky+rkz*rkz
            auxi=6.283185308 * exp(rksq/b)/rksq/vc
                  ksq = kx * kx + ky * ky + kz * kz
c criterio nuevo
                  if((auxi.gt.tolfour) .and. (ksq .ne. 0)) then
c criterio antiguo
c                  if((ksq.le.27 ) .and. (ksq .ne. 0)) then
c fin Cambio 
                     ik = ik + 1
                     if(ik.gt.mxvct) then
                       write(3,*) "stop mxvct too small"
                     stop
                     endif
c                     rksq = rkx * rkx + rky * rky + rkz * rkz
c       rkvec(ik) = 6.283185308 * exp(rksq/b)/rksq/boxx/boxy/boxz

       rkvec(ik) = 6.283185308 * exp(rksq/b)/rksq/vc
                     ktx(ik) = kx
                     kty(ik) = ky
                     ktz(ik) = kz
                  endif
               enddo
               nmin = -nmx 
            enddo
            mmin = -mmx 
         enddo
         maxvec = ik
c Cambio  
        if (maxvec.gt.maxvecrun) then
        maxvecrun=maxvec
c        write(6,*) 'maxvecrun=',maxvecrun
        endif 
c
      return 
      end 
! +--------------------------------------------------------------------+
! |                                                                    |
! | CEWFOR                                                             |
! |                                                                    |
! | Computes Fourier contribution to Ewald summation                   |
! |                                                                    |
! +--------------------------------------------------------------------+
      subroutine cewfor
c      implicit none


	include 'parametros_NpT.inc'
	include 'common.inc'
c
      real*8    cssum, snsum, csdel, sndel
      real*8    pewfou, pewslf, rkvec 
      integer ktx,    kty,    ktz,    maxvec
         real*8    cx, cy, cz         ! cosine tables
         real*8    sx, sy, sz         ! sine tables
         real*8    costab, sintab
         real*8    comfor
         real*8    rkveck
         integer    ktxk, ktyk, ktzk
         real*8    rkx, rky, rkz
         real*8    cossum, sinsum
         real*8    zi
         real*8    ctec1, ctec2
         integer i, l, m, n, k

         dimension cx(natmax, 0:lmx),
     &      cy(natmax,-mmx:mmx),
     &      cz(natmax,-nmx:nmx) 
         dimension sx(natmax, 0:lmx),
     &      sy(natmax,-mmx:mmx),
     &      sz(natmax,-nmx:nmx) 
         dimension costab(natmax), sintab(natmax)   
c
c ******** ATENCION CREO QUE ES IMPORTANTE 
C ******** QUE LOS ATOMOS ESTEN DENTRO DE LA CAJA
C ******** ANTES DE LLAMAR A CEWFOR
C

         ! Initial set up cosine and sine functions                  

         do i = 1, natoms
            cx(i,0) = 1.0
            cy(i,0) = 1.0
            cz(i,0) = 1.0
            sx(i,0) = 0.0
            sy(i,0) = 0.0
            sz(i,0) = 0.0
c
c Aqui en las siguientes 6 lineas el programa de
c Bresme dividia por boxx, boxy, boxz pero puesto
c que yo ya doy las coordenadas en unidades de caja
c esto no es necesario
c
            cx(i,1) = cos (6.283185308 * xfour(i) )
            cy(i,1) = cos (6.283185308 * yfour(i) )
            cz(i,1) = cos (6.283185308 * zfour(i) )
            sx(i,1) = sin (6.283185308 * xfour(i) )
            sy(i,1) = sin (6.283185308 * yfour(i) )
            sz(i,1) = sin (6.283185308 * zfour(i) )
         enddo

        do l = 2, lmx
          do i = 1, natoms
        cx(i, l) = cx(i, l - 1)*cx(i, 1) - sx(i, l - 1) * sx(i, 1)
        sx(i, l) = cx(i, l - 1)*sx(i, 1) + sx(i, l - 1) * cx(i, 1)
            enddo
         enddo

         do m = 2, mmx
          do i = 1, natoms
          cy(i, m) = cy(i, m - 1)*cy(i, 1) - sy(i, m - 1) * sy(i, 1)
          sy(i, m) = cy(i, m - 1)*sy(i, 1) + sy(i, m - 1) * cy(i, 1)
          enddo
         enddo

        do n = 2, nmx
          do i = 1, natoms
          cz(i, n) = cz(i, n - 1)*cz(i, 1) - sz(i, n - 1) * sz(i, 1)
          sz(i, n) = cz(i, n - 1)*sz(i, 1) + sz(i, n - 1) * cz(i, 1)
          enddo
         enddo

          do m = -mmx, -1
             do i = 1, natoms
                cy(i, m) =  cy(i, -m)
                sy(i, m) = -sy(i, -m)
             enddo
          enddo

          do n = -nmx, -1
             do i = 1, natoms
                cz(i, n) =  cz(i, -n)
                sz(i, n) = -sz(i, -n)
             enddo
          enddo

          ! End set up. Computation starts

          pewfou = 0.0

          ! Loop over reciprocal vectors

          do k = 1, maxvec
             rkveck = rkvec(k)

             ktxk   = ktx (k)
             ktyk   = kty (k)
             ktzk   = ktz (k)

c             rkx    = 6.283185308 * ktxk / boxx
c             rky    = 6.283185308 * ktyk / boxy
c             rkz    = 6.283185308 * ktzk / boxz

             rkx    =  ktxk *b1mod 
             rky    =  ktyk *b2mod 
             rkz    =  ktzk *b3mod 
c
             cossum = 0.0
             sinsum = 0.0

             do i = 1, natoms
                 zi=cargatom(i)

                ! Computes cos and sin functions                           
         ctec1=cx(i,ktxk) * cy(i,ktyk) - sx(i,ktxk) * sy(i,ktyk)
         ctec2=cx(i,ktxk) * sy(i,ktyk) + sx(i,ktxk) * cy(i,ktyk)

         costab(i) = ctec1 * cz(i, ktzk) - ctec2 * sz(i, ktzk)
         sintab(i) = ctec1 * sz(i, ktzk) + ctec2 * cz(i, ktzk)

                cossum = cossum + zi * costab (i)
                sinsum = sinsum + zi * sintab (i)

             enddo

             ! For each k vector store the cosine and sine sums
                cssum(k) = cossum
                snsum(k) = sinsum


             ! Computes potential
         pewfou =pewfou + rkveck*(cossum*cossum+sinsum*sinsum)

          enddo

          ! Considers other constants
          pewfou = 2.0 * pewfou        !* facur1

      
       return 
       end 
! +--------------------------------------------------------------------+
! |                                                                    |
! | CEWMC                                                              |
! |                                                                    |
! | Computes Change in Energy due to movement of a particle            |
! |                                                                    |
! +--------------------------------------------------------------------+
      subroutine cewmc(tp, oxt, oyt, ozt, x1int, y1int, z1int,ufnew)
c      implicit none

	include 'parametros_NpT.inc'
	include 'common.inc'
c
      real*8    cssum, snsum, csdel, sndel
      real*8    pewfou, pewslf, rkvec 
      integer ktx,    kty,    ktz,    maxvec
c
         real*8    cxo, cyo, czo          ! cosine tables
         real*8    sxo, syo, szo          ! sine tables
         real*8    cxn, cyn, czn          ! cosine tables
         real*8    sxn, syn, szn          ! sine tables
         real*8    costpo, sintpo
         real*8    costpn, sintpn
         real*8    comfor
         real*8    rkveck
         integer    ktxk, ktyk, ktzk
         real*8    rkx, rky, rkz
         real*8    cossum, sinsum
         real*8    ztp
         real*8    ctec1, ctec2
         real*8    oxt, oyt, ozt       ! Old coordinates
         real*8    x1int, y1int, z1int ! New coordinates
         real*8    pewnew
         integer i, l, m, n, k, tp

         dimension cxo(0:lmx), cyo(-mmx:mmx), czo(-nmx:nmx) 
         dimension cxn(0:lmx), cyn(-mmx:mmx), czn(-nmx:nmx) 
         dimension sxo(0:lmx), syo(-mmx:mmx), szo(-nmx:nmx) 
         dimension sxn(0:lmx), syn(-mmx:mmx), szn(-nmx:nmx) 

         ! Initial set up cosine and sine functions                  
c
c Metamos los atomos de excursion, dentro de la caja
c
            oxt =  oxt  - anint( (oxt-half) ) 
            oyt =  oyt  - anint( (oyt-half) ) 
            ozt  = ozt  - anint( (ozt-half) ) 
c

            x1int =  x1int  - anint( (x1int-half) ) 
            y1int =  y1int  - anint( (y1int-half) ) 
            z1int =  z1int  - anint( (z1int-half) ) 
c

         ! Old coordinates
            cxo(0) = 1.0
            cyo(0) = 1.0
            czo(0) = 1.0
            sxo(0) = 0.0
            syo(0) = 0.0
            szo(0) = 0.0
c
c Aqui Bresme dividia en las siguientes 
c lineas oxt... por boxx,boxy ,boxz pero como
c yo trabajo en unidades de caja esto no es necesario
c
            cxo(1) = cos (6.283185308 * oxt )
            cyo(1) = cos (6.283185308 * oyt )
            czo(1) = cos (6.283185308 * ozt )
            sxo(1) = sin (6.283185308 * oxt )
            syo(1) = sin (6.283185308 * oyt )
            szo(1) = sin (6.283185308 * ozt )

         ! New coordinates
            cxn(0) = 1.0
            cyn(0) = 1.0
            czn(0) = 1.0
            sxn(0) = 0.0
            syn(0) = 0.0
            szn(0) = 0.0
c
c
c Aqui Bresme dividia por boxx,boxy ,boxz pero como
c yo trabajo en unidades de caja esto no es necesario
c
            cxn(1) = cos (6.283185308 * x1int )
            cyn(1) = cos (6.283185308 * y1int )
            czn(1) = cos (6.283185308 * z1int )
            sxn(1) = sin (6.283185308 * x1int )
            syn(1) = sin (6.283185308 * y1int )
            szn(1) = sin (6.283185308 * z1int )

         do l = 2, lmx
               cxo(l) = cxo(l - 1) * cxo(1) - sxo(l - 1) * sxo(1)
               sxo(l) = cxo(l - 1) * sxo(1) + sxo(l - 1) * cxo(1)

               cxn(l) = cxn(l - 1) * cxn(1) - sxn(l - 1) * sxn(1)
               sxn(l) = cxn(l - 1) * sxn(1) + sxn(l - 1) * cxn(1)
         enddo

         do m = 2, mmx
               cyo(m) = cyo(m - 1) * cyo(1) - syo(m - 1) * syo(1)
               syo(m) = cyo(m - 1) * syo(1) + syo(m - 1) * cyo(1)

               cyn(m) = cyn(m - 1) * cyn(1) - syn(m - 1) * syn(1)
               syn(m) = cyn(m - 1) * syn(1) + syn(m - 1) * cyn(1)
         enddo

         do n = 2, nmx
               czo(n) = czo(n - 1) * czo(1) - szo(n - 1) * szo(1)
               szo(n) = czo(n - 1) * szo(1) + szo(n - 1) * czo(1)

               czn(n) = czn(n - 1) * czn(1) - szn(n - 1) * szn(1)
               szn(n) = czn(n - 1) * szn(1) + szn(n - 1) * czn(1)
         enddo

          do m = -mmx, -1
                cyo(m) =  cyo(-m)
                syo(m) = -syo(-m)

                cyn(m) =  cyn(-m)
                syn(m) = -syn(-m)
          enddo

          do n = -nmx, -1
                czo(n) =  czo(-n)
                szo(n) = -szo(-n)

                czn(n) =  czn(-n)
                szn(n) = -szn(-n)
          enddo

          ! End set up. Computation starts

          pewnew = 0.0
c
           ztp=cargatom(tp) 

          ! Loop over reciprocal vectors

          do k = 1, maxvec
             rkveck = rkvec(k)

             ktxk   = ktx (k)
             ktyk   = kty (k)
             ktzk   = ktz (k)

c             rkx    = 6.283185308 * ktxk / boxx
c             rky    = 6.283185308 * ktyk / boxy
c             rkz    = 6.283185308 * ktzk / boxz

             rkx    =  ktxk *b1mod 
             rky    =  ktyk *b2mod 
             rkz    =  ktzk *b3mod 

             ! Computes cos and sin functions                           
             ! Old coordinates
             ctec1 = cxo(ktxk) * cyo(ktyk) - sxo(ktxk) * syo(ktyk)
             ctec2 = cxo(ktxk) * syo(ktyk) + sxo(ktxk) * cyo(ktyk)

             costpo = ctec1 * czo(ktzk) - ctec2 * szo(ktzk)
             sintpo = ctec1 * szo(ktzk) + ctec2 * czo(ktzk)

             ! New coordinates
             ctec1 = cxn(ktxk) * cyn(ktyk) - sxn(ktxk) * syn(ktyk)
             ctec2 = cxn(ktxk) * syn(ktyk) + sxn(ktxk) * cyn(ktyk)

             costpn = ctec1 * czn(ktzk) - ctec2 * szn(ktzk)
             sintpn = ctec1 * szn(ktzk) + ctec2 * czn(ktzk)

             ! New cosine and sine sums
             csdel(k) = ztp * (costpn - costpo)
             sndel(k) = ztp * (sintpn - sintpo)

             cossum = cssum(k) + csdel(k)
             sinsum = snsum(k) + sndel(k)

	      cssum(k)=cossum
	      snsum(k)=sinsum

             ! Computes potential
          pewnew=pewnew+rkveck*(cossum * cossum + sinsum *sinsum)

          enddo

          ! Considers other constants
          pewnew = 2.0 * pewnew     !* facur1
          ufnew=pewnew
      return 
      end

cccccccccccccccccccccccc
c Sets up the einstein cristal. 

      SUBROUTINE ALBERT
      include 'parametros_NpT.inc'
	include 'common.inc'
      DIMENSION CTIT(4),PHIIT(4)
	     
      DO im=1,nmoltot

           jc=class(im)
           molref =puntero1(jc)+ (im-1-puntero2(jc))*nsites(jc)
           nsrefO = molref + 1
	     nsrefH1= molref + 2
	     nsrefH2= molref + 3
 
c Asignando coordenadas de referencia a cada molecula
c ----------------------------------------------------- 

           xatomico=xa(nsrefO)
           yatomico=ya(nsrefO)
           zatomico=za(nsrefO)
 
           ox=h(1,1)*xatomico+h(1,2)*yatomico+h(1,3)*zatomico
           oy=h(2,1)*xatomico+h(2,2)*yatomico+h(2,3)*zatomico
           oz=h(3,1)*xatomico+h(3,2)*yatomico+h(3,3)*zatomico
 
           xc1=ox               
           yc1=oy                
           zc1=oz                  

c Current reference coordinates of the molecule im

           xcentro(im)=hinv(1,1)*xc1+hinv(1,2)*yc1+hinv(1,3)*zc1
           ycentro(im)=hinv(2,1)*xc1+hinv(2,2)*yc1+hinv(2,3)*zc1
           zcentro(im)=hinv(3,1)*xc1+hinv(3,2)*yc1+hinv(3,3)*zc1

c Lattice reference coordinates of the molecule im

           REDX(im)=xcentro(im) 
           REDY(im)=ycentro(im) 
           REDZ(im)=zcentro(im) 

c Asignando orientaciones de referencia
c -------------------------------------- 
	if(nsites(jc).ne.1)then

           xatomico1=xa(nsrefH1)
           yatomico1=ya(nsrefH1)
           zatomico1=za(nsrefH1)

           xatomico2=xa(nsrefH2)
           yatomico2=ya(nsrefH2)
           zatomico2=za(nsrefH2)

           txp1=h(1,1)*xatomico1+h(1,2)*yatomico1+h(1,3)*zatomico1-ox
           typ1=h(2,1)*xatomico1+h(2,2)*yatomico1+h(2,3)*zatomico1-oy
           tzp1=h(3,1)*xatomico1+h(3,2)*yatomico1+h(3,3)*zatomico1-oz
	     
           txp2=h(1,1)*xatomico2+h(1,2)*yatomico2+h(1,3)*zatomico2-ox
           typ2=h(2,1)*xatomico2+h(2,2)*yatomico2+h(2,3)*zatomico2-oy
           tzp2=h(3,1)*xatomico2+h(3,2)*yatomico2+h(3,3)*zatomico2-oz
	     
           vxr=txp2-txp1
           vyr=typ2-typ1
           vzr=tzp2-tzp1
	     
           vxs=txp2+txp1
           vys=typ2+typ1
           vzs=tzp2+tzp1
	     
           vmodr=sqrt(vxr**2.+vyr**2.+vzr**2.)
	     
           vmods=sqrt(vxs**2.+vys**2.+vzs**2.)

           vxnorr=vxr/vmodr
           vynorr=vyr/vmodr
           vznorr=vzr/vmodr
c
           vxnors=vxs/vmods
           vynors=vys/vmods
           vznors=vzs/vmods

c Lattice orientation vectors

           VRHX_0(im)=vxnorr 
           VRHY_0(im)=vynorr
           VRHZ_0(im)=vznorr
	     
           VSHX_0(im)=vxnors 
           VSHY_0(im)=vynors
           VSHZ_0(im)=vznors

c Current orientation vectors	     

	     vrhx(im)=vrhx_0(im)
	     vrhy(im)=vrhy_0(im)
	     vrhz(im)=vrhz_0(im)

c
	     vshx(im)=vshx_0(im)
	     vshy(im)=vshy_0(im)
	     vshz(im)=vshz_0(im)
	endif
c
      ENDDO 
c
      RETURN
      END 


C **************************************************************
C SUBROUTINE TO EVALUATE THE INITIAL ENERGY OF THE CRISTAL 
C DUE TO THE SPRINGS 
      SUBROUTINE INULAT
      include 'parametros_NpT.inc'
	include 'common.inc'
      DIMENSION CTIT(4),PHIIT(4)
	     
C EVALUATING EINSTEIN CRISTAL ENERGY 
      ueinsold=0.000
c
	do ii=1,nmoltot
	 ulatrr(ii)=0.
	 ulatrs(ii)=0.
	enddo

      DO 10 im=1,nmoltot

	ic=class(im)

c Energía debida al desplazamiento respecto a las posiciones de
c referencia en el cristal de partida.
c --------------------------------------------------------------
      XMOL=xcentro(im)
      YMOL=ycentro(im)
      ZMOL=zcentro(im)
C
      XDIS=XMOL-REDX(im)
      YDIS=YMOL-REDY(im)
      ZDIS=ZMOL-REDZ(im)
C 
      XX=XDIS-dxcm  
      YY=YDIS-dycm
      ZZ=ZDIS-dzcm
C
      XXX=h(1,1)*XX+h(1,2)*YY+h(1,3)*ZZ
      YYY=h(2,1)*XX+h(2,2)*YY+h(2,3)*ZZ
      ZZZ=h(3,1)*XX+h(3,2)*YY+h(3,3)*ZZ

      UHART=XLAN1*(XXX*XXX+YYY*YYY+ZZZ*ZZZ)
      ULATT(im)=UHART

c Energía debida al cambio de orientación respecto a la que se
c tenía en el cristal de partida:
c -------------------------------------------------------------
	IF(nsites(ic).ne.1)THEN

      per=vrhx(im)*vrhx_0(im)+vrhy(im)*vrhy_0(im)+vrhz(im)*vrhz_0(im)
      pes=vshx(im)*vshx_0(im)+vshy(im)*vshy_0(im)+vshz(im)*vshz_0(im)

	if(pes.gt.1.)then
c	print*,'cuidadin',pes,im
		pes=1.
      endif

      ulatrr(im)=XLAN2*(1.-per**2.)
      ulatrs(im)=XLAN2*(acos(pes)/pi)**2.
!	ulatrs(im)=0.
      	

	ENDIF

      ueinsold=ueinsold+ulatt(im)+ulatrr(im)+ulatrs(im)

 10   CONTINUE

 	print*,ueinsold,'ueinsold'
      RETURN 
      END 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	subroutine widomsetup
	include 'parametros_NpT.inc'
	include 'common.inc'
	
	open(56,file='widom.inp',status='unknown')

!Inicializamos los sumatorios sobre el número de inserciones
!sobre la exponencial de la energía de insercion de partícula
!y sobre el cuadrado de las cargas de las partícula test
	insertions=0
	sumebdut=0.
	sumq2test=0.

!LECTURA DEL FICHERO DE INPUT PARA EL WIDOM TEST:
!Leemos el numero de veces que queremos insertar por cada configuracion
	read(56,*) insperconf
	read(56,*)

!Leemos el sigma de cada átomo (Ahora es 
!el identificador de los parametros LJ de cada atomo). 
	do i=1,nattest
	 read(56,*)sigmatest(i)
	enddo
	
	read(56,*)
!Leemos la carga de cada átomo
	do i=1,nattest
	 read(56,*)cargatest(i)
	enddo
      do i=1,nattest
       cargatest(i)=cargatest(i)*408.778672043
      enddo

	read(56,*)

!Leemos unas coordenadas cartesianas de referencia de la molécula
!(Poner el átomo sobre el que se quiere rotar en 0,0,0)
	do i=1,nattest
	 read(56,*)xtest0(i)
	 read(56,*)ytest0(i)
	 read(56,*)ztest0(i)
	 read(56,*)
	enddo

	read(56,*)coredurotest
	
      close(56)



!Sumatorio del cuadrado de las cargas
	do i=1,nattest
	 sumq2test=sumq2test+cargatest(i)**2.
	enddo

	if(sumq2test.gt.0.0000001)then
	iewaldtest=1
	else
	iewaldtest=0
	endif

!Se establecen vectores de referencia respecto al site 1 	
	do i=1,nattest
	   xvref0(i)=xtest0(i)-xtest0(1)
	   yvref0(i)=ytest0(i)-ytest0(1)
	   zvref0(i)=ztest0(i)-ztest0(1)
	enddo

!Se calclulan las contribuciones a la energía constantes
	call widomulong
	call widomintramol
	call widomself

	return
	end
	
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	subroutine widom(seed)
	include 'parametros_NpT.inc'
	include 'common.inc'
	dimension xatest(nattest),yatest(nattest),zatest(nattest)

	eperconf=0.
	sumebdutconf=0.
	insexitoconf=0

	open(34,file='analizowidom.dat')

	Do i=1,insperconf

	 call widomgenerapos(seed,xatest,yatest,zatest)
	 call widomenerg(xatest,yatest,zatest,deltaetest)

	 eperconf=eperconf+deltaetest 	
	 sumebdutconf=sumebdutconf+exp(-beta*(deltaetest))

	 sumebdut=sumebdut+exp(-beta*(deltaetest))

	 insertions=insertions+1

	 if(exp(-beta*(deltaetest)).gt.0.)then
	    insexito=insexito+1 
	    insexitoconf=insexitoconf+1
	 endif	    

c	 if(((ntot.ge.5).and.(ntot.le.15))
c     >  .and.(exp(-beta*(deltaetest)).gt.0.))then
c	 write(34,*)i,ntot,deltaetest,exp(-beta*(deltaetest))
c	 endif

	Enddo

	eperconfav=eperconf/float(insperconf)
	sumebdutconfav=sumebdutconf/float(insperconf)
	
	return
	end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
	subroutine widomgenerapos(seed,xatest,yatest,zatest)
	include 'parametros_NpT.inc'
	include 'common.inc'
	dimension xvref(nattest),yvref(nattest),zvref(nattest)
	dimension xatest(nattest),yatest(nattest),zatest(nattest)
      dimension ai(3,3),xc(3)
!Rotación 
	if(nattest.gt.1)then

! Direcci�n aleatoria entorno a la que rotar  
       call rnd_sphere(xc,seed)
! �ngulo aleatorio que se rota
       gi=2*acos(-1.)*ranf(seed)
! Matriz de giro en funci�n de la direcci�n y el �ngulo de rotaci�n
       call magiro(xc,gi,ai)
	 
       do is=1,nattest
        tx=(ai(1,1)*xvref0(is)+ai(1,2)*yvref0(is)+ai(1,3)*zvref0(is))
        ty=(ai(2,1)*xvref0(is)+ai(2,2)*yvref0(is)+ai(2,3)*zvref0(is))
        tz=(ai(3,1)*xvref0(is)+ai(3,2)*yvref0(is)+ai(3,3)*zvref0(is))

        xvref(is)=tx
        yvref(is)=ty
        zvref(is)=tz
       end do

	 do i=1,nattest
	  xt=xvref(i)+xtest0(1)
	  yt=yvref(i)+ytest0(1)
	  zt=zvref(i)+ztest0(1)
	  call cart_caja(xt,yt,zt,xatest(i),yatest(i),zatest(i))
	 enddo
	 
	elseif(nattest.eq.1)then
	  call cart_caja(xtest0(1),ytest0(1),ztest0(1),x,y,z)
	  xatest(1)=x
	  yatest(1)=y
	  zatest(1)=z
	endif

! Traslación

	dx=ranf(seed)
	dy=ranf(seed)
	dz=ranf(seed)

	do i=1,nattest
	 xatest(i)=xatest(i)+dx
	 yatest(i)=yatest(i)+dy
	 zatest(i)=zatest(i)+dz 
	enddo
	
	return
	end

	
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c Calculo de la correccion de largo alcance a la energía LJ
c debido a la inserción de la particula test. 
c
	subroutine widomulong
	include 'parametros_NpT.inc'
	include 'common.inc'
	
       rcut=sqrt(rcut2)
       ulrtottest=0.
	 

        do il=1,ntipmol
          do ii=1,nattest      
          do ij=1,nsites(il)

	  sigma1=sigmatest(ii)
	  sigma2=sigma(nordcar(il,ij))

          intid=min(int(sigma1),int(sigma2))*10+
     >          max(int(sigma1),int(sigma2))


	if(parpot(intid,7).lt.0.1)then !Non Yukawa case
          ulr=2.*PI*(
     > -parpot(intid,3)/
     > (parpot(intid,5)-3.)/rcut**(parpot(intid,5)-3.)
     > -parpot(intid,4)/
     > (parpot(intid,6)-3.)/rcut**(parpot(intid,6)-3.) 
     > +parpot(intid,1)*parpot(intid,2)*(
     > exp(-rcut/parpot(intid,2))*
     > (rcut**2+2.*rcut*parpot(intid,2)+2.*parpot(intid,2)**2)))
	endif

	if(parpot(intid,7).gt.0.9)then !Yukawa case
        ulr=2.*PI*(exp(-rcut/parpot(intid,2))*parpot(intid,2)
     >  *parpot(intid,1)*(rcut+parpot(intid,2)))
	endif

            xj=float(nmol(il))/float(nmoltot)

            ulrtottest=ulrtottest+xj*2.*ulr   
	
          end do
          end do
        end do
       !ulrtottest=ulrtottest*1000./rN_avo/rk_boltz

	     ulongtest=ulrtottest*(float(nmoltot)+1.)/vol    
	return
	end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c Se calcula la contribucion intramolecular a la energía
c de la test particle. 
      subroutine widomintramol

      include 'parametros_NpT.inc'
	include 'common.inc'

	energint=0.
      uion=0.
      u_lenjo=0.
	uljintra=0.

	Do j=1,nattest-1

	 sig_a=sigmatest(j)
	 eps_a=epsitest(j)
	
         DO i=j+1,nattest       
	
	    sig_b=sigmatest(i)
          sig_ij=0.5*(sig_a+sig_b)
	
	    dxcart=xtest0(i)-xtest0(j)
	    dycart=ytest0(i)-ytest0(j)
	    dzcart=ztest0(i)-ztest0(j)

	    dxcaja=hinv(1,1)*dxcart+hinv(1,2)*dycart+hinv(1,3)*dzcart
	    dycaja=hinv(2,1)*dxcart+hinv(2,2)*dycart+hinv(2,3)*dzcart
	    dzcaja=hinv(3,1)*dxcart+hinv(3,2)*dycart+hinv(3,3)*dzcart	

	    dxmic=dxcaja-anint(dxcaja)
	    dymic=dycaja-anint(dycaja)
	    dzmic=dzcaja-anint(dzcaja)

	    xmicart=h(1,1)*dxmic+h(1,2)*dymic+h(1,3)*dzmic
	    ymicart=h(2,1)*dxmic+h(2,2)*dymic+h(2,3)*dzmic
	    zmicart=h(3,1)*dxmic+h(3,2)*dymic+h(3,3)*dzmic

          r2=xmicart**2+ymicart**2+zmicart**2
             
             IF (r2.lt.rcut2) THEN 
c *** Interacción culómbica (contribución espacio real)
               if(iewaldtest.eq.1)then
                 qiqj=cargatest(i)*cargatest(j)
                 rijsq=sqrt(r2)
                 uion=qiqj*erfcc(alfa*rijsq)/rijsq-qiqj/rijsq
               endif                           
c *** Interacción Lennard-Jones
               if(abs(j-i).ne.1)then   !evita el calculo de interacc.
                                         !entre sites contiguos
                 if(sig_ij.lt.0.0000001)then 
                   u_lenjo=0.
                 else
                     r2sig=r2/sig_ij**2
                     Epsi_ij=(eps_a*epsitest(i))**(1./2.)
  
                     if (r2sig.le.0.16) then   
                       u_lenjo=1.42e10*Epsi_ij
                     else
                       r2i=1./r2sig
                       u_lenjo = 4.*Epsi_ij*( R2i**6 - R2i**3 ) 
                     endif    
                 endif
                  
               elseif(abs(j-i).eq.1)then
                  u_lenjo=0.      
               endif                   
c *** Si no se calculan                 
             ELSE
                 uion=0.       
                 u_lenjo=0.
             ENDIF   
c             write(6,*) u_lenjo,uion 
              u_ij=u_lenjo+uion
	        uljintra=uljintra+u_lenjo
              energint=energint+u_ij

           ENDDO
	    ENDDO 

	    uintratest=energint


      return                        
	end 

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c Se calcula el self term de la particula test
	subroutine widomself
	include 'parametros_NpT.inc'
	include 'common.inc'

	selftest=0.

	if(iewaldtest.eq.1)then
	 pi=acos(-1.)
	 selftest=-alfa/sqrt(pi)*sumq2test
	endif
	

	return
	end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c Se calcula el cambio de energía del sistema al introducir la
c partícula test. 
	subroutine widomenerg(xatest,yatest,zatest,etest)
      include 'parametros_NpT.inc'
	include 'common.inc'
	dimension xatest(nattest),yatest(nattest),zatest(nattest)
	
	call widomenergreal(xatest,yatest,zatest,etestreal,iax,u_lnn)

	uftest=0.
	if(iewaldtest.eq.1)then
	call widomenergfour(xatest,yatest,zatest,uftesttot)
	uftest=uftesttot-ufold
	endif

! Cambio de energía en el sistema al introducir la test particle:
! Todas las contribuciones se calculan con la enrgía de interacción 
! de la particula test exclusivamente, salvo la contribucion
! de espacio de fourier a la energia ionica que se calcula como la
! diferencia de la energías de fourier totales despues y antes de 
! insertar la particula test.
! Los terminos selftest, uintratest y ulongtest son constantes 
! por lo que solo se calculan al principio en widomsetup.

	etest=etestreal+uftest+selftest+uintratest+ulongtest
	
	return
	end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c Se calcula la interacción de la test particle con todas las 
c partículas del sistema

	subroutine widomenergreal(xt,yt,zt,Emol,iax,u_lnn)
      include 'parametros_NpT.inc'
	include 'common.inc'


	integer head,next,previous
      dimension xt(nattest),yt(nattest),zt(nattest)

	Emol = 0.

	iax = 0
	u_lnn= 0.

c *** bucle sobre todos los sites de la molecula imol
        do isite = 1,nattest   

	   Eatm = 0.

	   xi = xt(isite) - anint( (xt(isite)-half) )
	   yi = yt(isite) - anint( (yt(isite)-half) )
	   zi = zt(isite) - anint( (zt(isite)-half) )


c ****** calculando en que celda esta el site i

         i = int(xi/xlcell) + 1
         j = int(yi/ylcell) + 1
         k = int(zi/zlcell) + 1

	   icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

	   xi = xt(isite)
	   yi = yt(isite)
	   zi = zt(isite)

c **** Bucle sobre las ntb celdas de la caja de celdas centrada en icell

	   do ncell = 1,ntb
             
	      jcell = neighbour_cell(ncell,icell)
	      jatm = head(jcell)

c ******** bucle sobre todos los atomos en el interior de la celda jcell
	      
             do while (jatm.ne.0)

	         sig_ij = 0.5*(sigmatest(isite)+sigatom(jatm))

c ********* distancias interatomicas en convencion mic

	       dx = xa(jatm) - xi
		 dy = ya(jatm) - yi
		 dz = za(jatm) - zi
ccj Julio change number 22
       tx=(dx - anint(dx))
       ty=(dy - anint(dy))
       tz=(dz - anint(dz))
ccj
       txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
       typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
       tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
ccj
       dxmic = txp
       dymic = typ
       dzmic = tzp

	         r2 = (dxmic**2 + dymic**2 + dzmic**2)

c                 ** bandera de solapamiento
c             if(r2.lt.sig_ij**2.)then  !duro 
c                  iax=1         !duro 
c                  return        !duro 
c             endif              !duro 


           IF (r2.lt.rcut2) THEN
c *** Interacción iónica (contribución espacio real)
                   if(iewaldtest.eq.1)then
                     qiqj=cargatest(isite)*cargatom(jatm)
                     rijsq=sqrt(r2)
                     uij=qiqj*erfcc(alfa*rijsq)/rijsq
                     eatm=eatm+uij
                   endif                                
c *** Interacción Lennard-Jones
!            if(sig_ij.lt.0.0000001)then
!                 uij=0.
!             else
!                 r2sig=r2/sig_ij**2
! 	         Epsi_ij=(epsitest(isite)*epsiatom(jatm))**(1./2.)
!               if ((r2sig.le.coreduro).and.(Epsi_ij.gt.0.0001)) then
!                   Uij=1.42e10*Epsi_ij
!		   	 Emol=uij
!	             return
!               else
!                   r2i=1./r2sig
!                   Uij = 4.*Epsi_ij*( R2i**6 - R2i**3 ) 
!               endif
!	         u_lnn=u_lnn+uij
!             endif
c___________________________________________________________________
              intid=min(int(sigmatest(isite)),int(sigatom(jatm)))*10+
     >              max(int(sigmatest(isite)),int(sigatom(jatm)))
           uij=0.
              rjust=sqrt(r2)

              uijex=parpot(intid,1)*exp(-rjust/parpot(intid,2))
     >              /(rjust**(parpot(intid,7)))
              uijlj=-parpot(intid,3)/rjust**parpot(intid,5)
     >              -parpot(intid,4)/rjust**parpot(intid,6)
              uij=uijex+uijlj
              !uij=uij/rN_avo*1000./rk_boltz
      
              if(rjust.lt.coredurotest)then 
	        Emol=1.42e10
	        return
	      endif


	      u_lnn=u_lnn+uij

c___________________________________________________________________


 	      Eatm = Eatm + Uij
           END IF

c ********* a por el siguiente atomo de esta caja

		   jatm = next(jatm)

	      end do

	   end do

	   Emol = Emol + Eatm

	end do

	
	return 
	end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      subroutine widomenergfour(xatest,yatest,zatest,pewfout)

	include 'parametros_NpT.inc'
	include 'common.inc'
c
      real*8    cssum, snsum, csdel, sndel
      real*8    pewfou, pewslf, rkvec 
      integer ktx,    kty,    ktz,    maxvec
         real*8    cx, cy, cz         ! cosine tables
         real*8    sx, sy, sz         ! sine tables
         real*8    costab, sintab
         real*8    comfor
         real*8    rkveck
         integer    ktxk, ktyk, ktzk
         real*8    rkx, rky, rkz
         real*8    cossum, sinsum
         real*8    zi
         real*8    ctec1, ctec2
         integer i, l, m, n, k

         dimension cx(natmax, 0:lmx),
     &      cy(natmax,-mmx:mmx),
     &      cz(natmax,-nmx:nmx) 
         dimension sx(natmax, 0:lmx),
     &      sy(natmax,-mmx:mmx),
     &      sz(natmax,-nmx:nmx) 
         dimension costab(natmax), sintab(natmax)   
	   
	   dimension xatest(nattest),yatest(nattest),zatest(nattest)
	   dimension xftest(nattest),yftest(nattest),zftest(nattest)
c
c ******** ATENCION CREO QUE ES IMPORTANTE 
C ******** QUE LOS ATOMOS ESTEN DENTRO DE LA CAJA
C ******** ANTES DE LLAMAR A CEWFOR
C
	do i=1,nattest
        xftest(i)=xatest(i)-anint(xatest(i)-half)
        yftest(i)=yatest(i)-anint(yatest(i)-half)
        zftest(i)=zatest(i)-anint(zatest(i)-half)
	enddo

         ! Initial set up cosine and sine functions                  

         do i = 1, nattest
            cx(i,0) = 1.0
            cy(i,0) = 1.0
            cz(i,0) = 1.0
            sx(i,0) = 0.0
            sy(i,0) = 0.0
            sz(i,0) = 0.0
c
c Aqui en las siguientes 6 lineas el programa de
c Bresme dividia por boxx, boxy, boxz pero puesto
c que yo ya doy las coordenadas en unidades de caja
c esto no es necesario
c
            cx(i,1) = cos (6.283185308 * xftest(i) )
            cy(i,1) = cos (6.283185308 * yftest(i) )
            cz(i,1) = cos (6.283185308 * zftest(i) )
            sx(i,1) = sin (6.283185308 * xftest(i) )
            sy(i,1) = sin (6.283185308 * yftest(i) )
            sz(i,1) = sin (6.283185308 * zftest(i) )
         enddo

        do l = 2, lmx
          do i = 1, nattest
        cx(i, l) = cx(i, l - 1)*cx(i, 1) - sx(i, l - 1) * sx(i, 1)
        sx(i, l) = cx(i, l - 1)*sx(i, 1) + sx(i, l - 1) * cx(i, 1)
            enddo
         enddo

         do m = 2, mmx
          do i = 1, nattest
          cy(i, m) = cy(i, m - 1)*cy(i, 1) - sy(i, m - 1) * sy(i, 1)
          sy(i, m) = cy(i, m - 1)*sy(i, 1) + sy(i, m - 1) * cy(i, 1)
          enddo
         enddo

        do n = 2, nmx
          do i = 1, nattest
          cz(i, n) = cz(i, n - 1)*cz(i, 1) - sz(i, n - 1) * sz(i, 1)
          sz(i, n) = cz(i, n - 1)*sz(i, 1) + sz(i, n - 1) * cz(i, 1)
          enddo
         enddo

          do m = -mmx, -1
             do i = 1, nattest
                cy(i, m) =  cy(i, -m)
                sy(i, m) = -sy(i, -m)
             enddo
          enddo

          do n = -nmx, -1
             do i = 1, nattest
                cz(i, n) =  cz(i, -n)
                sz(i, n) = -sz(i, -n)
             enddo
          enddo

          ! End set up. Computation starts

          pewfout = 0.0

          ! Loop over reciprocal vectors

          do k = 1, maxvec
             rkveck = rkvec(k)

             ktxk   = ktx (k)
             ktyk   = kty (k)
             ktzk   = ktz (k)

c             rkx    = 6.283185308 * ktxk / boxx
c             rky    = 6.283185308 * ktyk / boxy
c             rkz    = 6.283185308 * ktzk / boxz

             rkx    =  ktxk *b1mod 
             rky    =  ktyk *b2mod 
             rkz    =  ktzk *b3mod 
c
             cossumt = 0.0
             sinsumt = 0.0

             do i = 1, nattest
                 zi=cargatest(i)

                ! Computes cos and sin functions                           
         ctec1=cx(i,ktxk) * cy(i,ktyk) - sx(i,ktxk) * sy(i,ktyk)
         ctec2=cx(i,ktxk) * sy(i,ktyk) + sx(i,ktxk) * cy(i,ktyk)

         costab(i) = ctec1 * cz(i, ktzk) - ctec2 * sz(i, ktzk)
         sintab(i) = ctec1 * sz(i, ktzk) + ctec2 * cz(i, ktzk)

                cossumt = cossumt + zi * costab (i)
                sinsumt = sinsumt + zi * sintab (i)

             enddo

             ! For each k vector store the cosine and sine sums
                cossumt=cssum(k)+cossumt
                sinsumt=snsum(k)+sinsumt


             ! Computes potential
         pewfout =pewfout + rkveck*(cossumt*cossumt+sinsumt*sinsumt)

          enddo

          ! Considers other constants
          pewfout = 2.0 * pewfout        !* facur1

      
       return 
       end 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	  subroutine cart_caja(a,b,c,x,y,z)
	include 'parametros_NpT.inc'
	include 'common.inc'
	  x=a*hinv(1,1)+b*hinv(1,2)+c*hinv(1,3)
	  y=a*hinv(2,1)+b*hinv(2,2)+c*hinv(2,3)
	  z=a*hinv(3,1)+b*hinv(3,2)+c*hinv(3,3)
	  return
	  end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	  subroutine caja_cart(a,b,c,x,y,z)
	include 'parametros_NpT.inc'
	include 'common.inc'
	  x=a*h(1,1)+b*h(1,2)+c*h(1,3)
	  y=a*h(2,1)+b*h(2,2)+c*h(2,3)
	  z=a*h(3,1)+b*h(3,2)+c*h(3,3)
	  return
	  end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	

c**********************************************************************
c
cNUCLEATION
c
c***********************************************************************
	subroutine q6q4q3q2vec(q6,q4,q3,q2,listav,nvecinos)
c Esta subrutina evalua el vector de 6 componentes q6 para cada una de las particulas del 
c sistema. Halla tanto q6 real como q6 imaginario
c 
c Defino costantes de armonicos esfericos
	include 'parametros_NpT.inc'
 	include 'common.inc'
	
	dimension q6(0:1,0:6,nmmax),q4(0:1,0:4,nmmax)
        dimension q3(0:1,0:3,nmmax),q2(0:1,0:2,nmmax)
	dimension q6bar(0:1,0:6,nmmax),q4bar(0:1,0:4,nmmax)
	dimension q3bar(0:1,0:3,nmmax),q2bar(0:1,0:2,nmmax)
	dimension y6(0:1,0:6),y4(0:1,0:4)
	dimension y3(0:1,0:3),y2(0:1,0:2)
	dimension listav(natmax,50)
	dimension listav0(natmax,50)
	dimension nvecinos(natmax)
	dimension nvecinos0(natmax)
	integer head,next,previous

	pi=acos(-1.)


	!call veckoos(listav,nvecinos,listav0,nvecinos0)
	call vecnokoos(listav,nvecinos,listav0,nvecinos0)

!Si hay agua, la quitamos del medio. 
!(Se presupone que el agua esta numerada como 1)  
!Todo esto lo comento porque no sirve para Yukawa
	
	!if(ntipmolmax.eq.3)then
	!  do i=1,nmol(1)
        ! call take_outof_list(i,1)
	!  enddo
	!  naq=nmol(1)
	!  natperaq=nsites(1)
	!else
	  naq=0
	  natperaq=0 
	!endif
	  

c Constantes de armonicos esfericos l=6
	y60=1./32.*sqrt(13./pi)
	y61=1./16.*sqrt(273./(2.*pi))
	y62=1./64.*sqrt(1365./pi)
	y63=1./32.*sqrt(1365./pi)
	y64=3./32.*sqrt(91./(2.*pi))
	y65=3./32.*sqrt(1001./pi)
	y66=1./64.*sqrt(3003./pi)

c Constantes de armonicos esfericos l=4
	y40=3./16./sqrt(pi)
	y41=3./8.*sqrt(5./pi)
	y42=3./8.*sqrt(5./2./pi)
	y43=3./8.*sqrt(35./pi)
	y44=3./16*sqrt(35./2./pi)

c Constantes de armonicos esfericos l=3

        y30=0.37317633259d0
        y31=0.32318018411d0
        y32=1.0219854764d0
        y33=0.41722382363d0

c Constantes de armonicos esfericos l=2

        y20=0.31539156525d0
        y21=0.77254840406d0
        y22=y21/2.d0



c CALCULO PARA CADA ATOMO UN VECTOR Q6 Y Q4 Y Q3 Y Q2
	DO imol=naq+1,nmoltot    !Bucle sobre moleculas


cInicializacion de sumatorio de armonicos esfericos
	 do k=0,1
	  do m=0,6
	   q6(k,m,imol)=0.
	  enddo
       enddo

	 do k=0,1
	  do m=0,4
	   q4(k,m,imol)=0.
	  enddo
       enddo

	 do k=0,1
	  do m=0,3
	   q3(k,m,imol)=0.
	  enddo
       enddo

	 do k=0,1
	  do m=0,2
	   q2(k,m,imol)=0.
	  enddo
       enddo

ccccccccccccccccccc


	 nvecinoscl(imol)=nvecinos(imol)

	  do i=1,nvecinos(imol)

	listavcl(imol,i)=listav(imol,i)


	call distanciasites(listavcl(imol,i),imol,dxmic,dymic,dzmic,r2)


  	     rjust=sqrt(r2)

c angulos theta y phy del vector que une el par de atomos y funciones 
c de los angulos que luego se utilizaran
	     costh=dzmic/rjust

	     costh2=costh*costh
             costh3=costh2*costh
	     costh4=costh2*costh2
	     costh6=costh4*costh2
	    
	     sinth2=1.-costh2
	     sinth=sqrt(sinth2)
	     sinth3=sinth*sinth2
	     sinth4=sinth2*sinth2
	     sinth5=sinth2*sinth3
	     sinth6=sinth2*sinth4

	     if(sinth.eq.0.)then
	      cosphi=0
	      sinphi=0
	     else
	      cosphi=dxmic/(rjust*sinth)
	      sinphi=dymic/(rjust*sinth)
	     endif
             twocosphi=2.*cosphi
	     cos2phi=twocosphi*cosphi-1.
	     sin2phi=twocosphi*sinphi

	     cos3phi=twocosphi*cos2phi-cosphi
	     sin3phi=twocosphi*sin2phi-sinphi

	     cos4phi=twocosphi*cos3phi-cos2phi
	     sin4phi=twocosphi*sin3phi-sin2phi

	     cos5phi=twocosphi*cos4phi-cos3phi
	     sin5phi=twocosphi*sin4phi-sin3phi

	     cos6phi=twocosphi*cos5phi-cos4phi
	     sin6phi=twocosphi*sin5phi-sin4phi

c Armonicos esferios Y6m, tanto la parte real(0) como la imaginaria(1)
	     y6(0,0)=y60*(-5.+105.*costh2-315*costh4+231.*costh6)
	     y6(1,0)=0.
	    
	     B=y61*costh*(5.-30.*costh2+33.*costh4)*sinth
	     y6(0,1)=-B*cosphi
	     y6(1,1)=-B*sinphi

	     B=y62*(1.-18.*costh2+33.*costh4)*sinth2
	     y6(0,2)=B*cos2phi  
	     y6(1,2)=B*sin2phi

	     B=y63*costh*sinth3*(-3.+11.*costh2)
	     y6(0,3)=-B*cos3phi  
	     y6(1,3)=-B*sin3phi

	     B=y64*sinth4*(-1.+11.*costh2) 
	     y6(0,4)=B*cos4phi  
	     y6(1,4)=B*sin4phi
	
	     B=y65*costh*sinth5
	     y6(0,5)=-B*cos5phi  
	     y6(1,5)=-B*sin5phi 

	     B=y66*sinth6
	     y6(0,6)=B*cos6phi  
	     y6(1,6)=B*sin6phi  

c Armonicos esfericos Y4m, tanto la parte real (0) como la imaginaria (1)
	     y4(0,0)=y40*(3.-30.*costh2+35.*costh4)
	     y4(1,0)=0.

	     B=y41*costh*(-3.+7.*costh2)*sinth
	     y4(0,1)=-B*cosphi
	     y4(1,1)=-B*sinphi

	     B=y42*(-1.+7.*costh2)*sinth2
	     y4(0,2)=B*cos2phi
	     y4(1,2)=B*sin2phi

	     B=y43*costh*sinth3
	     y4(0,3)=-B*cos3phi
	     y4(1,3)=-B*sin3phi

	     B=y44*sinth4
	     y4(0,4)=B*cos4phi
	     y4(1,4)=B*sin4phi

c Armonicos esfericos Y3m, tanto la parte real (0) como la imaginaria (1)
             y3(0,0) = y30*(5.0*costh3 - 3.*costh)
             y3(1,0) = 0.0d0

             B = y31*sinth*(5.*costh2-1.0d0)
             y3(0,1) = -B*cosphi
             y3(1,1) = -B*sinphi

             B = y32*costh*sinth2
             y3(0,2) = B*cos2phi
             y3(1,2) = B*sin2phi

             B = y33*sinth3
             y3(0,3) = -B*cos3phi
             y3(1,3) = -B*sin3phi

c Armonicos esfericos Y2m, tanto la parte real (0) como la imaginaria (1)
             y2(0,0) = y20*(3.*costh2 -1.0)
             y2(1,0) = 0.

             B = y21*costh*sinth
             y2(0,1) = -B*cosphi
             y2(1,1) = -B*sinphi

             B = y22*sinth2
             y2(0,2) = B*cos2phi
             y2(1,2) = B*sin2phi

c Se hace el sumatorio de los armonicos esfericos sobre los 
c vecinos encontrados para la  particula imol 

	     do m=0,6
	      q6(0,m,imol)=q6(0,m,imol)+y6(0,m)
	      q6(1,m,imol)=q6(1,m,imol)+y6(1,m)
	     enddo
	    
	     do m=0,4
	      q4(0,m,imol)=q4(0,m,imol)+y4(0,m)
	      q4(1,m,imol)=q4(1,m,imol)+y4(1,m)
	     enddo

	     do m=0,3
	      q3(0,m,imol)=q3(0,m,imol)+y3(0,m)
	      q3(1,m,imol)=q3(1,m,imol)+y3(1,m)
	     enddo

	     do m=0,2
	      q2(0,m,imol)=q2(0,m,imol)+y2(0,m)
	      q2(1,m,imol)=q2(1,m,imol)+y2(1,m)

	     enddo

	 enddo !fin del bucle sobre vecinos imol
	ENDDO    !fin de bucle sobre particulas


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11111
!Vectors averaged over neighbors




	DO imol=naq+1,nmoltot    !Bucle sobre moleculas

         do k=0,1
          do m=0,6
           q6bar(k,m,imol)=0.
          enddo
         enddo

         do k=0,1
          do m=0,4
           q4bar(k,m,imol)=0.
          enddo
        enddo

         do k=0,1
          do m=0,3
           q3bar(k,m,imol)=0.
          enddo
        enddo


         do k=0,1
          do m=0,2
           q2bar(k,m,imol)=0.
          enddo
        enddo


	  do i=1,nvecinos(imol)

	  jmol=listav(imol,i)

          rn=float(nvecinos(jmol))

c Se hace el sumatorio de los vectores q sobre los 
c vecinos encontrados para la  particula imol 

	     do m=0,6
	      q6bar(0,m,imol)=q6bar(0,m,imol)+q6(0,m,jmol)/rn
	      q6bar(1,m,imol)=q6bar(1,m,imol)+q6(1,m,jmol)/rn
	     enddo

	    
	     do m=0,4
	      q4bar(0,m,imol)=q4bar(0,m,imol)+q4(0,m,jmol)/rn
	      q4bar(1,m,imol)=q4bar(1,m,imol)+q4(1,m,jmol)/rn
	     enddo

	     do m=0,3
	      q3bar(0,m,imol)=q3bar(0,m,imol)+q3(0,m,jmol)/rn
	      q3bar(1,m,imol)=q3bar(1,m,imol)+q3(1,m,jmol)/rn
	     enddo

	     do m=0,2
	      q2bar(0,m,imol)=q2bar(0,m,imol)+q2(0,m,jmol)/rn
	      q2bar(1,m,imol)=q2bar(1,m,imol)+q2(1,m,jmol)/rn
	     enddo

	 enddo !fin del bucle sobre vecinos imol

	     rn=float(nvecinos(imol))

! Se le agnade el termino de la particula misma
	     do m=0,6
	      q6bar(0,m,imol)=q6bar(0,m,imol)+q6(0,m,imol)/rn
	      q6bar(1,m,imol)=q6bar(1,m,imol)+q6(1,m,imol)/rn
	      enddo

	     do m=0,4
	      q4bar(0,m,imol)=q4bar(0,m,imol)+q4(0,m,imol)/rn
	      q4bar(1,m,imol)=q4bar(1,m,imol)+q4(1,m,imol)/rn
	     enddo

	     do m=0,3
	      q3bar(0,m,imol)=q3bar(0,m,imol)+q3(0,m,imol)/rn
	      q3bar(1,m,imol)=q3bar(1,m,imol)+q3(1,m,imol)/rn
	     enddo

	     do m=0,2
	      q2bar(0,m,imol)=q2bar(0,m,imol)+q2(0,m,imol)/rn
	      q2bar(1,m,imol)=q2bar(1,m,imol)+q2(1,m,imol)/rn
	     enddo

!Si no hay vecinos los vectores se hacen cero
	if(nvecinos(imol).eq.0)then
             do m=0,6
              q6bar(0,m,imol)=0.
              q6bar(1,m,imol)=0.
              enddo

             do m=0,4
              q4bar(0,m,imol)=0.
              q4bar(1,m,imol)=0.
             enddo

             do m=0,3
              q3bar(0,m,imol)=0.
              q3bar(1,m,imol)=0.
             enddo

             do m=0,2
              q2bar(0,m,imol)=0.
              q2bar(1,m,imol)=0.
             enddo
	endif

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	     rnbar=float(nvecinos(imol)+1)

	     do m=0,6
	      q6bar(0,m,imol)=q6bar(0,m,imol)/rnbar
	      q6bar(1,m,imol)=q6bar(1,m,imol)/rnbar
	     enddo

	     do m=0,4
	      q4bar(0,m,imol)=q4bar(0,m,imol)/rnbar
	      q4bar(1,m,imol)=q4bar(1,m,imol)/rnbar
	     enddo


	     do m=0,3
	      q3bar(0,m,imol)=q3bar(0,m,imol)/rnbar
	      q3bar(1,m,imol)=q3bar(1,m,imol)/rnbar
	     enddo

	     do m=0,2
	      q2bar(0,m,imol)=q2bar(0,m,imol)/rnbar
	      q2bar(1,m,imol)=q2bar(1,m,imol)/rnbar
	     enddo
!                
	q6q6bar=0

         do m=1,6
          do ip=0,1
            q6q6bar=q6q6bar+q6bar(ip,m,imol)*q6bar(ip,m,imol)
          enddo
         enddo
	
	 q6q6bar=2.*q6q6bar+q6bar(0,0,imol)*q6bar(0,0,imol)


	 q6bartot(imol)=sqrt(4.*pi/13.*q6q6bar)


	q4q4bar=0

         do m=1,4
          do ip=0,1
            q4q4bar=q4q4bar+q4bar(ip,m,imol)*q4bar(ip,m,imol)
          enddo
         enddo
	
	 q4q4bar=2.*q4q4bar+q4bar(0,0,imol)*q4bar(0,0,imol)

	 q4bartot(imol)=sqrt(4.*pi/9.*q4q4bar)



	q3q3bar=0

         do m=1,3
          do ip=0,1
            q3q3bar=q3q3bar+q3bar(ip,m,imol)*q3bar(ip,m,imol)
          enddo
         enddo
	
	 q3q3bar=2.*q3q3bar+q3bar(0,0,imol)*q3bar(0,0,imol)

	 q3bartot(imol)=sqrt(4.*pi/7.*q3q3bar)


	write(920,*)q3q3bar,q4q4bar,q6q6bar
	write(919,*),q3bartot(imol),q4bartot(imol),q6bartot(imol)

	q2q2bar=0

         do m=1,2
          do ip=0,1
            q2q2bar=q2q2bar+q2bar(ip,m,imol)*q2bar(ip,m,imol)
          enddo
         enddo
	
	 q2q2bar=2.*q2q2bar+q2bar(0,0,imol)*q2bar(0,0,imol)

	 q2bartot(imol)=sqrt(4.*pi/5.*q2q2bar)

c     if you use q6 order parameter
!	 if(q6bartot(imol).gt.0.28)then 
!	  isolmrco(imol)=1
!	 else
!	  isolmrco(imol)=0
!	 endif

c     to identify fcc-like particles	 	
!	 if((isolmrco(imol).eq.1).and.(q4bartot(imol).ge.0.06))then
!          isolfcc(imol)=1
!	 else
!          isolfcc(imol)=0
!	 endif


!         write(9999,*)imol,q3bartot(imol)
c     if you use q3 order parameter 
	 if(q3bartot(imol).gt.-0.87)then 
	  isolmrco(imol)=1
	 else
	  isolmrco(imol)=0
	 endif

c     to identify planar (graphitic)-like structures	 	
!	 if((isolmrco(imol).eq.1).and.(q2bartot(imol).ge.0.5))then
!          isolgra(imol)=1
!	 else
!          isolgra(imol)=0
!	 endif


	 
	ENDDO    !fin de bucle sobre particulas



!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11111


c Histograma de numero de vecinos
	
      do iy=naq+1,nmoltot
       nvecinostot(nvecinos(iy))=nvecinostot(nvecinos(iy))+1
      enddo

c Division de las componentes de los vectores por el numero de vecinos
c y normalizacion de los vectores
	do i=naq+1,nmoltot
	 if(nvecinos(i).ne.0)then
	  rm6=0.
	  do m=0,6
	    q6(0,m,i)=q6(0,m,i)/float(nvecinos(i))
	    q6(1,m,i)=q6(1,m,i)/float(nvecinos(i))
	    rm6=q6(0,m,i)*q6(0,m,i)+q6(1,m,i)*q6(1,m,i)+rm6
        enddo
	    sqrm6=sqrt(2.*rm6-q6(0,0,i)*q6(0,0,i))

	  rm4=0.
	  do m=0,4
	    q4(0,m,i)=q4(0,m,i)/float(nvecinos(i))
	    q4(1,m,i)=q4(1,m,i)/float(nvecinos(i))
	    rm4=q4(0,m,i)*q4(0,m,i)+q4(1,m,i)*q4(1,m,i)+rm4
        enddo
	    sqrm4=sqrt(2.*rm4-q4(0,0,i)*q4(0,0,i))
	
	  rm3=0.
	  do m=0,3
	    q3(0,m,i)=q3(0,m,i)/float(nvecinos(i))
	    q3(1,m,i)=q3(1,m,i)/float(nvecinos(i))
	    rm3=q3(0,m,i)*q3(0,m,i)+q3(1,m,i)*q3(1,m,i)+rm3
        enddo
	    sqrm3=sqrt(2.*rm3-q3(0,0,i)*q3(0,0,i))

	
	  rm2=0.
	  do m=0,2
	    q2(0,m,i)=q2(0,m,i)/float(nvecinos(i))
	    q2(1,m,i)=q2(1,m,i)/float(nvecinos(i))
	    rm2=q2(0,m,i)*q2(0,m,i)+q2(1,m,i)*q2(1,m,i)+rm2
        enddo
	    sqrm2=sqrt(2.*rm2-q2(0,0,i)*q2(0,0,i))



	  if(sqrm6.ne.0.)then
	   do m=0,6
	     q6(0,m,i)=q6(0,m,i)/sqrm6
	     q6(1,m,i)=q6(1,m,i)/sqrm6
	   enddo
	  endif
	
	  if(sqrm4.ne.0.)then
	   do m=0,4
	     q4(0,m,i)=q4(0,m,i)/sqrm4
	     q4(1,m,i)=q4(1,m,i)/sqrm4
	   enddo
	  endif
	
	  if(sqrm3.ne.0.)then
	   do m=0,3
	     q3(0,m,i)=q3(0,m,i)/sqrm3
	     q3(1,m,i)=q3(1,m,i)/sqrm3
	   enddo
	  endif

	
	  if(sqrm2.ne.0.)then
	   do m=0,2
	     q2(0,m,i)=q2(0,m,i)/sqrm2
	     q2(1,m,i)=q2(1,m,i)/sqrm2
	   enddo
	  endif



	 endif
	enddo



c Histograma de numero de vecinos 
	do iy=naq+1,nmoltot
	 nvecinostot(nvecinos(iy))=nvecinostot(nvecinos(iy))+1
	enddo

!Si hay agua, la volvemos a poner. 
!(Se presupone que el agua esta numerada como 1)  
	
	if(ntipmolmax.eq.3)then
	  do i=1,nmol(1)
         call put_in_list(i,1)
	  enddo
	endif


	!call comparovecinos(listav0,nvecinos0,listav,nvecinos) 


!Halla la media del vector q6
	q6barratotal=0
	do i=1,nmoltot
	 q6barratotal=q6barratotal+q6bartot(i)
	enddo
 
	write(621,*)rporaquiva,q6barratotal/float(nmoltot)


	
	return
	end
c________________________________________________________________________
c________________________________________________________________________
c SUBRRUTINA PARA EL CALCULO DEL PRODUCTO VECTORIAL DE LOS VECTORES 
C ATOMICOS Q6

	subroutine q6q4q3q2dot(nclbigdot,iatsol)

	include 'parametros_NpT.inc'
	include 'common.inc'
	dimension q6(0:1,0:6,nmmax),q4(0:1,0:4,nmmax)
	dimension q3(0:1,0:3,nmmax),q2(0:1,0:2,nmmax)
	dimension listav(natmax,50)
	dimension nvecinos(natmax)
	dimension iclcon(nmoltot), iclstat(nmoltot)
	dimension indmolclnew(nmoltot)
        dimension iatsol(natmax)

      if(ntipmolmax.eq.3)then
        naq=nmol(1)
	  natperaq=nsites(1)
      else
        naq=0 
	  natperaq=0
      endif
	 
	deltaq6=2./201.                      

	nclustgt10=0.
	nclustgt50=0.
	nclustgt100=0.
	nclustgt250=0.
	nclustgt500=0.

c Hallo el vector q6 y q4 para cada particula y lista de primeros vecinos	
c     tambien q3 y q2


	call q6q4q3q2vec(q6,q4,q3,q2,listav,nvecinos)

c Inicializo iclcon y iclstat. 
c Iclcon(i) me dice cuantas particulas vecinas a i 
c forman cluster con ella. 
c iclstat(i) me dice en que estado de de cluster se encuentra 
c la particula i (0, liquido, 1 hay que ver con cuantas mas esta)
	do i=1,nmoltot
	 iclcon(i)=0
	 iclstat(i)=0
	enddo

!This will allow to identify as solids all the particles
!that have ever been solid during a time alpha
	if((rtimeblock.ge.rtimealpha).or.(ibucle.eq.1))then
	 do i=1,nmoltot
	  iatsol(i)=0
	 enddo
	endif
c Inicializo el numero de particulas en fase solida
	nsolid=0

!Q_P Initiallize Q_P

        do i=naq+1,nmoltot
          Q_P(i)=0.
        enddo


c Calculo el producto vectorial q6.q6* y q4.q4* 
c    de cada particula con sus vecinas. 
c     tambien q3 y q2 
	do imol=naq+1,nmoltot

	 do jvec=1,nvecinos(imol)

	  q6q6=0.
	  q4q4=0.
          q3q3=0.
          q2q2=0.

	  jmol=listav(imol,jvec)
	
c q6.q6*	
	 do m=1,6
	  do ip=0,1
	    q6q6=q6q6+q6(ip,m,imol)*q6(ip,m,jmol)
          enddo
	 enddo

	 q6q6=2.*q6q6+q6(0,0,imol)*q6(0,0,jmol)
	
        if((q6q6.gt.1.00001).or.(q6q6.lt.-1.0000001))then
         print*,q6q6
         print*,'q6q6 mayor que 1 o menor que -1?'
         stop
        endif

c q4.q4*	
	 do m=1,4
	  do ip=0,1
	    q4q4=q4q4+q4(ip,m,imol)*q4(ip,m,jmol)
          enddo
	 enddo

         q4q4=2.*q4q4+q4(0,0,imol)*q4(0,0,jmol)

	if((q4q4.gt.1.00001).or.(q4q4.lt.-1.0000001))then
	 print*,q4q4
	 print*,'q4q4 mayor que 1 o menor que -1?'
	 stop
	endif

c q3.q3*	
	 do m=1,3
	  do ip=0,1
	    q3q3=q3q3+q3(ip,m,imol)*q3(ip,m,jmol)
          enddo
	 enddo

         q3q3=2.*q3q3+q3(0,0,imol)*q3(0,0,jmol)

	if((q3q3.gt.1.00001).or.(q3q3.lt.-1.0000001))then
	 print*,q3q3
	 print*,'q3q3 mayor que 1 o menor que -1?'
	 stop
	endif

c q2.q2*	
	 do m=1,2
	  do ip=0,1
	    q2q2=q2q2+q2(ip,m,imol)*q2(ip,m,jmol)
          enddo
	 enddo

         q2q2=2.*q2q2+q2(0,0,imol)*q2(0,0,jmol)

	if((q2q2.gt.1.00001).or.(q2q2.lt.-1.0000001))then
	 print*,q2q2
	 print*,'q2q2 mayor que 1 o menor que -1?'
	 stop
	endif


c Umbral para el producto escalar
	  !if(q4q4.gt.umbq4)then
	  ! iclcon(imol)=iclcon(imol)+1
	  !endif

!	  if(q6q6.gt.umbq6)then
!	   iclcon(imol)=iclcon(imol)+1
!	  endif

!	  if(q3q3.lt.umbq3)then
!             iclcon(imol)=iclcon(imol)+1
!          endif

c Histograma de q6 y q4	 
	   ngrulla=int((q6q6+(deltaq6/2.))/deltaq6)
	   nhistoq6(ngrulla)=nhistoq6(ngrulla)+1

	   ngrulla=int((q4q4+(deltaq6/2.))/deltaq6)
	   nhistoq4(ngrulla)=nhistoq4(ngrulla)+1

c     tambien de q2 y q3
	   ngrulla=int((q3q3+(deltaq6/2.))/deltaq6)
	   nhistoq3(ngrulla)=nhistoq3(ngrulla)+1

	   ngrulla=int((q2q2+(deltaq6/2.))/deltaq6)
	   nhistoq2(ngrulla)=nhistoq2(ngrulla)+1

	   nnormal=nnormal+1

!Q_P
!         Q_P(imol)=Q_P(imol)+q6q6 ! if you use q6

           Q_P(imol)=Q_P(imol)+q3q3! if you use q3

	 enddo !fin del bucle sobre vecinos

c Umbral para el numero de vecinos 'solidamente enlazados'
!	 if(iclcon(imol).ge.iumbneigh)then
! 	  nsolid=nsolid+1  
!	  iclstat(imol)=1
!	  lsolid(nsolid)=imol
!	  iatsol(imol)=1
!	 endif


!         nsolid=nsolid+1
!         iclstat(imol)=1
!         lsolid(nsolid)=imol
!         iatsol(imol)=1
!        endif

         if( q6bartot(imol)  .ge.umbsol)then
!         if(q6bartot(imol).ge.(0.475-q4bartot(imo)))then
          nsolid=nsolid+1
          iclstat(imol)=1
          lsolid(nsolid)=imol
          iatsol(imol)=1
         endif


c Histograma del numero de conexiones
	nhistoconex(iclcon(imol))=nhistoconex(iclcon(imol))+1

!Q_P

        Q_P(imol)=Q_P(imol)/12.

	enddo !fin de bucle sobre particulas
	
 	nhistoclus(0)=nhistoclus(0)+nmoltot-naq-nsolid




c Calculo del numero de particulas que tiene el cluster solido 
c mas grande de cuantos hay en el sistema.
c Inicializacion del numero de particulas del cluster cuyo tamanno se
c comprueba y del numero de particulas del cluster de tamanno record. 
	nclbigdot=0
	nclnew=0

	IF(nsolid.gt.0)then
	 
	 do ind=1,nsolid
	  
	  imol=lsolid(ind)

c Si iclstat(imol) es 1 hay que proceder a calcular el tamanno del     
c cluster donde se encuentra imol.
        if(iclstat(imol).eq.1)then
	   nclnew=1
	   indmolclnew(nclnew)=imol
	   iclstat(imol)=2
	   call cluster
     >   (nmoltot,imol,listav,nvecinos,nclnew,iclstat,indmolclnew)
	  endif

c Histograma sobre el tamanno de los clusters:
	  if(nclnew.ne.0)then
	   nhistoclus(nclnew)=nhistoclus(nclnew)+1

!Information about number of clusters bigger than x

	   if(nclnew.gt.10)then
	   nclustgt10=nclustgt10+1
	   endif
	   if(nclnew.gt.50)then
	   nclustgt50=nclustgt50+1
	   endif
	   if(nclnew.gt.100)then
	   nclustgt100=nclustgt100+1
	   endif
	   if(nclnew.gt.250)then
	   nclustgt250=nclustgt250+1
	   endif
	   if(nclnew.gt.500)then
	   nclustgt500=nclustgt500+1
	   endif
	  endif

c Si el cluster cuyo tamanno se ha calculado es mayor que el que
c ya estaba, este pasa a ser el que 'pinta'
	  if(nclnew.gt.nclbigdot)then
	   nclbigdot=nclnew
	   do imc=1,nclbigdot
	    indmolclbig(imc)=indmolclnew(imc)
	   enddo
	  endif
	   
c A por otra particula
        nclnew=0
       enddo  !fin del bucle sobre particulas

      ENDIF
	ncb=nclbigdot	

!Print histogram alongtime
!Fom X to Y particles in the cluster
	
	iclhay1025=0
	do i=10,25
	iclhay1025=iclhay1025+nhistoclus(i)
	enddo

	iclhay2650=0
	do i=26,50
	iclhay2650=iclhay2650+nhistoclus(i)
	enddo

	iclhay5180=0
	do i=51,80
	iclhay5180=iclhay5180+nhistoclus(i)
	enddo

	iclhay81120=0
	do i=81,125
	iclhay81125=iclhay81125+nhistoclus(i)
	enddo
	
	iclhay126200=0
	do i=126,200
	iclhay126200=iclhay126200+nhistoclus(i)
	enddo
	
	iclhay201500=0
	do i=201,500
	iclhay201500=iclhay201500+nhistoclus(i)
	enddo
	
	iclhay501tot=0
	do i=501,nmoltot
	iclhay501tot=iclhay501tot+nhistoclus(i)
	enddo
	
	


	write(616,833)rporaquiva,iclhay1025,iclhay2650,iclhay5180
     >        ,iclhay81125,iclhay126200,iclhay201500,iclhay501tot

833     format(f9.4,1x,i5,1x,i5,1x,i5,1x,i5,1x,i5,1x,i5,1x,i5)
	


	if(ibucle.eq.1)then
	icontsol=0
        do i=1,nmoltot
	if(iatsol(i).ne.0)then
        icontsol = icontsol +1
	 initialsolmol(icontsol)=i
        endif
	enddo

	elseif(ibucle.gt.1)then

	do i=1,icontsol 
         iatsolvec(i)= initialsolmol(i)
        enddo
       

	endif


	do i=1,nmoltot
	 iseisolid(i)=iatsol(i)
	enddo


	print*,'sale de q6q4q3q2dot'

	return
	end

c________________________________________________________________________
c________________________________________________________________________
c SUBRRUTINA PARA CALCULAR EL TAMANNO DEL CLUSTER. ATENCION QUE
C ES RECURSIVA

  	recursive subroutine cluster
     >(nmoltota,imola,listava,nvecinosa,nclnewa,iclstata,indmolclnewa)

	include 'parametros_NpT.inc'
	include 'common.inc'

	dimension iclstata(nmoltota), indmolclnewa(nmoltota)
      dimension listava(natmax,50)
      dimension nvecinosa(natmax)	

	do i=1,nvecinoscl(imola)
	 jmol=listavcl(imola,i) 
	 
	 if(iclstata(jmol).eq.1)then
	  nclnewa=nclnewa+1
	  indmolclnewa(nclnewa)=jmol
	  iclstata(jmol)=2
        call cluster
     >  (nmoltota,jmol,listava,nvecinosa,nclnewa,iclstata,indmolclnewa) 
       endif
	enddo

	return
	end  

c________________________________________________________________________
c________________________________________________________________________
	subroutine saveconf          

	include 'parametros_NpT.inc'
	include 'common.inc'

c Salvo volumen y energia
	volsa=vol
	utotsa=utot
	u_ljsa=u_lj

c Salvo matriz h y h inversa
      do i=1,3
	 do j=1,3
	  hsa(i,j)=h(i,j)
	  hinvsa(i,j)=hinv(i,j)
       enddo
	enddo

c Salvo la longitud de los lados
	sideasa=sidea
	sidebsa=sideb
	sidecsa=sidec

c Salvo coordenadas
 	numdesites=0
	do i8=1,ntipmol
 	numdesites=nmol(i8)*nsites(i8)+numdesites
 	enddo
	do i=1,numdesites 
	  xasa(i)=xa(i)
	  yasa(i)=ya(i)
	  zasa(i)=za(i)
	enddo

c Salvo ewald staff
	if(iewald.eq.1)then
	   maxvecsa=maxvec
         do k = 1, maxvec
         cssumsa(k) = cssum(k) 
         snsumsa(k) = snsum(k) 
         enddo
	   ufoldsa=ufold
	endif

c Salvo nucleation staff
	nclbigsa=nclbig
	ebiassa=ebias

	ncbsa=ncb
	do i=1,ncb    
	 indmolclbigsa(i)=indmolclbig(i)
	enddo
	
	return
	end

c________________________________________________________________________
c________________________________________________________________________

	subroutine restoreconf

	include 'parametros_NpT.inc'
	include 'common.inc'

c  volumen y energia
	vol=volsa
	utot=utotsa
	u_lj=u_ljsa

c  matriz h y h inversa
      do i=1,3
	 do j=1,3
	  h(i,j)=hsa(i,j)
	  hinv(i,j)=hinvsa(i,j)
       enddo
	enddo

c   Longitud de los lados
	sidea=sideasa
	sideb=sidebsa
	sidec=sidecsa

c coordenadas
 	numdesites=0
	do i8=1,ntipmol
 	numdesites=nmol(i8)*nsites(i8)+numdesites
 	enddo
	do i=1,numdesites
	  xa(i)=xasa(i)
	  ya(i)=yasa(i)
	  za(i)=zasa(i)
	enddo

c lista de celdas
      call make_cell_map(sidea,sideb,sidec,cutoff)

      call make_link_list(natoms)

c ewald staff
	if(iewald.eq.1)then
	   maxvec=maxvecsa
         do k = 1, maxvec
          cssum(k) = cssumsa(k) 
          snsum(k) = snsumsa(k) 
         enddo
	   ufold=ufoldsa	   
         call ewstup(h) 
 	endif

c  nucleation staff
	nclbig=nclbigsa
	ebias=ebiassa

	ncb=ncbsa
	do i=1,ncb
	 indmolclbig(i)=indmolclbigsa(i)
	enddo

	return
	end

!____________________________________________
!____________________________________________
!____________________________________________
       subroutine escribeconf(seed)
	include 'parametros_NpT.inc'
	include 'common.inc'
	
      open(169,file='noseusaestetodaslasconf.dat',position='append')
      open(170,file='peliculita.xyz',position='append')
	

	cero=0.
	fscal=1.


	if(ifirstcallescri.eq.0)then
	  rewind(169)
	  rewind(170)
	  ifirstcallescri=1
	endif


!Escribo en coords de caja
        write(169,*)'otra',ntot,seed,utot
        write(169,*)pshift,ashift,dela,dela1

        numdesites=0

        do i8=1,ntipmol
         numdesites=nmol(i8)*nsites(i8)+numdesites
        enddo

        do ique=1,numdesites
           write(169,*) xa(ique),ya(ique),za(ique)
        end do

        do ique=1,3
         write(169,*)h(ique,1),h(ique,2),h(ique,3)
        end do

! Escribo configuraciones para pelicula
      write(170,*)numdesites+8
	write(170,*)
      write(170,600)'Li',cero,cero,cero,cero
      write(170,600)'Li',h(1,1)*fscal,h(2,1)*fscal,h(3,1)*fscal,cero
      write(170,600)'Li',h(1,2)*fscal,h(2,2)*fscal,h(3,2)*fscal,cero
      write(170,600)'Li',h(1,3)*fscal,h(2,3)*fscal,h(3,3)*fscal,cero

      write(170,600)'Li',(h(1,1)+h(1,2))*fscal,
     .                 (h(2,1)+h(2,2))*fscal,
     .                 (h(3,1)+h(3,2))*fscal,cero
      write(170,600)'Li',(h(1,1)+h(1,3))*fscal,
     .                 (h(2,1)+h(2,3))*fscal,
     .                 (h(3,1)+h(3,3))*fscal,cero
      write(170,600)'Li',(h(1,2)+h(1,3))*fscal,
     .                 (h(2,2)+h(2,3))*fscal,
     .                 (h(3,2)+h(3,3))*fscal,cero

      write(170,600)'Li',(h(1,1)+h(1,2)+h(1,3))*fscal,
     .                 (h(2,1)+h(2,2)+h(2,3))*fscal,
     .                 (h(3,1)+h(3,2)+h(3,3))*fscal, cero

	

	imol=0
	do i=1,ntipmol
	 do j=1,nmol(i)
	   imol=imol+1
	   numori=puntero1(i)+(imol-1-puntero2(i))*nsites(i)
	   do k=1,nsites(i)
	      ii=numori+k
	      xar=xa(ii)
            yar=ya(ii)
            zar=za(ii)
            xar = xar - anint((xar-half) )
            yar = yar - anint((yar-half) )
            zar = zar - anint((zar-half) )
            call caja_cart(xar,yar,zar,xr,yr,zr)
                                                            
            if(i.eq.1)then
            write(170,600)'K',xr,yr,zr    
            else
		write(170,600)'F',xr,yr,zr    
            endif
 
	   enddo
	 enddo
	enddo

	    
	close(169)
	close(170)
	
 600  format(2x,1A,4(F14.7,2x))
       return
       end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! FFS 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	subroutine ffsrutine(seed)
	include 'parametros_NpT.inc'
	include 'common.inc'


! Si llego a la siguiente interfase escribo la configuracion 
! y el fichero simiulacion.inp y paro.
	if(ncb.ge.nextint)then

        open(iseed0)

        numdesites=0
 	
        do i8=1,ntipmol
         numdesites=nmol(i8)*nsites(i8)+numdesites
        enddo
	
        do ique=1,numdesites
           write(iseed0,*) xa(ique),ya(ique),za(ique)
        end do

        do ique=1,3
         write(iseed0,*)h(ique,1),h(ique,2),h(ique,3)
        end do
	
	call imprimosimulacioninp(seed)

	stop 
	endif

!Veo si estoy en el l�quido
	
	if(ncb.le.irecordcumliq)then
	rpel=cumulative(ncb)   !probabilidad de que, teniendo el cluster maximo 
			  !ncb part�culas, estemos en el l�quido
	elseif(ncb.gt.irecordcumliq)then
	rpel=-1. 
	endif

	ranliq=ranf(seed)

	if(ranliq.le.rpel)then 
	call imprimosimulacioninp(seed)
	stop
	endif
	return
	end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Subrutina para escribir el fichero simulacion.inp 
	subroutine imprimosimulacioninp(seed)
        include 'parametros_NpT.inc'
        include 'common.inc'

        open(unit=1,file='simulacion.inp',status='unknown')
        rewind(1)
C Escribo un ficherho simulacion.inp que sera el del siguiente trial
c En el fichero init.dat doy la presión en bares
      factorp=1.E+5*beta/(1.380658E-23*1.E+30)
c Y la densidad en g/cm**3
       rho=rho*(rpesomolec*1.0E+24)/6.0221367E+23


c      write(1,44) pstar/factorp,rho,1./beta    ! estado termodinamico
      write(1,44) pstar/beta,rho,1./beta    ! estado termodinamico
      write(1,*) '0  ',neq,nmax,njob           ! longitud simulacion
      write(1,37) pshift,ashift,dela,dela1           ! tamanho tobas MC
      write(1,*) seed                         ! numero semilla
      write(1,*) kstart,nmoltot,ntipmol           ! modo de comienzo
      write(1,*) ilatt,nx,ny,nz          !modo de comienzo en solido
      write(1,*) npr,nwr
      write(1,*) iscale,inpt            ! modo de funcionamiento
      write(1,45) patmp_cm,patmp_rot,patmp_int,patmp_cb
     >  ! attempt probabilities
      write(1,*) deltar,ngrid                 ! parametros g(r)
      write(1,*) drho                         ! intervalos de rho
      write(1,*) xlan1,xlan2                 !lambda1,lambda2
      write(1,*) iumbrella                    !iumbrella
        write(1,*) iwidom
        write(1,*) inucleacion,rkbias,rnclcero,iunbias    ! se hace nucleacion?
                                                           ! constante bias potential
                                                           ! tamanno cluster origen
        write(1,*)iffs,nextint
	write(1,*)ibrownian,deltatiempo
        close(1)

44    format(4x,f14.4,4x,f24.20,4x,f14.4)
45    format(6(2x,f6.4))        
37    format(f10.5,1x,f10.5,1x,f10.5,1x,f10.5)

	return
	end


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCcc
! Se ve para cada molecula cuales estan pegadas a ella segun el cutoff rneigcl
! El resultado son dos vectores. 
! Uno nvecinoscl(imol), que me dice cuantos vecinos tiene la molecula imol
! otro listavcl(i,j) que me dice cual es el indice de la molecula j vecina de la i.
	subroutine vecinosacadaparticula 
        include 'parametros_NpT.inc'
        include 'common.inc'

	integer head,next,previous


c CALCULO PARA CADA ATOMO UN VECTOR Q6 Y Q4
	DO imol=1,nmoltot    !Bucle sobre moleculas

c Sacando esta molecula de la lista
	 
	ic=class(imol)
      call take_outof_list(imol,ic)

	 nvecinoscl(imol)=0

c Identificamos en que celdilla esta la molecula i
       numori=puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)
	 imolatom1=numori+1

       xi = xa(imolatom1) - anint( (xa(imolatom1)-half) )
       yi = ya(imolatom1) - anint( (ya(imolatom1)-half) )
       zi = za(imolatom1) - anint( (za(imolatom1)-half) )

       i = int(xi/xlcell) + 1
       j = int(yi/ylcell) + 1
       k = int(zi/zlcell) + 1
 
       icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

c Almacenamos coordenadas
       xi = xa(imolatom1)
       yi = ya(imolatom1)
       zi = za(imolatom1)
 

c Bucle sobre las ntb celdas de la caja de celdas centrada en icell
       do ncell = 1,ntb

        jcell = neighbour_cell(ncell,icell)
        jatm = head(jcell)

c bucle sobre todos los atomos en el interior de la celda jcell
         do while (jatm.ne.0)
	    
c distancias interatomicas en convencion mic
          dx = xa(jatm) - xi
          dy = ya(jatm) - yi
          dz = za(jatm) - zi
 
          tx=dx-anint(dx)
          ty=dy-anint(dy)
          tz=dz-anint(dz)

          txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
          typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
          tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz

          dxmic =txp
          dymic =typ
          dzmic =tzp

	    r2 = (dxmic**2 + dymic**2 + dzmic**2)


	    If(r2.lt.rneigcl**2)Then 
	
	     molecj=jatm
          
c Lista de vecinos para particulas en el mismo cluster
	     nvecinoscl(imol)=nvecinoscl(imol)+1
	     listavcl(imol,nvecinoscl(imol))=molecj
	    Endif

C a por el siguiente atomo de esta caja
            jatm=next(jatm)
        
           enddo !fin de bucle sobre atomos de esta celda
         enddo   !fin de bucle sobre celdas

c Incluyendo la molecula en la lista
 323    call put_in_list(imol,ic)

        ENDDO    !fin de bucle sobre particulas

	return
	end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!Teniendo la lista de las moleculas vecinas a una dada segun el cutoff rneigcl, hace un mapa
!de todos los cluster presentes en el sistema.
!nclsistema nos dice cuantos clusters han salido
!npuntcluster(i) nos dice donde empiezan los indices del cluster i en el vector ipartclust(j)
!ipartclust() es un vector que contiene los indices de todas las moleculas ordenadas por 
!orden de aparicion en los clusters que se van encontrando.
!numpartcluster(i) nos dice cuantas particulas tiene el cluster i.  
	subroutine listaclusterssistema
        include 'parametros_NpT.inc'
        include 'common.inc'
	dimension iclstat(nmoltot)
	dimension indmolclnew(nmoltot)

	call vecinosacadaparticula !Obtencion de lista de moleculas 
	                           !vecinas a una dada dentro de rneigcl

	nclsistema=0
	nyapertenece=0

!Hago saber que ninguna molecula pertenece a cluster (por ahora)
	do i=1,nmoltot
	iclstat(i)=1
	enddo

!Bucle principal
       DO ind=1,nmoltot 
        
          imol=ind

c Si iclstat(imol) es 1 hay que proceder a calcular el tamanno del     
c cluster donde se encuentra imol.
        if(iclstat(imol).eq.1)then
           nclnew=1
           indmolclnew(nclnew)=imol
           iclstat(imol)=2
           call cluster_b
     >   (nmoltot,imol,nclnew,iclstat,indmolclnew)
          endif

          if(nclnew.ne.0)then
           nhistoclus(nclnew)=nhistoclus(nclnew)+1
	   nclsistema=nclsistema+1
	   npuntcluster(nclsistema)=nyapertenece
	   numpartclust(nclsistema)=nclnew

           do imc=1,nclnew
	    nyapertenece=nyapertenece+1
	    ipartclust(nyapertenece)=indmolclnew(imc)   
           enddo

          endif

c A por otra particula
        nclnew=0
       ENDDO  !fin del bucle sobre particulas

	
        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c________________________________________________________________________
c________________________________________________________________________
c SUBRRUTINA PARA CALCULAR EL TAMANNO DEL CLUSTER. ATENCION QUE
C ES RECURSIVA

  	recursive subroutine cluster_b
     >(nmoltota,imola,nclnewa,iclstata,indmolclnewa)

	include 'parametros_NpT.inc'
	include 'common.inc'

	dimension iclstata(nmoltota), indmolclnewa(nmoltota)

	do i=1,nvecinoscl(imola)
	 jmol=listavcl(imola,i) 
	 
	 if(iclstata(jmol).eq.1)then
	  nclnewa=nclnewa+1
	  indmolclnewa(nclnewa)=jmol
	  iclstata(jmol)=2
        call cluster_b
     >  (nmoltota,jmol,nclnewa,iclstata,indmolclnewa) 
        endif
	enddo

	return
	end  

c________________________________________________________________________
c________________________________________________________________________
!Ojo que esta concebida para moleculas monoatomicas y sin Ewald
	subroutine clmove(seed,accpt,intento)

	include 'parametros_NpT.inc'
	include 'common.inc'

       dimension xatn(nsmax),yatn(nsmax),zatn(nsmax)
       dimension xato(nsmax),yato(nsmax),zato(nsmax)
       

	intento=1

!Hago una lista de los clusters del sistema
	call listaclusterssistema
	
! Si solo hay un cluster en es sistema paso de moverlo
! Todo el sistema esta formando un solo cluster y eso
! significa solo desplazar el centro de masas de todo el sistema
      if(nclsistema.eq.1)then
	      intento=0
	      return
      endif
			


!	do i=1,nclsistema
!	 do j=1,numpartclust(i)
!	  ii=npuntcluster(i)+j
!	  write(956,*)i,ipartclust(ii)
!	 enddo
!	enddo
!		
!	close(956)


c *** eleccion de cluster al azar      
      iclust = int(nclsistema*ranf(seed)) + 1
      if (iclust.gt.nclsistema) iclust=nclsistema

c Saco de la lista todas las moleculas del cluster	
	ioricl=npuntcluster(iclust)
	do i=1,numpartclust(iclust)
	 iii=ipartclust(ioricl+i)
         ic=class(iii)
         call take_outof_list(iii,ic)
	enddo

	
c Calculo la energia del cluster en la posicion vieja con el resto de
c particulas del sistema.
      uviejocl=0.	
	uviejocllj=0.
      do is=1,numpartclust(iclust)
	 numsite=ipartclust(ioricl+is)
         xato(1)=xa(numsite)
         yato(1)=ya(numsite)
         zato(1)=za(numsite)
	 imol=numsite
	 ic=class(imol)
         call inter_molecular1(xato,yato,zato,imol,ic,Uiold,iaxo,uljo)
	 uviejocl=uviejocl+Uiold
	 uviejocllj=uviejocllj+uljo
      end do

C Genero aleatoriamente tres desplazamientos
	factorescaladesp=numpartclust(iclust)**(-1./6.)

      dx=factorescaladesp*(pshift*(2.0*ranf(seed)-1.0)/sidea)
      dy=factorescaladesp*(pshift*(2.0*ranf(seed)-1.0)/sideb)
      dz=factorescaladesp*(pshift*(2.0*ranf(seed)-1.0)/sidec)

c *** calculando las posiciones y la energia del nuevo cluster
	unewcl=0.
	unewcllj=0.
      do is=1,numpartclust(iclust)
	 numsite=ipartclust(ioricl+is)
         xatn(1)=xa(numsite)+dx
         yatn(1)=ya(numsite)+dy
         zatn(1)=za(numsite)+dz
	 imol=numsite
	 ic=class(imol)
         call inter_molecular1(xatn,yatn,zatn,imol,ic,Uinew,iaxn,uljn)
         if(iaxn.eq.1)then 
	  goto 349
	 endif
	   unewcl=unewcl+Uinew
	   unewcllj=unewcllj+uljn
      end do

c Estas son las nuevas energias 
      u_ljtrial=u_lj-uviejocllj+unewcllj

      deltau=unewcl-uviejocl

      deltab=Beta*deltau
	
!	print*,iaxn,iaxo
!	print*,unewcl,uviejocl
!	read*,caca


C Criterio Metropolis.

       if (deltab.gt.70.000) then
         ratio=0.0000000000
       else
           if (deltab.lt.-70.00000000) then
           ratio=1.1
           else
           ratio = exp(-deltab)
           endif
       endif

	trial = ranf(seed)

c Actualizaciones en caso de aceptacion

        IF (trial.le.ratio) THEN
         accpt=accpt+1.0
         utot=utot+deltab
	   u_lj=u_ljtrial
         do is=1,numpartclust(iclust)
	    numsite=ipartclust(ioricl+is)
            xa(numsite)=xa(numsite)+dx
            ya(numsite)=ya(numsite)+dy
            za(numsite)=za(numsite)+dz
         end do
	
!Esta parte podria ser util para calcular el desplazamiento 
!cuadratico medio producido por movimientos de cluster
!         tx=dx
!         ty=dy
!         tz=dz
!ccj
!         txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
!         typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
!         tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz
!ccj
!         dx1=txp
!         dy1=typ
!         dz1=tzp

!         cdx(imol)=cdx(imol)+dx1
!         cdy(imol)=cdy(imol)+dy1
!         cdz(imol)=cdz(imol)+dz1

        END IF

c Meto en la lista todas las moleculas del cluster    
 349  do i=1,numpartclust(iclust)
       iii=ipartclust(ioricl+i)
       ic=class(iii)
       call put_in_list(iii,ic)
      enddo

	return
	end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c
        subroutine browniandynamics(seed)
        include 'parametros_NpT.inc'
        include 'common.inc'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	 vari=2.*deltatiempo/beta

! Hallo la fuerza sobre cada una de las particulas
! debida a la interaccion con las demas
	!call force(utot)
        call sysenergy(utot,iax)

	utot=beta*(utot+ulrtot*rho*float(nmoltot))


! Desplazo las particulas
        do i=1,nmoltot
	 call caja_cart(xa(i),ya(i),za(i),x,y,z)
	 xnew=x+deltatiempo*fuerzaextxa(i)+fromgaussian(seed,vari)
	 ynew=y+deltatiempo*fuerzaextya(i)+fromgaussian(seed,vari)
	 znew=z+deltatiempo*fuerzaextza(i)+fromgaussian(seed,vari)
	 call cart_caja(xnew,ynew,znew,xa(i),ya(i),za(i))
	 call acumulodespcuadmed(xnew,ynew,znew,x,y,z,i)
	enddo

!rehago la lista del sistema
        !call make_cell_map(sidea,sideb,sidec,cutoff)
	call make_link_list(natoms)



	return
	end
	
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        function fromgaussian(seed,varianza)

!Esta formula (de Box-Muller) tambien vale en principio per tiene problemas numericos
        !pi=3.14159265359
        !a=ranf(seed)
        !b=ranf(seed)
        !y1=sqrt(-2*log(a))*cos(2.*pi*b)

!Polar form of the Box-Muller transformation
        do
          x1= 2.0 * ranf(seed) - 1.0
          x2= 2.0 * ranf(seed) - 1.0
          w=x1*x1+x2*x2
          if(w.lt.1.0)exit
        enddo

        w = sqrt( (-2.0 * log( w ) )/ w)

         y1 = x1 * w
         y2 = x2 * w

        fromgaussian=y1*sqrt(varianza)
        !fromgaussian=y2*sqrt(varianza) este numero tambien vale pero no lo uso
        

        return
        end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
	subroutine interaccionpar(nordi,iatm,jatm,rjust,uij,fij)

        include 'parametros_NpT.inc'
        include 'common.inc'

           uij=0.
	   fij=0.
	     
!Ojo con la siguiente linea, que no esta pensada nada mas que para moleculas monoatomicas
              intid=min(int(sigatom(iatm)),int(sigatom(jatm)))*10+
     >              max(int(sigatom(iatm)),int(sigatom(jatm)))


!!!!!!!!!!!!!!!!!!!!!!!!POMS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!
!	   if(intid.eq.11)then
!
!	     if(rjust.lt.25.)then
!	     	 uij=1e42
!	     endif
!
!	   endif
!	   
!	   if(intid.eq.22)then
!
!	      if((rjust.ge.0.).and.(rjust.le.3.0))then
!		 uij=-6. 
!		endif
!
!	      !if((rjust.ge.4.0).and.(rjust.le.4.7))then
!		! uij=-3.5
!	      !print*,'tipo 2'
!		!endif
!	      
!	   endif
!
!
!
!!
!!!!!!!!!!!!!!!!!!!!!!!!!POMS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!YUK MAS CORE DURO!!!!!!!!!!!!!!!!!!
c Interaccion culombica (espacio real)
!             if(iewald.eq.1)then
!               qiqj=carga(nordi)*cargatom(jatm)
!               rijsq=rjust    
!               uijew=qiqj*erfcc(alfa*rijsq)/rijsq
!             endif                           
!

	

        if(rjust**2..lt.rcut2)then

	 if(rjust.le.1.)then 
	  uij=1E10 
	  return
	 endif
	
        endif

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!LENNARD JONES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!	rj2=rjust**2.
!
!	if(rj2.lt.rcut2)then
!	uij=4.*(1./rjust**12.-1./rjust**6.)      
! 
! 
!        fij=4./rjust**2.*
!     >   (12./rjust**12.            
!     >    -6./rjust**6.)
!	endif
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	return
	end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	subroutine acumulodespcuadmed(xnew,ynew,znew,x,y,z,i)

      include 'parametros_NpT.inc'
      include 'common.inc'
	
	dx=xnew-x
	dy=ynew-y
	dz=znew-z

	cdx(i)=cdx(i)+dx
	cdy(i)=cdy(i)+dy
	cdz(i)=cdz(i)+dz

	return
	end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      subroutine distanciasites(i,j,x,y,z,r2)
      include 'parametros_NpT.inc'
      include 'common.inc'

         dx=xa(i)-xa(j)
         dy=ya(i)-ya(j)
         dz=za(i)-za(j)

         dxm=dx-anint(dx)
         dym=dy-anint(dy)
         dzm=dz-anint(dz)

         call caja_cart(dxm,dym,dzm,x,y,z)

         r2=x**2.+y**2.+z**2.

	return
	end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      subroutine distanciasitesp(i,j,iesc,xsi,x,y,z,r2)
      include 'parametros_NpT.inc'
      include 'common.inc'

	if(iesc.eq.1)then
         dx=(xa(i)-xa(j))*(1-xsi)
         dy=ya(i)-ya(j)
         dz=za(i)-za(j)
	endif
	if(iesc.eq.2)then
         dx=xa(i)-xa(j)
         dy=(ya(i)-ya(j))*(1-xsi)
         dz=za(i)-za(j)
	endif
	if(iesc.eq.3)then
         dx=xa(i)-xa(j)
         dy=ya(i)-ya(j)
         dz=(za(i)-za(j))*(1-xsi)
	endif

         dxm=dx-anint(dx)
         dym=dy-anint(dy)
         dzm=dz-anint(dz)

         call caja_cart(dxm,dym,dzm,x,y,z)

         r2=x**2.+y**2.+z**2.

	return
	end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!

	subroutine comparovecinos(listav0,nvecinos0,listav,nvecinos)
        include 'parametros_NpT.inc'
        include 'common.inc'
	dimension listav0(natmax,50)
	dimension listav(natmax,50)
	dimension nvecinos0(natmax)
	dimension nvecinos(natmax)
	dimension isamemoliold(natmax)
	dimension ievent(natmax)
	dimension imost(natmax)
	dimension rfsamemoliv(natmax)

	double precision temp
	double precision dist(200),distsol(200)	
	character*4 label




	
	open(187,file='correlaciondevecindad.dat',position="append")
	open(982,file='corvecnoenanalizaestas.dat',position="append")
	open(939,file='corrvecanalizaestas.dat',position="append")
	open(137,file='enlacesporparticula.dat',position="append")

        open(737,file='fraction-same-80-90.dat',position="append")
        open(937,file='fraction-same90-100.dat',position="append")

        open(637,file='fraction-same-50-80.dat',position="append")

        open(537,file='fraction-same-0-50.dat',position="append")
        open(837,file='fraction-same-0-10.dat',position="append")
	open(885,file='distrotanalizaestas.dat')
	open(883,file='distrotnoanalizaestas.dat')
	open(884,file='distrottot.dat')


	do i=1,200
	dist(i)=0.0
	enddo



	if(ibucle.eq.1)then 
	rewind(187)
	rewind(137)
        rewind(737)
	rewind(937) 
        rewind(637)
        rewind(537)
        rewind(837)
        rewind(982)
	rewind(939)
	endif

	if(ibucle.eq.1)then
	do i=1,nmoltot
	ievent(i)=0
	enddo
	endif


	coincidencias=0.
	imoleff=0

	inicn=0 !Cuenta el numero de vecinos que se tienen al inicio (Doble del numero de enlaces iniciales)
	isame=0 !Cuenta el numero de vecinos de la particula i que coinciden con los
		  !vecinos que tenia al principio (Doble del numero de enlaces que coinciden)
	ienlaces=0 !Cuenta el numero de vecinos a un tiempo dado (Doble del numero de enlaces)


	icontapart=0

	
	histo09_1=0
	histo08_09=0
        histo05_08=0
	histo0_05=0
	histo0_01=0


	do i=1,nmoltot

	isamemoli=0

	if(ibucle.eq.1)rfsamemoliv(i)=0

          do j=1,nvecinos0(i)
	inicn=inicn+1

	     do k=1,nvecinos(i)

	       if(listav0(i,j)-listav(i,k).eq.0)then

		isame=isame+1

		isamemoli=isamemoli+1

		rfsamemoliv(i)=rfsamemoliv(i)+1./float(nvecinos0(i))
!		write(6,*) i,rfsamemoliv(i)

!		elseif((listav0(i,j)-listav(i,j)).ne.0)then
!		rfsamemoliv(i)=rfsamemoliv(i)+1./float(nvecinos(i))

		endif
	     enddo

	  enddo	



     	temp = dble(isamemoli)/dble(nvecinos(i))

	write(884,*)i,dble(isamemoli)/dble(nvecinos0(i))

	dist(isamemoli) = dist(isamemoli) + 1.0



	icontapart = icontapart+1

        if(temp.le.0.5.AND.temp.gt.0)then
         histo0_05=histo0_05+1
        endif


        if(temp.le.0.8.AND.temp.gt.0.5)then
         histo05_08=histo05_08+1
        endif
 
        if(temp.le.0.9.AND.temp.gt.0.8)then
         histo08_09=histo08_09+1
	endif
	
	
	 if(temp.le.1.0.AND.temp.gt.0.9)then
         histo09_1=histo09_1+1
        endif

        if(temp.le.0.1.AND.temp.gt.0.)then
         histo0_01=histo0_01+1
        endif

	if(ibucle.eq.1)isamemoliold(i)=isamemoli

	if(abs(isamemoli-isamemoliold(i)).gt.2)then
	ievent(i)=ievent(i)+abs(isamemoli-isamemoliold(i))
	endif	
	isamemoliold(i)=isamemoli

	  ienlaces=ienlaces+nvecinoscl(i)
	enddo


	if(ibucle.ge.146)then

	icontadist=0
	do i=1,200
	dist(i)=dist(i)/dble(nmoltot)
	if(dist(i).gt.0)then
	icontadist = icontadist +1
	endif
	enddo

	distmed = 0
	do i=1,200
	distmed = distmed + dble(i)*dist(i)
	enddo

	rrttime=rporaquiva

	write(1998,*)rrttime,distmed


	endif

	rrttime=rporaquiva

	!if(isame.gt.inicn)then
	!print*,isame,inicn
	!read*,caca
	!endif

	!write(187,*)rrttime,coincidencias/float(inicn)  !float(imoleff)
	write(187,*)rrttime,float(isame)/float(inicn)  !float(imoleff)
	write(137,*)rrttime,float(ienlaces)/2./float(nmoltot) 

         rrttime=rporaquiva


        write(737,*)rrttime, dble(histo08_09)/dble(icontapart)

        write(937,*)rrttime, dble(histo09_1)/dble(icontapart)

        write(637,*)rrttime, dble(histo05_08)/dble(icontapart)

        write(537,*)rrttime, dble(histo0_05)/dble(icontapart)
        write(837,*)rrttime, dble(histo0_01)/dble(icontapart)


	close(187)
	close(137)

	 close(737)
	 close(937)
	close(637)
 	close(537)

	!endif

! Llama a esta subrutina que imprime el cluster mas grande del sistema
! Fine loop su tutte le palle
! qui legge le solide da analizaesta

	if(ibucle.eq.1)then
	do i=1,nmoltot
 	 isolidatt(i)=0
	enddo

	do i=1,nmoltot
	 read(938,*,end=44)ii 
	 isolidatt(ii)=1
	enddo

 44     continue

	endif



	isame=0
	inicn=0
	do i=1,nmoltot

	if(isolidatt(i).eq.0)then

	isamemoli=0

          do j=1,nvecinos0(i)

	   inicn=inicn+1

	     do k=1,nvecinos(i)
	       if(listav0(i,j)-listav(i,k).eq.0)then
		isame=isame+1
		isamemoli=isamemoli+1
		endif
	     enddo

	  enddo	
     	temp = dble(isamemoli)/dble(nvecinos(i))
	icontapart = icontapart+1

	  ienlaces=ienlaces+nvecinoscl(i)

	write(883,*)i,dble(isamemoli)/dble(nvecinos0(i))
	endif

	enddo

	write(982,*)rrttime,float(isame)/float(inicn)  !float(imoleff)


!!!!!!!!!!!!!!!!!!!!!!!!!!!compare solids at time t
	isame=0
	inicn=0
	do i=1,nmoltot

	if(isolidatt(i).eq.1)then

	write(label,'(i4)') i

	do ii=1,200
	distsol(ii) = 0.d0
	enddo



	isamemoli=0

          do j=1,nvecinos0(i)

	   inicn=inicn+1

	     do k=1,nvecinos(i)
	       if(listav0(i,j)-listav(i,k).eq.0)then
		isame=isame+1
		isamemoli=isamemoli+1
		endif
	     enddo

	  enddo	
	
	write(885,*)i,float(isamemoli)/float(nvecinos0(i))
	endif

	
	enddo

8088	format(1x,f12.5,1x,i5,1x,i5)

	write(939,*)rrttime,float(isame)/float(inicn)  !float(imoleff)

 
!	if(ibucle.eq.64)then 
!	do i=1,nmoltot
!	 rfsamemoliv(i)=rfsamemoliv(i)/64.0d0
!	 rfsamemoliv(i)=1.0d0-rfsamemoliv(i)
!	enddo     
!	!call mostest2(ievent,nmoltot,imost)
!	call mostest(rfsamemoliv,imost)
!        call xyzsome(imost,4)
!        !call xyzsome(iseisolid,3)
!	do i=1,nmoltot
!	write(9090,*)i,ievent(i)
!	enddo

!	stop
!	endif

	rewind(883)
	rewind(884)
	rewind(885)

	return
	end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	subroutine mostest2(ivalores,nm,imost)
        include 'parametros_NpT.inc'
        include 'common.inc'
!Input un set de valores asociados a cada molecula, que pueden ser, por ejemplo, 
!la presion o el desplazamiento de cada particula. En array "valores(i)"
!Output: array imost(i) que es 1 si la molecula i esta entre el 5 por ciento
!de las que mas alto valor tiene y 0 si no. 
	dimension imost(natmax),ivalores(natmax)

	nsucento=5

	nmost=nm*nsucento/100

	do i=1,natmax
	 imost(i)=0
	enddo


	do j=1,nmost

	ivalmax=0
	iestmost=0
	do i=1,nm
	if(ivalores(i).gt.ivalmax)then
	 if(imost(i).eq.0)then
	  ivalmax=ivalores(i)
	  iestmost=i
	 endif
	endif
	enddo
	 
	imost(iestmost)=1
	enddo


	return
	end


!***********************************************************************

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

c***********************************************************************
	subroutine veckoos(listav,nvecinos,listav0,nvecinos0)
	include 'parametros_NpT.inc'
 	include 'common.inc'
	
	dimension listav(natmax,50)
	dimension listavlt2(natmax,50)
	dimension listavlt2sor(natmax,50)
	dimension distanciakoos(natmax,50)
	dimension distkoosorted(natmax,50)
	dimension listav0(natmax,50)
	dimension nvecinoslt2(natmax)
	dimension nvecinos0(natmax)
	dimension nvecinos(natmax)
	integer head,next,previous

	pi=acos(-1.)


	  naq=0
	  natperaq=0 
	  
!First we identify the particles within a cut off radious of 2 sigmar
	DO imol=naq+1,nmoltot    !Bucle sobre moleculas

c Sacando esta molecula de la lista
	 
	ic=class(imol)
      call take_outof_list(imol,ic)

c Inicializamos el contador del numero de vecinos de imol
	 nvecinoslt2(imol)=0

c Identificamos en que celdilla esta la molecula i

       numori=puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)
	 imolatom1=numori+1

       xi = xa(imolatom1) - anint( (xa(imolatom1)-half) )
       yi = ya(imolatom1) - anint( (ya(imolatom1)-half) )
       zi = za(imolatom1) - anint( (za(imolatom1)-half) )

       i = int(xi/xlcell) + 1
       j = int(yi/ylcell) + 1
       k = int(zi/zlcell) + 1
 
       icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

c Almacenamos coordenadas
       xi = xa(imolatom1)
       yi = ya(imolatom1)
       zi = za(imolatom1)
 

c Bucle sobre las ntb celdas de la caja de celdas centrada en icell
       do ncell = 1,ntb

        jcell = neighbour_cell(ncell,icell)
        jatm = head(jcell)

c bucle sobre todos los atomos en el interior de la celda jcell
         do while (jatm.ne.0)
	    
c distancias interatomicas en convencion mic
          dx = xa(jatm) - xi
          dy = ya(jatm) - yi
          dz = za(jatm) - zi
 
          tx=dx-anint(dx)
          ty=dy-anint(dy)
          tz=dz-anint(dz)

          txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
          typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
          tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz

          dxmic =txp
          dymic =typ
          dzmic =tzp

	    r2 = (dxmic**2 + dymic**2 + dzmic**2)

	    IF(r2.lt.cutkoos**2)THEN
	
	     molecj=jatm-naq*natperaq+naq
          
	     nvecinoslt2(imol)=nvecinoslt2(imol)+1

	     listavlt2(imol,nvecinoslt2(imol))=molecj
             distanciakoos(imol,nvecinoslt2(imol))=sqrt(r2)
	    ENDIF  !fin de sentencias solo para vecinos
	     
C a por el siguiente atomo de esta caja
 	    jatm=next(jatm) 
	   
	   enddo !fin de bucle sobre atomos de esta celda
	 enddo   !fin de bucle sobre celdas

c Incluyendo la molecula en la lista
 323    call put_in_list(imol,ic)
	ENDDO    !fin de bucle sobre particulas


        DO imol=naq+1,nmoltot    !Bucle sobre moleculas
	call sort(imol,nvecinoslt2(imol),distanciakoos,listavlt2,
     >   distkoosorted,listavlt2sor)

	ikoos=3
	a=rkoos(ikoos,imol,distkoosorted)

!!	write(889,*)"before",imol,a,nvecinoslt2(imol)


	do i=1,nvecinoslt2(imol)

	b=rkoos(ikoos,imol,distkoosorted)

!!	write(889,*)"in",imol,i,nvecinoslt2(imol),a,b

	if(a.lt.b)then
!!	write(889,*)"pluoto",imol,a,b,i
	exit

	else
!!!	endif
!!         write(889,*)"never",imol,a,b,i
	a=b
	ikoos=ikoos+1

	endif

	enddo

	nvecinos(imol)=ikoos

!!	write(889,*)"out",imol,ikoos

!!!!!!!!!!!!!!!!!!!!!!
!	if(ibucle.eq.1)nvecinos0(imol)=nvecinos(imol)
!	do i=1,nvecinos(imol)
!          listav(imol,i)=listavlt2sorted(imol,i)
!          if(ibucle.eq.1)listav0(imol,i)=listav(imol,i)
!	enddo
!!!!!!!!!!
        do i=1,nvecinos(imol)
          listav(imol,i)=listavlt2sor(imol,i)
!          print*,"koos", i,imol, listav(imol,i)
!          if(ibucle.eq.1)listav0(imol,i)=listav(imol,i)
!!		write(889,*)imol,i,listavlt2sor(imol,i)
        enddo

!        if(ibucle.eq.1)then
!		nvecinos0(imol)=nvecinos(imol)
!		do i=1,nvecinos0(imol)
!		listav0(imol,i)=listavlt2sorted(imol,i)
!		enddo	
!	endif	

!!!!!!!!!!!!

	ENDDO


	if(ibucle.eq.1)then
!t=2800	if(ibucle.eq.146)then
	 DO imol=naq+1,nmoltot 

        nvecinos0(imol)=nvecinos(imol)

        do i=1,nvecinos0(imol)
        listav0(imol,i)=listavlt2sor(imol,i)
        enddo   

	enddo

	endif	

	    
	return
	end
c***********************************************************************
	subroutine vecnokoos(listav,nvecinos,listav0,nvecinos0)
	include 'parametros_NpT.inc'
 	include 'common.inc'
	
	dimension listav(natmax,50)
	dimension listav0(natmax,50)
	dimension nvecinos(natmax)
	dimension nvecinos0(natmax)
	integer head,next,previous

	pi=acos(-1.)



	  naq=0
	  natperaq=0 
	  
!First we identify the particles within a cut off radious of 2 sigmar
	DO imol=naq+1,nmoltot    !Bucle sobre moleculas

	


c Sacando esta molecula de la lista
	 
	ic=class(imol)
      call take_outof_list(imol,ic)

c Inicializamos el contador del numero de vecinos de imol
	 nvecinos(imol)=0

c Identificamos en que celdilla esta la molecula i

       numori=puntero1(ic)+(imol-1-puntero2(ic))*nsites(ic)
	 imolatom1=numori+1

       xi = xa(imolatom1) - anint( (xa(imolatom1)-half) )
       yi = ya(imolatom1) - anint( (ya(imolatom1)-half) )
       zi = za(imolatom1) - anint( (za(imolatom1)-half) )

       i = int(xi/xlcell) + 1
       j = int(yi/ylcell) + 1
       k = int(zi/zlcell) + 1
 
       icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

c Almacenamos coordenadas
       xi = xa(imolatom1)
       yi = ya(imolatom1)
       zi = za(imolatom1)
 

c Bucle sobre las ntb celdas de la caja de celdas centrada en icell
       do ncell = 1,ntb

        jcell = neighbour_cell(ncell,icell)
        jatm = head(jcell)

c bucle sobre todos los atomos en el interior de la celda jcell
         do while (jatm.ne.0)
	    
c distancias interatomicas en convencion mic
          dx = xa(jatm) - xi
          dy = ya(jatm) - yi
          dz = za(jatm) - zi
 
          tx=dx-anint(dx)
          ty=dy-anint(dy)
          tz=dz-anint(dz)

          txp=h(1,1)*tx+h(1,2)*ty+h(1,3)*tz
          typ=h(2,1)*tx+h(2,2)*ty+h(2,3)*tz
          tzp=h(3,1)*tx+h(3,2)*ty+h(3,3)*tz

          dxmic =txp
          dymic =typ
          dzmic =tzp

	    r2 = (dxmic**2 + dymic**2 + dzmic**2)


	    IF(r2.lt.rneig**2)THEN

	
	     molecj=jatm-naq*natperaq+naq
          
             nvecinos(imol)=nvecinos(imol)+1



             listav(imol,nvecinos(imol))=molecj

	    ENDIF  !fin de sentencias solo para vecinos
	     
C a por el siguiente atomo de esta caja
 	    jatm=next(jatm) 
	   
	   enddo !fin de bucle sobre atomos de esta celda
	 enddo   !fin de bucle sobre celdas

c Incluyendo la molecula en la lista
 323    call put_in_list(imol,ic)
	ENDDO    !fin de bucle sobre particulas

        if(ibucle.eq.1)then
!t=2800 if(ibucle.eq.146)then
         DO imol=naq+1,nmoltot

        nvecinos0(imol)=nvecinos(imol)

        do i=1,nvecinos0(imol)
        listav0(imol,i)=listav(imol,i)
        enddo

        enddo

        endif   


	    
	return
	end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      subroutine sort(imol,count,data,listavlt2,datasorted,listasorted)
	include 'parametros_NpT.inc'
c
c  This program will determine how many
c  floating point items are in a source file,
c  average and sort the given data.
c
c23456789a123456789b123456789c123456789d123456789e123456789f123456789g12
c
      integer read_unit,write_unit
      integer index,count,string_length,data_length
      real*4 sum
      parameter(data_length = 20)
      dimension data(natmax,50)
      dimension datasorted(natmax,50)
      dimension listavlt2(natmax,50)
      dimension listasorted(natmax,50)
      dimension listasortt(natmax,50)


c
c      variables used for sorting
c
       integer i
c      how many times we have passed through the array
       integer pass  
c      flag variable: 1 if sorted; 0 if not sorted  
       integer sorted 
c      temporary variables used for swapping       
       real*4 temp
c
      integer read_status,write_status
c
c   
c     initialize variables
c
      sum = 0.0

	do i=1,count
	listasortt(imol,i)=listavlt2(imol,i)
!!	write(887,*)imol,i,listasortt(imol,i)
	enddo

c
c     sort the data
c
      pass = 1
 1001 continue
      sorted = 1
      do 1005 i = 1,count-pass
        if(data(imol,i) .gt. data(imol,i+1)) then

          temp = data(imol,i)
          data(imol,i) = data(imol,i+1)
          data(imol,i+1) = temp

          indtemp = listasortt(imol,i)
          listasortt(imol,i) = listasortt(imol,i+1)
          listasortt(imol,i+1) = indtemp

          sorted = 0
        endif
 1005 continue
      pass = pass +1
      if(sorted .eq. 0) goto 1001 

      do 1010 index = 1, count
        datasorted(imol,index)=data(imol,index)

!!!!!!!!!

	listasorted(imol,index) =listasortt(imol,index)
!!!!!!!!!!!!
 1010 continue

      return
      end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
	function rkoos(n,imol,distkoosorted)
	include 'parametros_NpT.inc'
        dimension distkoosorted(natmax,60)

	suma=0.
	do i=1,n
	suma=suma+distkoosorted(imol,i)
	enddo

	rkoos=suma/float(n-2)

        return
	end

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!111yyp
	subroutine boxdensity(istate)
      include 'parametros_NpT.inc'
      include 'common.inc'

	dimension istate(natmax)
	dimension npcell(10000),namfcell(10000),nsolcell(10000)
	dimension svircell(10000)
	dimension svircellx(10000),svircelly(10000),svircellz(10000)
	

	do i=1,ntcell
	npcell(i)=0
	namfcell(i)=0
	nsolcell(i)=0
	svircell(i)=0.
	svircellx(i)=0.
	svircelly(i)=0.
	svircellz(i)=0.
	enddo

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do ii=1,nmoltot	

	    xar=xa(ii)
            yar=ya(ii)
            zar=za(ii)
            xar = xar - anint((xar-half) )
            yar = yar - anint((yar-half) )
            zar = zar - anint((zar-half) )

c ****** calculating in which cell is site i

         i = int(xar/xlcell) + 1
         j = int(yar/ylcell) + 1
         k = int(zar/zlcell) + 1

	   icell = i + (j-1)*nxcell + (k-1)*nxcell*nycell

	npcell(icell)=npcell(icell)+1

	svircell(icell)=svircell(icell)+vir(ii)
	
	svircellx(icell)=svircellx(icell)+virx(ii)
	svircelly(icell)=svircelly(icell)+viry(ii)
	svircellz(icell)=svircellz(icell)+virz(ii)

	if(istate(ii).eq.1)then
	  nsolcell(icell)=nsolcell(icell)+1
	elseif(istate(ii).eq.0)then
	  namfcell(icell)=namfcell(icell)+1
	endif

	enddo


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	write(773,*)rporaquiva,"tiempo "
!
      detH=h(1,1)*(h(2,2)*h(3,3)-h(3,2)*h(2,3))
     *-h(2,1)*(h(1,2)*h(3,3)
     *-h(1,3)*h(3,2))+h(3,1)*(h(1,2)*h(2,3)-h(1,3)*h(2,2))

      V=abs(detH)

	vcell=V/float(ntcell)


	do i=1,ntcell


	prescell=1./vcell*(0.5*svircell(i)+npcell(i))

	prescellx=1./vcell*(0.5*svircellx(i)+npcell(i))
	prescelly=1./vcell*(0.5*svircelly(i)+npcell(i))
	prescellz=1./vcell*(0.5*svircellz(i)+npcell(i))
	
	pres_av=1./3.*(prescellx+prescelly+prescellz)

	write(773,*)npcell(i),namfcell(i),nsolcell(i),prescell,pres_av

	

	enddo

	return
	end
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!111yyp
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	subroutine decidethereissolid
        include 'parametros_NpT.inc'
        include 'common.inc'

	open(723,file='tienesolidosono.dat')

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!With the following criterion a configuration is rejected
!if there is more than xpercent per cent particles with q6bartot > rhastaaqui 

	xpercent=2.
	rntolero=float(nmoltot)*xpercent/100.
	nq6btgtx=0
	rhastaaqui=0.28

	do i=1,nmoltot
	  if(q6bartot(i).gt.rhastaaqui)then 
	   nq6btgtx=nq6btgtx+1
	  endif
	enddo

	frac=float(nq6btgtx)/float(nmoltot)

! If you want to bias over the fraction of solid particles
!	if(float(nq6btgtx).gt.rntolero)then
!	  write(723,*)frac
!	else
!	  write(723,*)frac
!	endif

!If you want to bias over the biggest cluster size
	write(723,*)ncb

	print*,ncb

	return
	end



