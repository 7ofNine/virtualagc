### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	P76.agc
## Purpose: 	Part of the source code for Luminary 1A build 099.
##		It is part of the source code for the Lunar Module's (LM)
##		Apollo Guidance Computer (AGC), for Apollo 11.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo.
## Pages:	709-711
## Mod history:	2009-05-19 RSB	Adapted from the corresponding 
##				Luminary131 file, using page 
##				images from Luminary 1A.
##		2016-12-13 RSB	GOTOP00H -> GOTOPOOH
##		2016-12-14 RSB	Proofed text comments with octopus/ProoferComments
##				and corrected the errors found.
##
## This source code has been transcribed or otherwise adapted from
## digitized images of a hardcopy from the MIT Museum.  The digitization
## was performed by Paul Fjeld, and arranged for by Deborah Douglas of
## the Museum.  Many thanks to both.  The images (with suitable reduction
## in storage size and consequent reduction in image quality as well) are
## available online at www.ibiblio.org/apollo.  If for some reason you
## find that the images are illegible, contact me at info@sandroid.org
## about getting access to the (much) higher-quality images which Paul
## actually created.
##
## Notations on the hardcopy document read, in part:
##
##	Assemble revision 001 of AGC program LMY99 by NASA 2021112-61
##	16:27 JULY 14, 1969 

## Page 709
# 1)	PROGRAM NAME - TARGET DELTA V PROGRAM (P76).
# 2)	FUNCTIONAL DESCRIPTION - UPON ENTRY BY ASTRONAUT ACTION, P76 FLASHES DSKY REQUESTS TO THE ASTRONAUT
#	TO PROVIDE VIA DSKY (1) THE DELTA V TO BE APPLIED TO THE OTHER VEHICLE STATE VECTOR AND (2) THE
#	TIME (TIG) AT WHICH THE OTHER VEHICLE VELOCITY WAS CHANGED BY EXECUTION OF A THRUSTING MANEUVER. THE
#	OTHER VEHICLE STATE VECTOR IS INTEGRATED TO TIG AND UPDATED BY THE ADDITION OF DELTA V (DELTA V HAVING
#	BEEN TRANSFORMED FROM LV TO REF COSYS).  USING INTEGRVS, THE PROGRAM THEN INTEGRATES THE OTHER
#	VEHICLE STATE VECTOR TO THE STATE VECTOR OF THIS VEHICLE, THUS INSURING THAT THE W-MATRIX AND BOTH VEHICLE
#	STATES CORRESPOND TO THE SAME TIME.
# 3)	ERASABLE INITIALIZATION REQUIRED - NONE.
# 4)	CALLING SEQUENCES AND EXIT MODES - CALLED BY ASTRONAUT REQUEST THRU DSKY V 37 E 76E.
#	EXITS BY TCF ENDOFJOB.
# 5)	OUTPUT - OTHER VEHICLE STATE VECTOR INTEGRATED TO TIG AND INCREMENTED BY DELTA V IN REF COSYS.
#	THE PUSHLIST CONTAINS THE MATRIX BY WHICH THE INPUT DELTA V MUST BE POST-MULTIPLIED TO CONVERT FROM LV
#	TO REF COSYS.
# 6)	DEBRIS - OTHER VEHICLE STATE VECTOR.
# 7)	SUBROUTINES CALLED - BANKCALL, GOXDSPF, CSMPREC (OR LEMPREC), ATOPCSM (OR ATOPLEM), INTSTALL, INTWAKE, PHASCHNG
#	INTPRET, INTEGRVS, AND MINIRECT.
# 8)	FLAG USE - MOONFLAG, CMOONFLAG, INTYPFLG, RASFLAG, AND MARKCTR.

		BANK	30
		SETLOC	P76LOC
		BANK

		COUNT*	$$/P76

		EBANK=	TIG

P76		TC	UPFLAG
		ADRES	TRACKFLG

		TC	INTPRET
		VLOAD
			DELVLVC
		STORE	DELVOV
		EXIT

		CAF	V06N84		# FLASH LAST DELTA V,
		TC	BANKCALL	# AND WAIT FOR KEYBOARD ACTION.
		CADR	GOFLASH
		TCF	ENDP76
		TC	+2		# PROCEED
		TC	-5		# STORE DATA AND REPEAT FLASHING
		CAF	V06N84 +1	# FLASH VERB 06 NOUN 33, DISPLAY LAST TIG,
		TC	BANKCALL	# AND WAIT FOR KEYBOARD ACTION.
		CADR	GOFLASH
		TCF	ENDP76
		TC	+2
		TC	-5
		TC	INTPRET		# RETURN TO INTERPRETIVE CODE
## Page 710
		DLOAD			# SET D(MPAC)=TIG IN CSEC B28
			TIG
		STCALL	TDEC1		# SET TDEC1=TIG FOR ORBITAL INTEGRATION
			OTHPREC
COMPMAT		VLOAD	UNIT
			RATT
		VCOMP			# U(-R)
		STORE	24D		# U(-R) TO 24D
		VXV	UNIT		# U(-R) X V = U(V X R)
			VATT
		STORE	18D
		VXV	UNIT		# U(V X R) X U(-R) = U((R X V) X R)
			24D
		STOVL	12D
			DELVOV
		VXM	VSL1		# V(MPAC)=DELTA V IN REFCOSYS
			12D
		VAD
			VATT
		STORE	6		# V(PD6)=VATT + DELTA V
		CALL			# PREVENT WOULD-BE USER OF ORBITAL
			INTSTALL	# INTEG FROM INTERFERING WITH UPDATING
		CALL
			P76SUB1
		VLOAD	VSR*
			6
			0,2
		STOVL	VCV
			RATT
		VSR*
			0,2
		STODL	RCV
			TIG
		STORE	TET
		CLEAR	DLOAD
			INTYPFLG
			TETTHIS
INTOTHIS	STCALL	TDEC1
			INTEGRVS
		CALL
			INTSTALL
		VLOAD
			RATT1
		STORE	RRECT
		STODL	RCV
			TAT
		STOVL	TET
			VATT1
		CALL
			MINIRECT
## Page 711
		EXIT
		TC	PHASCHNG
		OCT	04024

		TC	UPFLAG
		ADRES	REINTFLG

		TC	INTPRET
		CALL
			ATOPOTH
		SSP	EXIT
			QPRET
			OUT
		TC	BANKCALL	# PERMIT USE OF ORBITAL INTEGRATION
		CADR	INTWAKE1
OUT		EXIT
ENDP76		CAF	ZERO
		TS	MARKCTR		# CLEAR RR TRACKING MARK COUNTER
		TCF	GOTOPOOH

V06N84		NV	0684
		NV	0633
P76SUB1		AXT,2	SET
			2
			MOONFLAG	# SET MEANS MOON IS SPHERE OF INFLUENCE.
		BON	AXT,2
			CMOONFLG	# SET MEANS PERM CM STATE IN LUNAR SPHERE.
			QPRET
			0
		CLEAR	RVQ
			MOONFLAG



