#define _GNU_SOURCE             /* See feature_test_macros(7) */
#include <pthread.h>
#include <unistd.h>
#include <sched.h>
#include <linux/unistd.h>
#include <stdio.h>
#include <sys/syscall.h>
#include <string.h>
#include <sys/types.h>
#include <stdlib.h>

#include "stat_tests.h"

typedef int (*match_func_t)(const char *line, const char *str);
static void show_all_info(void);
static void show_one_info(char* l, match_func_t match, char *str);

static void *tid = (void*)0xbeaf;
static long preempt_core = 2; /* cpu 3 */

static void init_pid_env(void)
{
	int max = sched_get_priority_max(SCHED_OTHER);
	int min = sched_get_priority_min(SCHED_OTHER);

	debug_print(INFO, "tid=%d\n", tid);
	debug_print(INFO, "preempt_core=%d\n", preempt_core);
	debug_print(INFO, "min_prio=%d, max_prio=%d for %s\n", min, max,
			"SCHED_OTHER"); 

	max = sched_get_priority_max(SCHED_RR);
	min = sched_get_priority_min(SCHED_RR);

	debug_print(INFO, "min_prio=%d, max_prio=%d for %s\n", min, max,
			"SCHED_RR"); 
}

static int match_line(const char *line, const char *str)
{
	if (strstr(line, str))
		return 1;
	return 0;
}

/* hight priority thread, to preempt with a normal fair process*/
static void *thread_func_preempt(void* p)
{
	int policy = -1;
	struct sched_param schedp = {.sched_priority = 99};

	pthread_attr_t self_attr;
	pthread_attr_init(&self_attr);
	cpu_set_t *csetp = CPU_ALLOC(8);
	CPU_ZERO(csetp);
	pthread_getaffinity_np(pthread_self(), sizeof(*csetp), csetp);
	debug_print(INFO, "cset=%x\n", *csetp);
	CPU_SET(preempt_core, csetp);

	/*check if the policy and priority was set correctly when created*/	
	pthread_getschedparam(pthread_self(), &policy, &schedp);
	debug_print(INFO, "sched_policy=%d, sched_priorify=%d\n", policy, schedp.sched_priority);
	
	/* can't set to rt policy */
	schedp.sched_priority = 99;
	int ret = pthread_setschedparam(pthread_self(), SCHED_RR, &schedp);
	if (ret) {
		perror("pthread_setschedparam()");	
		debug_print(WARN, "failed to set to policy SCHED_RR, prio %d\n", schedp.sched_priority);
	}
	schedp.sched_priority = -1;
	pthread_getschedparam(pthread_self(), &policy, &schedp);
	debug_print(INFO, "sched_priorify=%d\n", schedp.sched_priority);
	return 0;
}

static void *thread_func(void *p)
{
	char f[128];
	int i = 0;

	pid_t pid = syscall(SYS_set_tid_address, &tid);
	debug_print(INFO, "thread pid=%d,  tid=%d, pid=%d\n", pid,
			syscall(SYS_gettid), getpid());
	sleep(2);
	debug_print(INFO, "change bind mask\n");
	cpu_set_t *cset = CPU_ALLOC(8);
	CPU_ZERO(cset);
	CPU_SET(preempt_core, cset);
	pthread_setaffinity_np(pthread_self(), sizeof(*cset), cset);

	for (i=0; i< 3; i++) {
		sprintf(f, "/proc/self/task/%d/status", syscall(SYS_gettid));
		show_one_info(f, match_line, "Cpus_allowed:");
		sleep(2);
	}
}

static void show_one_info(char* f, match_func_t match, char *str)
{
	char buf[1024] = {0};
	FILE *fp = NULL;
	fp = fopen(f, "r");
	if (!fp) {
		perror("fopen");	
		debug_print(ERROR, f);
		return;
	}
	debug_print(INFO, "checking %s\n", f);
	while (fgets(buf, 1024, fp)) {
		MATCH_LINE(match, buf, str);
		memset(buf, 0, sizeof(buf));
	}
	return;
}

static void show_all_info(void)
{
	char file[1024];
	char buf[1024] = {0};
	FILE *fp = NULL;

	sprintf(file, "/proc/self/task/%d/stat", syscall(SYS_gettid));
	fp = fopen(file, "r");
	show_one_info(file, NULL, NULL);

	sprintf(file, "/proc/self/task/%d/schedstat", syscall(SYS_gettid));
	show_one_info(file, NULL, NULL);

	sprintf(file, "/proc/self/task/%d/status", syscall(SYS_gettid));
	show_one_info(file, NULL, NULL);
}

int main()
{
	init_pid_env();

	pthread_t tid, tid_highprio;

	cpu_set_t *cset = CPU_ALLOC(8);
	CPU_ZERO(cset);
	CPU_SET(1, cset);

	pthread_attr_t attr, attr_hiprio;
	pthread_attr_init(&attr);

	pthread_attr_setaffinity_np(&attr, sizeof(*cset), cset);
	/* low priority, SCHED_OTHER */
	pthread_create(&tid, &attr, thread_func, NULL);

	/* wait*/
	sleep(2);

	/* hiprioriy thread, SCHED_RR*/
	struct sched_param schedp = {.sched_priority = 99};
	int inherit_mode = PTHREAD_EXPLICIT_SCHED;

	pthread_attr_init(&attr_hiprio);
	pthread_attr_setschedparam(&attr_hiprio, &schedp);
	pthread_attr_setinheritsched(&attr_hiprio, inherit_mode);
	
	/* bind to cpu 3 */
	CPU_ZERO(cset);
	CPU_SET(preempt_core, cset);
	pthread_attr_setaffinity_np(&attr_hiprio, sizeof(*cset), cset);
	pthread_create(&tid_highprio, &attr_hiprio, thread_func_preempt, NULL);

	int ret = pthread_join(tid, NULL);
	pthread_join(tid_highprio, NULL);

	debug_print(INFO, "after pthread_join ...");

	/*cleanup stuff*/
	CPU_FREE(cset);
	pthread_attr_destroy(&attr);
	pthread_attr_destroy(&attr_hiprio);
}

