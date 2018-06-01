module dotcache
  contains
  subroutine mm(first, second, multiply, status)
    real ( kind = 8), intent(in) :: first(:,:) ! pierwsza macierz
    real ( kind = 8), intent(in) :: second(: ,:) ! druga macierz
    real ( kind = 8), intent(out) :: multiply(:,:) ! macierz wynikowa
    integer ( kind = 4), intent(out) :: status ! kod błędu, 0 gdy OK
    integer ( kind = 4) :: rows1, rows2, cols1, cols2 ! kod błędu, 0 gdy OK
    integer ( kind = 4) :: resultshape(2)
    integer(kind = 4) :: i, j, k, jj, kk
    real (kind = 8) :: sum
    integer (kind = 4) :: ichunk

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

    multiply = 0

    ichunk = 512 ! I have a 4MB cache size
    do jj = 1, rows1, ichunk
        do kk = 1, cols2, ichunk

          do j = jj, min(jj + ichunk - 1, rows1)
              do k = kk, min(kk + ichunk - 1, cols2)
                multiply(j, k) = dot_product(first(j, :), second(:, k))
              end do
          end do
        end do
  end do


    status = 0
  end subroutine
end module