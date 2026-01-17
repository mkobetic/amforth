
.text
.global PFA_COLD
  j PFA_COLD

.include "macros.inc"
.include "user.inc"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"

ENDDICT
