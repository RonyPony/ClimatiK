const header = document.querySelector("[data-header]");
const reveals = document.querySelectorAll(".reveal");
const tiltTarget = document.querySelector("[data-tilt] .phone-frame");
const tiltArea = document.querySelector("[data-tilt]");

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
