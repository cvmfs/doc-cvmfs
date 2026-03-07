window.addEventListener("DOMContentLoaded", function () {
  if (!document.querySelector(".rst-content h1#cernvm-fs-parameters")) {
    return;
  }

  document
    .querySelectorAll(".rst-content h1#cernvm-fs-parameters ~ dl > dt[id]")
    .forEach(function (term) {
      if (term.querySelector(".parameter-permalink")) {
        return;
      }

      var id = term.id;
      if (!id) {
        return;
      }

      var label = term.textContent.trim();
      var link = document.createElement("a");
      link.className = "parameter-permalink";
      link.href = "#" + id;
      link.setAttribute("aria-label", "Permalink to " + label);
      link.setAttribute("title", "Permalink to " + label);
      link.textContent = "¶";
      term.appendChild(link);
    });
});