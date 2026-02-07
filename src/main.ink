INCLUDE about.ink
INCLUDE lessons/lesson-01-the-flow.ink

VAR SHORTCUTS_ENABLED = false

-> ToC

== TODO ==
WIP - work in progress (i.e. not done yet)
-> DONE

== ToC ==
Table of Contents

+ [Introduction]
-> Introduction
+ [Lesson 1: The Flow]
-> Lesson_01_The_Flow
+ [Lesson 2: Weave (WIP)]
+ [Lesson 3: Varying Choices (WIP)]
+ [Lesson 4: Branching The Flow (exercise) (WIP)]
+ [Lesson 5: Variables (WIP)]
+ [Lesson 6: Advanced Content (WIP)]
+ [Lesson 7: Advanced Choices (WIP)]
+ [About & Bonus Lesson]
-> About
+ [Index (WIP)]
+ [Playground: writable editor]
-> Playground

-
<-TODO
->ToC

== Introduction ==

<h2>Introduction</h2>

<strong>ink</strong> is a narrative scripting language built around the idea of marking up pure-text with flow in order to produce interactive scripts.

At its most basic, it can be used to write a Choose Your Own-style story, or a branching dialogue tree. But its real strength is in writing dialogues with lots of options and lots of recombination of the flow.

<strong>ink</strong> offers several features to enable non-technical writers to branch often, and play out the consequences of those branches, in both minor and major ways, without fuss.

The script aims to be clean and logically ordered, so branching dialogue can be tested "by eye". The flow is described in a declarative fashion where possible.

It's also designed with redrafting in mind; so editing a flow should be fast.

* [Go back]
-> ToC
* [Continue with "Lesson 1: The Flow"]
-> Lesson_01_The_Flow

== Playground ==

<pre>\// write you own story here ...\
</pre> # editor write-preview

* [Go back]
-
-> ToC


/*
Lesson 1: The Flow
Lesson 1.1: Basic Content - text, paragraphs (each line is separate,
        ignoring the whitespace)
Lesson 1.2: Basic Choices - options/choices, multiple choices
Lesson 1.3: Basic Knots - knots, diverts, stiches (naming things),
        ->END & ->DONE, scope (knot - global, stich - local)

Lesson 2: Weave
Lesson 2.1: Gathers
Lesson 2.2: Nesting choices and gathers

Lesson 3: Varying Choices (loops with knots)
Lesson 3.1: Sticky choices
Lesson 3.2: Fallback choice

Lesson 4: Branching The Flow (exercise)

Lesson 5: Variables
Lesson 5.1: Global variables
Lesson 5.2: Variable types & evaluation - strings, integers, floats,
        falsy values; usual brackets support; (no lists !)
Lesson 5.3: Math & Logic - "+, -, *, /, mod(%), and, or, not, ==, !=, >=, <=, <, >"
Lesson 5.4: Knots as variables - knot read count

Lesson 6: Advanced Content
Lesson 6.0: Comments
Lesson 6.1: Glue
Lesson 6.2: Variable text
Lesson 6.3: Conditional text

Lesson 7: Advanced Choices
Lesson 7.1: Conditional choices
Lesson 7.2: Labeling choices and gathers
Lesson 7.3: Loops with labeled choices


Lesson _: ...... (exercise)

Lesson _: Advanced Knots - arguments, knot as "function", "~ return"

Lesson _: Advanced Variables - divert type, local variables (temp), CONST, lists, list operators (has(?), hasnt), "ref" variables

Lesson _: ......

Math: POW, RANDOM, MIN, MAX

game queries and functions

tags, includes

*/
