%% -*- Mode: Prolog; coding: utf-8 -*-

:- set_prolog_flag(legacy_char_classification,on).

:- set_prolog_flag(toplevel_print_options,
    [quoted(true),numbervars(true),portrayed(true),
                                   max_depth(10000)]).

map(_,[],[]).
map(F,[X|Xs],[FX|FXs]) :- call(F,X,FX), map(F,Xs,FXs).

% open(File, Mode, Stream) : File: fájlnak az elérési útvonala, Mode: read / write / append, Stream: adatfolyam, ahonnan olvasni, ahova írni tudunk.
% close(Stream): Bezárja az adott adatfolyamot.
% read(Stream, Term): Stream-ről Prolog termet olvas és illeszti Term-re.
% read_line(Stream, Line): Stream-ről új sorig olvas és illeszti Line-ra.
%   !!! FIGYELEM: A Line a karakterkódokat fogja tartalmazni, karakterkódok listája lesz.
%                 Ebből következően String, mint olyan, NINCS prologban!
% atom_codes(Atom, CharCodes): Atom-ot alakítja az atomot felépítő karakterek karakterkódjainak listájára (CharCodes) és vissza.
% atom_chars(Atom, AtomChars): Atom-ot felbontja karakterek(, amelyek atomok lesznek) listájára.
% pl. 
% atom_concat(Atom1, Atom2, Result): Atom1-et összefűzi Atom2-vel, Result az eredmény, amely szintén atom.
% at_end_of_stream(Stream): ellenőrzi, hogy a Stream a végén van-e, tehát mindent kiolvastunk-e belőle.

% Piros vágóval.
close_at_end(Num, Stream) :- at_end_of_stream(Stream), close('$stream'(Num)).

atom_codes_all([],[]).
atom_codes_all([X|Xs],[Y|Ys]) :-
    atom_codes(X,Y),
    atom_codes_all(Xs,Ys).

read_all_lines_red(Stream, []) :- at_end_of_stream(Stream), !. % piros vágó
read_all_lines_red(Stream, [Line|Lines]) :-
    read_line(Stream, Line),
    read_all_lines_red(Stream,Lines).


% Zöld vágóval.
read_all_lines_green(Stream, []) :- at_end_of_stream(Stream), !. 
read_all_lines_green(Stream, [Line|Lines]) :-
    \+at_end_of_stream(Stream), % \+ : yes, ha a predikátum nem teljesül
    read_line(Stream, Line),
    read_all_lines_green(Stream,Lines).

% Lokális vágóval.
read_all_lines(Stream, Result) :-
    (at_end_of_stream(Stream) ->
        Result = []
    ;
        read_line(Stream, Line),
        Result = [Line|Lines],
        read_all_lines(Stream, Lines)
    ).

% get_code(Stream, C): Egy darab karaktert olvas Stream-ből, amit kód formájában ad vissza.
% char_code(Atom, CharCode): Egy karakterből álló Atom-ot alakít át annak a kódjára és vissza.
% peek_code(Stream, C): "Meglesi" a következő karaktert a Stream-en, de azt nem fogyasztja el.
% number_codes(Szám, KódLista): Kétirányú, átalakít egy számot a karakterkódjaira és vissza, exception, ha bármi más van.

% callable(T): T term callable-e, tehát atom vagy compound-e T.

% Olvassuk a karaktereket addig, amíg egy "feltétel" teljesül.
% read_chars_while(Stream, Pred, Result). % ZH-ban lesz feladat.

pred(X) :- \+X == a.

read_chars_while(Stream,    _, []) :- at_end_of_stream(Stream), !.
read_chars_while(Stream, Pred, []) :- peek_code(Stream, Char), char_code(X, Char), callable(Pred), \+call(Pred, X).
read_chars_while(Stream, Pred, [X|Xs]) :-
    \+at_end_of_stream(Stream),
    get_code(Stream, Char),
    char_code(X, Char),
    callable(Pred),
    call(Pred, X),
    read_chars_while(Stream, Pred, Xs).

% write(Stream, Atom): Stream-re ír Atom-ot.
% nl(Stream): New Line: az adott Stream-re új sor karaktert ír.

% Írjuk rá a Stream-re az összes sort.
write_all_lines(_, []) :- !.
write_all_lines(Stream, [Line]) :- write(Stream, Line), !.
write_all_lines(Stream, [Line|Lines]) :-
    write(Stream,Line),
    nl(Stream),
    write_all_lines(Stream,Lines).