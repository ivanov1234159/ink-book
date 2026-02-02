
// Detects whether the user accepts animations
function isAnimationEnabled() {
  return window.matchMedia("(prefers-reduced-motion: no-preference)").matches;
}

export function shallowClone(object, object2) {
  if (typeof object === 'object' && object !== null) {
    const clone = {...object};
    Object.setPrototypeOf(clone, Object.getPrototypeOf(object));
    if (typeof object2 === 'object' && object2 !== null) {
      Object.assign(clone, object2);
    }
    return clone;
  }
  return object;
}


// Remove all elements that match the given selector. Used for removing choices after
// you've picked one, as well as for the CLEAR and RESTART tags.
export function removeAll(element, selector) {
  for (const toRemove of element.querySelectorAll(selector)) {
    toRemove.parentNode.removeChild(toRemove);
  }
}

// Fades in an element after a specified delay
export function showAfter(delay, el) {
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
export function scrollDown(storyContainer, previousBottomEdge) {
  // If the user doesn't want animations, let them scroll manually
  if (!isAnimationEnabled()) {
    return;
  }

  // Line up top of screen with the bottom of where the previous content ended, but can't go further than the very bottom of the page
  const target = Math.min(previousBottomEdge, storyContainer.scrollHeight - storyContainer.clientHeight)
  const start = storyContainer.scrollTop;

  const duration = 3 * (100 + target - start);
  let startTime = null;
  function step(time) {
    if (startTime == null) {
      startTime = time;
    }
    const t = (time - startTime) / duration;
    const lerp = 3 * t * t - 2 * t * t * t; // ease in/out
    storyContainer.scrollTo(0, (1.0 - lerp) * start + lerp * target);
    if (t < 1) {
      requestAnimationFrame(step);
    }
  }
  requestAnimationFrame(step);
}

// The Y coordinate of the bottom end of all the story content, used
// for growing the container, and deciding how far to scroll.
export function contentBottomEdgeY(storyContainer) {
  const bottomElement = storyContainer.lastElementChild;
  return bottomElement
    ? bottomElement.offsetTop + bottomElement.offsetHeight
    : 0;
}
