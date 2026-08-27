/**
 * Rain cursor: a raining cloud emoji that follows the pointer and drips small
 * raindrop emojis. Disabled by default; toggled with the #rain-toggle button in
 * the navbar and remembered in localStorage.
 */

(() => {
  const STORAGE_KEY = "rain-cursor";
  const CLOUD = "\u{1F327}️"; // 🌧️
  const DROP = "\u{1F4A7}"; // 💧
  const DROP_INTERVAL = 110; // ms between raindrops
  const DROP_LIFETIME = 1100; // must match the CSS animation duration

  let enabled = false;
  let container = null;
  let cloud = null;
  let pointerX = -100;
  let pointerY = -100;
  let cloudX = -100;
  let cloudY = -100;
  let hasPointer = false;
  let frame = null;
  let dropTimer = null;

  const button = document.getElementById("rain-toggle");
  if (!button) return;

  const stored = () => {
    try {
      return localStorage.getItem(STORAGE_KEY);
    } catch (e) {
      return null;
    }
  };

  const store = (value) => {
    try {
      localStorage.setItem(STORAGE_KEY, value);
    } catch (e) {
      /* storage unavailable; the toggle still works for this page load */
    }
  };

  const onPointerMove = (event) => {
    pointerX = event.clientX;
    pointerY = event.clientY;
    if (!hasPointer) {
      // Avoid a long swoop in from the corner on the first move.
      cloudX = pointerX;
      cloudY = pointerY;
      hasPointer = true;
    }
  };

  const spawnDrop = () => {
    if (!hasPointer) return;
    const drop = document.createElement("span");
    drop.className = "rain-cursor-drop";
    drop.textContent = DROP;
    drop.style.left = `${cloudX - 2}px`;
    drop.style.top = `${cloudY + 14}px`;
    // A little sideways drift so the drops do not fall in a single column.
    drop.style.setProperty("--rain-drift", `${(Math.random() * 16 - 8).toFixed(1)}px`);
    container.appendChild(drop);
    setTimeout(() => drop.remove(), DROP_LIFETIME);
  };

  const tick = () => {
    // Ease the cloud toward the pointer so it trails slightly behind.
    cloudX += (pointerX - cloudX) * 0.35;
    cloudY += (pointerY - cloudY) * 0.35;
    cloud.style.transform = `translate3d(${cloudX - 14}px, ${cloudY - 10}px, 0)`;
    frame = requestAnimationFrame(tick);
  };

  const enable = () => {
    if (enabled) return;
    enabled = true;

    container = document.createElement("div");
    container.id = "rain-cursor";
    container.setAttribute("aria-hidden", "true");

    cloud = document.createElement("span");
    cloud.className = "rain-cursor-cloud";
    cloud.textContent = CLOUD;
    cloud.style.transform = "translate3d(-100px, -100px, 0)";
    container.appendChild(cloud);

    document.body.appendChild(container);
    document.documentElement.classList.add("rain-cursor-active");
    document.addEventListener("pointermove", onPointerMove, { passive: true });
    frame = requestAnimationFrame(tick);
    dropTimer = setInterval(spawnDrop, DROP_INTERVAL);
  };

  const disable = () => {
    if (!enabled) return;
    enabled = false;

    document.documentElement.classList.remove("rain-cursor-active");
    document.removeEventListener("pointermove", onPointerMove);
    cancelAnimationFrame(frame);
    clearInterval(dropTimer);
    frame = null;
    dropTimer = null;
    hasPointer = false;

    container.remove();
    container = null;
    cloud = null;
  };

  const apply = (on) => {
    button.setAttribute("aria-pressed", on ? "true" : "false");
    if (on) {
      enable();
    } else {
      disable();
    }
  };

  button.addEventListener("click", () => {
    const on = !enabled;
    store(on ? "on" : "off");
    apply(on);
  });

  // Off by default: only a previously stored "on" turns the cursor on.
  apply(stored() === "on");
})();
