### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    DAP_INTERFACE_SUBROUTINES.agc
## Purpose:     A section of Luminary revision 116.
##              It is part of the source code for the Lunar Module's (LM) 
##              Apollo Guidance Computer (AGC) for Apollo 12.
##              This file is intended to be a faithful transcription, except
##              that the code format has been changed to conform to the
##              requirements of the yaYUL assembler rather than the
##              original YUL assembler.
## Reference:   pp. 1396-1399
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2017-01-22 MAS  Created from Luminary 99.
##              2017-02-08 NV   Updated for Luminary 116.
##		2017-03-10 RSB	Proofed comment text via 3-way diff vs
##				Luminary 99 and 132 ... no problems found.

## Page 1396
                BANK            20                              
                SETLOC          DAPS3                           
                BANK                                            

                EBANK=          CDUXD                           
                COUNT*          $$/DAPIF                        

# MOD 0         DATE    11/15/66        BY GEORGE W. CHERRY
# MOD 1                  1/23/67        MODIFICATION BY PETER ADLER

# FUNCTIONAL DESCRIPTION
#       HEREIN ARE A COLLECTION OF SUBROUTINES WHICH ALLOW MISSION CONTROL PROGRAMS TO CONTROL THE MODE
#       AND INTERFACE WITH THE DAP.

# CALLING SEQUENCES
#       IN INTERRUPT OR WITH INTERRUPT INHIBITED
#               TC      IBNKCALL
#               FCADR   ROUTINE
#       IN A JOB WITHOUT INTERRUPT INHIBITED
#               INHINT
#               TC      IBNKCALL
#               FCADR   ROUTINE
#               RELINT

# OUTPUT
#       SEE INDIVIDUAL ROUTINES BELOW

# DEBRIS
#       A, L, AND SOMETIMES MDUETEMP                    ODE     NOT IN PULSES MODE

## Page 1397
# SUBROUTINE NAMES:
#       SETMAXDB, SETMINDB, RESTORDB, PFLITEDB
# MODIFIED:     30 JANUARY 1968 BY P S WEISSMAN TO CREATE RESTORDB.
# MODIFIED:     1 MARCH 1968 BY P S WEISSMAN TO SAVE EBANK AND CREATE PFLITEDB

# FUNCTIONAL DESCRIPTION:
#       SETMAXDB - SET DEADBAND TO 5.0 DEGREES
#       SETMINDB - SET DEADBAND TO 0.3 DEGREE
#       RESTORDB - SET DEADBAND TO .3, 1, OR 5 ACCORDING TO BITS 4 AND 5 OF DAPBOOLS
#       PFLITEDB - SET DEADBAND TO 1.0 DEGREE AND ZERO THE COMMANDED ATTITUDE CHANGE AND COMMANDED RATE

#       ALL ENTRIES SET UP A NOVAC JOB TO DO 1/ACCS SO THAT THE TJETLAW SWITCH CURVES ARE POSITIONED TO
#       REFLECT THE NEW DEADBAND.  IT SHOULD BE NOTED THAT THE DEADBAND REFERS TO THE ATTITUDE IN THE P-, U-, AND V-AXES.

# SUBROUTINE CALLED:    NOVAC

# CALLING SEQUENCE:     SAME AS ABOVE
#                       OR      TC RESTORDB +1    FROM ALLCOAST

# DEBRIS:               A, L, Q, RUPTREG1, (ITEMPS IN NOVAC)

RESTORDB        CAE             DAPBOOLS                        # DETERMINE CREW-SELECTED DEADBAND.
                MASK            DBSLECT2                        # CHECK FOR MAX DB (5 DEG)
                EXTEND                                          
                BZF             +2                              
                TCF             SETMAXDB                        # BIT5 DAPBOOLS IS SET - CREW WANTS 5 DEG
                CAE             DAPBOOLS                        
                MASK            DBSELECT                        # CHECK FOR 1 DEG DEADBAND SELECTION
                EXTEND                                          
                BZF             SETMINDB                        

                CAF             POWERDB                         # BIT4 DAPBOOLS IS SET - CREW WANTS 1 DEG
                TCF             SETMAXDB        +1              
SETMAXDB        CAF             WIDEDB                          # SET 5 DEGREE DEADBAND.
 +1             TS              DB                              

                EXTEND                                          # SET UP JOB TO RE-POSITION SWITCH CURVES.
                QXCH            RUPTREG1                        
CALLACCS        CAF             PRIO27                          
                TC              NOVAC                           
                EBANK=          AOSQ                            
                2CADR           1/ACCJOB                        

                TC              RUPTREG1                        # RETURN TO CALLER.

SETMINDB        CAF             NARROWDB                        # SET 0.3 DEGREE DEADBAND.
                TCF             SETMAXDB        +1              
## Page 1398
PFLITEDB        EXTEND                                          # THE RETURN FROM CALLACCS IS TO RUPTREG1.
                QXCH            RUPTREG1                        
                TC              ZATTEROR                        # ZERO THE ERRORS AND COMMANDED RATES.
                CAF             POWERDB                         # SET DB TO 1.0 DEG.
                TS              DB                              
                TCF             CALLACCS                        # SET UP 1/ACCS AND RETURN TO CALLER.
NARROWDB        OCTAL           00155                           # 0.3 DEGREE SCALED AT 45.
WIDEDB          OCTAL           03434                           # 5.0 DEGREES SCALED AT 45.
POWERDB         DEC             .02222                          # 1.0 DEGREE SCALED AT 45.

ZATTEROR        CAF             EBANK6                          
                XCH             EBANK                           
                TS              L                               # SAVE CALLERS EBANK IN L.
                CAE             CDUX                            
                TS              CDUXD                           
                CAE             CDUY                            
                TS              CDUYD                           
                CAE             CDUZ                            
                TS              CDUZD                           
                TCF             STOPRATE        +3              

STOPRATE        CAF             EBANK6                          
                XCH             EBANK                           
                TS              L                               # SAVE CALLERS EBANK IN L.
 +3             CAF             ZERO                            
                TS              OMEGAPD                         
                TS              OMEGAQD                         
                TS              OMEGARD                         
                TS              DELCDUX                         
                TS              DELCDUY                         
                TS              DELCDUZ                         
                TS              DELPEROR                        
                TS              DELQEROR                        
                TS              DELREROR                        
                LXCH            EBANK                           # RESTORE CALLERS EBANK.
                TC              Q                               

# SUBROUTINE NAME:      ALLCOAST
# WILL BE CALLED BY FRESH STARTS AND ENGINE OFF ROUTINES.               .

# CALLING SEQUENCE:     (SAME AS ABOVE)

# EXIT:                 RETURN TO Q.

# SUBROUTINES CALLED:   STOPRATE, RESTORDB, NOVAC

# ZERO:                 (FOR ALL AXES) AOS, ALPHA, AOSTERM, OMEGAD, DELCDU, DELEROR

## Page 1399
# OUTPUT:               DRIFTBIT/DAPBOOLS, DB, JOB TO DO 1/ACCS

# DEBRIS:               A, L, Q, RUPTREG1, RUPTREG2, (ITEMPS IN NOVAC)

ALLCOAST        EXTEND                                          # SAVE Q FOR RETURN
                QXCH            RUPTREG2                        
                TC              STOPRATE                        # CLEAR RATE INTERFACE.  RETURN WITH A=0
                LXCH            EBANK                           # AND L=EBANK6.  SAVE CALLERS EBANK.
                TS              AOSQ                            
                TS              AOSQ            +1              
                TS              AOSR                            
                TS              AOSR            +1              
                TS              ALPHAQ                          # FOR DOWNLIST.
                TS              ALPHAR                          
                TS              AOSQTERM                        
                TS              AOSRTERM                        
                LXCH            EBANK                           # RESTORE EBANK (EBANK6 NO LONGER NEEDED)

                CS              DAPBOOLS                        # SET UP DRIFTBIT
                MASK            DRIFTBIT                        
                ADS             DAPBOOLS                        
                TC              RESTORDB        +1              # RESTORE DEADBANK TO CREW-SELECTED VALUE.

                TC              RUPTREG2                        # RETURN.

