### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    RESTART_TABLES.agc
## Purpose:     A section of Luminary revision 116.
##              It is part of the source code for the Lunar Module's (LM) 
##              Apollo Guidance Computer (AGC) for Apollo 12.
##              This file is intended to be a faithful transcription, except
##              that the code format has been changed to conform to the
##              requirements of the yaYUL assembler rather than the
##              original YUL assembler.
## Reference:   pp. 238-243
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2017-01-22 MAS  Created from Luminary 99.

## NOTE: Page numbers below have not yet been updated to reflect Luminary 116.

## Page 238
# RESTART TABLES
# --------------

# THERE ARE TWO FORMS OF RESTART TABLES FOR EACH GROUP.  THEY ARE KNOWN AS THE EVEN RESTART TABLES AND THE ODD
# RESTART TABLES.  THE ODD TABLES HAVE ONLY ONE ENTRY OF THREE LOCATIONS WHILE THE EVEN TABLES HAVE TWO ENTRIES
# EACH USING THREE LOCATIONS.  THE INFORMATION AS TO WHETHER IT IS A JOB, WAITLIST, OR A LONGCALL IS GIVEN BY THE
# WAY THINGS ARE PUT IN TO THE TABLES.

#      A JOB HAS ITS PRIORITY STORED IN PRDTTAB OF THE CORRECT PHASE SPOT - A POSITIVE PRIORITY INDICATES A
# FINDVAC JOB, A NEGATIVE PRIORITY A NOVAC.  THE 2CADR OF THE JOB IS STORED IN THE CADRTAB.
# FOR EXAMPLE,

#               5.7SPOT         OCT     23000
#                               2CADR   SOMEJOB

# A RESTART OF GROUP 5 WITH PHASE SEVEN WOULD THEN CAUSE SOMEJOB TO BE RESTARTED AS A FINDVAC WITH PRIORITY 23.

#               5.5SPOT         OCT     -23000
#                               2CADR   ANYJOB

# HERE A RESTART OF GROUP 5 WITH PHASE 7 WOULD CAUSE ANYJOB TO BE RESTARTED AS A NOVAC WITH PRIORITY 23.
# A LONGCALL HAS ITS GENADR OF ITS 2CADR STORED NEGATIVELY AND ITS BBCON STORED POSITIVELY.  IN ITS PRDTTAB IS
# PLACED THE LOCATION OF A DP REGISTER THAT CONTAINS THE DELTA TIME THAT LONGCALL HAD BEEN ORIGINALLY STARTED
# WITH.  EXAMPLE,

#               3.6SPOT         GENADR  DELTAT
#                               -GENADR LONGTASK
#                               BBCON   LONGTASK
#                               OCT     31000
#                               2CADR   JOBAGAIN

# THIS WOULD START UP LONGTASK AT THE APPROPRIATE TIME, OR IMMEDIATELY IF THE TIME HAD ALREADY PASSED.  IT SHOULD
# BE NOTED THAT IF DELTAT IS IN A SWITCHED E BANK, THIS INFORMATOIN SHOULD BE IN THE BBCON OF THE 2CADR OF THE
# TASK.  FROM ABOVE, WE SEE THAT THE SECOND PART OF THIS PHASE WOULD BE STARTED AS A JOB WITH A PRIORITY OF 31.

# WAITLIST CALLS ARE IDENTIFIED BY THE FACT THAT THEIR 2CADR IS STORED NEGATIVELY.  IF PRDTTAB OF THE PHASE SPOT
# IS POSITIVE, THEN IT CONTAINS THE DELTA TIME, IF PRDTTAB IS NEGATIVE THEN IT IS THE -GENADR OF AN ERASABLE
# LOCATION CONTAINING THE DELTA TIME, THAT IS, THE TIME IS STORED INDIRECTLY.  IT SHOULD BE NOTED AS ABOVE, THAT
# IF THE TIME IS STORED INDIRECTLY, THE BBCON MUST CONTAIN THE NECESSARY E BANK INFORMATION IF APPLICABLE.  WITH
# WAITLIST WE HAVE ONE FURTHER OPTION, IF -0 IS STORED IN PRDTTAB, IT WILL CAUSE AN IMMEDIATE RESTART OF THE
# TASK.  EXAMPLES,

#                               OCT     77777           THIS WILL CAUSE AN IMMEDIATE RESTART
#                               -2CADR  ATASK           OF THE TASK :ATASK:
#       
#                               DEC     200             IF THE TIME OF THE 2 SECONDS SINCE DUMMY
#                               -2CADR  DUMMY           WAS PUT ON WAITLIST IS UP, IT WILL BEGIN
#                                                       IN 10 MS, OTHERWISE IT WILL BEGIN WHEN
#                                                       IT NORMALLY WOULD HAVE BEGUN.
## Page 239
#                               -GENADR DTIME           WHERE DTIME CONTAINS THE DELTA TIME
#                               -2CADR  TASKTASK        OTHERWISE THIS IS AS ABOVE

# ***** NOW THE TABLES THEMSELVES *****

                BANK            01                              
                SETLOC          RESTART                         
                BANK                                            

PRDTTAB         EQUALS          12000                           # USED TO FIND THE PRIORITY OR DELTATIME
CADRTAB         EQUALS          12001                           # THIS AND THE NEXT RELATIVE LOC CONTAIN
                                                                # RESTART 2CADR

                COUNT*          $$/RSTAB                        # TABLES IN BANK 1.
SIZETAB         TC              1.2SPOT         -12006          
                TC              1.3SPOT         -12004          
                TC              2.2SPOT         -12006          
                TC              2.3SPOT         -12004          
                TC              3.2SPOT         -12006          
                TC              3.3SPOT         -12004          
                TC              4.2SPOT         -12006          
                TC              4.3SPOT         -12004          
                TC              5.2SPOT         -12006          
                TC              5.3SPOT         -12004          
                TC              6.2SPOT         -12006          
                TC              6.3SPOT         -12004          
1.2SPOT         OCT             21000                           # A DUMMY EXAMPLE TO BE REPLACED AS SOON
                EBANK=          STATE                           
                2CADR           ENDOFJOB                        # AS THERE IS A LEGITIMATE 1.2SPOT

                DEC             100                             
                EBANK=          STATE                           
                2CADR           TASKOVER                        

# ANY MORE GROUP 1.EVEN RESTART VALUES SHOULD GO HERE

1.3SPOT         -GENADR         SAVET-30                        
                EBANK=          DVCNTR                          
                -2CADR          ULLGTASK                        

# ANY MORE GROUP 1.ODD RESTART VALUES SHOULD GO HERE

2.2SPOT         EQUALS          1.2SPOT                         

# ANY MORE GROUP 2.EVEN RESTART VALUES SHOULD GO HERE

2.3SPOT         GENADR          600SECS                         

                -GENADR         STATEINT                        
                EBANK=          RRECTCSM                        
                BBCON           STATEINT                        

## Page 240
2.5SPOT         OCT             05000                           
                EBANK=          RRECTCSM                        
                2CADR           STATINT1                        

2.7SPOT         DEC             1500                            
                EBANK=          LOSCOUNT                        
                -2CADR          P20LEMC1                        

2.11SPOT        OCT             14000                           
                EBANK=          P21TIME                         
                2CADR           P25LEM1                         

2.13SPOT        OCT             10000                           
                EBANK=          LOSCOUNT                        
                2CADR           RELINUS                         

2.15SPOT        OCT             26000                           
                EBANK=          LOSCOUNT                        
                2CADR           R22RSTRT                        

2.17SPOT        OCT             77777                           
                EBANK=          VGPREV                          
                -2CADR          REDO2.17                        

2.21SPOT        DEC             25                              
                EBANK=          DVCNTR                          
                -2CADR          R10,R11                         

# ANY MORE GROUP 2.ODD RESTART VALUES SHOULD GO HERE.

3.2SPOT         EQUALS          1.2SPOT                         

# ANY MORE GROUP 3.EVEN RESTART VALUES SHOULD GO HERE

3.3SPOT         -GENADR         ZOOMTIME                        
                EBANK=          DVCNTR                          
                -2CADR          ZOOM                            

3.5SPOT         OCT             20000                           
                EBANK=          TTOGO                           
                2CADR           S40.13                          

# ANY MORE GROUP 3.ODD RESTART VALUES SHOULD GO HERE

4.2SPOT         DEC             2500                            
                EBANK=          TTOGO                           

                -2CADR          TIG-5                           

                OCT             77777                           
                EBANK=          TTOGO                           
## Page 241
                -2CADR          REDO4.2                         

# ANY MORE GROUP 4.EVEN RESTART VALUES SHOULD GO HERE

4.3SPOT         OCT             25000                           
                EBANK=          DVCNTR                          
                2CADR           GOABORT                         

4.5SPOT         DEC             50                              
                EBANK=          TTOGO                           
                -2CADR          ULLAGOFF                        

4.7SPOT         DEC             500                             
                EBANK=          DVCNTR                          
                -2CADR          TIG-0                           

4.11SPOT        -GENADR         TGO             +1              
                EBANK=          DVCNTR                          
                -2CADR          ENGOFTSK                        

4.13SPOT        OCT             12000                           
                EBANK=          TRKMKCNT                        
                2CADR           POSTBURN                        

4.15SPOT        DEC             500                             
                EBANK=          TTOGO                           
                -2CADR          TIG-30                          

4.17SPOT        OCT             77777                           
                EBANK=          DVCNTR                          
                -2CADR          TIG-5                           

4.21SPOT        OCT             13000                           
                EBANK=          STAR                            
                2CADR           R51.1           +1              

4.23SPOT        OCT             77777                           
                EBANK=          DVCNTR                          
                -2CADR          IGNITION                        

4.25SPOT        GENADR          SAVET-30                        
                -GENADR         TIG-35                          
                EBANK=          SAVET-30                        
                BBCON           TIG-35                          


4.27SPOT        OCT             52777                           
                EBANK=          DVCNTR                          
                2CADR           P70A                            
## Page 242		
4.31SPOT        OCT             52777                           
                EBANK=          DVCNTR                          
                2CADR           P71A                            

4.33SPOT        OCT             46777                           
                EBANK=          DVCNTR                          
                2CADR           GOPOOFIX                        

4.35SPOT        OCT             46777                           
                EBANK=          DVCNTR                          
                2CADR           GOPOODOO                        

4.37SPOT        OCT             52777                           
                EBANK=          WHICH                           
                2CADR           COMFAIL                         

# ANY MORE 4.ODD RESTART VALUES SHOULD GO HERE.
5.2SPOT         OCT             22000                           
                EBANK=          DVCNTR                          
                2CADR           NORMLIZE                        

                DEC             200                             
                EBANK=          DVCNTR                          
                -2CADR          REREADAC                        

5.4SPOT         DEC             200                             
                EBANK=          DVCNTR                          
                -2CADR          REREADAC                        

                OCT             20000                           
                EBANK=          DVCNTR                          
                2CADR           SERVICER                        

# ANY MORE GROUP 5.EVEN RESTART VALUES SHOULD GO HERE

5.3SPOT         DEC             200                             
                EBANK=          DVCNTR                          
                -2CADR          REREADAC                        

5.5SPOT         OCT             77777                           
                EBANK=          DVCNTR                          
                -2CADR          REDO5.5                         

5.7SPOT         OCT             77777                           
                EBANK=          DVCNTR                          
## Page 243
                -2CADR          BIBIBIAS                        

# ANY MORE GROUP 5.ODD RESTART VALUES SHOULD GO HERE

6.2SPOT         EQUALS          1.2SPOT                         
6.3SPOT         DEC             100                             
                EBANK=          TIG                             
                -2CADR          CLOKTASK                        

6.5SPOT         OCT             30000                           # PROTECT INCREMENTING OF TIME2,TIME1 BY
                EBANK=          TEPHEM                          # P27(UPDATE PROGRAM) VIA V70 OR V73.
                2CADR           TIMEDIDR                        

6.7SPOT         OCT             17000                           
                EBANK=          VGPREV                          
                2CADR           REDO6.7                         


