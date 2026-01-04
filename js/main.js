import { createEditor, loadManifest } from "./load.js";
import { executeCommandFromTag } from "./story.js";
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

const {$editor: outerScrollContainer, $story: story, $preview: storyContainer} = createEditor(document.body, files['main.ink'], { fileHandler: new inkjs.JsonFileHandler(files) }, { withCode: true, withPreview: true, readonly: false });

// page features setup
let rewindEl = outerScrollContainer.querySelector(".controls > .rewind");
if (rewindEl) {
  rewindEl.addEventListener("click", restart);
}

const themeSwitchEl = outerScrollContainer.querySelector(".controls > .theme-switch");
if (themeSwitchEl) {
  themeSwitchEl.addEventListener("click", () => {
    document.body.classList.toggle("dark");
    window.localStorage.setItem("theme", document.body.classList.contains("dark") ? "dark" : "light");
  });
}

// Kick off the start of the story!
// continueStory(true);
restart();

// Main story processing function. Each time this is called it generates
// all the next content up as far as the next set of choices.
function continueStory(firstTime) {
  let delay = 0.0;

  // Don't over-scroll past new content
  const previousBottomEdge = firstTime ? 0 : contentBottomEdgeY(storyContainer);

  // Generate story text - loop through available content
  while (story.canContinue) {
    // Create paragraph element (initially hidden)
    let paragraphElement = document.createElement("p");
    // Get ink to generate the next paragraph
    let text = story.Continue();
    paragraphElement.innerHTML = text;

    // Any special tags included with this line
    for (const tag of story.currentTags) {
      executeCommandFromTag(story, tag, {$preview: storyContainer, $element: paragraphElement, $text: text});

      // CLEAR - removes all existing content.
      // RESTART - clears everything and restarts the story from the beginning
      if (tag == "CLEAR") {
        removeAll(storyContainer, "p");
      } else if (tag == "RESTART") {
        restart();
        return;
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
    choiceParagraphElement.innerHTML = `<a href="#">${choice.text}</a>`;
    for (const choiceTag of choice.tags) {
      executeCommandFromTag(story, choiceTag, {$preview: storyContainer, $element: choiceParagraphElement, $text: choice.text, $choice: choice});
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
        storyContainer.style.height = contentBottomEdgeY(storyContainer) + "px";

        // Remove all existing choices
        removeAll(storyContainer, ".choice");

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
    scrollDown(outerScrollContainer, previousBottomEdge);
  }
}

function restart() {
  removeAll(storyContainer, "p");
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
    setTimeout(() => el.classList.remove("hide"), delay);
  } else {
    // If the user doesn't want animations, show immediately
    el.classList.remove("hide");
  }
}

// Scrolls the page down, but no further than the bottom edge of what you could
// see previously, so it doesn't go too far.
function scrollDown(outerScrollContainer, previousBottomEdge) {
  // If the user doesn't want animations, let them scroll manually
  if (!isAnimationEnabled()) {
    return;
  }

  // Line up top of screen with the bottom of where the previous content ended, but can't go further than the very bottom of the page
  const target = Math.min(previousBottomEdge, outerScrollContainer.scrollHeight - outerScrollContainer.clientHeight)
  const start = outerScrollContainer.scrollTop;

  const duration = 3 * (100 + target - start);
  let startTime = null;
  function step(time) {
    if (startTime == null) {
      startTime = time;
    }
    const t = (time - startTime) / duration;
    const lerp = 3 * t * t - 2 * t * t * t; // ease in/out
    outerScrollContainer.scrollTo(0, (1.0 - lerp) * start + lerp * target);
    if (t < 1) {
      requestAnimationFrame(step);
    }
  }
  requestAnimationFrame(step);
}

// The Y coordinate of the bottom end of all the story content, used
// for growing the container, and deciding how far to scroll.
function contentBottomEdgeY(storyContainer) {
  const bottomElement = storyContainer.lastElementChild;
  return bottomElement
    ? bottomElement.offsetTop + bottomElement.offsetHeight
    : 0;
}

// Remove all elements that match the given selector. Used for removing choices after
// you've picked one, as well as for the CLEAR and RESTART tags.
function removeAll(element, selector) {
  for (const toRemove of element.querySelectorAll(selector)) {
    toRemove.parentNode.removeChild(toRemove);
  }
}
