PATH1="."
BUILD_DATE:=$(shell date +%g%m%d%H)
BUILD_VERSION:=1.19

##############################################################
# Linux Kernel 3.0
##############################################################

all: npreal2d npreal2d_redund tools
SP1: npreal2d npreal2d_redund tools
ssl: SSLnpreal2d npreal2d_redund tools
SP1_ssl: SSLnpreal2d npreal2d_redund tools
ssl64: SSL64npreal2d npreal2d_redund tools
SP1_ssl64: SSL64npreal2d npreal2d_redund tools
ppc64: ppc64npreal2d npreal2d_redund tools

CC+=$(POLLING)

lib: misc.c
	$(CC) -Wall -c misc.c
	$(AR) rcs misc.a misc.o 

npreal2d: npreal2d.o
	$(CC) npreal2d.o -o npreal2d

npreal2d.o : npreal2d.c npreal2d.h
	$(CC) -c npreal2d.c

npreal2d_redund: 	redund_main.o redund.o
	$(CC)	redund_main.o redund.o -lpthread -o npreal2d_redund

redund_main.o:	redund_main.c npreal2d.h redund.h
	$(CC) -c redund_main.c

redund.o:	redund.c redund.h npreal2d.h
	$(CC) -c redund.c

SSLnpreal2d: 	SSLnpreal2d.o
	cc	npreal2d.o -o npreal2d -lssl 

SSLnpreal2d.o:	npreal2d.c
	$(CC) -c -DSSL_ON -DOPENSSL_NO_KRB5 npreal2d.c -I$(PATH1)/include
	
SSL64npreal2d: 	SSL64npreal2d.o
	cc	-m64 npreal2d.o -o npreal2d -lssl 

SSL64npreal2d.o:	npreal2d.c
	$(CC) -c -m64 -DSSL_ON -DOPENSSL_NO_KRB5 npreal2d.c -I$(PATH1)/include
	
ppc64npreal2d: 	ppc64npreal2d.o
	cc	-mpowerpc64 npreal2d.o -o npreal2d -lssl 

ppc64npreal2d.o:	npreal2d.c
	$(CC) -c -mpowerpc64 -DSSL_ON -DOPENSSL_NO_KRB5 npreal2d.c -I$(PATH1)/include
	
misc.o : misc.c misc.h
	$(CC) -c misc.c


tools: mxaddsvr mxdelsvr mxcfmat mxloadsvr mxsetsec

mxaddsvr: mxaddsvr.c
	$(CC) -o mxaddsvr mxaddsvr.c

mxdelsvr: mxdelsvr.c
	$(CC) -o mxdelsvr mxdelsvr.c

mxcfmat: mxcfmat.c
	$(CC) -o mxcfmat mxcfmat.c

mxloadsvr: mxloadsvr.c
	$(CC) -o mxloadsvr mxloadsvr.c
	
mxsetsec: mxsetsec.c
	$(CC) -o mxsetsec mxsetsec.c
	
clean:
	rm -f *.o
	rm -rf ./.tmp_versions
	rm -f npreal2.mod*
	rm -f .npreal2*
	rm -f npreal2.ko
	rm -f *.order
	rm -f npreal2d
	rm -f npreal2d_redund
	rm -f mxaddsvr
	rm -f mxdelsvr
	rm -f mxcfmat
	rm -f mxloadsvr
	rm -f mxsetsec
	rm -f Module.symvers
	
pack:
	rm -rf ../../disk/moxa
	mkdir ../../disk/moxa
	cp * ../../disk/moxa
	tar -C ../../disk -zcvf ../../disk/npreal2_mainline_v${BUILD_VERSION}_build_${BUILD_DATE}.tgz moxa
	rm -rf ../../disk/moxa

