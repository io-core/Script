(* begin-module-use-description
Module Intrinsics handles pseudo-commands and operations internal to the LIL interpreter.

end-module-use-description *)
MODULE Intrinsics;
IMPORT SYSTEM, Kernel, Oberon;

TYPE
  Intrinsic* = POINTER TO IntrinsicDesc;
  IntrinsicDesc* = RECORD
    value*: INTEGER;
    next: Intrinsic
  END;

PROCEDURE New*(i: Intrinsic; v: INTEGER) : Intrinsic;
BEGIN
  IF i = NIL THEN NEW(i) END;
  IF i # NIL THEN
    i.value := v;
    i.next := NIL
  END
  RETURN i 
END New;


PROCEDURE Clear*(i: Intrinsic);
BEGIN
  i.value:=0;
  i.next:=NIL
END Clear;

BEGIN
END Intrinsics.
