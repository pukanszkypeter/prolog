%% -*- Mode: Prolog; coding: utf-8 -*-

% ℕ
nat(0).
nat(s(X)) :- nat(X).

list([]). % Üres lista
list([_|Xs]) :- list(Xs). % Legalább egy elemű lista

% Legalább 2 elemű lista
% [X|[Y|Xs]].
% [X,Y|Xs].

null([]).

singleton([_]).

% . operátor
% .(1,[]) == [1]
% Első paraméter egy elem, második egy lista.

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
% Ezt úgy hívják, hogy "member"
elem(X,[X|_]). % 1 [1,6,7]
elem(X,[_|Xs]) :- elem(X,Xs).

% a([Xs],[Ys],[Xs,Ys]).

% Létező predikátum _ nélkül.
% append([1,2,3],[4,5,6],[1,2,3,4,5,6]).
append_([],L,L) :- list(L).
append_([X|Xs],Ys,[X|Zs]) :- append_(Xs,Ys,Zs).

% reverse_naive([],[]).
% reverse_naive([X|Xs],Zs) :- reverse_naive(Xs,As), append_(As,[X],Zs).

% reverse_naive(L_list,[1,2,3]).
% reverse_naive([L|Ls],[1,2,3]).
% reverse_naive(Ls,As), append_(As,[L],[1,2,3]).
% mind2 változó^^^^^^^
%  |                 \_________________ Ls = [LL|LLs]
% reverse_naive([],[])                  reverse_naive([LL|LLs],As)
% append_([],[L],[1,2,3])               reverse_naive(LLs,Bs), append_(Bs,[LL],As), append_(As, [L], [1,2,3]).
% no                                     |                   \____________________________ LLs = [LLL|LLLs]
%                                       reverse_naive([],[]),                              reverse_naive([LLL|LLLs],Bs)
%                                       append_([],[LL],As)                                reverse_naive(LLLs,Cs), append_(Cs,[LLL],Bs), append_(Bs,[LL],As) append_(As, [L], [1,2,3]).
%                                       As = [LL],                                          |                   \____________________________ A baj az, hogy erre is tud jönni.
%                                       append_([LL], [L], [1,2,3])                        reverse_naive([],[])                               LLLs = [LLLL|LLLLs]
%                                       no                                                 append_([],[LLL],Bs),                              reverse_naive([LLLL|LLLLs],Cs), 
%                                                                                          Bs = [LLL]                                         reverse_naive(LLLLs,Ds), append_(Ds,[LLLL],Cs), 
%                                                                                          append_([LLL],[LL],As),                            |  append_(Cs,[LLL],Bs), append_(Bs,[LL],As),
%                                                                                          As = [LLL,LL]                                      |  append_(As, [L], [1,2,3]).
%                                                                                          append_([LLL,LL], [L], [1,2,3]).                   |-------------------------------------És itt folytatódik
%                                                                                          LLL = 1, LL = 2, L = 3, L_list = [3,2,1].          reverse_naive([],[]),                 ugyanez tovább.
%                                                                                          Itt az eredmény.                                   append_([],[LLLL],Cs),
%                                                                                                                                             Cs = [LLLL],
%                                                                                                                                             append_([LLLL],[LLL],Bs),
%                                                                                                                                             Bs = [LLLL,LLL],
%                                                                                                                                             append_([LLLL,LLL],[LL],As),
%                                                                                                                                             As = [LLLL,LLL,LL],
%                                                                                                                                             append_([LLLL,LLL,LL],[L],[1,2,3]).
%                                                                                                                                             no
% split2([1,2,3,4],[1,3],[2,4]).
% split2([1,2,3],[1,3],[2]).

split2([],[],[]).
split2([X],[X],[]).
split2([X,Y|Xs],[X|As],[Y|Bs]) :- split2(Xs,As,Bs).

split2_([],[],[]).
split2_([X|Xs],[X|As],Bs) :- split2_(Xs,Bs,As).

% Létező predikátum _ nélkül.
% length_

length_([],0).
length_([_|Xs], s(N)) :- length_(Xs,N).

% length [] = 0
% length (_:xs) = 1 + length xs

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

% bin_tree
% Legyen levélben és csomópontban is adat.

% tree_member

% isotree_