# Prolog

Prolog Programming Language<br/>
<br/>
Prolog is a declarative programming language<br/>
it's primarily used as a rational agent, classical AI<br/>
it percepts queries as input and perform search using DFS with backtracking<br/>
its based on predicate logic<br/>
since it's not an imperative language, there's no loops<br/>
its execution model makes recursion the most natural way to express repetition and search<br/>
<br/>
<br/>

---

## DFS (Depth-first search)

DFS (Depth-first search) is a Stack (LIFO) based algorithm<br/>
Top-to-bottom, left-to-right node traversal<br/>
therefore, DFS is structurally optimal for recursion<br/>
this execusion model aligns perfectly with how the call stack in recursion works :<br/>
	function call = visit node<br/>
	recursive call = go deeper<br/>
	return from function = backtrack<br/>
	call stack frames = path tracking<br/>
<br/>

### Pros and Cons of DFS:
Memory efficiency (Linear space complexity)<br/>
Incompleteness (can stuck in infinite loop)<br/>
(more later)<br/>
<br/>

---------------------------------------------------------------------------------------------------

## Example


    parent(mary, moss).
    parent(moss, leen).
    
    grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

facts and rules.<br/>
fact: mary is parent of moss.<br/>
fact: moss is parent of leen.<br/>
rule: X is grandparent of Y, if (represented by ":-") X is parent of Z and (represented by ",") Z is parent of Y.<br/>
<br/>

Now let's try a query:<br/>
grandparent(mary, leen).<br/>
-> true<br/>
<br/>

<img width="614" height="246" alt="trace1" src="https://github.com/user-attachments/assets/80c9fa70-a708-4c0d-9a9c-c10b508e4f2e" />

Trace:<br/>
DFS search tree with 3 levels<br/>
Depth 0: grandparent(X, Y)<br/>
Depth 1: parent(X, Z)<br/>
Depth 2: parent(Z, Y)<br/>
<br/>
-> grandparent(X, Y).<br/>
   unifies X with mary and Y with leen.<br/>
<br/>
   expand<br/>
<br/>
-> parent(X, Z).<br/>
   which became<br/>
   parent(mary, Z).<br/>
<br/>
   check first branch:<br/>
   parent(mary, moss).<br/>
   unifies Z with moss<br/>
   true<br/>
<br/>
   expand<br/>
<br/>
<br/>
-> parent(Z, Y).<br/>
   which became<br/>
   parent(moss, leen).<br/>
<br/>
   check first branch:<br/>
   parent(mary, moss).<br/>
   false<br/>
<br/>
   check second branch:<br/>
   parent(moss, leen).<br/>
   true<br/>
<br/>
both conditions are true<br/>
return true.<br/>
<br/>
Prolog returns true without ever backtracking to the second branch at depth 1<br/>

---------------------------------------------------------------------------------------------------

## Example with backtrack

    parent(mary, john). % new fact
    parent(mary, moss).
    parent(moss, leen).
    
    grandparent(X, Y) :- parent(X, Z), parent(Z, Y).
    
query: grandparent(mary, leen).<br/>
<br/>

DFS Trace:<br/>
Depth 0: grandparent(X, Y)<br/>
Depth 1: parent(X, Z)<br/>
Depth 2: parent(Z, Y)<br/>
<br/>
-> grandparent(X,Y) & grandparent(mary,leen) -> X = mary, Y = leen.<br/>
<br/>
   expand<br/>
 <br/>
-> parent(X, Z). <br/>
   parent(mary, Z)  & parent(mary, john)     -> Z = john. <br/>
						true. <br/>
   expand <br/>
 <br/>
-> parent(Z, Y). <br/>
   parent(john,leen) & parent(mary, john)    -> false. <br/>
		     & parent(mary, moss)    -> false. <br/>
		     & parent(moss, leen)    -> false. <br/>
 <br/>
-- backtrack -- <br/>
check the second branch at depth 1 <br/>
 <br/>
-> parent(X, Z). <br/>
   parent(mary, Z)   & parent(mary, moss)    -> Z = moss. <br/>
						true. <br/>
   expand <br/>
 <br/>
-> parent(Z, Y). <br/>
   parent(moss,leen) & parent(mary, john)    -> false. <br/>
		     & parent(mary, moss)    -> false. <br/>
		     & parent(moss, leen)    -> true. <br/>
 <br/>
Prolog returns true. <br/>
 <br/>

<img width="616" height="219" alt="trace2" src="https://github.com/user-attachments/assets/f66be5fb-4f53-4b5e-888d-85af35b27299" />

---------------------------------------------------------------------------------------------------

## Recursion example

    parent(mary, moss). 
    parent(moss, leen). 
    parent(leen, john). 
    
    ancestor(X, Y) :- parent(X, Y).                 % base case 
    ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y). % recursive case

<br/>

while the grandparent predicate could always be represented by a tree with 3 levels <br/>
ancestor is not fixed, <br/>
only way to implement it is using recursion <br/>
<br/>

Query: <br/>
?- ancestor(mary, john). <br/>
true. <br/>
<br/>

DFS Trace: <br/>

% Depth 0: ancestor(X, Y). <br/>
% Depth 1: base case: parent(X, Y). <br/>
%	 recursive case: parent(X, Z). <br/>
%	 Depth 2: ancestor(Z, Y) <br/>
%		  ...  <br/>
<br/>

Depth 0: <br/>
ancestor(X, Y). <br/>
ancestor(mary, john). <br/>
X = mary, Y = john. <br/>
<br/>

expand <br/>
<br/>

Depth 1: <br/>
Base Case <br/>
parent(X, Y). <br/>
parent(mary, john). <br/>
returns false with the 3 branches. <br/>
<br/>

-- backtrack -- <br/>
<br/>

Depth 1: <br/>
Recursive Case <br/>
parent(X, Z) <br/>
parent(mary, Z) <br/>
unifies Z with moss in the first branch. <br/>
<br/>

expand <br/>
<br/>

Depth 2: <br/>
ancestor(moss, john). <br/>
<br/>

expand  <br/>
<br/>

Depth 3: <br/>
Base Case <br/>
parent(moss, john). <br/>
return false with the 3 branches. <br/>
<br/>

-- backtrack -- <br/>
<br/>

Depth 3: <br/>
Recursive Case <br/>
parent(moss, Z2). <br/>
since this is the second stack call of ancestor, <br/>
this is the second copy of Z, let's name it Z2. <br/>
Z2 unifies with leen in the second branch. <br/>
<br/>

expand <br/>
<br/>

Depth 4: <br/>
ancestor(Z2, john). <br/>
ancestor(leen, john). <br/>
<br/>

expand <br/>
<br/>

Depth 5: <br/>
Base Case <br/>
parent(leen, john). <br/>
true. <br/>
<br/>

<img width="678" height="346" alt="trace3" src="https://github.com/user-attachments/assets/87727534-93f1-4192-9dac-5347968806db" />

---------------------------------------------------------------------------------------------------

## Infinite loop

<br/> Infinie loop: <br/>
<br/>

    bad_ancestor(X, Z) :- bad_ancestor(X, Y), parent(Y, Z).
    bad_ancestor(X, Z) :- parent(X, Z).
    
    parent(john, mary).
    parent(mary, leen).

<img width="750" height="596" alt="trace4" src="https://github.com/user-attachments/assets/f9bd2518-bd11-4849-be1e-98828db60b6a" />

<br/>
Stack Overflow. <br/>
<br/>
This could be solved with Tail Recursion <br/>
but other search algorithms (BFS, IDS, A*) are not affected by rule ordering. <br/>

---------------------------------------------------------------------------------------------------

## Further Prolog explanation

I highly recommend this course <br/>

<a href="https://www.youtube.com/playlist?list=PLu-l3j4eka07-3vgrH_XylHtYA0uNdjQC">Programming Paradigms - Chapter 8 - Prolog</a> <br/>
<a href="https://www.youtube.com/playlist?list=PLu-l3j4eka076vqI_CNbleaYge3P5JQ0m">Programming Paradigms - Chapter 9 - Prolog Recursion</a>

---------------------------------------------------------------------------------------------------

## BFS, IDS and A*

- BFS (Breadth-first seach) explores the search space level by level <br/>
it expands all nodes at Depth x before moving to Depth x+1 <br/>
uses Queue (FIFO) <br/>
<br/>

Unlike DFS, it's complete (if finite branching), it doesn't get stuck in a loop <br/>
it's typically faster and optimal if (the all steps costs equal) <br/>
but with higherSpace Complexity, making it memory-intensive. <br/>
BFS fixes DFS’s incorrectness (non-optimal, incomplete) but at a huge memory cost. <br/>
<br/>

- IDS (Iterative-Deepening Search) <br/>
Combine DFS’s low memory with BFS’s optimality <br/>
it goes level by level like BFS, <br/>
but unlike BFS, <br/>
only if the goal state isn't at the current depth, it expands <br/>
this comes with a cost of redundancy and revisiting shallow nodes <br/>
but it's cheap comparing to exploring deep levels <br/>
Traversal is LIFO, expanding is LIFO <br/>
<br/>

- A* <br/>
unlike former search algorithms <br/>
A* is an informed seach, <br/>
it uses heuristics and cost functions <br/>
f(n)=g(n)+h(n) <br/>
at each node, heuristics make an informed estimation to guide the search toward the goal efficiently <br/>
Heuristic requirements to guarantee optimality: <br/>
Admissible: h(n) <= true cost to goal <br/>
Consistent (monotonic): h(n) <= cost(n, n') + h(n') <br/>
A* is both complete and optimal provided that the heuristic is admissible and preferably consistent, but like BFS, <br/>
it can require substantial memory since it stores all generated nodes in its frontier. <br/>
<br/>

https://www.geeksforgeeks.org/machine-learning/search-algorithms-in-ai/ <br/>

---------------------------------------------------------------------------------------------------

Prolog's built-in DFS is efficient for many problems <br/>
but implementing other search algorithms in Prolog at top of it comes with great benefit at some cases: <br/>
<br/>

- Infinite Search Spaces <br/>
DFS goes depth-first, it can plunge down an infinitely deep branch <br/>
BFS explores level by level, guaranteeing it will find shallow solutions first <br/>
IDS gradually increases depth limits, ensuring a solution is found if it exists at any finite depth <br/>
<br/>

- Finding Shortest/Least Cost Path <br/>
DFS returns the first solution it encounters, there's no guarantee of optimality. <br/>
BFS guarantees the shortest path in unweighted graphs <br/>
A with heuristics* finds the cheapest path in weighted graphs <br/>
Uniform Cost Search finds optimal paths when all steps have varying costs <br/>
<br/>

- Rule Order <br/>
Algorithms like BFS, IDS, or A* are rule-order independent. <br/>
They explore the search space based on topology or cost <br/>
Not by order like DFS which can affect performance <br/>
<br/>

- Stack overflow <br/>
Very deep problems (thousands or millions of levels) cause stack overflow crashes. <br/>
IDS limits depth and restarts <br/>
<br/>

- High Branching Factors <br/>
DFS can explore an enormous number of nodes before finding a solution <br/>
especially if the solution is shallow but the leftmost branch is deep. <br/>
BFS and A* reduces exploration <br/>
example: Chess move generation <br/>
https://stoics.org.uk/~nicos/sware/chess_db/ <br/>
<br/>

- No Heuristics <br/>
Heuristics dramatically speed up search. <br/>
example: Navigation (Manhattan distance heuristic), puzzle solving (number of misplaced tiles) <br/>
<br/>

- Non-Deterministic or Dynamic Environments <br/>
Once committed to a path, DFS explores it completely before backtracking. <br/>
In dynamic or non-deterministic domains, this is inefficient. <br/>
<br/>

- Solving Constraint Satisfaction Problems (CSPs) <br/>
Standard backtracking (DFS) suffers from thrashing <br/>
unlike constraint-guided search <br/>
example: Sudoku, scheduling, map coloring. <br/>
<br/>

---------------------------------------------------------------------------------------------------

creep.
