#ifndef  __DEBUG_PRINT__
#define __DEBUG_PRINT__

#define INFO "INFO"
#define ERROR  "ERROR"
#define WARN "WARN"

/* debug print*/
#define debug_print(level, stream...) \
do \
{ \
	printf("[%s](pid=%d tid=%d): ", level, getpid(), syscall(SYS_gettid)); \
	printf(stream); \
} while (0);

#define debug_assert(0, func...) \
do \
{ \
	int ret = -1; \
	ret = #func; \
	if (ret) \
		perror("\""##func##\"\""); \
	\
} while (0)

#endif
