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
module elements

contains

  subroutine covalent_radius(zat,rc)

    implicit none

    integer zat
    real(8) rc

    select case(zat)
    case(1)
       rc=0.37d0
    case(2)
       rc=0.32d0
    case(3)
       rc=1.34d0
    case(4)
       rc=0.90d0
    case(5)
       rc=0.82d0
    case(6)
       rc=0.77d0
    case(7)
       rc=0.75d0
    case(8)
       rc=0.73d0
    case(9)
       rc=0.71d0
    case(10)
       rc=0.69d0
    case(11)
       rc=1.54d0
    case(12)
       rc=1.30d0
    case(13)
       rc=1.18d0
    case(14)
       rc=1.11d0
    case(15)
       rc=1.06d0
    case(16)
       rc=1.02d0
    case(17)
       rc=0.99d0
    case(18)
       rc=0.97d0
    case(19)
       rc=1.96d0
    case(20)
       rc=1.74d0
    case(21)
       rc=1.44d0
    case(22)
       rc=1.36d0
    case(23)
       rc=1.25d0
    case(24)
       rc=1.27d0
    case(25)
       rc=1.39d0
    case(26)
       rc=1.25d0
    case(27)
       rc=1.26d0
    case(28)
       rc=1.21d0
    case(29)
       rc=1.38d0
    case(30)
       rc=1.31d0
    case(31)
       rc=1.26d0
    case(32)
       rc=1.22d0
    case(33)
       rc=1.19d0
    case(34)
       rc=1.16d0
    case(35)
       rc=1.14d0
    case(36)
       rc=1.10d0
    case(37)
       rc=2.11d0
    case(38)
       rc=1.92d0
    case(39)
       rc=1.62d0
    case(40)
       rc=1.48d0
    case(41)
       rc=1.37d0
    case(42)
       rc=1.45d0
    case(43)
       rc=1.56d0
    case(44)
       rc=1.26d0
    case(45)
       rc=1.35d0
    case(46)
       rc=1.31d0
    case(47)
       rc=1.53d0
    case(48)
       rc=1.48d0
    case(49)
       rc=1.44d0
    case(50)
       rc=1.41d0
    case(51)
       rc=1.38d0
    case(52)
       rc=1.35d0
    case(53)
       rc=1.33d0
    case(54)
       rc=1.30d0
    end select

    return

  end subroutine covalent_radius

end module elements
