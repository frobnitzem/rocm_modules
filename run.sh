# These module files were written at the OLCF
# with input from Matthew Belhorn, Matt Davis,
# Reuben Budiardja, Verónica Melesse Vergara, & Cathy Willis
module use $PWD/rocm

bash <<.
module load rocm/5.1.0
hipcc -o graph graph.cc
./graph
.

# ok - links to rocm 5.1.0
./graph

module load rocm/4.5.0
# core dump - incompatible rocm versions
./graph

ldd graph # shows linking to rocm/4.5.0
