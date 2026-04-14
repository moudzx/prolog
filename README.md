# Prolog

Prolog Programming Language<br/>
<br/>
Prolog is a declarative programming language<br/>
it's primarily used as a rational agent, classical AI<br/>
it percepts queries as input and perform search using DFS with backtracking<br/>
its based on predicate logic<br/>
its execution model makes recursion the most natural way to express repetition and search<br/>
<br/>
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
Rule Ordering constraint in non tail recursive.

---------------------------------------------------------------------------------------------------

## Further Prolog explanation

I highly recommend this course <br/>

<a href="https://www.youtube.com/playlist?list=PLu-l3j4eka07-3vgrH_XylHtYA0uNdjQC">Programming Paradigms - Chapter 8 - Prolog</a> <br/>
<a href="https://www.youtube.com/playlist?list=PLu-l3j4eka076vqI_CNbleaYge3P5JQ0m">Programming Paradigms - Chapter 9 - Prolog Recursion</a>

---------------------------------------------------------------------------------------------------

## BFS, IDS, Uniform-Cost and A*

- BFS (Breadth-first seach) explores the search space level by level <br/>
it expands all nodes at Depth x before moving to Depth x+1 <br/>
uses Queue (FIFO) <br/>
<br/>

Unlike DFS, it's complete (if finite branching), it doesn't get stuck in a loop <br/>
it's typically faster and optimal (if the all steps have equal) <br/>
BFS fixes DFS’s incorrectness (non-optimal, incomplete) but at a huge memory cost (higher Space Complexity). <br/>
<br/>

- IDS (Iterative-Deepening Search) <br/>
Combine DFS’s low memory with BFS’s optimality <br/>
Traversal is FIFO, expanding is LIFO <br/>
this comes with a cost of redundancy and revisiting shallow nodes <br/>
but it's cheap comparing to exploring deep levels <br/>
<br/>

- UCS (Uniform-Cost Search) <br>
  informed search, based on lowest cost <br>
  f(n)=g(n) where g(n) is the cumulative cost of n <br>

- A* <br/>
 informed search
f(n)=g(n)+h(n) <br/>
where h(n) is heuristic function.<br>
at each node, heuristics make an informed estimation to guide the search toward the goal efficiently <br/>
Heuristic requirements to guarantee optimality: <br/>
Admissible: h(n) <= true cost to goal <br/>
Consistent (monotonic): h(n) <= cost(n, n') + h(n') <br/>
A* is both complete and optimal provided that the heuristic is admissible and preferably consistent, but like BFS, <br/>
it can require substantial memory since it stores all generated nodes in its frontier. <br/>
<br/>
  
https://www.geeksforgeeks.org/machine-learning/search-algorithms-in-ai/ <br/>

---------------------------------------------------------------------------------------------------

Prolog's built-in DFS (depth-first search) is efficient for many problems<br>
but implementing other search algorithms in Prolog on top of it comes with great benefits in cases such as:<br>
<br>
Infinite Search Spaces<br>
Finding Shortest/Least Cost Path<br>
Rule Order Independence<br>
Stack Overflow<br>
High Branching Factors<br> 
Heuristics<br>
Solving Constraint Satisfaction Problems (CSPs)<br>
<br>
<br>
https://stackoverflow.com/questions/36235348/prolog-and-limitations-of-backtracking
---------------------------------------------------------------------------------------------------

<code> graph_search.pl </code> <br>
<img width="900" height="678" alt="graph" src="https://github.com/user-attachments/assets/b42d5bac-3e9f-4df1-91f9-d931435741f4" /> <br>
 <br>
<code> left_recursive_ancestor.pl </code> <br>
<img width="708" height="242" alt="left" src="https://github.com/user-attachments/assets/164e7236-56cf-46d1-854b-84225e188f7e" /> <br>
 <br>
<code> deep_maze.pl </code> <br>
<img width="585" height="233" alt="deepmaze" src="https://github.com/user-attachments/assets/66213adf-9c98-4313-8f79-8219afe3fab7" /> <br>
 <br>
<code> chess_search.pl </code> <br>
<img width="834" height="705" alt="chess1a" src="https://github.com/user-attachments/assets/d7890a89-4bd7-48eb-953b-c4b1c6daf4ea" /> <br>
<img width="830" height="694" alt="chess1b" src="https://github.com/user-attachments/assets/df7b4bdd-0c8e-4161-815f-b9c5e043f84b" /> <br>
https://stoics.org.uk/~nicos/sware/chess_db/ <br>
 <br>
------------------------------------------------------------------------------------------
Run Prolog online:
https://swish.swi-prolog.org/
-------------------------------------------------------------------------------------------
creep.
