window.addEventListener("DOMContentLoaded", function () {
  var sidebarTitle = document.querySelector("div.wy-side-nav-search");
  var logo = sidebarTitle && sidebarTitle.querySelector("img.logo");

  if (!sidebarTitle || !logo) {
    return;
  }

  var logoLink = logo.closest("a");
  if (logoLink && !logoLink.classList.contains("icon-home")) {
    logoLink.classList.add("icon-home");
  }

  window.setTimeout(function () {
    if (sidebarTitle.querySelector("#version-selector") || typeof base_url !== "string") {
      return;
    }

    var baseUrl = new URL(base_url, window.location.href);
    var currentMatch = baseUrl.pathname.match(/\/([^/]+)\/$/);
    if (!currentMatch) {
      return;
    }

    fetch(new URL("../versions.json", baseUrl))
      .then(function (response) { return response.json(); })
      .then(function (versions) {
        if (sidebarTitle.querySelector("#version-selector")) {
          return;
        }

        var currentVersion = currentMatch[1];
        var current = versions.find(function (version) {
          return version.version === currentVersion ||
            (Array.isArray(version.aliases) && version.aliases.includes(currentVersion));
        });

        if (!current) {
          return;
        }

        var select = document.createElement("select");
        select.id = "version-selector";

        versions
          .filter(function (version) {
            return version.version === current.version ||
              !version.properties ||
              !version.properties.hidden;
          })
          .forEach(function (version) {
            var option = new Option(version.title, version.version, false, version.version === current.version);
            select.add(option);
          });

        select.addEventListener("change", function () {
          window.location.href = new URL("../" + this.value + "/", baseUrl).toString();
        });

        var search = sidebarTitle.querySelector('[role="search"]');
        sidebarTitle.insertBefore(select, search || null);
      })
      .catch(function () {});
  }, 0);
});