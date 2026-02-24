HEADLESS "(loop)", DOLOOP
  ldr r0, =#1
  b 1f
END DOLOOP

HEADLESS "(+loop)", DOPLUSLOOP
  mov r0, tos
  loadtos
1:
  adds rloopindex, r0
  bvs 2f
  ldr FORTHIP, [FORTHIP]
  NEXT
2:
  add FORTHIP, #4
  pop {rloopindex, rlooplimit}
  NEXT
END DOPLUSLOOP
