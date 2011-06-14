require 'mkmf'

extname = 'LLVM-EB'

have_library('LLVM-2.9')

$CFLAGS << '-Wall -O3 -fPIC'
$LDFLAGS = '-I LLVM-2.9 -o libLLVM-EB-2.9.so'

dir_config(extname)
create_makefile(extname)
