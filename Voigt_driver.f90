  ! DRIVER CODE FOR VOIGT_RK FOR ACCURACY CHECK AND EFFICIENCY BENCHMARK
  ! FOR INLINE COMPILATION USE
  ! "gfortran -o3 set_rk.f90 Faddeyeva_v3_mod_rk.f90 Voigt_mod_rk.f90 Voigt_driver.f90  -o Voigt_driver"
  ! MOFREH R ZAGHLOUL
  ! UNITED ARAB EMIRATES UNIVERSITY
  ! OCTOBER 23, 2024
  
  PROGRAM VOIGT_DRIVER

    USE, INTRINSIC :: IEEE_ARITHMETIC
    USE SET_RK, ONLY: RK
    USE FADDEYEVA_V3_MOD_RK, ONLY: FADDEYEVA_V3_RK
    USE VOIGT_MOD_RK, ONLY: HUMLIK, VOIGT_RK

    IMPLICIT NONE

    INTEGER, PARAMETER :: NV = 40000 ! NUMBER OF POINTS IN ONE PROFILE
    REAL (RK) :: DX                ! STEP IN X (TYPICALLY REDUCED WAVELENGTH)
    REAL (RK) :: XM                ! MAXIMUM EXTENT OF X
    REAL (RK) :: Y                 ! CONSTANT Y PARAMETER FOR 1 PROFILE
    REAL (RK), DIMENSION (NV) :: X2, Y2, Y_PRESENT, V ! AUXILIARY ARRAYS
    COMPLEX (RK), DIMENSION (NV) :: Z2, W_REF
    INTEGER :: I, J, K, JN, NP_Y
    REAL (RK) :: TIME_BEGIN, TIME_END, ELAPSED_TIME, Y_MIN
    REAL (RK) :: ERR_MAX_V_PRSNT, ERR_RE_W_MAX_OLD, ERR_MAX_V_HUMLIK, ERR_MAX_VOIGT


    XM = 20.0_RK                   ! PROFILE GOES FROM -XM TO +XM
    DX = 2.0_RK*XM/REAL(NV, RK)     ! BY STEPS OF DX                

    DO I = 1, NV                    ! NV: NUMBER OF ELEMENTS IN THE X-VECTOR
      X2(I) = -XM + DX*REAL(I, RK)
    END DO

    Y_MIN = 1.0E-20_RK
    NP_Y = 45
    
    WRITE (*, *) ' '
    WRITE (*, *) '************************************************* '
    WRITE (*, *) 'ACCURACY CHECK USING FADDEYEVA_V3 AS A REFERENCE'
    WRITE (*, *) '************************************************* '

    Y = Y_MIN

    DO J = 1, NP_Y

      Z2 = CMPLX(X2, Y, KIND=RK)
      CALL FADDEYEVA_V3_RK(Z2, W_REF, 14)
      CALL HUMLIK(1, NV, X2, Y, Y2)
      CALL VOIGT_RK(1, NV, X2, Y, Y_PRESENT)


      ERR_MAX_V_HUMLIK = 0.0E0_RK
      DO JN = 1, NV
        IF (ABS(REAL(W_REF(JN),KIND=RK))>0.0E0_RK) THEN
          ERR_RE_W_MAX_OLD = ERR_MAX_V_HUMLIK
          ERR_MAX_V_HUMLIK = MAX(ERR_RE_W_MAX_OLD, ABS(Y2(JN)-REAL(W_REF(JN), &
            KIND=RK))/ABS(REAL(W_REF(JN),KIND=RK)))
          IF (ERR_MAX_V_HUMLIK>ERR_RE_W_MAX_OLD) THEN
          END IF
        END IF
      END DO


      ERR_MAX_VOIGT = 0.0E0_RK
      DO JN = 1, NV
        IF (ABS(REAL(W_REF(JN),KIND=RK))>0.0E0_RK) THEN
          ERR_RE_W_MAX_OLD = ERR_MAX_VOIGT
          ERR_MAX_VOIGT = MAX(ERR_RE_W_MAX_OLD, ABS(Y_PRESENT(JN)-REAL(W_REF(JN), &
            KIND=RK))/ABS(REAL(W_REF(JN),KIND=RK)))
          IF (ERR_MAX_VOIGT>ERR_RE_W_MAX_OLD) THEN
          END IF
        END IF
      END DO

      WRITE (*, '(A6,ES11.3E3,1X,A25,ES11.3E3,A25,ES11.3E3 )') 'Y =', Y, 'ER_VOIGT_RK=', &
        ERR_MAX_VOIGT, 'ER_HUMLIK=', ERR_MAX_V_HUMLIK

      Y = Y*SQRT(10.0_RK)
    END DO

    WRITE (*, *) ' '
    WRITE (*, *) '************************************************* '
    WRITE (*, *) 'EFFICIENCY COMPARISON '
    WRITE (*, *) '************************************************* '

    CALL CPU_TIME(TIME_BEGIN)
    DO K = 1, 100
      Y = Y_MIN
      DO J = 1, NP_Y
        CALL HUMLIK(1, NV, X2, Y, Y2)
        Y = Y*SQRT(10.0_RK)
      END DO
    END DO
    CALL CPU_TIME(TIME_END)
    ELAPSED_TIME = TIME_END - TIME_BEGIN
    WRITE (*, '(/A,I5,A,G13.6,A)') 'HUMLIK          ', RK, '  ELAPSED TIME =', ELAPSED_TIME, &
      ' PROCESSOR DEPENDENT UNITS'



    ! :-
    CALL CPU_TIME(TIME_BEGIN)
    DO K = 1, 100
      Y = Y_MIN
      DO J = 1, NP_Y
        CALL VOIGT_RK(1, NV, X2, Y, Y_PRESENT)
        Y = Y*SQRT(10.0_RK)
      END DO
    END DO
    CALL CPU_TIME(TIME_END)
    ELAPSED_TIME = TIME_END - TIME_BEGIN
    WRITE (*, '(/A,I5,A,G13.6,A)') 'VOIGT_RK        ', RK, '  ELAPSED TIME =', ELAPSED_TIME, &
      ' PROCESSOR DEPENDENT UNITS'


  END PROGRAM Voigt_driver
