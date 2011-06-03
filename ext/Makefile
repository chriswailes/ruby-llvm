LLVM_VERSION	= 2.9

CXX		= g++
CFLAGS	= -O3 -fPIC
LIBFLAGS	= -shared -Wl,-soname,libLLVM-EB-$(LLVM_VERSION).so

LIBS		= /usr/local/lib/libLLVMSupport.a

all: libLLVM-EB.so

libLLVM-EB.so: support.o
	$(CXX) $(CFLAGS) $(LIBFLAGS) -o libLLVM-EB-$(LLVM_VERSION).so support.o $(LIBS)

support.o: support.cpp
	$(CXX) $(CFLAGS) -c $<

.PHONY: clean
clean:
	rm -f *.o
	rm -f *.so
