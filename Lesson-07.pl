%% -*- Mode: Prolog; coding: utf-8 -*-

:- set_prolog_flag(legacy_char_classification,on).

:- set_prolog_flag(toplevel_print_options,
    [quoted(true),numbervars(true),portrayed(true),
                                   max_depth(10000)]).

fact(0,1).
fact(X,N) :-
    X > 0,
    X1 is X - 1,
    fact(X1,K),
    N is K * X.

fact_opt(X,N) :- fact_helper(X,1,N).

fact_helper(0,Acc,Acc).
fact_helper(X,Acc,N) :-
    X > 0,
    X1 is X - 1,
    R is X * Acc,
    fact_helper(X1,R,N).

lucas(0,2).
lucas(1,1).
lucas(X,N) :-
    X > 1,
    X1 is X - 1,
    X2 is X - 2,
    lucas(X1,N1),
    lucas(X2,N2),
    N is N1 + N2.

lucas_opt(X,N) :- lucas_opt_helper(X,1,2,N).

lucas_opt_helper(0,_,A2,A2).
lucas_opt_helper(1,A1,_,A1).
lucas_opt_helper(X,A1,A2,N) :-
    X > 1,
    X1 is X - 1,
    A3 is A1 + A2,
    lucas_opt_helper(X1,A3,A1,N).

% Vágók
% !/0

minimum0(X,Y,X) :- X =< Y.
minimum0(X,Y,Y) :- Y < X.
% minimum0(3,4,X).
%  X = 3 ? ;
% no

minimum1(X,Y,X) :- X =< Y, !. % Zöld vágó: A predikátum működését a vágó szemantikailag nem befolyásolja.
minimum1(X,Y,Y) :- Y < X.

% rossz
% minimum2_(X,Y,Z) :- X = Z, X =< Y, !. % ua, mint az alatta lévő sor.
minimum2(X,Y,X) :- X =< Y, !. % Piros vágó: A predikátum működését a vágó szemantikailag befolyásolja.
minimum2(_,Y,Y).

minimum3(X,Y,Z) :- X =< Y, !, Z = X. % Piros vágó
minimum3(_,Y,Y).

minimum4(X,Y,Z) :- X =< Y, !, Z = X. % Zöld vágó
minimum4(X,Y,Y) :- Y < X.

% rossz
minimum5(X,Y,Z) :- (X =< Y, Z = X) ; Z = Y.
% ua, mint minimum3 a ! nélkül

% Lokális vágó
minimum6(X,Y,Z) :- (X =< Y -> Z = X) ; Z = Y.

% rossz
minimum7(X,Y,Z) :- X =< Y, Z = X -> true ; Z = Y.
% Attól még mindig vágás után illesztünk!

% -------------------------------------------------------
% STO = Subject To Occurs-check

member_nsto(X,[Y|_]) :- X = Y.
member_nsto(X,[_|Xs]) :- member_nsto(X,Xs).

member_sto(X,[Y|_]) :- unify_with_occurs_check(X,Y).
member_sto(X,[_|Xs]) :- member_sto(X,Xs).

~=(X,Y) :- unify_with_occurs_check(X,Y).

:- op(700,xfx,'~=').