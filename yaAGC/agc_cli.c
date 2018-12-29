/*
 * Original Copyright 2003-2006,2009,2017 Ronald S. Burkey <info@sandroid.org>
 * Modified Copyright 2008,2016 Onno Hommes <ohommes@alumni.cmu.edu>
 *
 * This file is part of yaAGC.
 *
 * yaAGC is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * yaAGC is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with yaAGC; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * In addition, as a special exception, permission is given to
 * link the code of this program with the Orbiter SDK library (or with
 * modified versions of the Orbiter SDK library that use the same license as
 * the Orbiter SDK library), and distribute linked combinations including
 * the two. You must obey the GNU General Public License in all respects for
 * all of the code used other than the Orbiter SDK library. If you modify
 * this file, you may extend this exception to your version of the file,
 * but you are not obligated to do so. If you do not wish to do so, delete
 * this exception statement from your version.
 *
 * Filename:	agc_cli.c
 * Purpose:	This module implements the yaAGC command-line interface
 * Contact:	Onno Hommes <ohommes@alumni.cmu.edu>
 * Reference:	http://www.ibiblio.org/apollo
 * Mods:       	11/30/08 OH.	Began rework
 *              08/04/16 OH     Fixed the GPL statement and old user-id
 *              09/30/16 MAS    Added the --inhibit-alarms option
 *              05/30/17 RSB	Added --initialize-sunburst-37 option.
 */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <direct.h>
// #include <unistd.h>  // not existing in VS2015
#include "agc_cli.h"
#include "agc_engine.h"
#include "agc_symtab.h"

/* Some legacy vars for now */
int FullNameMode = 0;
int QuietMode = 0;

static char CduLog[] = "yaAGC.cdulog";

static Options_t Options;

/**
The command line options try to stay compatible with the early versions of
yaAGC for some time to enable a transition period but will not list them
in the usage for the command help to discourage its usage. Hence the option
--core is somewhat confusing because in the old builds it represents the
executable core-ropes image file but normally gdb uses this for the
core file. */
static void CliShowUsage(void)
{
	printf ("Usage:\n"
"\tyaAGC [options] exec-ropes-file [core-resume-file]\n\n"
"Options:\n\n"
"--exec=EXECFILE   Use EXECFILE as the exec-ropes-file\n"
"--fullname        Output information used by emacs-GDB interface.\n"
"--symbols=SYMFILE Read symbols from SYMFILE generated by yaYUL.\n"
"--quiet           Do not print version number on startup.\n"
"--cd=DIR          Change current directory to DIR.\n"
"--command=FILE    Execute AGC commands from FILE.\n"
"--directory=DIR   Search for source files in DIR.\n"
"--port=N          Change the server port number (default=19697).\n"
"--nodebug         Disables debugging and run just the simulation\n"
"--interlace=N     Read the socket interface every N CPU instructions.\n"
"--dump-time=N     Create core image every N seconds (default = 10).\n"
"--cdu-log         Used only for debugging. Creates the file yaAGC.cdulog\n"
"                  containing data related to the bandwidth-limiting of\n"
"                  CDU inputs PCDU and MCDU.\n"
"--debug-dsky      Rather than run the core program, go into DSKY-debug\n"
"                  mode. In this mode send pre-determined codes to\n"
"                  the DSKY upon receiving DSKY keypresses.\n"
"--debug-deda      This mode runs the core program as usual, but also\n"
"                  responds to messages from yaDEDA and generates fake\n"
"                  messages to yaDEDA for testing purposes.\n"
"--deda-quiet      Used with --debug-deda to eliminate outputs from yaAGC\n"
"                  to the DEDA.  In other words, lets yaAGC parse the\n"
"                  messages being received from the DEDA, but never to\n"
"                  send any.  That lets \"yaAGC --debug-deda --deda-quiet\"\n"
"                  to be used alongside yaAGS without conflict.\n"
"--inhibit-alarms  Prevents the simulated hardware alarms (Night Watchman\n"
"                  Rupt Lock, and TC Trap) from causing resets.\n"
"--cfg=file        The name of a configuration file.  Presently, the\n"
"                  configuration files is used only for --debug-dsky\n"
"                  mode.  It would typically be the same configuration\n"
"                  file as used for yaDSKY.\n\n"
"--initialize-sunburst-37 Makes some initializations to erasable memory needed\n"
"                         for a first-time run of SUNBURST 37 (SHEPATIN 0) having\n"
"                         otherwise clean memory, in lieu of pad-loads.  Not\n"
"                         required for subsequent runs.  Note that this option only\n"
"                         has an effect if there is no existing core-dump file.\n"
"Note that the exec-ropes file should contain exactly 36 banks\n"
"(36x1024=36864 words, or 73728 bytes). Other sizes may be accepted,\n"
"but it is unclear what (if any) utility such core-rope images\n"
"would have. (In particular, if the core-rope\n"
"is supposed to be for actual Luminary or Colossus software, then\n"
"the checksums of the missing memory banks would be incorrect, and\n"
"so the built-in self-test would fail.)\n\n");
}

extern FILE *rfopen (const char *Filename, const char *mode);


/**
This function parses the specified configuration file.
It loads its contents not a lot of checking is done here.
It returns 0 on "success" and 1 on known error.
*/
int CliParseCfg (char *Filename)
{
	char s[129] = { 0 };
	int KeyCode, Channel, Value, Result = 1;
	char Logic;
	FILE *fin;

	fin = rfopen (Filename, "r");
	if (fin)
	{
		Result = 0;

		while (NULL != fgets (s, sizeof (s) - 1, fin))
		{
			char *ss;

			/* Find newline or form feed and replace with string termination */
			for (ss = s; *ss; ss++) if (*ss == '\n' || *ss == '\r') *ss = 0;

			/* Parse string */
			if (4 == sscanf(s,"DEBUG %d %o %c %x",&KeyCode,&Channel,&Logic,&Value))
			{
				/* Ensure valid values are porvided */
				if (Channel < 0 || Channel > 255) continue;
				if (Logic != '=' && Logic != '&' &&
				    Logic != '|' && Logic != '^') continue;
				if (Value != (Value & 0x7FFF)) continue;
				if (KeyCode < 0 || KeyCode > 31) continue;
				if (NumDebugRules >= MAX_DEBUG_RULES) break;

				/* Set the Debug Rules */
				DebugRules[NumDebugRules].KeyCode = KeyCode;
				DebugRules[NumDebugRules].Channel = Channel;
				DebugRules[NumDebugRules].Logic = Logic;
				DebugRules[NumDebugRules].Value = Value;
				NumDebugRules++;
			}
			else if (!strcmp (s, "LMSIM")) CmOrLm = 0;
			else if (!strcmp (s, "CMSIM")) CmOrLm = 1;
		}
		fclose (fin);
	}
	return (Result);
}

/**
This is a private function of the Cli module. It sets the
internal Options structure members to their default value.
The Option structure handle will be returned through the
commandline parse function. */
static void CliInitializeOptions(void)
{
	  Options.core = (char*)0;
	  Options.resume = (char*)0;
	  Options.cdu_log = (char*)0;
	  Options.symtab = (char*)0;
	  Options.directory = (char*)0;
	  Options.cd = (char*)0;
	  Options.cfg = (char*)0;
	  Options.fromfile = (char*)0;
	  Options.port  = 19697;
	  Options.dump_time = 10;
	  Options.debug_dsky = 0;
	  Options.debug_deda = 0;
	  Options.deda_quiet = 0;
	  Options.inhibit_alarms = 0;
	  Options.quiet = 0;
	  Options.fullname = 0;
	  Options.debug = 1;
	  Options.resumed = 0;
	  Options.interlace = 50;
	  Options.version = 0;
	  Options.initializeSunburst37 = 0;
}
/**
This function takes a character string and checks the string for
known command line options. To support both single and double dash
options this function will normalize the double dash to s single dash just
by skipping the first dash. If the token is recognized the function
will return CLI_E_OK else it will return CLI_E_UNKOWNTOKEN.
\param *token The character string
\return The success of failure indication. */
static int CliProcessArgument(char* token)
{
	int result = CLI_E_OK;
	int j;

	/* Transform -- to just - for compatibility */
	if (!strncmp(token,"--",2)) token++;

	/* Parse the token */
	if (!strcmp (token, "-help") || !strcmp (token, "/?"))	result = 1;
	else if (!strncmp (token, "-nx", 3)) { /* Ignore for now */ }
	else if (!strncmp (token, "-args", 5)) { /* Ignore for now */ }
	else if (!strncmp (token, "-core=", 6))
	{
		/* If --core is used assume classic behavior is expected */
		Options.core = _strdup(&token[6]);

		/* with classi behavior default is nodebug */
		Options.debug = 0;
	}
	else if (!strncmp (token, "-directory=", 11))Options.directory = _strdup(&token[11]);
	else if (!strncmp (token, "-cd=", 4))Options.cd = _strdup(&token[4]);
	else if (!strncmp (token, "-exec=", 6))Options.core = _strdup(&token[6]);
	else if (!strncmp (token, "-resume=", 8))Options.resume = _strdup(&token[8]);
	else if (1 == sscanf (token, "-port=%d", &j)) Options.port = j;
	else if (1 == sscanf (token, "-dump-time=%d", &j)) Options.dump_time = j;
	else if (!strcmp (token, "-debug-dsky")) Options.debug_dsky = 1;
	else if (!strcmp (token, "-debug-deda")) Options.debug_deda = 1;
	else if (!strcmp (token, "-deda-quiet")) Options.deda_quiet = 1;
	else if (!strcmp (token, "-inhibit-alarms")) Options.inhibit_alarms = 1;
	else if (!strcmp (token, "-cdu-log")) Options.cdu_log = CduLog;
	else if (!strncmp (token, "-cfg=", 5)) Options.cfg = _strdup(&token[5]);
	else if (!strcmp (token, "-fullname")) Options.fullname = 1;
	else if (!strcmp (token, "-quiet"))Options.quiet = 1;
	else if (!strcmp (token, "-nodebug")) Options.debug = 0;
	else if (!strcmp (token, "-debug")) Options.debug = 1;
	else if (!strcmp (token, "-version")) Options.version = 6;
	else if (!strncmp (token, "-command=",9)) Options.fromfile = _strdup(&token[9]);
	else if (!strncmp (token, "-interpreter=",13)) /* Ignore for now */;
	else if (!strncmp (token, "-symbols=", 9)) Options.symtab = _strdup(&token[9]);
	else if (!strncmp (token, "-symtab=", 8)) Options.symtab = _strdup(&token[8]);
	else if (1 == sscanf (token,"-interlace=%d", &j)) Options.interlace = j;
	else if (!strcmp (token, "-initialize-sunburst-37")) Options.initializeSunburst37 = 1;
	else if (Options.core == (char*)0) Options.core = _strdup(token);
	else if (Options.resume == (char*)0) Options.resume =_strdup(token);
	else result = CLI_E_UNKOWNTOKEN;

	return (result);
}

/**
This function takes the command line argument count and argument array
as inputs and returns an Option structure if all parses correctly.
When errors are encountered the parser will return a NULL reference
\param argc The argument count
\param *argv The pointer to the argument array.
\return A handle to an Option structure. */
Options_t* CliParseArguments(int argc, char *argv[])
{
	Options_t* result = (Options_t*)0;
	int i;

	/* Set all the defaults in the option structure */
	CliInitializeOptions();

	/* Parse the command-line tokens */
	for (i = 1; i < argc; i++) if (CliProcessArgument(argv[i])) break;

	/* If there is an issue with the provided command line interface
	 * display the usage message. Otherwise proceed with the automatic
	 * values based on the core-ropes image name.
	 */
	if (argc == 1 || i < argc || (!Options.core && !Options.debug_dsky))
	{
		/* Check if only version info is requested */
		if (Options.version) result = &Options;
		else /* Show the usage message */
			CliShowUsage();
	}
	else
	{
		/* If a new working directory is specified then change to it
		 * immediately */
		if (Options.cd != NULL)
		  {
		    if (_chdir(Options.cd) < 0)
		      {
		        printf("\n*** Cannot change directories. ***\n]n");
		        return (NULL);
		      }
		  }

		/* Options are properly Parsed */
		result = &Options;

		/* Must have .bin extension to find the symbol table based on the
		 * core basename with the bin extension.
		 */
		if (strstr(Options.core,".bin"))
		{
			int FullPathLength = strlen(Options.core);

			/* If Debugging without symtab set default symtab */
			if (Options.debug && !Options.symtab)
			{
				Options.symtab = (char*)calloc(1,FullPathLength + 4);
				strcpy(Options.symtab,Options.core);
				strcpy(Options.symtab + strlen(Options.core)-3,"symtab");
			}
		}

		/* If a configuration file is specified load its contents */
		if (Options.cfg)
		{
			if (CliParseCfg (Options.cfg))
			{
			  result = (Options_t*)0;
			  printf("\n*** Unknown configuration file. ***\n\n");
			}
		}
	}

	return (result);
}
