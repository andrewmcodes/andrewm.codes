const boundArchives = new WeakSet();

function initArchives() {
  document.querySelectorAll("[data-archive]").forEach((archive) => {
    const controls = archive.querySelector("[data-archive-controls]");
    if (!controls || boundArchives.has(controls)) return;
    boundArchives.add(controls);
    const items = [...archive.querySelectorAll("[data-archive-item]")];
    const query = controls.querySelector("[data-archive-query]");
    const language = controls.querySelector("[data-archive-language]");
    const starred = controls.querySelector("[data-archive-starred]");
    const recent = controls.querySelector("[data-archive-recent]");
    const featured = controls.querySelector("[data-archive-featured]");
    const cutoff = new Date();
    cutoff.setFullYear(cutoff.getFullYear() - 1);
    const update = () => {
      const terms = query.value.trim().toLowerCase().split(/\s+/).filter(Boolean);
      let count = 0;
      items.forEach((item) => {
        const matches =
          terms.every((term) => item.dataset.search.toLowerCase().includes(term)) &&
          (!language?.value || item.dataset.language === language.value) &&
          (!starred?.checked || Number(item.dataset.stars) > 0) &&
          (!recent?.checked || new Date(item.dataset.updated) >= cutoff) &&
          (!featured?.checked || item.dataset.featured === "true");
        item.hidden = !matches;
        if (matches) count++;
      });
      archive.querySelectorAll("[data-archive-group]").forEach((group) => {
        group.hidden = !group.querySelector("[data-archive-item]:not([hidden])");
      });
      controls.querySelector("[data-archive-status]").textContent =
        `${count} of ${items.length} ${archive.dataset.archive}${count ? "" : " — try another filter"}`;
    };
    controls.addEventListener("input", update);
    controls.addEventListener("change", update);
    controls.querySelector("[data-archive-reset]").addEventListener("click", () => {
      query.value = "";
      if (language) language.value = "";
      if (starred) starred.checked = false;
      if (recent) recent.checked = false;
      if (featured) featured.checked = false;
      update();
      query.focus();
    });
    update();
    controls.disabled = false;
  });
}
document.addEventListener("turbo:load", initArchives);
initArchives();
