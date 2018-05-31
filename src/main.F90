program main
  use naive
  implicit none

  real ( kind = 8) :: first(2,3) ! pierwsza macierz
  real ( kind = 8) :: second(3 ,2) ! druga macierz
  real ( kind = 8) :: multiply(2,3) ! macierz wynikowa
  integer ( kind = 4) :: status ! macierz wynikowa
  
  first = 5
  print *, first
  print *, multiply
  call mm(first, second, multiply, status)
  print *, "Called mm"
  print *, first
  print *, multiply


  contains

end program main
