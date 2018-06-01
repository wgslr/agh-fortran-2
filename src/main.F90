#ifndef _MODULE
#define _MODULE naive
#endif

program main
  use _MODULE
  implicit none

  ! real ( kind = 8) :: first(2,3) ! pierwsza macierz
  ! real ( kind = 8) :: second(3 ,2) ! druga macierz
  ! real ( kind = 8) :: multiply(2,2) ! macierz wynikowa
  integer ( kind = 4) :: i

  ! first = reshape([1, 4, 2, 5, 3, 6], shape(first))
  ! second = reshape([10, 1000, 100000, 100, 10000, 1000000], shape(second))
  
  ! print *, first
  ! print *, second
  ! print *, multiply
  ! call mm(first, second, multiply, status)
  ! print *, "Called mm"
  ! print *, multiply
  ! print *
  ! print *, MATMUL(first, second)

  print *, modname()

  do i = 10, 30, 1
    print *, i
    call measure(i)
  end do
  do i = 600, 610, 1
    print *, i
    call measure(i)
  end do

  do i = 580, 600, 1
    print *, i
    call measure(i)
  end do

  do i = 1, 1000, 10
    call measure(i)
  end do
  contains

  subroutine measure(size)
    implicit none
    integer (kind=4) :: status, clock, size
    real (kind=8) :: first(size,size), second(size, size), multiply(size, size), start, stop

    first = 1.5
    second = 2.5

    ! call start_clock(clock)

    ! call cpu_time(start)

    call mm(first, second, multiply, status)

!  result   write(*, *) 'dtime : ', dtime
        ! put code to test here
    ! call cpu_time(stop)
    ! print *, size
    print '("Time = ",f6.3," seconds.")', (stop - start)

  end subroutine

end program main
