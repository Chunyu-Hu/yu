#include <linux/module.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/mm.h>
#include <linux/slab.h>
#include <linux/time.h>
#include <linux/kthread.h>
#include <linux/delay.h>
#include <linux/workqueue.h>
#include <linux/wait.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Chunyu Hu <chuhu@redhat.com>");
MODULE_DESCRIPTION("waitqueue book mark testing");

static wait_queue_head_t bookmark_wait_queue;
static wait_queue_head_t waker_wait_queue;
static long num_threads = 80;

struct work_struct workq;
static int finish_test;
static int stop;

struct wait_thread {
	struct list_head entry;
	struct task_struct *p;
};

LIST_HEAD(wait_threads_list);

static void stop_test_threads(void)
{
	struct wait_thread *pos;
	struct wait_thread *n;
	int i = 0;
	finish_test = 1;
	list_for_each_entry_safe(pos, n, &wait_threads_list, entry) {
		pr_info("freeing kthread%d=%px", i++, pos->p);
		kthread_stop(pos->p);
		wake_up_process(pos->p);
		kfree(pos);	
	}
}

static int wait_queue_test_thread(void *index)
{
	DECLARE_WAITQUEUE(wait, current);
	add_wait_queue(&bookmark_wait_queue, &wait);
	for (;;) {
		//pr_info("kthread %ld is queueing to wait", (long)index);
		set_current_state(TASK_INTERRUPTIBLE);
		schedule_timeout_interruptible(HZ*10);
		pr_info("kthread %ld is woken up", (long)index);
		if (kthread_should_stop())
			break;
	}
	remove_wait_queue(&bookmark_wait_queue, &wait);
	return 0;
}

static int start_waitqueue_test(void)
{
	struct task_struct *p; 
	struct wait_thread *w;
	long i;
	pr_info("Creating %ld threads", num_threads);
	for (i=0; i < num_threads; i++) {
		p = kthread_create(wait_queue_test_thread, (void*)i, "wait-queue-test-%ld", i);
		if (!IS_ERR(p)) {
			w = kmalloc(sizeof(*w), GFP_KERNEL);
			INIT_LIST_HEAD(&w->entry);
			w->p = p;
			list_add(&w->entry, &wait_threads_list);
			wake_up_process(p);
		}
		else
			WARN_ON(1);
	}
	return 0;
}

void my_workqueue_handler(struct work_struct *work)
{
	msleep(5000);  /* sleep */
	stop = 1;
	wake_up_interruptible(&waker_wait_queue);
}
int init_module(void)
{
	pr_info("Wait queue bookmark testing ....");

	init_waitqueue_head(&bookmark_wait_queue);
	init_waitqueue_head(&waker_wait_queue);
	start_waitqueue_test();

	INIT_WORK(&workq, my_workqueue_handler);
	schedule_work(&workq);

	pr_info("MODULE: This moudle is goint to sleep....");
	wait_event_interruptible(waker_wait_queue, (stop==1));

	pr_info("MODULE: Wakeup Wakeup I am Waked up........");
	wake_up_interruptible(&bookmark_wait_queue);

	return 0;
}

void cleanup_module(void)
{
	pr_info("MODULE: start to cleanup");
	pr_info("MODULE: This moudle is goging to stop test threads....");
	stop_test_threads(); 
}
