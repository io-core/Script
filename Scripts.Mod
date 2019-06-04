MODULE Scripts;

  IMPORT SYSTEM, Files, Fonts, Intrinsics;

  CONST 
    replace* = 0; insert* = 1; delete* = 2; unmark* = 3;  (*op-codes*)

  TYPE 
    Method* = POINTER TO MethodDesc;
    Expression* = POINTER TO ExpressionDesc;
    ExpressionDesc* = RECORD
      x*, y*, w*, h*, d*, p*: INTEGER;
      sx*, sy*: REAL;
      sw*, sh*: INTEGER;
      selected*, marked*: BOOLEAN;
      do*: Method;
      next: Expression
    END;

    Script* = POINTER TO ScriptDesc;
    Notifier* = PROCEDURE (s: Script; op: INTEGER; beg, end: LONGINT);
    ScriptDesc* = RECORD
      len*: LONGINT;
      changed*: BOOLEAN;
      flattened*: BOOLEAN;
      sel*, first: Expression;
      notify*: Notifier
    END;


    MethodDesc* = RECORD
        copy*: PROCEDURE (from, to: Expression);
        
        selectable*: PROCEDURE (e: Expression; x, y: INTEGER): BOOLEAN;
        read*: PROCEDURE (e: Expression; VAR r: Files.Rider); (*; VAR c: Context); *)
        write*: PROCEDURE (e: Expression; cno: INTEGER; VAR r: Files.Rider); (*; VAR c: Context);*)
        print*: PROCEDURE (e: Expression; x, y: INTEGER)
      END ;

    
VAR 
 
  new*: Expression; 

  PROCEDURE New*(e: Expression);
  BEGIN   new := e 
  END New;


  PROCEDURE Add*(s: Script; e: Expression);
  BEGIN e.marked := FALSE; e.selected := TRUE; e.next := s.first;
    s.first := e; s.sel := e; s.changed := TRUE
  END Add;


  PROCEDURE SaveSession*(s: Script; name: ARRAY OF CHAR);
    VAR f: Files.File; w: Files.Rider; 
  BEGIN f := Files.New(name); Files.Set(w, f, 0); 
  (*  Files.Write(w, GraphFileId); InitContext(c); StoreElems(w, c, s.first);  *)
    Files.Register(f)
  END SaveSession;


  PROCEDURE ResumeSession*(s: Script; name: ARRAY OF CHAR);
    VAR tag: CHAR;
          b: BYTE;
          i: INTEGER;
      f: Files.File; r: Files.Rider; 
  BEGIN s.first := NIL; s.sel := NIL; s.changed := FALSE; f := Files.Old(name);
    IF f # NIL THEN
      Files.Set(r, f, 0);
      Files.ReadByte(r, b); i:=b;
      Files.ReadByte(r, b); i:=i+(b*100H);
     
    ELSE 
    END
  END ResumeSession;


  PROCEDURE Erase*(s: Script);
    VAR e, pred: Expression;
  BEGIN s.sel := NIL; s.changed := TRUE; e := s.first;
    WHILE (e # NIL) & e.selected DO e := e.next END ;
    s.first := e;
    IF e # NIL THEN
      pred := e; e := e.next;
      WHILE e # NIL DO
        IF e.selected THEN pred.next := e.next ELSE pred := e END ;
        e := e.next
      END
    END
  END Erase;

BEGIN 
END Scripts.

