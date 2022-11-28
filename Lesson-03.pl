%% -*- Mode: Prolog; coding: utf-8 -*-

% ℕ - természetes számok
nat(0).
nat(s(X)) :- nat(X).

% Üres lista
list([]).

% Legalább egy elemű lista
list([_|Xs]) :- list(Xs).

% Legalább 2 elemű lista
% [X|[Y|Xs]].
% [X,Y|Xs].

null([]).

singleton([_]).

% . operátor
% .(1,[]) == [1]
% 1 paraméter egy elem, 2 egy lista.

doubleton([_,_]).
doubleton_(.(_,.(_,[]))).

head([X|_], X).
tail([_|Xs], Xs).

% Létező predikátum _ nélkül.
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

% Létező predikátum _ nélkül.
% append([1,2,3],[4,5,6],[1,2,3,4,5,6]).
append_([],L,L) :- list(L).
append_([X|Xs],Ys,[X|Zs]) :- append_(Xs,Ys,Zs).

% split2([1,2,3,4],[1,3],[2,4]).
% split2([1,2,3],[1,3],[2]).
split2([],[],[]).
split2([X],[X],[]).
split2([X,Y|Xs],[X|As],[Y|Bs]) :- split2(Xs,As,Bs).

split2_([],[],[]).
split2_([X|Xs],[X|As],Bs) :- split2_(Xs,Bs,As).

% Létező predikátum _ nélkül.
length_([],0).
length_([_|Xs], s(N)) :- length_(Xs,N).

% reverse_naive([1,2,3], [3,2,1]).
reverse_naive([],[]).
reverse_naive([X|Xs],Zs) :- reverse_naive(Xs,As), append_(As,[X],Zs).

replicate(0,_,[]).
replicate(s(N),X,[X|Xs]) :- replicate(N,X,Xs).

% Létező predikátum _ nélkül.
% reverse_([1,2,3], [3,2,1]).
reverse_(Xs,Ys) :- reverse_acc(Xs,[],Ys).

reverse_acc([],Acc,Acc).
reverse_acc([X|Xs],Acc,Ys) :- reverse_acc(Xs,[X|Acc],Ys).