%% -*- Mode: Prolog; coding: utf-8 -*-

% module/2
:- module(gy08, [add/3, contains/2, map/3, filter/3]).

:- set_prolog_flag(legacy_char_classification,on).

:- set_prolog_flag(toplevel_print_options,
    [quoted(true),numbervars(true),portrayed(true),
                                   max_depth(10000)]).

% Normális számok összeadására írjunk minden irányba működő predikátumot.
% Legalább 2 paraméternek ismertnek kell lennie.
add(X,Y,Z) :-
    number(X),
    number(Y),
    var(Z),
    Z is X + Y.
add(X,Y,Z) :-
    number(X),
    var(Y),
    number(Z),
    Y is Z - X.
add(X,Y,Z) :-
    var(X),
    number(Y),
    number(Z),
    X is Z - Y.
add(X,Y,Z) :-
    number(X),
    number(Y),
    number(Z),
    Z is X + Y.

% functor(X,Y,Z), ahol X egy term, Y == (X =.. [Y|_]), Z az Y aritása (hány paraméteres).

% arg(N,T,X), ahol N > 0 egy egész szám, T egy összetett (compound) term, X T-nek az N. paramétere.
% 1-től indexel.

% call/1.
% A call futtatja/kiértékeli az átadott prediktáumot.


% contains(T,X), T-ben (termben) szerepel-e X.
% contains(f(1,2),1)
% contains(f(1,2),2)
% contains(f(1,2),f(1,2))

% contains(f(X,Y),X)
% contains(f(X,Y),Y)
% contains(f(X,Y),f(X,Y))

% contains(g(f(a,b),h(i,j)),a)
% contains(g(f(a,b),h(i,j)),b)
% contains(g(f(a,b),h(i,j)),i)
% contains(g(f(a,b),h(i,j)),j)
% contains(g(f(a,b),h(i,j)),f(a,b))
% contains(g(f(a,b),h(i,j)),h(i,j))
% contains(g(f(a,b),h(i,j)),g(f(a,b),h(i,j)))

contains(T,X) :-
    (T == X ->
        true
    ;
        compound(T), functor(T,_,N), contains_in_arg(N,T,X)).

contains_in_arg(N,T,X) :-
    (arg(N,T,T2), contains(T2,X) ->
        true
    ;
        N > 1, N1 is N - 1, contains_in_arg(N1,T,X)).

% map: alkalmaz egy predikátumot egy lista összes elemén.
% callable/1: Ellenőrzi, hogy a paraméter egy atom vagy compound-e.
% call/3: call(A,B,C) -> A(B,C), amit futtat is.
map(_,[],[]).
map(F,[X|Xs],[FX|Ys]) :-
%   F =.. Ts,
%   append(Ts,[X,FX],Ts1),
%   F1 =.. Ts1,
%   call(F1), % ezt csinálja meg nekünk a call/3
    call(F,X,FX),
    map(F,Xs,Ys).
% map(add(1),[1,5,10],Xs).
% [add(1,1,X),add(1,5,Y),add(1,10,Z)], Xs = [X,Y,Z]

filter(_,[],[]).
filter(P,[X|Xs],Ys) :-
    (call(P,X) ->
        Ys = [X|Zs], filter(P,Xs,Zs)
    ;
        filter(P,Xs,Ys)).