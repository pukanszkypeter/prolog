%% -*- Mode: Prolog; coding: utf-8 -*-

% :- set_prolog_flag(toplevel_print_options, [max_depth(10000)]).
bool(true).
bool(false).

not(true,false).
not(false,true).

or(true, B, true) :- bool(B).
or(false, B, B) :- bool(B).

% A | B | A ⊃ B
% i | i |   i
% i | h |   h
% h | i |   i
% h | h |   i

impl(true,false,false).
impl(true, true, true).
impl(false, A, true) :- bool(A).

impl2(A,B,C) :-
    bool(A),
    bool(B),
    bool(C),
    not(A,D),
    or(D,B,C).

% ----------------------------------------

% ℕ
nat(0).
nat(s(X)) :- nat(X).

plus3(X,s(s(s(X)))) :- nat(X).

add(0,X,X) :- nat(X).
add(s(X),Y,s(Z)) :- add(X,Y,Z).

% 0 + x = x
% s(n) + x = s (n + x)

divideBy2(A,B) :- add(B,B,A).

% x + x = 2 * x

mulBackward(0,M,0) :- nat(M).
mulBackward(s(N),M,X) :-
    add(Y,M,X),
    mulBackward(N,M,Y).

mulForward(0,M,0) :- nat(M).
mulForward(s(N),M,X) :-
    mulForward(N,M,Y),
    add(Y,M,X).

% -------------------------

list([]). % Üres lista
list([_|Xs]) :- list(Xs). % Legalább egy elemű lista

% Legalább 2 elemű lista
% [X|[Y|Xs]].
% [X,Y|Xs].

null([]).

singleton([_]).
% Lista elemeit fel lehet sorolni vesszőkkel elválasztva
% pl. [1,alma,3]

myList(nil).
myList(cons(_,Xs)) :- myList(Xs).
% cons(1,cons(2,cons(alma,nil))).

head([X|_], X).
tail([_|Xs], Xs).

last_([Y],Y).
last_([_|Xs],Y) :- last_(Xs,Y).

% init [_] = []
% init (x:xs) = x : init xs

init([_],[]).
init([X|Xs], [X|Ys]) :- init(Xs,Ys).

% Egy adott érték eleme-e a listának.
% 1 [2,4,1,6,7]
elem(X,[X|_]). % 1 [1,6,7]
elem(X,[_|Xs]) :- elem(X,Xs).