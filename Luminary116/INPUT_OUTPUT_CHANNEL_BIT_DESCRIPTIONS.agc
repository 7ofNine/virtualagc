### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    INPUT_OUTPUT_CHANNEL_BIT_DESCRIPTIONS.agc
## Purpose:     A section of Luminary revision 116.
##              It is part of the source code for the Lunar Module's (LM) 
##              Apollo Guidance Computer (AGC) for Apollo 12.
##              This file is intended to be a faithful transcription, except
##              that the code format has been changed to conform to the
##              requirements of the yaYUL assembler rather than the
##              original YUL assembler.
## Reference:   pp. 54-60
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2017-01-22 MAS  Created from Luminary 99.
##		2017-03-02 RSB	Completed transcription, and then proofed 
##				comment text by diffing vs Luminary 131.

## Page 54

# *** CHANNEL DESCRIPTIONSF WORDS ARE ALLOCATED IN ERASABLE ASSIGNMENTS ***

# CHANNEL 1     IDENTICAL TO COMPUTER REGISTER L (0001)

# CHANNEL 2     IDENTICAL TO COMPUTER REGISTER Q (0002)

# CHANNEL 3     HISCALAR; INPUT CHANNEL; MOST SIGNIFICANT 14 BITS FROM 33 STAGE BINARY COUNTER. SCALE
#               FACTOR IS B23 IN CSEC, SO MAX VALUE ABOUT 23.3 HOURS AND LEAST SIGNIFICANT BIT 5.12 SECS.

# CHANNEL 4     LOSCALAR; INPUT CHANNEL; NEXT MOST SIGNIFICANT 14 BITS FROM THE 33 STAGE BINARY COUNTER
#               ASSOCIATED WITH CHANNEL 3. SCALE FACTOR IS B9 IN  CSEC. SO MAX VAL IS 5.12 SEC AND LEAST
#               SIGNIFICANT BIT IS 1/3200 SEC. SCALE FACTOR OF D.P. WORD WITH CHANNEL 3 IS B23 CSEC.

# CHANNEL 5     PYJETS; OUTPUT CHANNEL; PITCH RCS JET CONTROL.   (REACTION CONTROL SYSTEM) USES BITS 1-8.

# CHANNEL 6     ROLLJETS; OUTPUT CHANNEL; ROLL RCS JET CONTROL.   (REACTION CONTROL SYSTEM) USES BIT 1-8.

# CHANNEL 7     SUPERBNK; OUTPUT CHANNEL; NOT RESET BY RESTART;   FIXED EXTENSION BITS USED TO SELECT THE
#               APPROPRIATE FIXED MEMORY BANK IF FBANK IS 30 OCTAL OR MORE. USES BITS 5-7.

# CHANNEL 10    OUTO; OUTPUT CHANNEL; REGISTER USED TO TRANSMIT  LATCHING-RELAY DRIVING INFORMATION FOR
#               THE DISPLAY SYSTEM. BITS 15-12 ARE SET TO THE ROW NUMBER (1-14 OCTAL) OF THE RELAY TO BE
#               CHANGED AND BITS 11-1 CONTAIN THE REQUIRED SETTINGS FOR THE RELAYS IN THE ROW.

# CHANNEL 11    DSALMOUT; OUTPUT CHANNEL; REGISTER WHOSE BITS ARE USED FOR ENGINE ON-OFF CONTROL AND TO
#               DRIVE INDIVIDUAL INDICATORS OF THE DISPLAY SYSTEM. BITS 1-7 ARE A RELAYS.

#               BIT 1           ISS WARNING
#               BIT 2           LIGHT COMPUTER ACTIVITY LAMP
#               BIT 3           LIGHT UPLINK ACTIVITY LAMP
#               BIT 4           LIGHT TEMP CAUTION LAMP
#               BIT 5           LIGHT KEYBOARD RELEASE LAMP
#               BIT 6           FLASH VERB AND NOUN LAMPS
#               BIT 7           LIGHT OPERATOR ERROR LAMP
## Page 55
#               BIT 8           SPARE
#               BIT 9           TEST CONNECTOR OUTBIT
#               BIT 10          CAUTION RESET
#               BIT 11          SPARE
#               BIT 12          SPARE
#               BIT 13          ENGINE ON
#               BIT 14          ENGINE OFF
#               BIT 15          SPARE

# CHANNEL 12    CHAN12; OUTPUT CHANNEL; BITS USED TO DRIVE NAVIGATION AND SPAECRAFT HARDWARE

#               BIT 1           ZERO RR CDU; CDU'S GIVE RRADAR INFORMATION FOR LM
#               BIT 2           ENABLE CDU RADAR ERROR COUNTERS
#               BIT 3           NOT USED
#               BIT 4           COARSE ALIGN ENABLE OF IMU
#               BIT 5           ZERO IMU CDU'S
#               BIT 6           ENABLE IMU ERROR COUNTER, CDU ERROR COUNTER.
#               BIT 7           SPARE
#               BIT 8           DISPLAY INERTIAL DATA
#               BIT 9           -PITCH GIMBAL TRIM (BELL MOTION) DESCENT ENGINE
#               BIT 10          +PITCH GIMBAL TRIM (BELL MOTION) DESCENT ENGINE
#               BIT 11          -ROLL GIMBAL TRIM (BELL MOTION) DESCENT ENGINE
#               BIT 12          +ROLL GIMBAL TRIM (BELL MOTION) DESCENT ENGINE
#               BIT 13          LR POSITION 2 COMMAND
#               BIT 14          ENABLE RENDESVOUS RADAR LOCK-ON;AUTO ANGLE TRACK'G
#               BIT 15          ISS TURN ON DELAY COMPLETE

## Page 56
# CHANNEL 13    CHAN13; OUTPUT CHANNEL

#               BIT 1           RADAR C         PROPER SETTING OF THE A,B,C MATRIX
#               BIT 2           RADAR B         SELECTS CERTAIN RADAR
#               BIT 3           RADAR A         PARAMETERS TO BE READ.
#               BIT 4           RADAR ACTIVITY
#               BIT 5           NOT USED (CONNECTS AN ALTERNATE INPUT TO UPLINK)
#               BIT 6           SPARE
#               BIT 7           DOWNLINK TELEMETRY WORD ORDER CODE BIT
#               BIT 8           RHC COUNTER ENABLE (READ HAND CONTROLLER ANGLES)
#               BIT 9           START RHC READ INTO COUNTERS IF BIT 8 SET
#               BIT 10          TEST ALARMS, TEST DSKY LIGHTS
#               BIT 11          ENABLE STANDBY
#               BIT 12          RESET TRAP 31-A         ALWAYS APPEAR TO BE SET TO 0
#               BIT 13          RESET TRAP 31-B         ALWAYS APPEAR TO BE SET TO 0
#               BIT 14          RESET TRAP 32           ALWAYS APPEAR TO BE SET TO 0
#               BIT 15          ENABLE T6 RUPT

# CHANNEL 14    CHAN14; OUTPUT CHANNEL; USED TO CONTROL COMPUTER COUNTER CELLS (CDU,GYRO,SPACECRAFT FUNC.

#               BIT 1           OUTLINK ACTIVITY (NOT USED)
#               BIT 2           ALTITUDE RATE OR ALTITIDE SELECTOR
#               BIT 3           ALTITUDE METER ACTIVITY
#               BIT 4           THRUST DRIVE ACTIVITY FOR DESCENT ENGINE
#               BIT 5           SPARE
#               BIT 6           GYRO ENABLE POWER FOR PULSES
#               BIT 7           GYRO SELECT B           PAIR OF BITS IDENTIFIES AXIS OF -
#               BIT 8           GYRO SELECT A           GYRO SYSTEM TO BE TORQUED.
#               BIT 9           GYRO TORQUING COMMAND IN NEGATIVE DIRECTION
## Page 57
#               BIT 10          GYRO ACTIVITY
#               BIT 11          DRIVE CDU S
#               BIT 12          DRIVE CDU T
#               BIT 13          DRIVE CDU Z
#               BIT 14          DRIVE CDU Y
#               BIT 15          DRIVE CDU X

# CHANNEL 15    MNKEYIN; INPUT CHANNEL;KEY CODE INPUT FROM KEYBOARD OF DSKY, SENSED BY PROGRAM WHEN
#               PROGRAM INTERRUPT #5 IS RECEIVED. USES BITS 5-1

# CHANNEL 16    NAVKEYIN; INPUT CHANNEL; OPTICS MARK INFORMATION AND NAVIGA ION PANEL DSKY (CM) OR THRUST
#               CONTROL (LM) SENSED BY PROGRAM WHEN PROGRAM INTER-RUPT #6 IS RECEIVED. USES BITS 3-7 ONLY.

#               BIT 1           NOT ASSIGNED
#               BIT 2           NOT ASSIGNED
#               BIT 3           OPTICS X-AXIS MARK SIGNAL FOR ALIGN OPTICAL TSCOPE
#               BIT 4           OPTICS Y-AXIS MARK SIGNAL FOR AOT
#               BIT 5           OPTICS MARK REJECT SIGNAL
#               BIT 6           DESCENT+ ; CREW DESIRED SLOWING RATE OF DESCENT
#               BIT 7           DESCENT- ; CREW DESIRED SPEEDING UP RATE OF D'CENT

# NOTE: ALL BITS IN CHANNELS 30-33 ARE INVERTED AS SENSED BY THE  PROGRAM, SO THAT A VALUE OF ZERO MEANS
# THAT THE INDICATED SIGNAL IS PRESENT.

# CHANNEL 30    INPUT CHANNEL

#               BIT 1           ABORT WITH DESCENT STAGE
#               BIT 2              UNUSED
#               BIT 3           ENGINE ARMED SIGNAL
#               BIT 4           ABORT WITH ASCENT ENGINE STAGE
#               BIT 5           AUTO THROTTLE; COMPUTER CONTROL OF DESCENT ENGINE
## Page 58
#               BIT 6           DISPLAY INERTIAL DATA
#               BIT 7           RR CDU FAIL
#               BIT 8           SPARE
#               BIT 9           IMU OPERATE WITH NO MALFUNCTION
#               BIT 10          LM COMPUTER (NOT AGS) HAS CONTROL OF LM
#               BIT 11          IMU CAGE COMMAND TO DRIVE IMU GIMBAL ANGLES TO 0.
#               BIT 12          IMU CDU FAIL (MALFUNCTION OF IMU CDU,S)
#               BIT 13          IMU FAIL (MALFUNCTION OF IMU STABILIZATION LOOPS)
#               BIT 14          ISS TURN ON REQUESTED
#               BIT 15          TEMPERATURE OF STABLE MEMBER WITHIN DESIGN LIMITS

# CHANNEL 31    INPUT CHANNEL; BITS ASSOCIATED WITH THE ATTITUDE CONTROLLER, TRANSLATIONAL CONTROLLER,
#               AND SPACECRAFT ATTITUDE CONTROL; USED BY RCS DAP

#               BIT 1           ROTATION (BY RHC) COMMANDED IN POSITIVE PITCH DIRECTION; MUST BE IN MINIMUM IMPULSE MODE.
#                               ALSO POSITIVE ELEVATION CHANGE FOR LANDING POINT  DESIGNATOR
#               BIT 2           AS BIT 1 EXCEPT NEGATIVE PITCH AND ELEVATION
#               BIT 3           ROTATION (BY RHC) COMMANDED IN POSITIVE YAW DIRECTION; MUST BE IN MINUMUM IMPULSE MODE.
#               BIT 4           AS BIT 3 EXCEPT NEGATIVE YAW
#               BIT 5           ROTATION (BY RHC) COMMANDED IN POSITIVE ROLL DIRECTION; MUST BE IN MINIMUM IMPULSE MODE.
#                               ALSO POSITIVE AZIMUTH CHANGE FOR LANDING POINT DESIGNATOR
#               BIT 6           AS BIT 5 EXCEPT NEGATIVE ROLL AND AZIMUTH
#               BIT 7           TRANSLATION IN +X DIRECTION COMMANDED BY THC
#               BIT 8           TRANSLATION IN -X DIRECTION COMMANDED BY THC
#               BIT 9           TRANSLATION IN +Y DIRECTION COMMANDED BY THC
#               BIT 10          TRANSLATION IN -Y DIRECTION COMMANDED BY THC
#               BIT 11          TRANSLATION IN +Z DIRECTION COMMANDED BY THC
#               BIT 12          TRANSLATION IN -Z DIRECTION COMMANDED BY THC
## Page 59
#               BIT 13          ATTITUDE HOLD MODE ON SCS MODE CONTROL SWITCH
#               BIT 14          AUTO STABILIZATION OF ATTITUDE ON SCS MODE SWITCH
#               BIT 15          ATTITUDE CONTROL OUT OF DETENT (RHC NOT IN NEUTRAL

# CHANNEL 32    INPUT CHANNEL.

#               BIT 1              THRUSTERS 2 & 4 DISABLED BY CREW
#               BIT 2              THRUSTERS 5 & 8 DISABLED BY CREW
#               BIT 3              THRUSTERS 1 & 3 DISABLED BY CREW
#               BIT 4              THRUSTERS 6 & 7 DISABLED BY CREW
#               BIT 5              THRUSTERS 14 & 16 DISABLED BY CREW
#               BIT 6              THRUSTERS 13 & 15 DISABLED BY CREW
#               BIT 7              THRUSTERS 9 & 12 DISABLED BY CREW
#               BIT 8              THRUSTERS 10 & 11 DISABLED BY CREW
#               BIT 9              DESCENT ENGINE GIMBALS DISABLED BY CREW
#               BIT 10             APPARENT DESCENT ENGINE GIMBAL FAILURE
#               BIT 14          INDICATES PROCEED KEY IS DEPRESSED

# CHANNEL 33    CHAN33; INPUT CHANNEL; FOR HARDWARE STATUS AND COMMAND INFORMATION. BITS 15-11 ARE FLIP-
#               FLOP BITS RESET BY A CHANNEL "WRITE" COMMAND THAT ARE RESET BY A RESTART & BY T4RUPT LOOP.

#               BIT 1           SPARE
#               BIT 2           RR AUTO-POWER ON
#               BIT 3           RR RANGE LOW SCALE
#               BIT 4           RR DATA GOOD
#               BIT 5           LR RANGE DATA GOOD
#               BIT 6           LR POS1
#               BIT 7           LR POS2
## Page 60
#               BIT 8           LR VEL DATA GOOD
#               BIT 9           LR RANGE LOW SCALE
#               BIT 10          BLOCK UPLINK INPUT
#               BIT 11          UPLINK TOO FAST
#               BIT 12          DOWNLINK TOO FAST
#               BIT 13          PIPA FAIL
#               BIT 14          WARNING OF REPEATED ALARMS: RESTART,COUNTER FAIL, VOLTAGE FAIL,AND SCALAR DOUBLE.
#               BIT 15          LGC OSCILLATOR STOPPED

# CHANNEL 34    DNT M1; OUTPUT CHANNEL; DOWNLINK 1  FIRST OF TWO WORDS SERIALIZATION.
# CHANNEL 35    DNT M2; OUTPUT CHANNEL DOWNLINK 2 SOCOND OF TWO   WORDS SERIALIZATION.


