:- use_module(library(lists)).

node_coords(a1,1,1). node_coords(a2,1,2). node_coords(a3,1,3).
node_coords(a4,1,4). node_coords(a5,1,5). node_coords(a6,1,6).
node_coords(b1,2,1). node_coords(b2,2,2). node_coords(b3,2,3).
node_coords(b4,2,4). node_coords(b5,2,5). node_coords(b6,2,6).
node_coords(c1,3,1). node_coords(c2,3,2). node_coords(c3,3,3).
node_coords(c4,3,4). node_coords(c5,3,5). node_coords(c6,3,6).
node_coords(d1,4,1). node_coords(d2,4,2). node_coords(d3,4,3).
node_coords(d4,4,4). node_coords(d5,4,5). node_coords(d6,4,6).
node_coords(e1,5,1). node_coords(e2,5,2). node_coords(e3,5,3).
node_coords(e4,5,4). node_coords(e5,5,5). node_coords(e6,5,6).
node_coords(f1,6,1). node_coords(f2,6,2). node_coords(f3,6,3).
node_coords(f4,6,4). node_coords(f5,6,5). node_coords(f6,6,6).

node_coords(trap1,0,1). node_coords(trap2,0,2). node_coords(trap3,0,3).
node_coords(trap4,0,4). node_coords(trap5,0,5). node_coords(trap6,0,6).
node_coords(trap7,0,7). node_coords(trap8,0,8). node_coords(trap9,0,9).
node_coords(trap10,0,10).
node_coords(trap11,0,11). node_coords(trap12,0,12). node_coords(trap13,0,13).
node_coords(trap14,0,14). node_coords(trap15,0,15). node_coords(trap16,0,16).
node_coords(trap17,0,17). node_coords(trap18,0,18). node_coords(trap19,0,19).
node_coords(trap20,0,20).
node_coords(trap21,0,21). node_coords(trap22,0,22). node_coords(trap23,0,23).
node_coords(trap24,0,24). node_coords(trap25,0,25). node_coords(trap26,0,26).
node_coords(trap27,0,27). node_coords(trap28,0,28). node_coords(trap29,0,29).
node_coords(trap30,0,30).

move(chess, a1, a2). move(chess, a1, b1).
move(chess, a2, a3). move(chess, a2, b2).
move(chess, a3, a4). move(chess, a3, b3).
move(chess, a4, a5). move(chess, a4, b4).
move(chess, a5, a6). move(chess, a5, b5).
move(chess, a6, b6).
move(chess, b1, b2). move(chess, b1, c1).
move(chess, b2, b3). move(chess, b2, c2).
move(chess, b3, b4). move(chess, b3, c3).
move(chess, b4, b5). move(chess, b4, c4).
move(chess, b5, b6). move(chess, b5, c5).
move(chess, b6, c6).
move(chess, c1, c2). move(chess, c1, d1).
move(chess, c2, c3). move(chess, c2, d2).
move(chess, c3, c4). move(chess, c3, d3).
move(chess, c4, c5). move(chess, c4, d4).
move(chess, c5, c6). move(chess, c5, d5).
move(chess, c6, d6).
move(chess, d1, d2). move(chess, d1, e1).
move(chess, d2, d3). move(chess, d2, e2).
move(chess, d3, d4). move(chess, d3, e3).
move(chess, d4, d5). move(chess, d4, e4).
move(chess, d5, d6). move(chess, d5, e5).
move(chess, d6, e6).
move(chess, e1, e2). move(chess, e1, f1).
move(chess, e2, e3). move(chess, e2, f2).
move(chess, e3, e4). move(chess, e3, f3).
move(chess, e4, e5). move(chess, e4, f4).
move(chess, e5, e6). move(chess, e5, f5).
move(chess, e6, f6).
move(chess, f1, f2). move(chess, f2, f3).
move(chess, f3, f4). move(chess, f4, f5).
move(chess, f5, f6).

move(chess, a1, trap1). move(chess, trap1, trap2). 
move(chess, trap2, trap3). move(chess, trap3, trap4). 
move(chess, trap4, trap5). move(chess, trap5, trap6).
move(chess, trap6, trap7). move(chess, trap7, trap8). 
move(chess, trap8, trap9). move(chess, trap9, trap10).

move(chess, c3, trap11). move(chess, trap11, trap12). 
move(chess, trap12, trap13). move(chess, trap13, trap14). 
move(chess, trap14, trap15). move(chess, trap15, trap16).
move(chess, trap16, trap17). move(chess, trap17, trap18). 
move(chess, trap18, trap19). move(chess, trap19, trap20).

move(chess, e3, trap21). move(chess, trap21, trap22). 
move(chess, trap22, trap23). move(chess, trap23, trap24). 
move(chess, trap24, trap25). move(chess, trap25, trap26).
move(chess, trap26, trap27). move(chess, trap27, trap28). 
move(chess, trap28, trap29). move(chess, trap29, trap30).

dfs(Start, Goal, Path) :-
    dfs(Start, Goal, [Start], RevPath),
    reverse(RevPath, Path).

dfs(Goal, Goal, Visited, Visited).
dfs(Start, Goal, Visited, Path) :-
    move(chess, Start, Next),
    \+ member(Next, Visited),
    dfs(Next, Goal, [Next|Visited], Path).

bidirectional(Start, Goal, Path) :-
    bidirectional([Start], [Goal], [Start], [Goal], Start, Goal, Path).

bidirectional([FNode|_], [BNode|_], FVisited, BVisited, Start, Goal, Path) :-
    member(FNode, BVisited),
    !,
    build_path(FNode, Start, Goal, FVisited, BVisited, Path).
bidirectional([FNode|_], [BNode|_], FVisited, BVisited, Start, Goal, Path) :-
    member(BNode, FVisited),
    !,
    build_path(BNode, Start, Goal, FVisited, BVisited, Path).
bidirectional([FNode|FRest], [BNode|BRest], FVisited, BVisited, Start, Goal, Path) :-
    findall(Next, (move(chess, FNode, Next), \+ member(Next, FVisited)), FChildren),
    findall(Prev, (move(chess, Prev, BNode), \+ member(Prev, BVisited)), BChildren),
    append(FRest, FChildren, NewFFrontier),
    append(BRest, BChildren, NewBFrontier),
    append(FChildren, FVisited, NewFVisited),
    append(BChildren, BVisited, NewBVisited),
    bidirectional(NewFFrontier, NewBFrontier, NewFVisited, NewBVisited, Start, Goal, Path).

build_path(Node, Start, Goal, FVisited, BVisited, Path) :-
    forward_path(Node, Start, FVisited, [], Forward),
    reverse(Forward, FPath),
    backward_path(Node, Goal, BVisited, [], BPath),
    append(FPath, [Node|BPath], Path).

forward_path(Node, Start, _, Acc, Path) :-
    Node = Start,
    Path = Acc.
forward_path(Node, Start, Visited, Acc, Path) :-
    move(chess, Parent, Node),
    member(Parent, Visited),
    forward_path(Parent, Start, Visited, [Parent|Acc], Path).

backward_path(Node, Goal, _, Acc, Path) :-
    Node = Goal,
    Path = Acc.
backward_path(Node, Goal, Visited, Acc, Path) :-
    move(chess, Node, Child),
    member(Child, Visited),
    backward_path(Child, Goal, Visited, [Child|Acc], Path).

run_example(Start, Goal) :-
    write('========================================='), nl,
    write('Start: '), write(Start), write('  Goal: '), write(Goal), nl,
    write('========================================='), nl,
    
    statistics(runtime, [T1|_]),
    dfs(Start, Goal, DFSPath),
    statistics(runtime, [T2|_]),
    DFSTime is T2 - T1,
    write('DFS Path: '), write(DFSPath), nl,
    length(DFSPath, L1),
    write('DFS Length: '), write(L1), nl,
    write('DFS Time: '), write(DFSTime), write(' ms'), nl, nl,
    
    statistics(runtime, [T3|_]),
    bidirectional(Start, Goal, BiPath),
    statistics(runtime, [T4|_]),
    BiTime is T4 - T3,
    write('Bidirectional Path: '), write(BiPath), nl,
    length(BiPath, L2),
    write('Bidirectional Length: '), write(L2), nl,
    write('Bidirectional Time: '), write(BiTime), write(' ms'), nl, nl,
    
    write('========================================='), nl,
    (DFSTime =:= 0 -> 
        write('DFS completed in less than 1 ms'), nl
    ; BiTime =:= 0 ->
        write('Bidirectional completed in less than 1 ms'), nl
    ; BiTime < DFSTime -> 
        Speedup is DFSTime / BiTime,
        write('Bidirectional is '), write(Speedup), write('x faster!'), nl
    ; DFSTime < BiTime ->
        Speedup is BiTime / DFSTime,
        write('DFS is '), write(Speedup), write('x faster'), nl
    ;
        write('Both algorithms have similar speed'), nl
    ),
    write('========================================='), nl.

example1 :- run_example(a1, f6).
