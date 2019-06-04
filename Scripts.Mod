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

    Msg* = RECORD END ;
    WidMsg* = RECORD (Msg) w*: INTEGER END ;
    ColorMsg* = RECORD (Msg) col*: INTEGER END ;
    FontMsg* = RECORD (Msg) fnt*: Fonts.Font END ;
    


    MethodDesc* = RECORD
        copy*: PROCEDURE (from, to: Expression);
        draw*, change*: PROCEDURE (e: Expression; VAR msg: Msg);
        selectable*: PROCEDURE (e: Expression; x, y: INTEGER): BOOLEAN;
        read*: PROCEDURE (e: Expression; VAR r: Files.Rider); (*; VAR c: Context); *)
        write*: PROCEDURE (e: Expression; cno: INTEGER; VAR r: Files.Rider); (*; VAR c: Context);*)
        print*: PROCEDURE (e: Expression; x, y: INTEGER)
      END ;

    
VAR 
 
  res*: INTEGER;
  width: INTEGER;
  new*: Expression; 
  LineMethod*, CapMethod*, MacMethod* : Method;

  PROCEDURE New*(e: Expression);
  BEGIN   new := e 
  END New;

  PROCEDURE Add*(s: Script; e: Expression);
  BEGIN e.marked := FALSE; e.selected := TRUE; e.next := s.first;
    s.first := e; s.sel := e; s.changed := TRUE
  END Add;

  PROCEDURE ThisExpression*(s: Script; x, y: INTEGER): Expression;
    VAR e: Expression;
  BEGIN e := s.first;
    WHILE (e # NIL) & ~e.do.selectable(e, x ,y) DO e := e.next END ;
    RETURN e
  END ThisExpression;

  PROCEDURE SelectExpression*(s: Script; e: Expression);
  BEGIN
    IF e # NIL THEN e.selected := TRUE; s.sel := e END
  END SelectExpression;

  PROCEDURE SelectArea*(s: Script; x0, y0, x1, y1: INTEGER);
    VAR e: Expression; t: INTEGER;
  BEGIN e := s.first;
    IF x1 < x0 THEN t := x0; x0 := x1; x1 := t END ;
    IF y1 < y0 THEN t := y0; y0 := y1; y1 := t END ;
    WHILE e # NIL DO
      IF (x0 <= e.x) & (e.x + e.w <= x1) & (y0 <= e.y) & (e.y + e.h <= y1) THEN
        e.selected := TRUE; s.sel := e
      END ;
      e := e.next
    END ;
    IF s.sel # NIL THEN  END
  END SelectArea;

  PROCEDURE Draw*(s: Script; VAR m: Msg);
    VAR e: Expression;
  BEGIN e := s.first;
    WHILE e # NIL DO e.do.draw(e, m); e := e.next END
  END Draw;

  (*----------------procedures operating on selection -------------------*)

  PROCEDURE Deselect*(s: Script);
    VAR e: Expression;
  BEGIN e := s.first; s.sel := NIL; 
    WHILE e # NIL DO e.selected := FALSE; e := e.next END
  END Deselect;

  PROCEDURE DrawSel*(s: Script; VAR m: Msg);
    VAR e: Expression;
  BEGIN e := s.first;
    WHILE e # NIL DO
      IF e.selected THEN e.do.draw(e, m) END ;
      e := e.next
    END
  END DrawSel;

  PROCEDURE Change*(s: Script; VAR m: Msg);
    VAR e: Expression;
  BEGIN e := s.first; s.changed := TRUE;
    WHILE e # NIL DO
      IF e.selected THEN e.do.change(e, m) END ;
      e := e.next
    END
  END Change;



  PROCEDURE WriteFile*(s: Script; name: ARRAY OF CHAR);
    VAR f: Files.File; w: Files.Rider; 
  BEGIN f := Files.New(name); Files.Set(w, f, 0); 
  (*  Files.Write(w, GraphFileId); InitContext(c); StoreElems(w, c, s.first);  *)
    Files.Register(f)
  END WriteFile;


  PROCEDURE SetWidth*(w: INTEGER);
  BEGIN width := w
  END SetWidth;


  PROCEDURE Open*(s: Script; name: ARRAY OF CHAR);
    VAR tag: CHAR;
          b: BYTE;
          i: INTEGER;
      f: Files.File; r: Files.Rider; 
  BEGIN s.first := NIL; s.sel := NIL; s.changed := FALSE; f := Files.Old(name);
    IF f # NIL THEN
      Files.Set(r, f, 0);
      Files.ReadByte(r, b); i:=b;
      Files.ReadByte(r, b); i:=i+(b*100H);
     
    ELSE res := 2
    END
  END Open;



  PROCEDURE Delete*(s: Script);
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
  END Delete;






  PROCEDURE InstallDrawMethods*(drawLine, drawCaption, drawMacro: PROCEDURE (e: Expression; VAR msg: Msg));
  BEGIN LineMethod.draw := drawLine; CapMethod.draw := drawCaption; MacMethod.draw := drawMacro
  END InstallDrawMethods;

BEGIN 
END Scripts.

