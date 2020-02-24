module freengfunc
      implicit none
      contains
              subroutine calcfree(rho1,rho2,engxz,engyz)

                      implicit none
                      real(kind=8), parameter :: temp=298.d0 !K
                      real(kind=8), parameter :: kT=0.0019872041*temp !boltzmann constant in kcal/mol.K
                      real,intent(in) :: rho1,rho2
                      real,intent(out) :: engxz,engyz

                      engxz=-kT*log( rho1 )
                      engyz=-kT*log( rho2 )

              end subroutine 

end module freengfunc

