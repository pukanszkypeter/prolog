%% -*- Mode: Prolog; coding: utf-8 -*-

% Prolog config
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

impl(true, A, A) :- bool(A).
impl(false, A, true) :- bool(A).

% implikáció a (vagy) függvény megfordításával
impl_not_or(A,B,C) :-
    bool(A),
    bool(B),
    bool(C),
    not(A,D),
    or(D,B,C).

% ----------------------------------------

% ℕ - természetes számok
nat(0).
nat(s(X)) :- nat(X).

% számhoz adunk 3-t
plus_3(X,s(s(s(X)))) :- nat(X).

% 0 + x = x
add(0,X,X) :- nat(X).
% s(n) + x = s (n + x)
add(s(X),Y,s(Z)) :- add(X,Y,Z).

% x + x = 2 * x
divideBy2(A,B) :- add(B,B,A).

mulBackward(0,M,0) :- nat(M).
mulBackward(s(N),M,X) :-
    add(Y,M,X),
    mulBackward(N,M,Y).

mulForward(0,M,0) :- nat(M).
mulForward(s(N),M,X) :-
    mulForward(N,M,Y),
    add(Y,M,X).

% ----------------------------------------

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