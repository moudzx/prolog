% Algorithms: DFS, BFS, IDS, A*, UCS

edge(a, b).
edge(b, c).
edge(c, a).
edge(b, d).
edge(d, e).
goal(e).

dfs_path(Node, Node, [Node]).
dfs_path(Start, Goal, [Start|Path]) :-
    edge(Start, Next),
    dfs_path(Next, Goal, Path).

bfs_path(Start, Goal, Path) :-
    bfs([[Start]], Goal, RevPath),
    reverse(RevPath, Path).

bfs([[Goal|Path]|_], Goal, [Goal|Path]).
bfs([Path|Paths], Goal, Result) :-
    extend(Path, NewPaths),
    append(Paths, NewPaths, Paths1),
    bfs(Paths1, Goal, Result).

extend([Node|Path], NewPaths) :-
    findall([Next,Node|Path],
            (edge(Node, Next), not(member(Next, [Node|Path]))),
            NewPaths),
    !.
extend(_, []).

ids_path(Start, Goal, Path) :-
    between(1, 100, Depth),
    depth_limited(Start, Goal, Depth, Path),
    !.

depth_limited(Goal, Goal, _, [Goal]).
depth_limited(Start, Goal, Depth, [Start|Path]) :-
    Depth > 0,
    edge(Start, Next),
    NewDepth is Depth - 1,
    depth_limited(Next, Goal, NewDepth, Path).

path_cost(a, b, 5).
path_cost(a, c, 2).
path_cost(b, d, 4).
path_cost(c, d, 3).
path_cost(d, e, 1).
heuristic(e, 0).
heuristic(d, 1).
heuristic(c, 4).
heuristic(b, 6).
heuristic(a, 7).

astar_path(Start, Goal, Path, Cost) :-
    heuristic(Start, H),
    astar([[Start, H, 0, [Start]]], Goal, RevPath, Cost),
    reverse(RevPath, Path).

astar([[Goal, _, G, Path]|_], Goal, Path, G).
astar([Current|Frontier], Goal, ResultPath, ResultCost) :-
    Current = [Node, _, G, Path],
    findall([Child, NewF, NewG, [Child|Path]],
            (path_cost(Node, Child, StepCost),
             not(member(Child, Path)),
             NewG is G + StepCost,
             heuristic(Child, H),
             NewF is NewG + H),
            Children),
    merge(Children, Frontier, NewFrontier),
    astar(NewFrontier, Goal, ResultPath, ResultCost).

merge([], Frontier, Frontier).
merge([Child|Children], Frontier, NewFrontier) :-
    insert(Child, Frontier, TempFrontier),
    merge(Children, TempFrontier, NewFrontier).

insert(Child, [], [Child]).
insert(Child, [Front|Frontier], [Child, Front|Frontier]) :-
    Child = [_, F1, _, _],
    Front = [_, F2, _, _],
    F1 =< F2,
    !.
insert(Child, [Front|Frontier], [Front|NewFrontier]) :-
    insert(Child, Frontier, NewFrontier).

ucs_path(Start, Goal, Path, Cost) :-
    ucs([[Start, 0, [Start]]], Goal, RevPath, Cost),
    reverse(RevPath, Path).

ucs([[Goal, G, Path]|_], Goal, Path, G).
ucs([Current|Frontier], Goal, ResultPath, ResultCost) :-
    Current = [Node, G, Path],
    findall([Child, NewG, [Child|Path]],
            (path_cost(Node, Child, StepCost),
             not(member(Child, Path)),
             NewG is G + StepCost),
            Children),
    merge_ucs(Children, Frontier, NewFrontier),
    ucs(NewFrontier, Goal, ResultPath, ResultCost).

merge_ucs([], Frontier, Frontier).
merge_ucs([Child|Children], Frontier, NewFrontier) :-
    insert_ucs(Child, Frontier, TempFrontier),
    merge_ucs(Children, TempFrontier, NewFrontier).

insert_ucs(Child, [], [Child]).
insert_ucs(Child, [Front|Frontier], [Child, Front|Frontier]) :-
    Child = [_, G1, _],
    Front = [_, G2, _],
    G1 =< G2,
    !.
insert_ucs(Child, [Front|Frontier], [Front|NewFrontier]) :-
    insert_ucs(Child, Frontier, NewFrontier).