#include <linux/preempt.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/pid.h>
#include <linux/debugfs.h>
#include <asm/uaccess.h>

LIST_HEAD(kmemleak_leaked_objects);
LIST_HEAD(kmemleak_insert_hooks);
LIST_HEAD(kmemleak_delete_hooks);
DEFINE_MUTEX(kmemleak_hook_lock);

static int init_test(void)
{	
	pr_info("Initiate kmemleak hook ...");
	return 0;
}

int kmemleak_false_report_backtrace(int error)
{
	dump_stack();	
	return 0
}

int kmemleak_trigger_false_report(int error)
{
	mutex_lock(kmemleak_hook_lock);
	pr_info("");
	mutex_unlock(kmemleak_hook_lock);
	return 0;
}

int kmemleak_register_hook(void *func, int type)
{
	struct list_head *l;
	struct kmemleak_extra {
		unsigned long object,
		unsigned long pointer,
	};
	mutex_lock(kmemleak_hook_lock);
	list_for_each(l, kmemleak_insert_hooks) {
		d = list_entry(l, struct kmemleak_extra, list);
		if (id < d->id)
			break;
	pr_info("");
	mutex_unlock(kmemleak_hook_lock);
	return 0;
}

int kmemleak_unregister_hook(void *func, int type)
{
	mutex_lock(kmemleak_hook_lock);
	pr_info("unregister hook");
	mutex_unlock(kmemleak_hook_lock);
	return 0;
}

static void exit_test(void)
{
	pr_info("tear down hooks");
}

module_init(init_test);
module_exit(exit_test);
MODULE_LICENSE("GPL");

