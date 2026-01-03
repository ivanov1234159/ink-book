import { loadManifest } from "./load.js";
import { compileStory, executeCommandFromTag } from "./story.js";
import buildInCode from "./build-in.js";
import customCode from "../src/custom.js";

const manifest = await loadManifest();

const files = {};
for (const {storyPath, downloadPath} of manifest.files) {
  files[storyPath] = await fetch(downloadPath, {
    cache: 'no-cache',
  }).then((response) => response.text());
}

if (typeof files['main.ink'] !== 'string') {
    alert('Abort. Missing "main.ink" file!');
    throw new Error('Abort. Missing "main.ink" file!');
}

if (typeof customCode === 'function') {
  customCode();
}

buildInCode();

// Create ink story from the content using inkjs
const story = compileStory(files['main.ink'], { fileHandler: new inkjs.JsonFileHandler(files) });

executeCommandFromTag(story, 'theme set auto');
// Global tags - those at the top of the ink file
if (story.globalTags != null) {
  for (const tagString of story.globalTags) {
    executeCommandFromTag(story, tagString);
  }
}

var storyContainer = document.querySelector("#story");
var outerScrollContainer = document.querySelector(".outerContainer");

// page features setup
let rewindEl = document.getElementById("rewind");
if (rewindEl) {
  rewindEl.addEventListener("click", function (event) {
    removeAll("p");
    removeAll("img");
    restart();
  });
}

const themeSwitchEl = document.getElementById("theme-switch");
if (themeSwitchEl) {
  themeSwitchEl.addEventListener("click", () => {
    document.body.classList.toggle("dark");
    window.localStorage.setItem("theme", document.body.classList.contains("dark") ? "dark" : "light");
  });
}

// Kick off the start of the story!
continueStory(true);

// Main story processing function. Each time this is called it generates
// all the next content up as far as the next set of choices.
function continueStory(firstTime) {
  var delay = 0.0;

  // Don't over-scroll past new content
  var previousBottomEdge = firstTime ? 0 : contentBottomEdgeY();

  // Generate story text - loop through available content
  while (story.canContinue) {
    // Create paragraph element (initially hidden)
    let paragraphElement = document.createElement("p");
    // Get ink to generate the next paragraph
    let text = story.Continue();
    paragraphElement.innerHTML = text;

    // Any special tags included with this line
    for (const tag of story.currentTags) {
      executeCommandFromTag(story, tag, {$element: paragraphElement, $text: text});

      // CLEAR - removes all existing content.
      // RESTART - clears everything and restarts the story from the beginning
      if (tag == "CLEAR" || tag == "RESTART") {
        removeAll("p");
        removeAll("img");

        if (tag == "RESTART") {
          restart();
          return;
        }
      }
    }

    // Check if text is empty
    if (text.trim().length == 0) {
      continue; // Skip empty paragraphs
    }
    storyContainer.appendChild(paragraphElement);

    // Fade in paragraph after a short delay
    showAfter(delay, paragraphElement);
    delay += 200.0;
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach(choice => {
    // Create paragraph with anchor element
    const choiceParagraphElement = document.createElement("p");
    choiceParagraphElement.classList.add("choice");
    choiceParagraphElement.innerHTML = `<a href='#'>${choice.text}</a>`;
    for (const choiceTag of choice.tags) {
      executeCommandFromTag(story, choiceTag, {$element: choiceParagraphElement, $text: choice.text, $choice: choice});
    }

    storyContainer.appendChild(choiceParagraphElement);

    // Fade choice in after a short delay
    showAfter(delay, choiceParagraphElement);
    delay += 200.0;

    // Click on choice
    const choiceAnchorEl = choiceParagraphElement.querySelector('a');
    if (choiceAnchorEl) {
      choiceAnchorEl.addEventListener("click", event => {
        // Don't follow <a> link
        event.preventDefault();

        // Extend height to fit
        // We do this manually so that removing elements and creating new ones doesn't
        // cause the height (and therefore scroll) to jump backwards temporarily.
        storyContainer.style.height = contentBottomEdgeY() + "px";

        // Remove all existing choices
        removeAll(".choice");

        // Tell the story where to go next
        story.ChooseChoiceIndex(choice.index);

        // Aaand loop
        continueStory();
      });
    }
  });

  // Unset storyContainer's height, allowing it to resize itself
  storyContainer.style.height = "";

  if (!firstTime) {
    scrollDown(previousBottomEdge);
  }
}

function restart() {
  story.ResetState();
  continueStory(true);
  outerScrollContainer.scrollTo(0, 0);
}

// -----------------------------------
// Various Helper functions
// -----------------------------------

// Detects whether the user accepts animations
function isAnimationEnabled() {
  return window.matchMedia("(prefers-reduced-motion: no-preference)").matches;
}

// Fades in an element after a specified delay
function showAfter(delay, el) {
  if (isAnimationEnabled()) {
    el.classList.add("hide");
    setTimeout(function () {
      el.classList.remove("hide");
    }, delay);
  } else {
    // If the user doesn't want animations, show immediately
    el.classList.remove("hide");
  }
}

// Scrolls the page down, but no further than the bottom edge of what you could
// see previously, so it doesn't go too far.
function scrollDown(previousBottomEdge) {
  // If the user doesn't want animations, let them scroll manually
  if (!isAnimationEnabled()) {
    return;
  }

  // Line up top of screen with the bottom of where the previous content ended
  var target = previousBottomEdge;

  // Can't go further than the very bottom of the page
  var limit =
    outerScrollContainer.scrollHeight - outerScrollContainer.clientHeight;
  if (target > limit) target = limit;

  var start = outerScrollContainer.scrollTop;

  var dist = target - start;
  var duration = 300 + (300 * dist) / 100;
  var startTime = null;
  function step(time) {
    if (startTime == null) startTime = time;
    var t = (time - startTime) / duration;
    var lerp = 3 * t * t - 2 * t * t * t; // ease in/out
    outerScrollContainer.scrollTo(0, (1.0 - lerp) * start + lerp * target);
    if (t < 1) requestAnimationFrame(step);
  }
  requestAnimationFrame(step);
}

// The Y coordinate of the bottom end of all the story content, used
// for growing the container, and deciding how far to scroll.
function contentBottomEdgeY() {
  var bottomElement = storyContainer.lastElementChild;
  return bottomElement
    ? bottomElement.offsetTop + bottomElement.offsetHeight
    : 0;
}

// Remove all elements that match the given selector. Used for removing choices after
// you've picked one, as well as for the CLEAR and RESTART tags.
function removeAll(selector) {
  var allElements = storyContainer.querySelectorAll(selector);
  for (var i = 0; i < allElements.length; i++) {
    var el = allElements[i];
    el.parentNode.removeChild(el);
  }
}
