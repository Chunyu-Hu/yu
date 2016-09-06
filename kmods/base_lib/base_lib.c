#include <linux/export.h>
#include <linux/kallsyms.h>
#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/module.h>
#include <linux/types.h>
#include <linux/rcupdate.h>
#include <linux/workqueue.h>
#include <linux/kthread.h>
#include <linux/device.h>

static int dummy = 0;
extern struct list_head tasks;
static struct workqueue_struct *test_cleanup_wq;
static int really_do = 0;

static void deferred_probe_work_func(struct work_struct *work)
{
        struct device *dev;
        pr_info("base_lib: in queued func: sizeof struct device: %ld",
                sizeof(*dev));
}

static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);

struct test_description {
        int id;
        int duration;
        char res[8];
        int date;
        #ifdef __GENKSYMS__
        int hiddend_data1;
        int hiddend_data2;
        int hiddend_data3;
        #endif
};

static struct test_description base_lib_desc;

EXPORT_SYMBOL(base_lib_desc);

static void test_defer_it(struct work_struct* work)
{
	    if (!really_do)
		        return;
        /*
         * Kick the re-probe thread.  It may already be scheduled, but it is
         * safe to kick it again.
         */
	    queue_work(test_cleanup_wq, &deferred_probe_work);
}

int test_init_workqueue(void)
{
        test_cleanup_wq = create_singlethread_workqueue("test_cleanups");
        if (WARN_ON(!test_cleanup_wq))
		        return -ENOMEM;
        return 0;
}

unsigned long long test_dump_tasklist(int number, pid_t pid)
{
        struct task_struct *task;
        /* Protect the task struct during the iter */
	    rcu_read_lock();
        for_each_process(task)
        {
                printk("%s [%d], threads %d\n",task->comm ,task->pid,
                        get_nr_threads(task));
                if (!number--) 
                        break;
        }
	    rcu_read_unlock();

        return number;
}

EXPORT_SYMBOL(test_dump_tasklist);

long test_dump_cpulist(int node, int cpu)
{
        pr_info("Printing cpu info");
        return 0xff;
}
EXPORT_SYMBOL(test_dump_cpulist);

long test_dump_nodelist(void *p, unsigned int count, int fd)
{
        return 0xff;
}
EXPORT_SYMBOL(test_dump_nodelist);

int init_lib(void)
{
        test_defer_it(&deferred_probe_work);
	    return 0;
}

void exit_lib(void)
{
	    return;
}

module_init(init_lib);
module_exit(exit_lib);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Chunyu Hu <chuhu@redhat.com>");
module_param(dummy, int, 0444);
MODULE_PARM_DESC(dummy, "How long will the hung task block.");

