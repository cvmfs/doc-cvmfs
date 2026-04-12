window.addEventListener("DOMContentLoaded", function () {
  var selector = ".rst-content .codehilite, .rst-content div.highlight, .rst-content pre.highlight";

  function detectLanguage(elements) {
    for (var i = 0; i < elements.length; i += 1) {
      var element = elements[i];
      if (!element) {
        continue;
      }

      for (var j = 0; j < element.classList.length; j += 1) {
        var className = element.classList[j];
        var match = className.match(/(?:lang(?:uage)?-)([A-Za-z0-9_+-]+)/);
        if (match) {
          return match[1].toLowerCase();
        }
      }
    }

    return "";
  }

  function copyText(text) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      return navigator.clipboard.writeText(text);
    }

    return new Promise(function (resolve, reject) {
      var textarea = document.createElement("textarea");
      textarea.value = text;
      textarea.setAttribute("readonly", "readonly");
      textarea.style.position = "absolute";
      textarea.style.left = "-9999px";
      document.body.appendChild(textarea);
      textarea.select();

      try {
        document.execCommand("copy");
        resolve();
      } catch (error) {
        reject(error);
      } finally {
        document.body.removeChild(textarea);
      }
    });
  }

  document.querySelectorAll(selector).forEach(function (node) {
    if (node.dataset.codeEnhanced === "true") {
      return;
    }

    var block = node;
    var pre = node;

    if (node.tagName !== "PRE") {
      pre = node.querySelector("pre");
    }

    if (node.tagName === "PRE") {
      block = document.createElement("div");
      block.className = "code-block";
      node.parentNode.insertBefore(block, node);
      block.appendChild(node);
    }

    var code = pre && pre.querySelector("code");
    if (!pre || !code) {
      return;
    }

    node.dataset.codeEnhanced = "true";
    block.dataset.codeEnhanced = "true";
    block.classList.add("code-block");

    var wrapper = document.createElement("div");
    wrapper.className = "code-block-wrap";
    block.parentNode.insertBefore(wrapper, block);
    wrapper.appendChild(block);

    var sourceText = code.textContent.replace(/\u00a0/g, " ").replace(/\n$/, "");

    var copyButton = document.createElement("button");
    copyButton.type = "button";
    copyButton.className = "code-copy-button";
    copyButton.setAttribute("aria-label", "Copy code to clipboard");
    copyButton.setAttribute("title", "Copy code to clipboard");

    copyButton.addEventListener("click", function () {
      copyText(sourceText)
        .then(function () {
          copyButton.setAttribute("data-copied", "true");
          copyButton.setAttribute("aria-label", "Copied to clipboard");
          copyButton.setAttribute("title", "Copied to clipboard");

          window.setTimeout(function () {
            copyButton.removeAttribute("data-copied");
            copyButton.setAttribute("aria-label", "Copy code to clipboard");
            copyButton.setAttribute("title", "Copy code to clipboard");
          }, 1800);
        })
        .catch(function () {
          copyButton.setAttribute("aria-label", "Copy failed");
          copyButton.setAttribute("title", "Copy failed");
          window.setTimeout(function () {
            copyButton.setAttribute("aria-label", "Copy code to clipboard");
            copyButton.setAttribute("title", "Copy code to clipboard");
          }, 1800);
        });
    });

    wrapper.appendChild(copyButton);
  });
});