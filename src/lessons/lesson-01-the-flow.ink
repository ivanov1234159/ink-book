/*
Lesson 1: The Flow
Lesson 1.1: Basic Content - text, paragraphs (each line is separate,
        ignoring the whitespace)
Lesson 1.2: Basic Choices - options/choices, multiple choices
Lesson 1.3: Basic Knots - knots, diverts, stiches (naming things),
        ->END & ->DONE, scope (knot - global, stich - local)
*/


== Lesson_01_The_Flow ==

<h3>Lesson 1: The Flow</h3>

In <strong>ink</strong>, the story flow is the main thing that holds everything together. The flow is simply one story path that the player/user can take while navigating it.

- (nextChapter)

* [1. Basics Content]
->basicContent

* {SHORTCUTS_ENABLED} [Question 1]
->Question_1(0)

* {SHORTCUTS_ENABLED} [Question 2]
->Question_2

* {SHORTCUTS_ENABLED or basicContent} [2. Basic Choices]
->basicChoices

* {SHORTCUTS_ENABLED} [2.2: Suppressing choice text]
->basicChoices_part_2

* {SHORTCUTS_ENABLED} [2.3: Mixing choice and output text]
->basicChoices_part_3

* {SHORTCUTS_ENABLED} [2.4: Multiple Choices]
->basicChoices_part_4

* {SHORTCUTS_ENABLED} [Question 3]
->Question_3

* {SHORTCUTS_ENABLED or basicChoices} [3. Basic Knots]
->basicKnots

* {SHORTCUTS_ENABLED} [3.2: Knots "divert" to knots]
->basicKnots_part_2

* {SHORTCUTS_ENABLED} [Question 4]
->Question_4

* {SHORTCUTS_ENABLED} [3.3: Diverts are invisible]
->basicKnots_part_3

* {SHORTCUTS_ENABLED} [3.4: Knots can be subdivided into "stiches"]
->basicKnots_part_4

* {SHORTCUTS_ENABLED} [3.5: The first stitch is the default]
->basicKnots_part_5

* {SHORTCUTS_ENABLED} [3.6: Local diverts]
->basicKnots_part_6

* {SHORTCUTS_ENABLED or basicKnots} [next lesson]
->ToC


= basicContent

<h4>1. Basics Content</h4>

By default, all text in your file will appear in the output content, unless specially marked up.

Text on separate lines produces new paragraphs. Empty lines doen't matter.

All redundant whitespace will be ignored, i.e. from the start/end of a line, or duplicated spaces.\
Indentation doesn't matter at all.

<strong>Ink</strong> has a few special symbols and constructions that\
we will look into in this book, but if you need to opt out from such\
behaviour, you can escape characters using "\\" (backslash).

* [Question 1]
->Question_1(0)


= Question_1(wrong_attempts)

Q: What is the right <strong>ink</strong> script that prints "Hello world"?

* <pre>print("Hello world")</pre>
->Question_1_Wrong(wrong_attempts + 1, "Python")

* <pre>echo "Hello world"</pre>
->Question_1_Wrong(wrong_attempts + 1, "PHP")

* <pre>Hello world</pre>
->Question_1_Correct(wrong_attempts)

* <pre>console.log("Hello world")</pre>
->Question_1_Wrong(wrong_attempts + 1, "JavaScript")

* {SHORTCUTS_ENABLED} [(skip question)]
->Question_2


= Question_1_Wrong(wrong_attempts, lang)
{That is incorrect|Oops, it's not that|Wrong again}! This is how <strong>{lang}</strong> does it. Remember {unless specially marked up|by default|that} everithing in <strong>ink</strong> is {considered an output|printed automatically|just text, unless specified diffrently}. {Second guesses?|Go and try another one.|Final guess?}
->Question_1(wrong_attempts)


= Question_1_Correct(wrong_attempts)
{
- wrong_attempts == 0: Well gone, from the first try!
- wrong_attempts == 1: Okay, not bad! You made a single mistake, but finally found the right one.
- wrong_attempts == 2: Aha, that's it! It took you a while, but you guessed correctrly this time.
- else: Huh? You found the true answer after all.
}

* [Question 2]
->Question_2


= Question_2
Q: Which of the following would produce this text: <pre>Hello\
world</pre>

* <pre>Hello\
world</pre>
->Question_2_Correct

* <pre>Hello\
    world</pre>
->Question_2_Correct

* <pre>Hello world</pre>
->Question_2_Wrong

* <pre>  Hello\
\
world</pre>
->Question_2_Correct

* {SHORTCUTS_ENABLED} [(skip question)]
->nextChapter


= Question_2_Wrong
Oops, you found the only wrong answer.
->nextChapter

= Question_2_Correct
{Hurrah, this is correct. Can you find another one that is also correct?\
->Question_2|\
Aha, this one too. Can you find more?\
->Question_2|\
Great! That's all!\
->nextChapter}

= basicChoices

<h4>2. Basics Choices</h4>

<h5>2.1: Text choises</h5>

Input is offered to the player/user via text choices. A text choice is indicated by an * (asterisk) character.

If no other flow instructions are given, once made, the choice will flow into the next line of text.

Play around with the following example:

<pre>Hello world!\
*   Hello back!\
    Nice to hear from you!</pre> # editor read-preview

* [next]
- (basicChoices_part_2)

<h5>2.2: Suppressing choice text</h5>

Some games separate the text of a choice from its outcome. In <strong>ink</strong>, if the choice text is given in\
square brackets, the text of the choice will not be printed into response.

Here is an example:

<pre>Hello world!\
*   [Hello back!]\
    Nice to hear from you!</pre> # editor read-preview

* [next]
- (basicChoices_part_3)

<h5>2.3: Mixing choice and output text</h5>

The square brackets in fact divide up the option content. What's before is printed in both choice and output; what's inside only in choice; and what's after, only in output. Effectively, they provide alternative ways for a line to end.

<pre>Hello world!\
*   Hello [back!] right back to you!\
    Nice to hear from you!</pre> # editor read-preview

This is most useful when writing dialogue choices:

<pre>"What's that?" my master asked.\
*   "I am somewhat tired[."]," I repeated.\
    "Really," he responded. "How deleterious."</pre> # editor read-preview

* [next]
- (basicChoices_part_4)

<h5>2.4: Multiple Choices</h5>

To make choices really choices, we need to provide alternatives. We can do this simply by listing them:

<pre>"What's that?" my master asked.\
*   "I am somewhat tired[."]," I repeated.\
    "Really," he responded. "How deleterious."\
*   "Nothing, Monsieur!"[] I replied.\
    "Very good, then."\
*   "I said, this journey is appalling[."] and I want no more of it."\
    "Ah," he replied, not unkindly. "I see you are feeling frustrated. Tomorrow, things will improve."</pre> # editor read-preview

The above syntax is enough to write a single set of choices. In a real game/story, we'll want to move the flow\
from one point to another based on what the player/user chooses. To do that, we need to introduce a bit more\
structure, but before that lets answer some questions about choices.

* [Question 3]
->Question_3

= Question_3
Q: Which of the following can produce a flow like this:
<pre>We arrived into London at 9.45pm exactly.\
*   "There is not a moment to lose!"[] I declared.\
    We hurried home to Savile Row as fast as we could.\
*   "Monsieur, let us savour this moment!"[] I declared.\
    My master clouted me firmly around the head and dragged me out of the door.\
    He insisted that we hurried home to Savile Row as fast as we could.\
*   We hurried home [] to Savile Row as fast as we could.</pre> # editor preview-only

* [<pre>We arrived into London at 9.45pm exactly.\
\*   "There is not a moment to lose!" I declared.\
     We hurried home to Savile Row as fast as we could.\
\*   "Monsieur, let us savour this moment!"\[\] I declared.\
     My master clouted me firmly around the head and dragged me out of the door.\
     He insisted that we hurried home to Savile Row as fast as we could.\
\*   We hurried home \[\] to Savile Row as fast as we could.</pre> # editor read-only]

* [<pre>We arrived into London at 9.45pm exactly.\
\*   "There is not a moment to lose!"\[\] I declared.\
     We hurried home to Savile Row as fast as we could.\
\*   "Monsieur, let us savour this moment!"\[\] I declared.\
     My master clouted me firmly around the head and dragged me out of the door.\
     He insisted that we hurried home to Savile Row as fast as we could.\
\*   We hurried home to Savile Row as fast as we could.</pre> # editor read-only]

* <pre>We arrived into London at 9.45pm exactly.\
\*   "There is not a moment to lose!"\[\] I declared.\
     We hurried home to Savile Row as fast as we could.\
\*   "Monsieur, let us savour this moment!"\[\] I declared.\
     My master clouted me firmly  around the head  and dragged me out of the door.\
     He insisted that we hurried home to\\\
     Savile Row as fast as we could.\
\*   We hurried home \[\] to Savile Row as fast as we could.</pre> # editor read-only
    - - (Question_3_Correct)
    Hurray, you've made it! Now, lets introduse some structure.
    ->nextChapter

* [<pre>We arrived into London at 9.45pm exactly.\
\*   "There is not a moment to lose!"\[\] I declared.\
     We hurried home to Savile Row as fast as we could.\
\*   "Monsieur, let us savour this moment\[!"\]", I declared.\
     My master clouted me firmly around the head and dragged me out of the door.\
     He insisted that we hurried home to Savile Row as fast as we could.\
\*   We hurried home \[\]\
\
to Savile Row as fast as we could.</pre> # editor read-only]

* {SHORTCUTS_ENABLED} [(skip question)]
->nextChapter

- (Question_3_Wrong)
{Oh, no! |}You've missed it{|, again}. {You have 2 more attempts left.|Final chance!|Anyway lets continue with some more structure.\
->nextChapter}
->Question_3

= basicKnots

<h4>3. Basics Knots</h4>

<h5>3.1: Pieces of content are called "knots"</h5>

To allow the game/story to branch we need to mark up sections of content with names\
(as an old-fashioned gamebook does with its 'Paragraph 18', and the like).

The start of a knot is indicated by two or more equals signs, as follows.

<pre>=== top_knot ===</pre>

The equals signs on the end are optional; and the name needs to be a single word with no spaces.

The start of a knot is a header; the content that follows will be inside that knot.

<pre>=== back_in_london ===\
\
We arrived into London at 9.45pm exactly.</pre>

<blockquote>Knot names are case sensitive (i.e. "back_in_london" is different from "Back_in_London").</blockquote> # note

* [next]
- (basicKnots_part_2)

<h5>3.2: Knots "divert" to knots</h5>

You can tell the story to move from one knot to another using <pre>\-></pre>, a "divert arrow". Diverts happen immediately without any user input. The whitespace aftrer the arrow and before the knot name is irrelevant.

<pre>=== back_in_london ===\
\
We arrived into London at 9.45pm exactly.\
\-> hurry_home\
\
\=== hurry_home ===\
We hurried home to Savile Row as fast as we could.<pre>

<blockquote>When you start an ink file, content outside of knots will be run automatically. But knots won't. So if you start using knots to hold your content, you'll need to tell the game where to go. We do this with a divert arrow <pre>\-></pre>.</blockquote> # note

* [next]
-

A knottier "hello world" example:

<pre>\-> top_knot\
\
\=== top_knot ===\
Hello world!</pre>

However, strong>ink</strong> doesn't like loose ends, and produces a warning on compilation and/or run-time when it thinks this has happened. The script above produces this on compilation:

<blockquote>WARNING: Apparent loose end exists where the flow runs out. Do you need a '\-> END' statement, choice or divert? on line 3 of tests/test.ink</blockquote>

and this on running:

<blockquote>Runtime error in tests/test.ink line 3: ran out of content. Do you need a '\-> DONE' or '\-> END'?</blockquote>

* [next]
-

The following plays and compiles without error:

<pre>\-> top_knot\
\
\=== top_knot ===\
Hello world!\
\-> END</pre> # editor read-preview

<pre>\-> END</pre> is a marker for both the writer and the compiler; it means "the story should now stop".
<pre>\-> DONE</pre> is another marker that we'll explain in a later lesson, but for now, lets say it means "this flow is now completed".

* [Question 4]
- (Question_4)
Q: TODO

* [a]
->basicKnots_part_3
* [b]
* [c]
* [d]
-
->Question_4

- (basicKnots_part_3)

<h5>3.3: Diverts are invisible</h5>

Diverts are intended to be seamless and can even happen mid-sentence:

<pre>=== hurry_home ===\
We hurried home to Savile Row \-> as_fast_as_we_could\
\
\=== as_fast_as_we_could ===\
as fast as we could.\
\->END</pre> # editor read-preview --start=hurry_home

* [next]
- (basicKnots_part_4)

<h5>3.4: Knots can be subdivided into "stiches"</h5>

As stories get longer, they become more confusing to keep organised without some additional structure.

Knots can include sub-sections called "stitches". These are marked using a single equals sign.

<pre>=== the_orient_express ===\
\= in_first_class\
    ...\
\= in_third_class\
    ...\
\= in_the_guards_van\
    ...\
\= missed_the_train\
    ...</pre>

One could use a knot for a scene, for instance, and stitches for the events within the scene.

Stitches have unique names within the knot; a stitch can be diverted to using its "address" like so:

<pre>*   [Travel in third class]\
    \-> the_orient_express.in_third_class\
\
*   [Travel in the guard's van]\
    \-> the_orient_express.in_the_guards_van</pre>

* [next]
- (basicKnots_part_5)

<h5>3.5: The first stitch is the default</h5>

Diverting to a knot which contains stitches will divert to the first stitch in the knot. So:

<pre>*   [Travel in first class]\
    "First class, Monsieur. Where else?"\
    \-> the_orient_express</pre>

is the same as:

<pre>*   [Travel in first class]\
    "First class, Monsieur. Where else?"\
    \-> the_orient_express.in_first_class</pre>

...unless we move the order of the stitches around inside the knot!

* [next]
- 

You can also include content at the top of a knot outside of any stitch. However, you need to remember to divert out of it - the engine won't automatically enter the first stitch once it's worked its way through the header content.

<pre>=== the_orient_express ===\
\
We boarded the train, but where?\
*   [First class] \-> in_first_class\
*   [Second class] \-> in_second_class\
\
\= in_first_class\
    ...\
\= in_second_class\
    ...</pre>

* [next]
- (basicKnots_part_6)

<h5>3.6: Local diverts</h5>

From inside a knot, you don't need to use the full address for a stitch.

<pre>\-> the_orient_express\
\
\=== the_orient_express ===\
\= in_first_class\
    I settled my master.\
    *   [Move to third class]\
        \-> in_third_class\
\
\= in_third_class\
    I put myself in third.</pre> # editor read-preview

This means stitches and knots can't share names, but several knots can contain the same stitch name. (So both the Orient Express and the SS Mongolia can have first class.)

The compiler will warn you if ambiguous names are used.


* [Question 5]
- (Question_5)
Q: TODO

* [a]
* [b]
* [c]
* [d]
->nextChapter
-
->Question_5
