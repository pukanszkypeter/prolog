%% -*- Mode: Prolog; coding: utf-8 -*-

% Egyszerű állítások
% 2 zh
% mindkettőn 20-20 pont
% mindkettőn 8-8 pont a minimum
% 40% -tól 2
% 55% -tól 3
% 70% -tól 4
% 85% -tól 5

% next_state/2
next_state(green, yellow).
next_state(yellow, red).
next_state(red, yellow_red).
next_state(yellow_red, green).

% next_state/1
next_state(purple).

next2_state(X,Y) :- next_state(X,Z), next_state(Z,Y).

alma(_).

% Típusok:

bool(true).
bool(false).

not(true,false).
not(false,true).

and1(true,true,true).
and1(false,B,false) :- bool(B).
and1(A,false,false) :- bool(A).

and(true,B,B) :- bool(B).
and(false,B,false) :- bool(B).

if_then_else(true, A, _, A).
if_then_else(false, _, B, B).

flip_if_then_else(A,B,C,D) :- not(A, X), if_then_else(X,B,C,D).

