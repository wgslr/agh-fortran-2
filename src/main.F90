#ifndef _MODULE
#define _MODULE naive
#endif

program main
  use _MODULE
  implicit none
  integer ( kind = 8) :: i, n, step, parse_result
  character(len=10) :: arg

  if (command_argument_count() .NE. 2) then
    n = 1000
    step = 1
  else
    call get_command_argument(1, arg)
    read(arg, *, iostat=parse_result) n
    call get_command_argument(2, arg)
    read(arg, *, iostat=parse_result) step
  end if

  do i = 1, n, step
    call measure(i)
  end do
  contains

  subroutine measure(isize)
    implicit none
    integer (kind=4) :: status
    integer (kind=8), intent(in) :: isize
    real (kind=8), allocatable :: first(:,:), second(:, :), multiply(:, :)
    real (kind=8) :: start, stop

    allocate(first(isize, isize))
    allocate(second(isize, isize))
    allocate(multiply(isize, isize))

    first = 1.1
    second = 2.3

    call cpu_time(start)
    call mm(first, second, multiply, status)
    call cpu_time(stop)

    print '(A,";",i6,";",f10.7,"")', modname(), isize,(stop - start)

    deallocate(first)
    deallocate(second)
    deallocate(multiply)
  end subroutine

end program main
