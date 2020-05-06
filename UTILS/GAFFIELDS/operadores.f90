module operadores

  use input
  use populacao
  use selecao
  use objetivo

  real(8) murat

  save murat

contains

  subroutine geracao

    implicit none

    call cruzamento(opcr)

    call mutacao

    call convert_float

    call elitismo

    call avaliacao

    return

  end subroutine geracao

  subroutine cruzamento(op)

    implicit none

    integer i,j,npopx,nx,nxx,op
    real dummy,dummyl

    npopx=nint(txgr*npop)
    npopx=npopx-mod(npopx,2)

    !-definindo geracao atual

    call codificacao

    if(op.eq.0)goto 1
    if(op.eq.1)goto 2
    if(op.eq.2)goto 3
    if(op.eq.3)goto 4

1   do i=1,npop
       do j=1,ncron
          binl(ix0(i),j)=bin(ix0(i),j)
       end do
    end do

    goto 10

2   call RANDOM_NUMBER(dummy)

    nx=nint(dummy*ncron)

    do i=1,npopx,2
       do j=1,nx
          binl(ix0(i),j)=bin(ix0(i),j)
          binl(ix0(i+1),j)=bin(ix0(i+1),j)
       end do
       do j=1+nx,ncron
          binl(ix0(i),j)=bin(ix0(i+1),j)
          binl(ix0(i+1),j)=bin(ix0(i),j)
       end do
    end do

    do i=1+npopx,npop
       do j=1,ncron
          binl(ix0(i),j)=bin(ix0(i),j)
       end do
    end do

    goto 10

3   call RANDOM_NUMBER(dummy)
    call RANDOM_NUMBER(dummyl)

!    dummy=0.9*dummy
!    dummyl=max(dummyl,dummy+0.1)
    dummy=min(dummy,dummyl)
    dummyl=max(dummy,dummyl)

    nx=nint(dummy*ncron)
    nxx=nint(dummyl*ncron)

    do i=1,npopx,2
       do j=1,nx
          binl(ix0(i),j)=bin(ix0(i),j)
          binl(ix0(i+1),j)=bin(ix0(i+1),j)
       end do
       do j=1+nx,nxx
          binl(ix0(i),j)=bin(ix0(i+1),j)
          binl(ix0(i+1),j)=bin(ix0(i),j)
       end do
       do j=1+nxx,nx
          binl(ix0(i),j)=bin(ix0(i),j)
          binl(ix0(i+1),j)=bin(ix0(i+1),j)
       end do
    end do

    do i=1+npopx,npop
       do j=1,ncron
          binl(ix0(i),j)=bin(ix0(i),j)
       end do
    end do

    goto 10

4   do i=1,npopx,2
       do j=1,ncron
          call RANDOM_NUMBER(dummy)
          if(j.ne.int(dummy*ncron))then
             binl(ix0(i),j)=bin(ix0(i),j)
             binl(ix0(i+1),j)=bin(ix0(i+1),j)
          elseif(j.eq.int(dummy*ncron))then
             binl(ix0(i),j)=bin(ix0(i+1),j)
             binl(ix0(i+1),j)=bin(ix0(i),j)
          end if
       end do
    end do

    do i=1+npopx,npop
       do j=1,ncron
          binl(ix0(i),j)=bin(ix0(i),j)
       end do
    end do

    goto 10

10  continue

    return

  end subroutine cruzamento

  subroutine mutacao

    implicit none

    integer i,j,k,ix
    real(8) dummy

    ix=1
    do i=1,npop
       do j=1,ncron
          call RANDOM_NUMBER(dummy)
          if(dummy.le.pmut)then
             imm(ix)=i
             imn(ix)=j
             ix=ix+1
          end if
       end do
    end do

    ix=ix-1

!    if(opcod.eq.1)goto 1 !-binario
!    if(opcod.eq.2)goto 2 !-real
!
!1   do i=1,npop
!       do j=1,ncron
!          do k=1,ix
!             if(i.eq.imm(k).and.j.eq.imn(k))then
!                if(binl(ix0(i),j).eq.0)then
!                   binl(ix0(i),j)=1.0d0
!                elseif(binl(ix0(i),j).eq.1)then
!                   binl(ix0(i),j)=0.0d0
!                end if
!             end if
!          end do
!       end do
!    end do
!
!    goto 10

    do i=1,npop
       do j=1,ncron
          do k=1,ix
             if(i.eq.imm(k).and.j.eq.imn(k))then
                call RANDOM_NUMBER(dummy)
                !binl(ix0(i),j)=(nimax(j)-binl(ix0(i),j))*dummy
                binl(ix0(i),j)=(2.d0*dummy-1.d0)*binl(ix0(i),j)
             end if
          end do
       end do
    end do

    murat=(float(ix)/float(npop*ncron))

    return

  end subroutine mutacao

  subroutine convert_float()

    implicit none

    integer i,j

!    if(opcod.eq.1)goto 1
!    if(opcod.eq.2)goto 2

!1   do i=1,npop
!       decl(i)=0
!       do j=1,ncron
!          decl(i)=decl(i)+nint(binl(i,ncron+1-j)*2**(j-1))
!       end do
!    end do
!
!    do i=1,npop
!       indl(i,1)=nimin(1)+(nimax(1)-nimin(1))*decl(i)/(2**ncron-1)
!    end do
!
!    goto 10

    do i=1,npop
       do j=1,ncron
          indl(i,j)=binl(ix0(i),j)
       end do
    end do

    return

  end subroutine convert_float

  subroutine elitismo

    implicit none

    integer i,j,ibstl
    real(8) fitnessmx,fitnessl,xn(nparam)
    logical chk

    fitnessmx=0.d0
    do i=1,npop
       do j=1,nparam
          xn(j)=indl(i,j)
       end do
!       if(opcod.eq.1)call aptidao_bin(xn,fitnessl)
       call aptidao(xn,fitnessl)
       call rangechk(xn,chk)
       if(fitnessl.ge.fitnessmx.and.chk.eqv..true.)then
          fitnessmx=fitnessl
          ibstl=i
       end if
    end do

    do j=1,nparam
       ind(iwst,j)=indl(ibstl,j)
    end do
    do j=1,ncron
       bin(iwst,j)=binl(ibstl,j)
    end do

    dec(iwst)=decl(ibstl)

    return

  end subroutine elitismo

  subroutine rangechk(xn,chk)

    implicit none

    integer i
    real(8) xn(nparam)
    logical chk

    chk=.true.

    do i=1,nparam
!       if(xn(i).le.nimin(i).or.xn(i).gt.nimax(i))chk=.false.
       if(xn(i).le.nimin(i).or.xn(i).gt.nimax(i))chk=.true.
    end do

    return

  end subroutine rangechk

end module operadores