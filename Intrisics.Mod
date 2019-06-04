MODULE Intrisics;
IMPORT SYSTEM, Kernel, Oberon;

TYPE
  Intrisic* = POINTER TO IntrisicDesc;
  IntrisicDesc* = RECORD
    value*: INTEGER;
    next: Intrisic
  END;

PROCEDURE New*(i: Intrisic; v: INTEGER) : Intrisic;
BEGIN
  IF i = NIL THEN NEW(i) END;
  IF i # NIL THEN
    i.value := v;
    i.next := NIL
  END
  RETURN i 
END New;

PROCEDURE Get*(i: Intrisic; x: INTEGER): INTEGER;
  VAR r,i: INTEGER; i1:Intrisic;
BEGIN i:=0;r:=0;
  i1:=i; WHILE i1 # NIL DO 
    IF i = x THEN r := i1.value END;
    i1:=i1.next;
    INC(i)
  END
  RETURN r 
END Get;

PROCEDURE Clear*(i: Intrisic);
BEGIN
  i.value:=0;
  i.next:=NIL
END Clear;

BEGIN
END Intrisics.
