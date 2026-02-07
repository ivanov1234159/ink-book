== About
= intro
This digital book was started as a University project and is highly\
inspired by <strong>ink</strong>'s own documentation - <a href="https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md">Writing with ink</a>.

You can find a link to the GitHub repo <a href="https://github.com/ivanov1234159/ink-book">here</a>.

The book is not finished, yet (even the design - can't tell that should be a book), and I wanted to include so much more\
(and I will continue to add stuff whenever possible), but in the meantime here is a bonus lesson with sintax\
that I use while writing this and haven't made it to the lessons, yet.

+ [Continue with the Bonus Lesson]
    -> Bonus_Lesson
+ [Go back]
    -> ToC

== Bonus_Lesson
<h3>Bonus Lesson</h3>

I have used some <i>advanced</i> syntax that haven't made it to the book, yet.\
So here are all the parts of this lesson, feel free to jump around in any order you like.

+ [\<> Glue \<> \| from Lesson 6 {glue: (completed)}]
->glue
+ [- Gathers \| from Lesson 2 {gathers: (completed)}]
->gathers
+ [Nesting choices and gathers \| from Lesson 2 {nestingChoicesAndGathers: (completed)}]
->nestingChoicesAndGathers
+ [Labeling choices and gathers \| from Lesson 7 {labelingChoicesAndGathers: (completed)}]
->labelingChoicesAndGathers

+ [Global variables & Variable types \| from Lesson 5 {globalVariables: (completed)}]
->globalVariables
+ [\~ Evaluation \| from Lesson 5 {evaluation: (completed)}]
->evaluation

+ [Knots as variables - knot read count \| from Lesson 5 {knotsAsVariables: (completed)}]
->knotsAsVariables
+ [Knot arguments {knotArguments: (completed)}]
->knotArguments

+ [Selected part of Math & Logic: +, ==, or \| from Lesson 5 {mathAndLogic: (completed)}]
->mathAndLogic

+ [+ Sticky choices \| from Lesson 3 {stickyChoices: (completed)}]
->stickyChoices
+ [Conditional choices \| from Lesson 7 {conditionalChoices: (completed)}]
->conditionalChoices

+ [Conditional text \| from Lesson 6 {conditionalText: (completed)}]
->conditionalText
+ [Variable text \| from Lesson 6 {variableText: (completed)}]
->variableText

+ [/\* Comments *\/ \| from Lesson 6 {comments: (completed)}]
->comments
+ [\# Tags]
+ [INCLUDEs]

+ [\<- Treads]

+ [Go back]
    Oh, before you go ... I'm going to grant you access to all of the shortcuts that are available in the lessons.
    ~ SHORTCUTS_ENABLED = true
    -> ToC

-
->TODO


= glue
<h4>Lesson 6: 2. Glue</h4>

-> TODO

= gathers
<h4>Lesson 2: 1. Gathers</h4>

<h5>1.1: Gather points gather the flow back together</h5>

Let's go back to an earlier multi-choice example.

<pre>"What's that?" my master asked.\
*   "I am somewhat tired[."]," I repeated.\
    "Really," he responded. "How deleterious."\
*   "Nothing, Monsieur!"[] I replied.\
    "Very good, then."\
*   "I said, this journey is appalling[."] and I want no more of it."\
    "Ah," he replied, not unkindly. "I see you are feeling frustrated. Tomorrow, things will improve."</pre> # editor read-preview

In a real game, all three of these options might well lead to the same conclusion - Monsieur Fogg leaves the room. We can do this using a gather, without the need to create any new knots, or add any diverts.

<pre>"What's that?" my master asked.\
*   "I am somewhat tired[."]," I repeated.\
    "Really," he responded. "How deleterious."\
*   "Nothing, Monsieur!"[] I replied.\
    "Very good, then."\
*   "I said, this journey is appalling[."] and I want no more of it."\
    "Ah," he replied, not unkindly. "I see you are feeling frustrated. Tomorrow, things will improve."\
-   With that Monsieur Fogg left the room.</pre> # editor read-preview

+ [next]
- (gathers_part_2)

<h5>1.2: Options and gathers form chains of content</h5>

We can string these gather-and-branch sections together to make branchy sequences that always run forwards.

<pre>=== escape ===\
I ran through the forest, the dogs snapping at my heels.\
\
	* 	I checked the jewels[] were still in my pocket, and the feel of them brought a spring to my step. <>\
\
	*  I did not pause for breath[] but kept on running. <>\
\
	*	I cheered with joy. <>\
\
- 	The road could not be much further! Mackie would have the engine running, and then I'd be safe.\
\
	*	I reached the road and looked about[]. And would you believe it?\
	* 	I should interrupt to say Mackie is normally very reliable[]. He's never once let me down. Or rather, never once,\ previously to that night.\
\
-	The road was empty. Mackie was nowhere to be seen.</pre> # editor read-preview

This is the most basic kind of weave. The rest of this section details additional features that allow weaves to nest, contain side-tracks and diversions, divert within themselves, and above all, reference earlier choices to influence later ones.

+ [next]
- (gather_part_3)

<h5>1.3: The weave philosophy</h5>

Weaves are more than just a convenient encapsulation of branching flow; they're also a way to author more robust content. The <code>escape</code> example above has already four possible routes through, and a more complex sequence might have lots and lots more. Using normal diverts, one has to check the links by chasing the diverts from point to point and it's easy for errors to creep in.

With a weave, the flow is guaranteed to start at the top and "fall" to the bottom. Flow errors are impossible in a basic weave structure, and the output text can be easily skim read. That means there's no need to actually test all the branches in game to be sure they work as intended.

Weaves also allow for easy redrafting of choice-points; in particular, it's easy to break a sentence up and insert additional choices for variety or pacing reasons, without having to re-engineer any flow.

+ [Go back]
-> Bonus_Lesson
+ [Continue with "Nesting choices and gathers"]
-> nestingChoicesAndGathers

= nestingChoicesAndGathers
<h4>Lesson 2: 2. Nesting choices and gathers (i.e. Nested Flow)</h4>

The weaves shown eariler are quite simple, "flat" structures. Whatever the player does, they take the same number of turns to get from top to bottom. However, sometimes certain choices warrant a bit more depth or complexity.

For that, we allow weaves to nest.

This section comes with a warning. Nested weaves are very powerful and very compact, but they can take a bit of getting used to!

+ [next]
- (nestingChoicesAndGathers_part_1)

<h5>2.1: Options can be nested</h5>

Consider the following scene:

<pre>- "Well, Poirot? Murder or suicide?"\
* "Murder!"\
* "Suicide!"\
- Ms. Christie lowered her manuscript a moment. The rest of the writing group sat, open-mouthed.</pre> # editor read-preview

The first choice presented is "Murder!" or "Suicide!". If Poirot declares a suicide, there's no more to do, but in the case of murder, there's a follow-up question needed - who does he suspect?

We can add new options via a set of nested sub-choices. We tell the script that these new choices are "part of" another choice by using two asterisks, instead of just one.

<pre>- "Well, Poirot? Murder or suicide?"\
* "Murder!"\
  "And who did it?"\
* *	"Detective-Inspector Japp!"\
* *	"Captain Hastings!"\
* *	"Myself!"\
* "Suicide!"\
-	Mrs. Christie lowered her manuscript a moment. The rest of the writing group sat, open-mouthed.</pre> # editor read-preview

<blockquote>it's good style to also indent the lines to show the nesting, but the compiler doesn't mind.\
Also the spacing between the asterisks (for choices) and the dashes (for gathers) is redundant, i.e. "* * *" is the same as "***" and " *  *     *  ".</blockquote> # note

+ [next]
-

And should we want to add new sub-options to the other route, we do that in similar fashion.

<pre>- "Well, Poirot? Murder or suicide?"\
* "Murder!"\
  "And who did it?"\
  * * "Detective-Inspector Japp!"\
  * * "Captain Hastings!"\
  * * "Myself!"\
* "Suicide!"\
  "Really, Poirot? Are you quite sure?"\
  * * "Quite sure."\
  * * "It is perfectly obvious."\
-	Mrs. Christie lowered her manuscript a moment. The rest of the writing group sat, open-mouthed.</pre> # editor read-preview

Now, that initial choice of accusation will lead to specific follow-up questions - but either way, the flow will come back together at the gather point, for Mrs. Christie's cameo appearance.

But what if we want a more extended sub-scene?

+ [next]
- (nestingChoicesAndGathers_part_2)

<h5>2.2: Gather points can be nested too</h5>

Sometimes, it's not a question of expanding the number of options, but having more than one additional beat of story. We can do this by nesting gather points as well as options.

<pre>- "Well, Poirot? Murder or suicide?"\
* "Murder!"\
  "And who did it?"\
  * * "Detective-Inspector Japp!"\
  * * "Captain Hastings!"\
  * * "Myself!"\
  - - "You must be joking!"\
  * * "Mon ami, I am deadly serious."\
  * * "If only..."\
* "Suicide!"\
  "Really, Poirot? Are you quite sure?"\
  * * "Quite sure."\
  * * "It is perfectly obvious."\
-	Mrs. Christie lowered her manuscript a moment. The rest of the writing group sat, open-mouthed.</pre> # editor read-preview

If the player chooses the "murder" option, they'll have two choices in a row on their sub-branch - a whole flat weave, just for them.

<blockquote>Advanced: What gathers do\
\
Gathers are hopefully intuitive, but their behaviour is a little harder to put into words: in general, after an option has been taken, the story finds the next gather down that isn't on a lower level, and diverts to it.\
\
The basic idea is this: options separate the paths of the story, and gathers bring them back together. (Hence the name, "weave"!)</blockquote> # note --style=info

+ [next]
- (nestingChoicesAndGathers_part_3)

<h5>2.3: You can nest as many levels are you like</h5>

Above, we used two levels of nesting; the main flow, and the sub-flow. But there's no limit to how many levels deep you can go.

<pre>- "Tell us a tale, Captain!"\
* "Very well, you sea-dogs. Here's a tale..."\
  * * "It was a dark and stormy night..."\
    * * * "...and the crew were restless..."\
      * * * * "... and they said to their Captain..."\
        * * * * * "...Tell us a tale Captain!"\
* "No, it's past your bed-time."\
- To a man, the crew began to yawn.</pre> # editor read-preview

After a while, this sub-nesting gets hard to read and manipulate, so it's good style to divert away to a new stitch if a side-choice goes unwieldy.

But, in theory at least, you could write your entire story as a single weave.

+ [next]
- (nestingChoicesAndGathers_part_4)

<h5>2.4: Example: a conversation with nested nodes</h5>

Here's a longer example:

<pre>- I looked at Monsieur Fogg\
* ... and I could contain myself no longer.\
  'What is the purpose of our journey, Monsieur?'\
  'A wager,' he replied.\
  * * 'A wager!'[] I returned.\
    He nodded.\
    * * * 'But surely that is foolishness!'\
    * * * 'A most serious matter then!'\
    - - - He nodded again.\
    * * * 'But can we win?'\
      'That is what we will endeavour to find out,' he answered.\
    * * * 'A modest wager, I trust?'\
      'Twenty thousand pounds,' he replied, quite flatly.\
    * * * I asked nothing further of him then[.], and after a final, polite cough, he offered nothing more to me. <>\
  * * 'Ah[.'],' I replied, uncertain what I thought.\
  - - After that, <>\
* ... but I said nothing[] and <>\
- we passed the day in silence.\
\-> END</pre> # editor read-preview

Hopefully, this demonstrates the philosophy laid out above: that weaves offer a compact way to offer a lot of branching, a lot of choices, but with the guarantee of getting from beginning to end!

+ [Go back]
-> Bonus_Lesson
+ [Continue with "Labeling choices and gathers"]
-> labelingChoicesAndGathers

= labelingChoicesAndGathers
<h4>Lesson 7: 2. Labeling choices and gathers (i.e. Tracking a Weave)</h4>

Sometimes, the weave structure is sufficient. But when it's not, we need a bit more control.

<h5>2.1: Weaves are largely unaddressed</h5>

By default, lines of content in a weave don't have an address or label, which means they can't be diverted to, and they can't be tested for. In the most basic weave structure, choices vary the path the player takes through the weave and what they see, but once the weave is finished those choices and that path are forgotten.

But should we want to remember what the player has seen, we can add in labels where they're needed using the <code>(label_name)</code> syntax.

+ [next]
- (labelingChoicesAndGathers_part_2)

<h5>2.2: Gathers and options can be labelled</h5>

Gather points at any nested level can be labelled using brackets.

<pre>- (top)</pre> # editor read-only

Once labelled, gather points can be diverted to, or tested for in conditionals, just like knots and stitches. This means you can use previous decisions to alter later outcomes inside the weave, while still keeping all the advantages of a clear, reliable forward-flow.

Options can also be labelled, just like gather points, using brackets. Label brackets come before conditions in the line.

These addresses can be used in conditional tests, which can be useful for creating options unlocked by other options.

<pre>=== meet_guard ===\
The guard frowns at you.\
\
* (greet) [Greet him]\
  'Greetings.'\
* (get_out) 'Get out of my way[.'],' you tell the guard.\
\
- 'Hmm,' replies the guard.\
\
* \{greet\} 'Having a nice day?' /\/ only if you greeted him\
\
* 'Hmm?'[] you reply.\
\
* \{get_out\} [Shove him aside] /\/ only if you threatened him\
	You shove him sharply. He stares in reply, and draws his sword!\
	\-> fight_guard            /\/ this route diverts out of the weave\
\
- 'Mff,' the guard replies, and then offers you a paper bag. 'Toffee?'\
\-> DONE\
\
\/\/ somewhere else:
\=== fight_guard ===\
...\
\-> DONE</pre> # editor read-preview --start=meet_guard


+ [next]
- (labelingChoicesAndGathers_part_3)

<h5>2.3: Scope</h5>

Inside the same block of weave, you can simply use the label name; from outside the block you need a path, either to a different stitch within the same knot:

<pre>=== knot ===\
\= stitch_one\
- \(gatherpoint) Some content.\
\= stitch_two\
* \{stitch_one.gatherpoint\} Option</pre> # editor read-only

or pointing into another knot:

<pre>=== knot_one ===\
- \(gather_one)\
* \{knot_two.stitch_two.gather_two\} Option\
\
\=== knot_two ===\
\= stitch_two\
- \(gather_two)\
* \{knot_one.gather_one\} Option</pre> # editor read-only


/*
TODO: in "Lesson 7: 3. Loops with labeled choices"

- Advanced: all options can be labelled
- Advanced: Loops in a weave
- Advanced: diverting to options
- Advanced: Gathers directly after an option

*/

+ [Go back]
-> Bonus_Lesson
+ [Continue with "Global variables & Variable types"]
-> globalVariables

= globalVariables
/*
<h3>Lesson 5: Variables</h3>

So far we've made conditional text, and conditional choices, using tests based on what content the player has seen so far.

ink also supports variables, both temporary and global, storing numerical and content data, or even story flow commands. It is fully-featured in terms of logic, and contains a few additional structures to help keep the often complex logic of a branching story better organised.
*/

<h4>Lesson 5: 1. Global variables & Variable types</h4>

The most powerful kind of variable, and arguably the most useful for a story, is a variable to store some unique property about the state of the game - anything from the amount of money in the protagonist's pocket, to a value representing the protagonist's state of mind.

This kind of variable is called "global" because it can be accessed from anywhere in the story - both set, and read from. (Traditionally, programming tries to avoid this kind of thing, as it allows one part of a program to mess with another, unrelated part. But a story is a story, and stories are all about consequences: what happens in Vegas rarely stays there.)

<h5>1.1: Defining Global Variables</h5>

Global variables can be defined anywhere, via a <code>VAR</code> statement. They should be given an initial value, which defines what type of variable they are - boolean, integer, floating point (decimal), content, or a story address (divert).

<pre>VAR knowledge_of_the_cure = false\
VAR players_name = "Emilia"\
VAR number_of_infected_people = 521\
VAR chance_of_infection = 0.15\
VAR current_epilogue = \-> they_all_die_of_the_plague</pre> # editor read-only

+ [next]
- (globalVariables_part_2)

<h5>1.2: Using Global Variables</h5>

We can test global variables to control options, and provide conditional text, in a similar way to what we have previously seen.

<pre>VAR mood = 1 /\/ try with some negative value\
VAR knows_about_wager = false /\/ try with true\
\-> the_train\
\=== the_train ===\
The train jolted and rattled. \{ mood > 0:I was feeling positive enough, however, and did not mind the odd bump\|It was more\ than I could bear\}.\
* \{ not knows_about_wager \} 'But, Monsieur, why are we travelling?'[] I asked.\
* \{ knows_about_wager\} I contemplated our strange adventure[]. Would it be possible?\
\-> END</pre> # editor write-preview

// TODO: "Advanced: storing diverts as variables"
// TODO: "Advanced: Global variables are externally visible"

+ [next]
- (globalVariables_part_3)

<h5>1.3: Printing variables</h5>

The value of a variable can be printed as content using an inline syntax similar to sequences, and conditional text:
// TODO: sequences and conditional text may not be presented, yet

<pre>VAR friendly_name_of_player = "Jackie"\
VAR age = 23\
\
My name is Jean Passepartout, but my friends call me \{friendly_name_of_player\}. I'm \{age\} years old.</pre> # edotir read-preview

/*
This can be useful in debugging. For more complex printing based on logic and variables, see the section on functions.
*/

+ [Go back]
-> Bonus_Lesson
+ [Continue with "Evaluation"]
-> evaluation

= evaluation
<h4>Lesson 5: 2. Evaluation</h4>

It might be noticed that previously we refered to variables as being able to contain "content", rather than "strings". That was deliberate, because a string defined in <strong>ink</strong> can contain ink - although it will always evaluate to a string. (Yikes!)

An evaluation line starts with <code>~</code> and represents some mutaiton of a variable or a function call. It's never printed as part of the story.

// TODO: functions may not be presented to the reader, yet

<pre>VAR a_colour = ""\
\
~ a_colour = "\{~red\|blue\|green\|yellow\}"'
\
\{a_colour\}</pre> # editor read-preview

<blockquote>Try restarting the sample above to get different results. It uses a non taught short "shuffle" syntax.</blockquote> # note

Every time it produces one of red, blue, green or yellow.

Note that once a piece of content like this is evaluated, its value is "sticky". (The quantum state collapses.) So the following won't produce a very interesting effect. (If you really want this to work, use a text function to print the colour!)

<pre>VAR a_colour = ""\
\
~ a_colour = "{~red|blue|green|yellow}"'
\
The goon hits you, and sparks fly before you eyes, \{a_colour\} and \{a_colour\}.</pre> # editor read-preview


This is also why the following is explicitly disallowed; it would be evaluated on the construction of the story, which probably isn't what you want.
<pre>VAR a_colour = "{~red|blue|green|yellow}"</pre> # editor read-only

+ [Go back]
-> Bonus_Lesson
+ [Continue with "Knots as variables - knot read count"]
-> knotsAsVariables

= knotsAsVariables
<h4>Lesson 5: 4. Knots as variables - knot read count</h4>

Technically, knots and stiches (and labeled choices and gathers also) are also variables. They are of the number type and thier value represent the number of times the knot/stich (or choice, or gather) have been visited so far.

// TODO: labeling choices and gathers is from Lesson 7.2

<pre>=== knot ===\
"knot" was visited \{knot\} time\{knot!=1:s\}\
"stich1" was visited \{stich1\} time\{stich1!=1:s\}\
"stich2" was visited \{stich2\} time\{stich1!=1:s\}\
\
"stich1.choice1" was visited \{stich1.choice1\} time\{stich1.choice1!=1:s\}\
"stich1.choice2" was visited \{stich1.choice2\} time\{stich1.choice2!=1:s\}\
"stich1.choice3" was visited \{stich1.choice3\} time\{stich1.choice3!=1:s\}\
"stich1.gather" was visited \{stich1.gather\} time\{stich1.gather!=1:s\}\
\
"stich2.choice1" was visited \{stich2.choice1\} time\{stich2.choice1!=1:s\}\
"stich2.choice2" was visited \{stich2.choice2\} time\{stich2.choice2!=1:s\}\
"stich2.choice3" was visited \{stich2.choice3\} time\{stich2.choice3!=1:s\}\
"stich2.gather" was visited \{stich2.gather\} time\{stich2.gather!=1:s\}\
\
\= stich1\
+ (choice1) [choice 1: go to gather & stich 2]\
+ (choice2) [choice 2: go to stich 2]\
\-> stich2\
+ (choice3) [choice 3: go to knot]\
\-> knot\
- (gather)\
\-> stich2\
\= stich2\
+ (choice1) [choice 1: go to knot]\
\-> knot\
+ (choice2) [choice 2: go to gather & knot]\
+ (choice3) [choice 3: go to stich 1]\
\-> stich1\
- (gather)\
\-> knot\
</pre> # editor read-preview --start=knot

<blockquote>Please, note that <code>VAR knot_read_count = knot_name</code> and <code>VAR knot_address = \-> knot_name</code> are from different types and represent different things. The first is the knot's read count and the secong is the knot's address!</blockquote> # note

+ [Go back]
-> Bonus_Lesson
+ [Continue with "Knot arguments"]
-> knotArguments

= knotArguments
<h4>Lesson _: _. Knot arguments</h4>

-> TODO

= mathAndLogic
<h4>Lesson 5: 3. Selected part of Math & Logic</h4>

-> TODO

= stickyChoices
<h4>Lesson 3: 1. Sticky choices</h4>

-> TODO

= conditionalChoices
<h4>Lesson 7: 1. Conditional choices</h4>

-> TODO

= conditionalText
<h4>Lesson 6: 3. Conditional text</h4>

-> TODO

= variableText
<h4>Lesson 6: 2. Variable text</h4>

-> TODO

= comments
<h4>Lesson 6: 0. Comments</h4>

-> TODO

= tags
<h4>Lesson _: _. Tags</h4>

-> TODO

= includes
<h4>Lesson _: _. Includes</h4>

-> TODO

= treads
<h4>Lesson _: _. Treads</h4>

-> TODO
