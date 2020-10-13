(* begin-package-description
The Script package automates Oberon commands.

end-package-description *)

(* begin-module-description
Module Script will implement LIL, a derivative of TCL.

end-module-description *)
MODULE Script;

  IMPORT Files, Fonts, Viewers, Texts, Oberon,
    TextFrames, MenuViewers, Environments;

  CONST Menu = "System.Close  System.Copy  System.Grow  Script.Run  Edit.Store";

  VAR W: Texts.Writer;

  PROCEDURE Load*;
    VAR T: Texts.Text;
    S: Texts.Scanner;
    beg, end, time: LONGINT;
  BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
    IF (S.class = Texts.Char) & (S.codepoint = ORD("^")) OR (S.line # 0) THEN
      Oberon.GetSelection(T, beg, end, time);
      IF time >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S) END
    END;
    IF S.class = Texts.Name THEN
      
    END
  END Load;


  PROCEDURE Open*;
    VAR T: Texts.Text;
    S: Texts.Scanner;
    V: Viewers.Viewer;
    X, Y: INTEGER;
    beg, end, time: LONGINT;
  BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
    IF (S.class = Texts.Char) & (S.codepoint = ORD("^")) OR (S.line # 0) THEN
      Oberon.GetSelection(T, beg, end, time);
      IF time >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S) END
    END;
    IF S.class = Texts.Name THEN
      Oberon.AllocateUserViewer(Oberon.Par.vwr.X, X, Y);
      V := MenuViewers.New(
        TextFrames.NewMenu(S.s, Menu),
        TextFrames.NewText(TextFrames.Text(S.s), 0),
        TextFrames.menuH, X, Y)
    END
  END Open;

  PROCEDURE Run*;
    VAR S: Texts.Scanner;
      Menu: TextFrames.Frame; G: TextFrames.Frame;
      v: Viewers.Viewer;
  BEGIN
    IF Oberon.Par.frame = Oberon.Par.vwr.dsc THEN
      Menu := Oberon.Par.vwr.dsc(TextFrames.Frame); G := Menu.next(TextFrames.Frame);
      Texts.OpenScanner(S, Menu.text, 0); Texts.Scan(S); 
      IF S.class = Texts.Name THEN
        Texts.WriteString(W, S.s); Texts.WriteString(W, " running");
        Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
        
      END
    ELSE
      Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Name THEN
        v := Oberon.MarkedViewer();
        IF (v.dsc # NIL) & (v.dsc.next IS TextFrames.Frame) THEN
          G := v.dsc.next(TextFrames.Frame);
          Texts.WriteString(W, S.s); Texts.WriteString(W, " running");
          Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
          
        END
      END
    END
  END Run;



BEGIN Texts.OpenWriter(W); Texts.WriteString(W, "Script - CP 1.3.2019");
  Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
END Script.

