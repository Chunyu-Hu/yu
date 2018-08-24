#include <linux/module.h>
#include <linux/rcupdate.h>
#include <linux/sched.h>
#include <asm-generic/current.h>
#include <linux/fs.h>
#include <linux/seq_file.h>



//[root@hp-dl580g7-03 module]# cat /proc/kallsyms  | grep _schedule_bug
//ffffffff8e09a0d7 t __schedule_bug
static struct file afile;
static void (*t_sched_debug_func)(struct task_struct *prev);
static int init_stall(void)
{
   ssize_t s = seq_read(&afile, NULL, 0, NULL);
   filp_open(0, 0, 0);
   t_sched_debug_func =  0xffffffff8e09a0d7;
   printk("This module has loaded.\n");
   preempt_disable();
   preempt_disable();
   current_thread_info()->preempt_count++;
   current_thread_info()->preempt_count++;
   t_sched_debug_func(get_current());
   return 0;
}

static void cleanup_stall(void)
{
    printk("unloading module\n");
}

module_init(init_stall);
module_exit(cleanup_stall);

MODULE_LICENSE("GPL");

