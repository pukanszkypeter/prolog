%% -*- Mode: Prolog; coding: utf-8 -*-

% 11. gyakorlat is ebben a fájlban van!

:- set_prolog_flag(legacy_char_classification,on).

:- set_prolog_flag(toplevel_print_options,
    [quoted(true),numbervars(true),portrayed(true),
                                   max_depth(10000)]).

% :- set_prolog_flag(double_quotes, chars). % String-ekből egy karakteres atomok listája lesz.

% DCG = Definite Clause Grammar
% - - >
% S -> aA
% A -> baA | bB
% B -> c

repeat(_,[]).
repeat(X,[X|Xs]) :- repeat(X,Xs).

% phrase/2: A parser-ünk akkor teljesül, ha lenyelte az összes inputot.
% phrase/3 létezik, a harmadik paraméter a megmaradt rész, amit nem sikerült olvasni.

% phrase(Goal, Ls) :- phrase(Goal, Ls, []).

repeated(_) --> [].
repeated(X) --> [X], repeated(X).

fromAdd1_(N,[N]).
fromAdd1_(N,[N|Xs]) :- K is N + 1, fromAdd1_(K,Xs).

fromAdd1(N) --> [N] | [N], { K is N + 1 }, fromAdd1(K).

reverse_([])     --> [].
reverse_([X|Xs]) --> reverse_(Xs), [X].

palindrome --> [].
palindrome --> [_].
palindrome --> [X], palindrome, [X].

% ---------------------------------------------
% Parsing

no0_value(N) --> [0'1], !, { N = 0'1 }.
no0_value(N) --> [0'2], !, { N = 0'2 }.
no0_value(N) --> [0'3], !, { N = 0'3 }.
no0_value(N) --> [0'4], !, { N = 0'4 }.
no0_value(N) --> [0'5], !, { N = 0'5 }.
no0_value(N) --> [0'6], !, { N = 0'6 }.
no0_value(N) --> [0'7], !, { N = 0'7 }.
no0_value(N) --> [0'8], !, { N = 0'8 }.
no0_value(N) --> [0'9], !, { N = 0'9 }.

shorter_value(N) --> [X], { 0'0 =< X, X =< 0'9 }, !, { N = X }.

value(N) --> [0'0], !, { N = 0'0 }.
value(N) --> [0'1], !, { N = 0'1 }.
value(N) --> [0'2], !, { N = 0'2 }.
value(N) --> [0'3], !, { N = 0'3 }.
value(N) --> [0'4], !, { N = 0'4 }.
value(N) --> [0'5], !, { N = 0'5 }.
value(N) --> [0'6], !, { N = 0'6 }.
value(N) --> [0'7], !, { N = 0'7 }.
value(N) --> [0'8], !, { N = 0'8 }.
value(N) --> [0'9], !, { N = 0'9 }.

/*
% Erre nincs szükség!

digitsToNum(Xs,N) :- digitsToNumHelper(Xs,0,N).

digitsToNumHelper([],Acc,Acc).
digitsToNumHelper([X|Xs],Acc,N) :-
    0'0 =< X, 
    X =< 0'9,
    number_codes(D,[X]),
    Acc1 is Acc * 10 + D,
    digitsToNumHelper(Xs,Acc1,N).
*/

more(E) --> (value(D), !, more(Ds), { E = [D|Ds] }) | [], { E = [] }.

num(N) --> no0_value(D), more(Ds), { number_codes(N,[D|Ds]) }.

ws(0'\t).
ws(0'\n).
ws(0'\v).
ws(0'\f).
ws(0'\r).
ws(0' ).

operator("+",+).
operator("*",*).
operator("-",-).
operator("^",^).
operator("-+",-).
operator("/",/).

foldl(_,Acc,[],Acc).
foldl(F,Acc,[X|Xs],Res) :- NewAcc =.. [F,Acc,X], foldl(F,NewAcc,Xs,Res).

from1ToN(N,L) :- N >= 1, from1ToN(N,1,L).
from1ToN(N,Acc,[Acc]) :- N =:= Acc.
from1ToN(N,Acc,[Acc|Xs]) :-
    N > Acc,
    Acc1 is Acc + 1,
    from1ToN(N,Acc1,Xs).

factExpr(X,R) :- from1ToN(X,L), foldl(*,1,L,R).

/*
fact_helper(0,Acc,Acc).
fact_helper(X,Acc,N) :-
    X > 0,
    X1 is X - 1,
    R is X * Acc,
    fact_helper(X1,R,N).
*/

ws --> [].
ws --> [X], { ws(X) }, ws.

% prefix operátor
chainPrefixAssoc(Next,OpList,Expr) --> {ToRun1 =.. [Next,Expr]}, ToRun1
                                     | {member(Op,OpList), operator(Op,C)}, Op, ws, chainPrefixAssoc(Next,OpList,Expr1), {Expr =.. [C,Expr1]}.

chainPrefix(Next,OpList,Expr) --> {ToRun1 =.. [Next,Expr]}, ToRun1
                                | {member(Op,OpList), operator(Op,C)}, Op, ws, {ToRun2 =.. [Next,Expr1]}, ToRun2, {Expr =.. [C,Expr1]}.

% postfix operátor
chainPostfixAssoc(Next,OpList,Expr) --> {ToRun1 =.. [Next,Expr]}, ToRun1
                                      | {ToRun =.. [Next,Expr2]}, ToRun, postfixAssocL(Next,OpList,Expr2,Expr).

postfixAssocL(Next,OpList,Expr1,Expr2) --> {member(Op,OpList), operator(Op,C)}, Op, ws, {NewExpr =.. [C,Expr1]}, postfixAssocL(Next,OpList,NewExpr,Expr2) | {Expr1 = Expr2}.

% chainr1(_,["+"],R)
% R = 3 + (4 + 5)
chainr1(Next,OpList,Expr) --> {ToRun1 =.. [Next,Expr]}, ToRun1
                            | {ToRun2 =.. [Next,Expr1]}, ToRun2, {member(Op,OpList), operator(Op,C)}, Op, ws, chainr1(Next,OpList,Expr2), {Expr =.. [C,Expr1,Expr2]}.

chainl1(Next,OpList,Expr) --> {ToRun =.. [Next,Expr2]}, ToRun, chainl1L(Next,OpList,Expr2,Expr).
chainl1L(Next,OpList,Expr1,Expr2) --> { member(Op,OpList), operator(Op,C)}, Op, ws, {NextP =.. [Next,P]}, NextP, {NewExpr =.. [C,Expr1,P]}, chainl1L(Next,OpList,NewExpr,Expr2) | {Expr1 = Expr2}.

chain1(Next,OpList,Expr) --> {ToRun1 =.. [Next,Expr] }, ToRun1
                           | {ToRun2 =.. [Next,Expr1]}, ToRun2, {member(Op,OpList), operator(Op,C)}, Op, ws, {ToRun3 =.. [Next,Expr2]}, ToRun3, {Expr =.. [C,Expr1,Expr2]}.

base(Expr) --> num(I), ws, { integer(I), Expr = I }.
base(Expr) --> "(", ws, add(Expr), ")", ws.

pow(Expr) --> chainr1(base,["^"],Expr).

negate(Expr) --> chainPrefix(pow,["-+"],Expr).

mul(Expr) --> chainl1(negate,["*","/"],Expr).

add(Expr) --> chainl1(mul,["+","-"],Expr).

expr(Expr) --> ws, add(Expr).

parseExpr(Str,Expr) :- phrase(expr(Expr), Str).

evalExpr(Str,Result) :- parseExpr(Str,Expr), Result is Expr.

% A ", []" rész nem csinált semmit az ég világon, a vesszővel utána rakott rész csak annyit mond meg,
% hogy az olvasás után megmaradt rész elé a megadott elemeket tegye be:
% egy hihetőbb példa rá:
look_ahead(E), [E] --> [E].
% Ez megnézi a következő elemet, de "nem nyeli le".
% Elfogyasztja, parse-olja, de vissza is rakja a maradék elejére.

% ------------------------------------------------------

% d-listák
% difference list

% Xs-Zs
% [1,2,3|Xs]-Xs == [1,2,3]

% [1,2,3|4]-4 % NEM d-lista
% [1,2,3|Xs]-Zs % d-lista

% D-lista mindaz, amely rendes lista vagy pedig a | után **változó** áll.

append_dl(Xs-Ys,Ys-Zs,Xs-Zs).

toDList([],Xs-Xs).
toDList([X|Xs],[X|As]-Bs) :- toDList(Xs,As-Bs).

append_(Xs,Ys,Zs) :- toDList(Xs,Dx), toDList(Ys,Dy), append_dl(Dx,Dy,Zs-[]).

reverse_dl(As-Xs,Bs-Ys) :-
    ( As == Xs -> Bs = Ys
    ; As = [C|Cs], reverse_dl(Cs-Xs,Bs-[C|Ys])
    ).

reverse_(Xs,Ys) :- reverse_dl(Xs-[],Ys-[]).