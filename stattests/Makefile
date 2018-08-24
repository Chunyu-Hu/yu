
.PHONY: clean install run

LD_FLAGS := -lpthread
objects = pid_status.o
stattests: $(objects)
	$(error, $(CC))
	$(CC) -o $@ $(objects) $(LD_FLAGS)
pid_status.o: pid_status.c stat_tests.h
	cc -c pid_status.c $(LD_FLAGS)

clean:
	- rm *.o -f
install: FORCE
	$(shell echo $(error, hello))

FORCE:

run:
	./stattests
