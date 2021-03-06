module builtin
  contains
  subroutine mm(first, second, multiply, status)
    real ( kind = 8), intent(in) :: first(:,:) ! pierwsza macierz
    real ( kind = 8), intent(in) :: second(: ,:) ! druga macierz
    real ( kind = 8), intent(out) :: multiply(:,:) ! macierz wynikowa
    integer ( kind = 4), intent(out) :: status ! kod błędu, 0 gdy OK
    integer ( kind = 4) :: rows1, rows2, cols1, cols2
    integer ( kind = 4) :: resultshape(2)

    rows1 = size(first, 1)
    cols1 = size(first, 2)
    rows2 = size(second, 1)
    cols2 = size(second, 2)
    resultshape = shape(multiply)

    if (cols1 .NE. rows2) then
      status = 1
      return
    end if

    if (ANY((resultshape - (/rows1, cols2/)) /= 0)) then
      status = 2
      return
    end if

    multiply = matmul(first, second)
    status = 0
  end subroutine

  function modname()
    character(len=32) :: modname
    modname="builtin"
  end function
end module