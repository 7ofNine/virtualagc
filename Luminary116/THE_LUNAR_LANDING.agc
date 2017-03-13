### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    THE_LUNAR_LANDING.agc
## Purpose:     A section of Luminary revision 116.
##              It is part of the source code for the Lunar Module's (LM)
##              Apollo Guidance Computer (AGC) for Apollo 12.
##              This file is intended to be a faithful transcription, except
##              that the code format has been changed to conform to the
##              requirements of the yaYUL assembler rather than the
##              original YUL assembler.
## Reference:   pp. 778-785
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2017-01-22 MAS  Created from Luminary 99.
##              2017-03-10 HG   Transcribed

## Page 778
                BANK            32
                SETLOC          F2DPS*32
                BANK

                EBANK=          E2DPS

#          ****************************************
#          P63: THE LUNAR LANDING, BRAKING PHASE
#          ****************************************

                COUNT*          $$/P63

P63LM           TC              PHASCHNG
                OCT             04024
## Note: The above label (P63LM) has a box in blue pen drawn arround it
##       The two statements above are circled with a blue pen arround them

                TC              BANKCALL                        # DO IMU STATUS CHECK ROUTINE R02
                CADR            R02BOTH

                CAF             P63ADRES                        # INITIALIZE WHICH FOR BURNBABY
                TS              WHICH

                CAF             DPSTHRSH                        # INITIALIZE DVMON
                TS              DVTHRUSH
                CAF             FOUR
                TS              DVCNTR

                CS              ONE                             # INITIALIZE WCHPHASE AND FLPASS0
                TS              WCHPHASE

                CA              ZERO
                TS              FLPASS0

                CS              BIT14
                EXTEND
                WAND            CHAN12                          # REMOVE TRACK-ENABLE DISCRETE.

FLAGORGY        TC              INTPRET                         # DIONYSIAN FLAG WAVING
                CLEAR           CLEAR
                                NOTHROTL
                                REDFLAG
                CLEAR           SET
                                LRBYPASS
                                MUNFLAG
                CLEAR           CLEAR
                                P25FLAG                         # TERMINATE P25 IF IT IS RUNNING.
                                RNDVZFLG                        # TERMINATE P20 IF IT IS RUNNING

                                                                # ****************************************

IGNALG          SETPD           VLOAD                           # FIRST SET UP INPUTS FOR RP-TO-R:-

## Page 779
                                0                               #   AT 0D LANDING SITE IN MOON FIXED FRAME
                                RLS                             #   AT 6D ESTIMATED TIME OF LANDING
                PDDL            PUSH                            #   MPAC NON-ZERO TO INDICATE LUNAR CASE
                                TLAND
                STCALL          TPIP                            # ALSO SET TPIP FOR FIRST GUIDANCE PASS
                                RP-TO-R
                VSL4            MXV
                                REFSMMAT
                STCALL          LAND
                                GUIDINIT                        # GUIDINIT INITIALIZES WM AND /LAND/
                DLOAD           DSU
                                TLAND
                                GUIDDURN
                STCALL          TDEC1                           # INTEGRATE STATE FORWARD TO THAT TIME
                                LEMPREC
                SSP             VLOAD
                                NIGNLOOP
                                40D
                                UNITX
                STOVL           CG
                                UNITY
                STOVL           CG              +6
                                UNITZ
                STODL           CG              +14
                                99999CON
                STOVL           DELTAH                          # INITIALIZE DELTAH FOR V16N68 DISPLAY
                                ZEROVECS
                STODL           UNFC/2                          # INITIALIZE TRIM VELOCITY CORRECTION TERM
                                HI6ZEROS
                STORE           TTF/8

IGNALOOP        DLOAD
                                TAT
                STOVL           PIPTIME1
                                RATT1
                VSL4            MXV
                                REFSMMAT
                STCALL          R
                                MUNGRAV
                STCALL          GDT/2
                                ?GUIDSUB                        # WHICH DELIVERS N PASSES OF GUIDANCE

# DDUMCALC IS PROGRAMMED AS FOLLOWS:-

#                                       2                                           -
#            (RIGNZ - RGU )/16 + 16(RGU  )KIGNY/B8 + (RGU - RIGNX)KIGNX/B4 + (ABVAL(VGU) - VIGN)KIGNV/B4
#                        2             1                 0
#     DDUM = -------------------------------------------------------------------------------------------
#                                            10
#                                           2   (VGU - 16 VGU KIGNX/B4)

## Page 780
#                                                   2        0

# THE NUMERATOR IS SCALED IN METERS AT 2(28).   THE DENOMINATOR IS A VELOCITY IN UNITS OF 2(10)M/CS.
# THE QUOTIENT IS THUS A TIME IN UNITS OF 2(18) CENTISECONDS.   THE FINAL SHIFT RESCALES TO UNITS OF 2(28) CS.
# THERE IS NO DAMPING FACTOR.   THE CONSTANTS KIGNX/B4, KIGNY/B8 AND KIGNV/B4 ARE ALL NEGATIVE IN SIGN.

DDUMCALC        TS              NIGNLOOP
                TC              INTPRET
                DLOAD           DMPR                            # FORM DENOMINATOR FIRST
## Note: The above operator and operand are separately underlined with a black pen.
##       The corresponding octal opcode in the resulting listing is marked with a box around it in  black pen.
                                VGU
                                KIGNX/B4
                SL4R            BDSU
                                VGU             +4
                PDDL            DSU
                                RIGNZ
                                RGU             +4
                SR4R            PDDL
                                RGU             +2
                DSQ             DMPR
                                KIGNY/B8
                SL4R            PDDL
                                RGU
                DSU             DMPR
                                RIGNX
                                KIGNX/B4
                PDVL            ABVAL
                                VGU
                DSU             DMPR
                                VIGN
                                KIGNV/B4
                DAD             DAD
                DAD             DDV
                SRR
                                10D

                PUSH            DAD
                                PIPTIME1
                STODL           TDEC1                           # STORE NEW GUESS FOR NEXT INTEGRATION
                ABS             DSU
                                DDUMCRIT
                BMN             CALL
                                DDUMGOOD
                                INTSTALL
                SET             SET
                                INTYPFLG
                                MOONFLAG
                DLOAD
                                PIPTIME1
                STOVL           TET                             # HOPEFULLY ?GUIDSUB DID NOT
                                RATT1                           #   CLOBBER RATT1 AND VATT1

## Page 781
                STOVL           RCV
                                VATT1
                STCALL          VCV
                                INTEGRVS
                GOTO
                                IGNALOOP

DDUMGOOD        SLOAD           SR
                                ZOOMTIME
                                14D
                BDSU
                                TDEC1
                STOVL           TIG                             # COMPUTE DISTANCE LANDING SITE WILL BE
                                V                               #   OUT OF LM'S ORBITAL PLANE AT IGNITION:
                VXV             UNIT                            #   SIGN IS + IF LANDING SITE IS TO THE
                                R                               #   RIGHT, NORTH; - IF TO THE LEFT, SOUTH.
                DOT             SL1
                                LAND
R60INIT         STOVL           OUTOFPLN                        # INITIALIZATION FOR CALCMANU
                                UNFC/2
                STORE           R60VSAVE                        # STORE UNFC/2 TEMPORARILY IN R60SAVE
                EXIT
                                                                # ****************************************

IGNALGRT        TC              PHASCHNG                        # PREVENT REPEATING IGNALG
                OCT             04024

ASTNCLOK        CS              ASTNDEX
                TC              BANKCALL
                CADR            STCLOK2
                TCF             ENDOFJOB                        # RETURN IN NEW JOB AND IN EBANK FIVE

ASTNRET         TC              INTPRET
                SSP             RTB                             # GO PICK UP DISPLAY AT END OF R51:
                                QMAJ                            #   "PROCEED" WILL DO A FINE ALIGNMENT
                FCADR           P63SPOT2                        #   "ENTER" WILL RETURN TO P63SPOT2
                                R51P63
P63SPOT2        VLOAD           UNIT                            # INITIALIZE KALCMANU FOR BURN ATTITUDE
                                R60VSAVE
                STOVL           POINTVSM
                                UNITX
                STORE           SCAXIS
                EXIT

                CAF             EBANK7
                TS              EBANK

                INHINT
                TC              IBNKCALL
                CADR            PFLITEDB

## Page 782
                RELINT

                TC              BANKCALL
                CADR            R60LEM

                TC              PHASCHNG                        # PREVENT RECALLING R60
                OCT             04024

P63SPOT3        CA              BIT6                            # IS THE LR ANTENNA IN POSITION 1 YET
                EXTEND
                RAND            CHAN33
                EXTEND
                BZF             P63SPOT4                        # BRANCH IF ANTENNA ALREADY IN POSITION 1

                CAF             CODE500                         # ASTRONAUT: PLEASE CRANK THE
                TC              BANKCALL                        #            SILLY THING AROUND
                CADR            GOPERF1
                TCF             GOTOPOOH                        # TERMINATE
                TCF             P63SPOT3                        # PROCEED    SEE IF HE'S LYING

P63SPOT4        TC              BANKCALL                        # ENTER      INITIALIZE LANDING RADAR
                CADR            SETPOS1

                TC              POSTJUMP                        # OFF TO SEE THE WIZARD...
                CADR            BURNBABY


#               --------------------------------------------

#                      CONSTANTS FOR P63LM AND IGNALG


P63ADRES        GENADR          P63TABLE


ASTNDEX         =               MD1                             # OCT 25;  INDEX FOR CLOKTASK

CODE500         OCT             00500


99999CON        2DEC            30479.7         B-24
GUIDDURN        2DEC            +66440                          #         GUIDDURN +6.64400314 E+2
DDUMCRIT        2DEC            +8              B-28            # CRITERION FOR IGNALG CONVERGENCE

## Page 783
#               ---------------------------------------------

## Page 784
#               ****************************************
#               P68: LANDING CONFIRMATION
#               ****************************************

                BANK            34
                SETLOC          F2DPS*31
                BANK

                COUNT*          $$/P6567

LANDJUNK        TC              PHASCHNG
                OCT             04024

                INHINT
                TC              BANKCALL                        # ZERO ATTITUDE ERROR
                CADR            ZATTEROR

                TC              INTPRET                         # TO INTERPRETIVE AS TIME IS NOT CRITICAL
                SET                                             # PREVENT RCS JET FIRINGS IF MODE CONT IS
                                PULSEFLG                        # IN ATT HOLD
                SET             CLEAR
                                SURFFLAG
                                LETABORT
                SET             VLOAD
                                APSFLAG
                                RN
                STODL           ALPHAV
                                PIPTIME
                SET             CALL
                                LUNAFLAG
                                LAT-LONG
                SETPD           VLOAD                           # COMPUTE RLS AND STORE IT AWAY
                                0
                                RN
                VSL2            PDDL
                                PIPTIME
                PUSH            CALL
                                R-TO-RP
                STORE           RLS
                EXIT
                CAF             V06N43*                         # ASTRONAUT: NOW LOOK WHERE YOU ENDED UP
                TC              BANKCALL
                CADR            GOFLASH
                TCF             GOTOPOOH                        # TERMINATE
                TCF             +2                              # PROCEED
                TCF             -5                              # RECYCLE


                TC              INTPRET
                VLOAD                                           # INITIALIZE GSAV AND (USING REFMF)

## Page 785
                                UNITX                           # YNBSAV, ZNBSAV AND ATTFLAG FOR P57
                STCALL          GSAV
                                REFMF
                EXIT

                TCF             GOTOPOOH                        # ASTRONAUT: PLEASE SELECT P57


V06N43*         VN              0643
