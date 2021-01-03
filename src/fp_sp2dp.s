.file  "fp_sp2dp.s"
.option nopic
.text
.align 1
.globl main
.type  main, @function
main:
    /* this program tests the conversion of floating-point numbers
       between single-precision and double-precision formats */
    li t0, 0x2000
    csrs mstatus, t0

    li t0, 0x40400000
    li t1, 0xc0a00000
    fmv.w.x ft0, t0
    fmv.w.x ft1, t1
    fsgnj.s ft2, ft1, ft0
    fsgnjn.s ft2, ft1, ft0
    fsgnjx.s ft2, ft1, ft0

    la t2, lable
    fsw ft0, 0(t2)
    flw ft0, 0(t2)

    li t0, 3
    fcvt.d.l ft0, t0
    fcvt.s.d ft0, ft0
    fmadd.s ft2, ft0, ft0, ft0
    fmsub.s ft2, ft0, ft0, ft0
    fnmadd.s ft2, ft0, ft0, ft0
    fnmsub.s ft2, ft0, ft0, ft0

    li a0, 0
    call bp_finish
    jalr x0, ra
    nop
    nop
    nop
    nop
    nop

lable:
   .word 0x0
