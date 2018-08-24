                        clock_gettime(CLOCK_REALTIME, &t);
                        if (t.tv_sec >= work_end)
                                break;
                        if(a++||b++);
                }
                while (1) {
                        clock_gettime(CLOCK_REALTIME, &t);
                        if (t.tv_sec >= loop_end)
                                break;
                        usleep(2000);
                }
        }
}

static void work_load_mem(int size)
{
        int loop = size/4096;
        while (1) {
                char *mem = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_SHARED, -1, 0);
                int ret = mlock(mem, 4096);
                if (ret) {perror("mlock"); exit(1);}
                *(mem+1024) = 'x';
                munmap(mem, 4096);
                ret = 
                        break;
        }
}

static int switch_to_deadline(long period, long runtime, long deadline)
{
        struct sched_attr attr = {0};

        attr.size = sizeof(struct sched_attr);
        attr.sched_policy = SCHED_DEADLINE;
        attr.sched_runtime = MS(runtime);
        attr.sched_period = MS(period);
        attr.sched_deadline = MS(deadline);
        attr.sched_flags = SCHED_FLAG_RESET_ON_FOR
