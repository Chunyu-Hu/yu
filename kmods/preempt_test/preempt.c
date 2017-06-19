#include <linux/preempt.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/pid.h>
#include <linux/debugfs.h>
#include <asm/uaccess.h>


static struct dentry *d_preempt;
static struct dentry *d_file_pid, *d_file_preempt;

static unsigned long target_pid;
static int preempt_setup;
static unsigned int old_pc;

module_param(target_pid, long, 0444);

static int set_preempt_count_by_task(struct task_struct *t, int val);

static int pid_open(struct inode *inode, struct file *filp)
{
	return 0;
}

static ssize_t pid_read(struct file *filp, char __user *ubuf,
			 size_t cnt, loff_t *ppos)
{
	long copied;	
	copied = copy_to_user(ubuf, &target_pid, sizeof(target_pid));
	pr_info("target_pid = %lu", target_pid);
	return copied;
}

static ssize_t pid_write(struct file *filp, const char __user *ubuf,
			  size_t cnt, loff_t *ppos)
{
	if (kstrtoint_from_user(ubuf, cnt, 10, (int*)&target_pid))
		return -EINVAL;

	printk("pid: writing to target_pid = %lu\n", target_pid);
	return cnt;
}

static int preempt_open(struct inode *inode, struct file *filp)
{
	return 0;
}

static ssize_t preempt_read(struct file *filp, char __user *ubuf,
			 size_t cnt, loff_t *ppos)
{
	long copied;	
	copied = copy_to_user(ubuf, &preempt_setup, sizeof(preempt_setup));
	pr_info("preempt_setup = %d", preempt_setup);
	return copied;
}

static ssize_t preempt_write(struct file *filp, const char __user *ubuf,
			  size_t cnt, loff_t *ppos)
{
	struct task_struct *t;
	if (kstrtoint_from_user(ubuf, cnt, 10, &preempt_setup))
		return -EINVAL;
	printk("preempt: writing to setup = %d\n", preempt_setup);
	t = get_pid_task(find_get_pid(target_pid), PIDTYPE_PID); 
	set_preempt_count_by_task(t, preempt_setup);
	return cnt;
}

static const struct file_operations preempt_fops = {
	.open		= preempt_open,
	.read		= preempt_read,
	.write		= preempt_write,
	.llseek		= default_llseek,
};

static const struct file_operations pid_fops = {
	.open		= pid_open,
	.read		= pid_read,
	.write		= pid_write,
	.llseek		= default_llseek,
};


static void dump_task_context(struct task_struct *t)
{
	pr_info("gs=%lx", t->thread.gs);
	pr_info("fs=%lx", t->thread.fs);
	pr_info("sp=%lx", t->thread.sp);
	pr_info("sp0=%lx", t->thread.sp0);
	pr_info("iopl=%lx", t->thread.iopl);
}

/*
 * It's safe to use the thread directly, no matter the task is current or
 * not. Reason is that the 16K stask side is enough to get through the saved
 * sp0 after round up to 16K.
 * */
static struct thread_info *find_task_threadinfo(struct task_struct *t)
{
	long long  sp = t->thread.sp;
	return (struct thread_info*)(sp & ~(THREAD_SIZE - 1));
}

static long long preempt_count_by_task(struct task_struct *t)
{
	struct thread_info* ti = find_task_threadinfo(t);
	if (WARN_ON(!ti))
		return 0;
	return ti->preempt_count;
}

static int set_preempt_count_by_task(struct task_struct *t, int val)
{
	struct thread_info* ti = find_task_threadinfo(t);
	if (WARN_ON(!ti))
		return 0;
	ti->preempt_count += val;

	return ti->preempt_count;
}

static int test_helper(int val)
{
	switch (val) {
	case 1:
		break;
	case 2:
		break;
	default:
		break;
	}
	return 0;	
}

static int init_debugfs_pt_entry(void)
{
	d_preempt = debugfs_create_dir("preempt", NULL);
	if (WARN_ON(!d_preempt))
		return -1;

	d_file_pid = debugfs_create_file("pid", 0644, d_preempt, NULL, &pid_fops);
	if (WARN_ON(!d_file_pid)) {
		debugfs_remove(d_preempt);
		return -1;
	}

	d_file_preempt = debugfs_create_file("preempt_setup", 0644, d_preempt, NULL, &preempt_fops);
	if (WARN_ON(!d_file_preempt)) {
		debugfs_remove(d_preempt);
		return -1;
	}

	printk("preempt initialized\n");

	return 0;
}

static int cleanup_debugfs_pt_entry(void)
{
	debugfs_remove_recursive(d_preempt);
	printk("preempt debug unloaded\n");
	return 0;
}

static int init_test(void)
{	
	struct task_struct *t;
	pr_info("Init test ...");

	init_debugfs_pt_entry();

	if (!target_pid)
		target_pid = current->pid;

	pr_info("schedule_in_atomic emulate ..., %d", preempt_count());

	t = get_pid_task(find_get_pid(target_pid), PIDTYPE_PID); 

	task_lock(t);
	dump_task_context(t);
	old_pc = preempt_count_by_task(t);
	pr_info("preempt_count: %s: %u", t->comm, old_pc);
	task_unlock(t);

	pr_info("test schedule_in_atomic : end test ...");

	return 0;
}

static void  exit_test(void)
{
	struct task_struct *t;
	unsigned long pc;

	cleanup_debugfs_pt_entry();

	t = get_pid_task(find_get_pid(target_pid), PIDTYPE_PID); 
	if ((!t)) {
		pr_alert("pid not there");
		return;
	}
	task_lock(t);
	pc = preempt_count_by_task(t);
	if (pc == old_pc) {
		pr_info("preempt_count unchagned: %s: %u", t->comm, old_pc);
		pr_info("preempt_count setting back to old val %u", old_pc);
		set_preempt_count_by_task(t, -1);
		pr_info("preempt_count = %lld", preempt_count_by_task(t));
	}
	task_unlock(t);
	pr_info("Exit test ...");
}

module_init(init_test);
module_exit(exit_test);
MODULE_LICENSE("GPL");

