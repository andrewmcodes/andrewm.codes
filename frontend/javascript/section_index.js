const boundIndexes = new WeakSet();

function initSectionIndexes() {
  document.querySelectorAll("[data-section-index]").forEach((nav) => {
    if (boundIndexes.has(nav)) return;
    const headings = [...document.querySelectorAll(nav.dataset.sectionIndex)];
    if (!headings.length) return;
    boundIndexes.add(nav);
    const select = nav.querySelector("select");
    select.replaceChildren();
    headings.forEach((heading, index) => {
      if (!heading.id) heading.id = `section-${index + 1}`;
      const option = document.createElement("option");
      option.value = heading.id;
      option.textContent = heading.textContent.replace(/#\s*$/, "").trim();
      select.append(option);
    });
    nav.hidden = false;
    nav.querySelector("button").addEventListener("click", () => {
      const heading = document.getElementById(select.value);
      heading.tabIndex = -1;
      heading.focus({ preventScroll: true });
      heading.scrollIntoView();
      history.replaceState(null, "", `#${encodeURIComponent(heading.id)}`);
    });
  });
}
document.addEventListener("turbo:load", initSectionIndexes);
initSectionIndexes();
