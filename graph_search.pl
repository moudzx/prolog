edge(start, cheap1).
edge(start, expensive1).
edge(start, cycle_start).
edge(start, medium1).
edge(start, deep1).
edge(start, short1).
edge(start, direct_goal).
edge(cheap1, cheap2).
edge(cheap2, cheap3).
edge(cheap3, goal).
edge(expensive1, expensive2).
edge(expensive2, expensive3).
edge(expensive3, goal).
edge(cycle_start, cycle_middle).
edge(cycle_middle, cycle_end).
edge(cycle_end, cycle_start).
edge(cycle_end, goal).
edge(medium1, medium2).
edge(medium2, medium3).
edge(medium3, medium4).
edge(medium4, goal).
edge(deep1, deep2).
edge(deep2, deep3).
edge(deep3, deep4).
edge(deep4, deep5).
edge(deep5, deep6).
edge(deep6, deep7).
edge(deep7, deep8).
edge(deep8, deep9).
edge(deep9, deep10).
edge(deep10, goal).
edge(short1, goal).
edge(start, direct_goal).
goal(goal).

path_cost(start, cheap1, 1).
path_cost(cheap1, cheap2, 1).
path_cost(cheap2, cheap3, 1).
path_cost(cheap3, goal, 1).
path_cost(start, expensive1, 200).
path_cost(expensive1, expensive2, 200).
path_cost(expensive2, expensive3, 200).
path_cost(expensive3, goal, 200).
path_cost(start, cycle_start, 10).
path_cost(cycle_start, cycle_middle, 10).
path_cost(cycle_middle, cycle_end, 10).
path_cost(cycle_end, cycle_start, 1).
path_cost(cycle_end, goal, 10).
path_cost(start, medium1, 50).
path_cost(medium1, medium2, 50).
path_cost(medium2, medium3, 50).
path_cost(medium3, medium4, 50).
path_cost(medium4, goal, 50).
path_cost(start, deep1, 100).
path_cost(deep1, deep2, 100).
path_cost(deep2, deep3, 100).
path_cost(deep3, deep4, 100).
path_cost(deep4, deep5, 100).
path_cost(deep5, deep6, 100).
path_cost(deep6, deep7, 100).
path_cost(deep7, deep8, 100).
path_cost(deep8, deep9, 100).
path_cost(deep9, deep10, 100).
path_cost(deep10, goal, 100).
path_cost(start, short1, 30).
path_cost(short1, goal, 30).
path_cost(start, direct_goal, 500).

heuristic(goal, 0).
heuristic(cheap3, 1).
heuristic(cheap2, 2).
heuristic(cheap1, 3).
heuristic(expensive3, 50).
heuristic(expensive2, 100).
heuristic(expensive1, 150).
heuristic(cycle_end, 5).
heuristic(cycle_middle, 10).
heuristic(cycle_start, 15).
heuristic(medium4, 30).
heuristic(medium3, 60).
heuristic(medium2, 90).
heuristic(medium1, 120).
heuristic(deep10, 10).
heuristic(deep9, 20).
heuristic(deep8, 30).
heuristic(deep7, 40).
heuristic(deep6, 50).
heuristic(deep5, 60).
heuristic(deep4, 70).
heuristic(deep3, 80).
heuristic(deep2, 90).
heuristic(deep1, 100).
heuristic(short1, 25).
heuristic(direct_goal, 1).
heuristic(start, 30).

dfs_path(Start, Goal, Path) :-
    dfs_helper(Start, Goal, [Start], RevPath),
    reverse(RevPath, Path),
    !.

dfs_helper(Goal, Goal, Visited, Visited).
dfs_helper(Current, Goal, Visited, Path) :-
    edge(Current, Next),
    not(member(Next, Visited)),
    dfs_helper(Next, Goal, [Next|Visited], Path).

bfs_path(Start, Goal, Path) :-
    bfs([[Start]], Goal, RevPath),
    reverse(RevPath, Path),
    !.

bfs([[Goal|Path]|_], Goal, [Goal|Path]).
bfs([Path|Paths], Goal, Result) :-
    extend_bfs(Path, NewPaths),
    append(Paths, NewPaths, Paths1),
    bfs(Paths1, Goal, Result).

extend_bfs([Node|Path], NewPaths) :-
    findall([Next,Node|Path],
            (edge(Node, Next), not(member(Next, [Node|Path]))),
            NewPaths),
    !.
extend_bfs(_, []).

ids_path(Start, Goal, Path) :-
    ids(Start, Goal, 1, RevPath),
    reverse(RevPath, Path),
    !.

ids(Start, Goal, Depth, Path) :-
    depth_limited(Start, Goal, Depth, [Start], Path),
    !.
ids(Start, Goal, Depth, Path) :-
    NewDepth is Depth + 1,
    ids(Start, Goal, NewDepth, Path).

depth_limited(Goal, Goal, _, Visited, Visited).
depth_limited(Current, Goal, Depth, Visited, Path) :-
    Depth > 0,
    edge(Current, Next),
    not(member(Next, Visited)),
    NewDepth is Depth - 1,
    depth_limited(Next, Goal, NewDepth, [Next|Visited], Path).

astar_path(Start, Goal, Path, Cost) :-
    heuristic(Start, H),
    astar([[Start, H, 0, [Start]]], Goal, RevPath, Cost),
    reverse(RevPath, Path),
    !.

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
    merge_astar(Children, Frontier, NewFrontier),
    astar(NewFrontier, Goal, ResultPath, ResultCost).

merge_astar([], Frontier, Frontier).
merge_astar([Child|Children], Frontier, NewFrontier) :-
    insert_astar(Child, Frontier, TempFrontier),
    merge_astar(Children, TempFrontier, NewFrontier).

insert_astar(Child, [], [Child]).
insert_astar(Child, [Front|Frontier], [Child, Front|Frontier]) :-
    Child = [_, F1, _, _],
    Front = [_, F2, _, _],
    F1 =< F2,
    !.
insert_astar(Child, [Front|Frontier], [Front|NewFrontier]) :-
    insert_astar(Child, Frontier, NewFrontier).

ucs_path(Start, Goal, Path, Cost) :-
    ucs([[Start, 0, [Start]]], Goal, RevPath, Cost),
    reverse(RevPath, Path),
    !.

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

greedy_path(Start, Goal, Path) :-
    heuristic(Start, H),
    greedy([[Start, H, 0, [Start]]], Goal, RevPath),
    reverse(RevPath, Path),
    !.

greedy([[Goal, _, _, Path]|_], Goal, Path).
greedy([Current|Frontier], Goal, ResultPath) :-
    Current = [Node, _, G, Path],
    findall([Child, H, NewG, [Child|Path]],
            (path_cost(Node, Child, StepCost),
             not(member(Child, Path)),
             NewG is G + StepCost,
             heuristic(Child, H)),
            Children),
    merge_greedy(Children, Frontier, NewFrontier),
    greedy(NewFrontier, Goal, ResultPath).

merge_greedy([], Frontier, Frontier).
merge_greedy([Child|Children], Frontier, NewFrontier) :-
    insert_greedy(Child, Frontier, TempFrontier),
    merge_greedy(Children, TempFrontier, NewFrontier).

insert_greedy(Child, [], [Child]).
insert_greedy(Child, [Front|Frontier], [Child, Front|Frontier]) :-
    Child = [_, H1, _, _],
    Front = [_, H2, _, _],
    H1 =< H2,
    !.
insert_greedy(Child, [Front|Frontier], [Front|NewFrontier]) :-
    insert_greedy(Child, Frontier, NewFrontier).

compute_path_cost([_], 0).
compute_path_cost([X,Y|Rest], TotalCost) :-
    path_cost(X, Y, Cost),
    compute_path_cost([Y|Rest], RestCost),
    TotalCost is Cost + RestCost.

compare_all :-
    write('SEARCH ALGORITHMS COMPARISON'), nl, nl,
    
    write('1. DEPTH-FIRST SEARCH (DFS):'), nl,
    dfs_path(start, goal, DFSPath),
    write('   Path: '), write(DFSPath), nl,
    length(DFSPath, DFSSteps),
    write('   Steps: '), write(DFSSteps), nl,
    compute_path_cost(DFSPath, DFSCost),
    write('   Cost: '), write(DFSCost), nl, nl,
    
    write('2. BREADTH-FIRST SEARCH (BFS):'), nl,
    bfs_path(start, goal, BFSPath),
    write('   Path: '), write(BFSPath), nl,
    length(BFSPath, BFSSteps),
    write('   Steps: '), write(BFSSteps), nl,
    compute_path_cost(BFSPath, BFSCost),
    write('   Cost: '), write(BFSCost), nl, nl,
    
    write('3. ITERATIVE DEEPENING (IDS):'), nl,
    ids_path(start, goal, IDSPath),
    write('   Path: '), write(IDSPath), nl,
    length(IDSPath, IDSSteps),
    write('   Steps: '), write(IDSSteps), nl,
    compute_path_cost(IDSPath, IDSCost),
    write('   Cost: '), write(IDSCost), nl, nl,
    
    write('4. A* SEARCH (Optimal Cost):'), nl,
    astar_path(start, goal, AStarPath, AStarCost),
    write('   Path: '), write(AStarPath), nl,
    length(AStarPath, AStarSteps),
    write('   Steps: '), write(AStarSteps), nl,
    write('   Cost: '), write(AStarCost), nl, nl,
    
    write('5. UNIFORM COST SEARCH (UCS):'), nl,
    ucs_path(start, goal, UCSPath, UCSCost),
    write('   Path: '), write(UCSPath), nl,
    length(UCSPath, UCSSteps),
    write('   Steps: '), write(UCSSteps), nl,
    write('   Cost: '), write(UCSCost), nl, nl,
    
    write('6. GREEDY BEST-FIRST (GREEDY):'), nl,
    greedy_path(start, goal, GreedyPath),
    write('   Path: '), write(GreedyPath), nl,
    length(GreedyPath, GreedySteps),
    write('   Steps: '), write(GreedySteps), nl,
    compute_path_cost(GreedyPath, GreedyCost),
    write('   Cost: '), write(GreedyCost), nl, nl,
    
    write('SUMMARY OF DIFFERENCES:'), nl,
    write('DFS:      First path found (cheap1 branch)'), nl,
    write('BFS:      Shortest path by steps (direct_goal)'), nl,
    write('IDS:      First path at minimum depth'), nl,
    write('A*:       Cheapest path by cost (cost=4)'), nl,
    write('UCS:      Same as A* without heuristic'), nl,
    write('GREEDY:   Greedy by heuristic (direct_goal)'), nl.

compare_steps :-
    dfs_path(start, goal, DFS),
    bfs_path(start, goal, BFS),
    length(DFS, DFSLen),
    length(BFS, BFSLen),
    write('DFS steps: '), write(DFSLen), nl,
    write('BFS steps: '), write(BFSLen), nl,
    (BFSLen < DFSLen -> 
        write('BFS finds SHORTER path by '), write(DFSLen - BFSLen), write(' steps'), nl
    ; write('DFS finds shorter path')), nl.

compare_optimal :-
    astar_path(start, goal, _, ACost),
    ucs_path(start, goal, _, UCost),
    write('A* cost: '), write(ACost), nl,
    write('UCS cost: '), write(UCost), nl,
    (ACost =:= UCost -> 
        write('Both find optimal cost (same)'), nl
    ; write('Different costs!')), nl.

compare_greedy :-
    greedy_path(start, goal, GreedyPath),
    astar_path(start, goal, AStarPath, AStarCost),
    compute_path_cost(GreedyPath, GreedyCost),
    write('GREEDY path: '), write(GreedyPath), nl,
    write('GREEDY cost: '), write(GreedyCost), nl,
    write('A* path:     '), write(AStarPath), nl,
    write('A* cost:     '), write(AStarCost), nl,
    (GreedyCost > AStarCost ->
        write('GREEDY found MORE EXPENSIVE path (greedy not optimal)'), nl
    ; write('GREEDY found optimal path')), nl.
