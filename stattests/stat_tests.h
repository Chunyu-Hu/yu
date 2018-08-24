#ifndef __STAT_TESTS_H__
#define __STAT_TESTS_H__

#include "debug.h"
#define MATCH_LINE(match_func, line, str) \
do \
{	\
		if (!match_func) { \
			printf("%s", line); 	\
		} else {	\
			if (match_func(line, str))	\
				printf("%s", line);	\
		}	\
	\
} while (0);

#endif
