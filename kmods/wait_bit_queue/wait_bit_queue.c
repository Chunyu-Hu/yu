#include <linux/wait.h>
#include <linux/kernel.h>
#include <linux/export.h>
#include <linux/module.h>
#include <linux/spinlock.h>
#include <linux/delay.h>
#include <linux/sched.h>
#include <linux/interrupt.h>

#define WAIT_FLAG_HERE 100
/*
 * Wait bit for range of 32 bit.
 */
#define WAIT_BIT_HERE  31
static int bit_storage;
static spinlock_t m_lock;

/*
 * For activating the current insmod process.
 */
static struct tasklet_struct tasklet_activate_waiter;

static int volatile kmod_test_counter;

static void wait_for_kmod_quit(void *data)
{
	DEFINE_WAIT_BIT(wq, &bit_storage, WAIT_BIT_HERE);
	wait_queue_head_t *wqh;

	pr_info("waiting ... , sizeof(wq) == %lu", sizeof(wq));
	pr_info("bit_nr == %d, flags == %lu", wq.key.bit_nr, (unsigned long)wq.key.flags);

	wqh = bit_waitqueue(&bit_waitqueue, WAIT_BIT_HERE);

	while (kmod_test_counter == 0) {
		__wait_on_bit(wqh, &wq, bit_wait,
			      TASK_INTERRUPTIBLE);
	}
}

static void activate_kmod_current(unsigned long data)
{
	wait_queue_head_t *wqh;
	struct tasklet_struct *t = (struct tasklet_struct*)data;

	static int loop = 100;
	/*
	 * Wait for 10s, then activate the current task.
	 */
	while (loop--) {
		pr_info("looping ... %d", 100 - loop);				
		msleep(100);
		tasklet_schedule(t);
		schedule();
	}
	/* Activate insmod process*/
	kmod_test_counter = 1;

	wqh = bit_waitqueue(&bit_storage, WAIT_BIT_HERE);
	__wake_up_bit(wqh, &bit_storage, WAIT_BIT_HERE);
}

static int test_init(void)
{
	tasklet_init(&tasklet_activate_waiter, activate_kmod_current,
					(unsigned long)&tasklet_activate_waiter);

	tasklet_enable(&tasklet_activate_waiter);
	tasklet_schedule(&tasklet_activate_waiter);
	wait_for_kmod_quit(0);
	return 0;
}

static void test_exit(void)
{
	spin_lock(&m_lock);
	msleep(1);
	tasklet_disable(&tasklet_activate_waiter);
	spin_unlock(&m_lock);
	return;
}

module_init(test_init);
module_exit(test_exit);
MODULE_LICENSE("GPL");
