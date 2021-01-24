!
!MIT License
!
!Copyright (c) 2020 flavianowilliams
!
!Permission is hereby granted, free of charge, to any person obtaining a copy
!of this software and associated documentation files (the "Software"), to deal
!in the Software without restriction, including without limitation the rights
!to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
!copies of the Software, and to permit persons to whom the Software is
!furnished to do so, subject to the following conditions:
!
!THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
!IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
!FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
!AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
!LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
!OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
!SOFTWARE.
!
program HICOLM
  !*******************************************************************************************
  !programa principal responsavel pelo instanciamento dos objetos                            *
  !*******************************************************************************************

  use prepare_module        ! prepare class to prepare the physical environment

  implicit none

  integer       :: i
  real(8)       :: t0,t1,t2,t3,t4
  real(8)       :: sf_coul,sf_vdw
  character(10) :: host,time
  character(8)  :: date,in
  logical       :: lval

  type(prepare) :: prp      ! instanciating prepare object

  call cpu_time(t0)

  !-abrindo ficheiro de dados

  open(5,file='HICOLM.in',status='old')               ! reading input datas
  open(6,file='HICOLM.out',status='unknown')          ! printing output informations
  open(1,file='HICOLM.XSF',status='unknown')          ! printing atomic coordinates
  open(2,file='.HICOLM.XSF',status='unknown')          ! 
  open(3,file='HICOLM.AXSF',status='unknown')          ! printing coordinates for each frame
  open(4,file='atoms.csv',status='unknown')          ! imprimindo informacoes atomicas
  open(7,file='thermodynamics.csv',status='unknown') ! imprimindo informacoes termodinamicas
  open(8,file='lattice.csv',status='unknown')        ! imprimindo informacoes da rede
  open(9,file='HICOLM.xyz',status='old')             ! 

  t1=0.d0
  t2=0.d0
  t3=0.d0
  t4=0.d0

  !-elapsed time information

  call date_and_time(Date=date)
  call date_and_time(TIME=time)
  call hostnm(host)
!  host='undefined'

  !-cabecalho
  !
  write(6,*)
  write(6,'(18x,a57)')'HICOLM: Multi-Methods for Molecules and Condensed Systems'
  write(6,*)
  write(6,'(39x,a14)')'Version: x.x.x'
  write(6,*)
  write(6,'(''Host: '',2x,a10)')host
  write(6,'(''Date: '',2x,a8)')date
  write(6,'(''Time: '',2x,a10)')time
  write(6,*)

  ! assign 1-4 scale factor according AMBER force field
  !
  sf_coul=1.d0/1.2d0
  sf_vdw=1.d0/2.d0

  !========================================================
  !
  !-read MD option
  !
  lval=.false.
  do while (lval.eqv..false.)
     read(5,*,end=1)in
     if(in.eq.'@PREPARE')then
        prp=prepare()                            ! definindo valores default
        call prp%constants_prepare()             ! definindo constantes
        call prp%molecules()                     ! atribuindo qde moléculas e sitios atomicos
        call prp%set_natom()                     ! calculando qde de sitios atomicos
        call prp%set_lattice_constants()         ! calculando constantes de rede
        call prp%set_lattice_angles()            ! calculando angulos de rede
        call prp%set_volume()                    ! calculando volume da supercelula
        call prp%set_symmetry()                  ! calculando grupo de simetria
        call prp%sites()                         ! atribuindo coordenadas atomicas e Z
        call prp%translate()                     ! aplicando translação do sistema coordenadas
        call prp%molecule_prepare()              ! atribuindo informacoes moleculares
        call prp%set_massmol()                   ! calculando massa molecular
        call prp%set_mmolar()                    ! calculando massa molecular
        call prp%set_scale_factor(sf_coul,sf_vdw)! atribuindo fatores escalonamento 1-4
        call prp%set_internal_coordinates()      ! atribuindo coordenadas internas
        call prp%set_parbnd()                    ! atribuindo potenciais de ligacao
        call prp%set_parbend()                   ! atribuindo potenciais angulares
        call prp%set_extra_parbnd()              ! alterando potenciais intramoleculares
        call prp%set_extra_parbend()             ! alterando potenciais intramoleculares
        call prp%set_parvdw()                    ! atribuindo potenciais de Van der Waals
        call prp%check()                         ! checando parametros de entrada
        call prp%set_global()                    ! imprimindo propriedades globais
        call prp%print_sys()                     ! imprimindo estrutura em HICOLM.sys
        call prp%print_top()                     ! imprimindo topologia em HICOLM.top
        call prp%print_out()                     ! imprimindo valores em HICOLM.out
        lval=.true.
     elseif(in.eq.'@MD     ')then
        lval=.true.
     end if
  end do
  !============================================================================================
  !
  !-print copyright
  !
    write(6,'(93a1)')('#',i=1,93)
    write(6,*)('END!',i=1,23)
    write(6,'(93a1)')('#',i=1,93)
    write(6,*)
    write(6,'(5x,a12)')'MIT License'
    write(6,*)
    write(6,'(5x,a36)')'Copyright (c) 2020 flavianowilliams'
    write(6,*)
    write(6,'(5x,a77)')'Permission is hereby granted, free of charge, to any person obtaining a copy'
    write(6,'(5x,a78)')'of this software and associated documentation files (the "Software"), to deal'
    write(6,'(5x,a77)')'in the Software without restriction, including without limitation the rights'
    write(6,'(5x,a74)')'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell'
    write(6,'(5x,a70)')'copies of the Software, and to permit persons to whom the Software is'
    write(6,'(5x,a57)')'furnished to do so, subject to the following conditions:'
    write(6,*)
    write(6,'(5x,a75)')'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR'
    write(6,'(5x,a73)')'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,'
    write(6,'(5x,a76)')'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE'
    write(6,'(5x,a71)')'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER'
    write(6,'(5x,a78)')'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,'
    write(6,'(5x,a78)')'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE'
    write(6,'(5x,a10)')'SOFTWARE.'
    write(6,*)
    !==========================================================================================

  stop

1 write(6,*)'ERROR: Method does not found!'
  write(6,*)'Hint: You must choose one of the following methods: @PREPARE or @MD'
  stop

end program HICOLM