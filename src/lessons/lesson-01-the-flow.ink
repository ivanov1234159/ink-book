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

- (next)

* [1. Basics Content]
->basicContent

* {basicContent} [2. Basic Choices]
->TODO


= basicContent

<h4>1. Basics Content</h4>

By default, all text in your file will appear in the output content, unless specially marked up.

Text on separate lines produces new paragraphs. Empty lines doen't matter.

All redundant whitespace will be ignored, i.e. from the start/end of a line, or duplicated spaces. Indentation doesn't matter at all.

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


= Question_1_Wrong(wrong_attempts, lang)
{That is incorrect|Oops, it's not that|Wrong again}! This is how <strong>{lang}</strong> does it. Remember {unless specially marked up|by default|that} everithing in <strong>ink</strong> is {considered an output|printed automatically|just text, unless specified diffrently}. {Go and try another one.|Second guesses?|Final guess?}
->Question_1(wrong_attempts)


= Question_1_Correct(wrong_attempts)
{
- wrong_attempts == 0: Well gone, from the first time!
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


= Question_2_Wrong
Oops, you found the only wrong answer.
->next

= Question_2_Correct
{Hurrah, this is correct. Can you find another one that is also correct?\
->Question_2|\
Aha, this one too. Can you find more?\
->Question_2|\
Great! That's all!\
->next}
