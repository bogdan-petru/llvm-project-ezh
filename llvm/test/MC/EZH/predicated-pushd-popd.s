# RUN: llvm-mc -triple ezh-none-elf -show-encoding %s | FileCheck %s
#
# The printer has a hand-rolled alias path for the pushd/popd-shaped
# STR_PRE/LDR_POST MCInsts that codegen emits (SP-based, +/-4). It must
# keep the condition suffix: a predicated pop-into-PC printed as a bare
# "popd pc" re-assembles as an UNCONDITIONAL return and changes semantics.
# (Object emission always encoded the predicate correctly; the raw forms
# below parse into the codegen-shaped MCInst, exercising exactly that
# printer path. The plain suffixed aliases parse into a different operand
# layout and never reached the bug.)

ldr_post sp, pc, 4
# CHECK: popd pc                                 ; encoding: [0x01,0x34,0x1f,0x01]
ldr_post_ze sp, pc, 4
# CHECK: popd_ze pc                              ; encoding: [0x21,0x34,0x1f,0x01]
str_pre sp, r4, -4
# CHECK: pushd r4                                ; encoding: [0x02,0x04,0x47,0xff]
str_pre_nz sp, r4, -4
# CHECK: pushd_nz r4                             ; encoding: [0x42,0x04,0x47,0xff]
