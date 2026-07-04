
document.addEventListener('DOMContentLoaded', () => {

  const targets = document.querySelectorAll('.fade-scroll');

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        
        const index = [...targets].indexOf(entry.target);
        entry.target.style.transitionDelay = `${index * 0.15}s`;

        entry.target.classList.add('is-visible');
        observer.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.2
  });

  targets.forEach(target => observer.observe(target));

});


document.addEventListener('DOMContentLoaded', () => {
  const hero = document.querySelector('.hero-inner');
  let hasAnimated = false;

  window.addEventListener('scroll', () => {
    if (window.scrollY > 30 && !hasAnimated) {
      hero.classList.add('is-animated');
      hasAnimated = true;
    }
  });
});

        