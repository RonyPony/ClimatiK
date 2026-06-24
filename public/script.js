const header = document.querySelector("[data-header]");
const reveals = document.querySelectorAll(".reveal");
const tiltTarget = document.querySelector("[data-tilt] .phone-frame");
const tiltArea = document.querySelector("[data-tilt]");
const privacyModal = document.querySelector("[data-privacy-modal]");
const privacyPanel = privacyModal?.querySelector(".legal-modal__panel");
const privacyOpeners = document.querySelectorAll("[data-open-privacy]");
const privacyClosers = document.querySelectorAll("[data-close-privacy]");
let lastFocusedElement = null;

const onScroll = () => {
  header?.classList.toggle("is-scrolled", window.scrollY > 18);
};

onScroll();
window.addEventListener("scroll", onScroll, { passive: true });

const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        revealObserver.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.16 }
);

reveals.forEach((element, index) => {
  element.style.transitionDelay = `${Math.min(index * 35, 240)}ms`;
  revealObserver.observe(element);
});

if (tiltArea && tiltTarget && window.matchMedia("(pointer: fine)").matches) {
  tiltArea.addEventListener("mousemove", (event) => {
    const rect = tiltArea.getBoundingClientRect();
    const x = (event.clientX - rect.left) / rect.width - 0.5;
    const y = (event.clientY - rect.top) / rect.height - 0.5;
    tiltTarget.style.transform = `rotateX(${7 - y * 8}deg) rotateY(${
      -8 + x * 10
    }deg) translateY(-4px)`;
  });

  tiltArea.addEventListener("mouseleave", () => {
    tiltTarget.style.transform = "rotateX(7deg) rotateY(-8deg)";
  });
}

const isPrivacyUrl = () => {
  const params = new URLSearchParams(window.location.search);
  const pathHasPrivacy = /\/privacy\/?$/.test(window.location.pathname);
  return (
    window.location.hash === "#privacy" ||
    params.get("privacy") === "true" ||
    pathHasPrivacy
  );
};

const getCleanPrivacyUrl = () => {
  const url = new URL(window.location.href);
  url.pathname = url.pathname.replace(/\/privacy\/?$/, "/") || "/";
  url.searchParams.delete("privacy");
  url.hash = "";
  return `${url.pathname}${url.search}`;
};

const openPrivacyModal = ({ updateUrl = false } = {}) => {
  if (!privacyModal || !privacyPanel) return;

  lastFocusedElement = document.activeElement;
  privacyModal.classList.add("is-open");
  privacyModal.setAttribute("aria-hidden", "false");
  document.body.classList.add("modal-open");

  if (updateUrl && window.location.hash !== "#privacy") {
    history.pushState(null, "", "#privacy");
  }

  requestAnimationFrame(() => privacyPanel.focus());
};

const closePrivacyModal = ({ cleanUrl = true } = {}) => {
  if (!privacyModal) return;

  privacyModal.classList.remove("is-open");
  privacyModal.setAttribute("aria-hidden", "true");
  document.body.classList.remove("modal-open");

  if (cleanUrl && isPrivacyUrl()) {
    history.replaceState(null, "", getCleanPrivacyUrl());
  }

  if (lastFocusedElement instanceof HTMLElement) {
    lastFocusedElement.focus();
  }
};

privacyOpeners.forEach((opener) => {
  opener.addEventListener("click", (event) => {
    event.preventDefault();
    openPrivacyModal({ updateUrl: true });
  });
});

privacyClosers.forEach((closer) => {
  closer.addEventListener("click", () => closePrivacyModal());
});

window.addEventListener("keydown", (event) => {
  if (!privacyModal?.classList.contains("is-open")) return;

  if (event.key === "Escape") {
    closePrivacyModal();
  }

  if (event.key === "Tab") {
    const focusableElements = privacyModal.querySelectorAll(
      'a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])'
    );
    const firstElement = focusableElements[0];
    const lastElement = focusableElements[focusableElements.length - 1];

    if (!firstElement || !lastElement) return;

    if (event.shiftKey && document.activeElement === firstElement) {
      event.preventDefault();
      lastElement.focus();
    } else if (!event.shiftKey && document.activeElement === lastElement) {
      event.preventDefault();
      firstElement.focus();
    }
  }
});

window.addEventListener("hashchange", () => {
  if (isPrivacyUrl()) {
    openPrivacyModal();
  } else {
    closePrivacyModal({ cleanUrl: false });
  }
});

window.addEventListener("popstate", () => {
  if (isPrivacyUrl()) {
    openPrivacyModal();
  } else {
    closePrivacyModal({ cleanUrl: false });
  }
});

if (isPrivacyUrl()) {
  openPrivacyModal();
}
