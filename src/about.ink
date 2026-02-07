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

I have used some advanced syntax that haven't made it to the book, yet.\
So here are all the parts of this lesson, feel free to jump around in any order you like.

+ [\<> Glue \<> \| from Lesson 6 {glue: (completed)}]
->glue
+ [- Gathers \| from Lesson 2 {gathers: (completed)}]
->gathers
+ [Nesting choices and gathers \| from Lesson 2 {nestingChoicesAndGathers: (completed)}]
->nestingChoicesAndGathers
+ [Labeling choices and gathers \| from Lesson 7 {labelingChoicesAndGathers: (completed)}]
->labelingChoicesAndGathers

+ [Global variables \| from Lesson 5 {globalVariables: (completed)}]
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

* [next]
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

* [next]
- (gather_part_3)

<h5>1.3: The weave philosophy</h5>

Weaves are more than just a convenient encapsulation of branching flow; they're also a way to author more robust content. The <code>escape</code> example above has already four possible routes through, and a more complex sequence might have lots and lots more. Using normal diverts, one has to check the links by chasing the diverts from point to point and it's easy for errors to creep in.

With a weave, the flow is guaranteed to start at the top and "fall" to the bottom. Flow errors are impossible in a basic weave structure, and the output text can be easily skim read. That means there's no need to actually test all the branches in game to be sure they work as intended.

Weaves also allow for easy redrafting of choice-points; in particular, it's easy to break a sentence up and insert additional choices for variety or pacing reasons, without having to re-engineer any flow.

* [Go back]
-> Bonus_Lesson
* [Continue with "Nesting choices and gathers"]
-> nestingChoicesAndGathers

= nestingChoicesAndGathers
<h4>Lesson 2: 2. Nesting choices and gathers (i.e. Nested Flow)</h4>

The weaves shown eariler are quite simple, "flat" structures. Whatever the player does, they take the same number of turns to get from top to bottom. However, sometimes certain choices warrant a bit more depth or complexity.

For that, we allow weaves to nest.

This section comes with a warning. Nested weaves are very powerful and very compact, but they can take a bit of getting used to!

* [next]
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

* [next]
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

* [next]
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

* [next]
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

* [next]
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

* [Go back]
-> Bonus_Lesson
* [Continue with "Labeling choices and gathers"]
-> labelingChoicesAndGathers

= labelingChoicesAndGathers
<h4>Lesson 7: 2. Labeling choices and gathers</h4>

-> TODO

= globalVariables
<h4>Lesson 5: 1. Global variables</h4>

-> TODO

= evaluation
<h4>Lesson 5: 2.2. Evaluation</h4>

-> TODO

= knotsAsVariables
<h4>Lesson 5: 4. Knots as variables - knot read count</h4>

-> TODO

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
