MODULE Environments;
  IMPORT SYSTEM, Files, Intrinsics, Texts;

  CONST 
    replace* = 0; insert* = 1; delete* = 2; unmark* = 3;  (*op-codes*)

  TYPE 
    Method* = POINTER TO MethodDesc;
    Binding* = POINTER TO BindingDesc;
    BindingDesc* = RECORD
      x*, y*, w*, h*, d*, p*: INTEGER;
      sx*, sy*: REAL;
      sw*, sh*: INTEGER;
      selected*, marked*: BOOLEAN;
      do*: Method;
      next: Binding
    END;

    Env* = POINTER TO EnvDesc;
    Notifier* = PROCEDURE (e: Env; op: INTEGER; beg, end: LONGINT);
    EnvDesc* = RECORD
      len*: LONGINT;
      changed*: BOOLEAN;
      flattened*: BOOLEAN;
      sel*, first: Binding;
      notify*: Notifier
    END;


    MethodDesc* = RECORD
        copy*: PROCEDURE (from, to: Binding);
        
        selectable*: PROCEDURE (b: Binding; x, y: INTEGER): BOOLEAN;
        read*: PROCEDURE (b: Binding; VAR r: Files.Rider); (*; VAR c: Context); *)
        write*: PROCEDURE (b: Binding; cno: INTEGER; VAR r: Files.Rider); (*; VAR c: Context);*)
        print*: PROCEDURE (b: Binding; x, y: INTEGER)
      END ;

    
VAR 
 
  top*: Env;
  new*: Binding; 

  PROCEDURE New*(b: Binding);
  BEGIN   new := b 
  END New;


  PROCEDURE Prepare*(VAR e: Env; VAR T: Text);
    VAR t: Text;
  BEGIN   t := T
  END Prepare;


  PROCEDURE Set*(e: Env; b: Binding);
  BEGIN b.marked := FALSE; b.selected := TRUE; b.next := e.first;
    e.first := b; e.sel := b; e.changed := TRUE
  END Set;


  PROCEDURE Save*(e: Env; name: ARRAY OF CHAR);
    VAR f: Files.File; w: Files.Rider; 
  BEGIN f := Files.New(name); Files.Set(w, f, 0); 
  (*  Files.Write(w, GraphFileId); InitContext(c); StoreElems(w, c, e.first);  *)
    Files.Register(f)
  END Save;


  PROCEDURE Resume*(e: Env; name: ARRAY OF CHAR);
    VAR tag: CHAR;
          y: BYTE;
          i: INTEGER;
      f: Files.File; r: Files.Rider; 
  BEGIN e.first := NIL; e.sel := NIL; e.changed := FALSE; f := Files.Old(name);
    IF f # NIL THEN
      Files.Set(r, f, 0);
      Files.ReadByte(r, y); i:=y;
      Files.ReadByte(r, y); i:=i+(y*100H);
     
    ELSE 
    END
  END Resume;


  PROCEDURE Unset*(e: Env);
    VAR b, pred: Binding;
  BEGIN e.sel := NIL; e.changed := TRUE; b := e.first;
    WHILE (b # NIL) & b.selected DO b := b.next END ;
    e.first := b;
    IF b # NIL THEN
      pred := b; b := b.next;
      WHILE b # NIL DO
        IF b.selected THEN pred.next := b.next ELSE pred := b END ;
        b := b.next
      END
    END
  END Unset;

BEGIN 
  NEW(top);
  top.len := 0;
  top.changed := False;
  top.flattened := False;
  top.sel := Nil;
  top.first := Nil;
  top.notify:= Nil;
END Environments.

