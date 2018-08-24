#include <linux/preempt.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/pid.h>
#include <linux/debugfs.h>
#include <asm/uaccess.h>

static int init_test(void)
{	
	int a[8];
	struct task_struct *t;
	int b,c,d=0;
	int i = 0;
	for (i=0; i< 8; i++)
		pr_info("a[%d]=%d,c=%d", i, a[i],c);

	return 0;
}

static void exit_test(void)
{
	pr_info("Exit test ...");
}

module_init(init_test);
module_exit(exit_test);
MODULE_LICENSE("GPL");

