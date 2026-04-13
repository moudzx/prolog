% Algorithms: DFS, BFS, A*

move(chess, a1, a2).
move(chess, a1, b1).
move(chess, a2, a3).
move(chess, a2, b2).
move(chess, a3, a4).
move(chess, a3, b3).
move(chess, a4, a5).
move(chess, a4, b4).
move(chess, b1, b2).
move(chess, b1, c1).
move(chess, b2, b3).
move(chess, b2, c2).
goal_chess(b4).

dfs_chess(Start, Goal) :-
    dfs_chess(Start, Goal, [Start]).

dfs_chess(Goal, Goal, _).
dfs_chess(Start, Goal, Visited) :-
    move(chess, Start, Next),
    not(member(Next, Visited)),
    dfs_chess(Next, Goal, [Next|Visited]).

bfs_chess(Start, Goal) :-
    bfs_chess([[Start]], Goal).

bfs_chess([[Goal|Path]|_], Goal) :-
    reverse([Goal|Path], _).
bfs_chess([Path|Paths], Goal) :-
    findall([Next,Path],
            (move(chess, Path, Next), not(member(Next, Path))),
            NewPaths),
    append(Paths, NewPaths, Paths1),
    bfs_chess(Paths1, Goal).

heuristic_chess(a1, 5).
heuristic_chess(a2, 4).
heuristic_chess(a3, 3).
heuristic_chess(a4, 2).
heuristic_chess(b1, 4).
heuristic_chess(b2, 3).
heuristic_chess(b3, 2).
heuristic_chess(b4, 1).
heuristic_chess(c1, 3).
heuristic_chess(c2, 2).

move_cost(chess, a1, a2, 1).
move_cost(chess, a1, b1, 2).
move_cost(chess, a2, a3, 1).
move_cost(chess, a2, b2, 2).
move_cost(chess, a3, a4, 1).
move_cost(chess, a3, b3, 2).
move_cost(chess, a4, a5, 1).
move_cost(chess, a4, b4, 2).
move_cost(chess, b1, b2, 1).
move_cost(chess, b1, c1, 2).
move_cost(chess, b2, b3, 1).
move_cost(chess, b2, c2, 2).

astar_chess(Start, Goal, Path, Cost) :-
    heuristic_chess(Start, H),
    astar_chess([[Start, H, 0, [Start]]], Goal, RevPath, Cost),
    reverse(RevPath, Path).

astar_chess([[Goal, _, G, Path]|_], Goal, Path, G).
astar_chess([Current|Frontier], Goal, ResultPath, ResultCost) :-
    Current = [Node, _, G, Path],
    findall([Child, NewF, NewG, [Child|Path]],
            (move_cost(chess, Node, Child, StepCost),
             not(member(Child, Path)),
             NewG is G + StepCost,
             heuristic_chess(Child, H),
             NewF is NewG + H),
            Children),
    merge_chess(Children, Frontier, NewFrontier),
    astar_chess(NewFrontier, Goal, ResultPath, ResultCost).

merge_chess([], Frontier, Frontier).
merge_chess([Child|Children], Frontier, NewFrontier) :-
    insert_chess(Child, Frontier, TempFrontier),
    merge_chess(Children, TempFrontier, NewFrontier).

insert_chess(Child, [], [Child]).
insert_chess(Child, [Front|Frontier], [Child, Front|Frontier]) :-
    Child = [_, F1, _, _],
    Front = [_, F2, _, _],
    F1 =< F2,
    !.
insert_chess(Child, [Front|Frontier], [Front|NewFrontier]) :-
    insert_chess(Child, Frontier, NewFrontier).