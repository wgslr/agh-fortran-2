program main
  use naive
  implicit none

  real ( kind = 8) :: first(2,3) ! pierwsza macierz
  real ( kind = 8) :: second(3 ,2) ! druga macierz
  real ( kind = 8) :: multiply(2,2) ! macierz wynikowa
  integer ( kind = 4) :: status ! macierz wynikowa

  first = reshape([1, 4, 2, 5, 3, 6], shape(first))
  second = reshape([10, 1000, 100000, 100, 10000, 1000000], shape(second))
  
  print *, first
  print *, second
  print *, multiply
  call mm(first, second, multiply, status)
  print *, "Called mm"
  print *, multiply
  print *
  print *, MATMUL(first, second)


  contains

end program main
