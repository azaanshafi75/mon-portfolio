
document.documentElement.classList.add('js');

const header = document.querySelector('.site-header');
const progress = document.querySelector('.scroll-progress');
const backToTop = document.querySelector('.back-to-top');
const menuToggle = document.querySelector('.menu-toggle');
const navLinks = document.querySelector('.nav-links');

function onScroll() {
  const y = window.scrollY;
  header?.classList.toggle('scrolled', y > 16);
  backToTop?.classList.toggle('visible', y > 620);
  const max = document.documentElement.scrollHeight - window.innerHeight;
  if (progress) progress.style.width = `${max > 0 ? (y / max) * 100 : 0}%`;
}
window.addEventListener('scroll', onScroll, { passive: true });
onScroll();

menuToggle?.addEventListener('click', () => {
  const open = menuToggle.getAttribute('aria-expanded') === 'true';
  menuToggle.setAttribute('aria-expanded', String(!open));
  navLinks?.classList.toggle('open', !open);
});
navLinks?.querySelectorAll('a').forEach(link => link.addEventListener('click', () => {
  menuToggle?.setAttribute('aria-expanded', 'false');
  navLinks?.classList.remove('open');
}));

backToTop?.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));

const revealEls = document.querySelectorAll('[data-reveal]');
if ('IntersectionObserver' in window && !window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
  const revealObserver = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -30px' });
  revealEls.forEach(el => revealObserver.observe(el));
} else {
  revealEls.forEach(el => el.classList.add('is-visible'));
}

const filterButtons = document.querySelectorAll('[data-filter]');
const filterItems = document.querySelectorAll('[data-category]');
const emptyState = document.querySelector('.empty-state');
filterButtons.forEach(button => {
  button.addEventListener('click', () => {
    filterButtons.forEach(btn => btn.classList.remove('active'));
    button.classList.add('active');
    const filter = button.dataset.filter;
    let visible = 0;
    filterItems.forEach(item => {
      const show = filter === 'all' || item.dataset.category.split(' ').includes(filter);
      item.hidden = !show;
      if (show) visible += 1;
    });
    if (emptyState) emptyState.style.display = visible ? 'none' : 'block';
  });
});

const printButton = document.querySelector('[data-print]');
printButton?.addEventListener('click', () => window.print());

const contactForm = document.querySelector('[data-contact-form]');
const contactStatus = document.querySelector('[data-form-status]');
contactForm?.addEventListener('submit', async event => {
  event.preventDefault();
  if (!contactForm.reportValidity()) return;
  const data = new FormData(contactForm);
  const message = `Nom : ${data.get('name')}\nEmail : ${data.get('email')}\nSujet : ${data.get('subject')}\n\n${data.get('message')}`;
  try {
    await navigator.clipboard.writeText(message);
    if (contactStatus) contactStatus.textContent = 'Message copié. Ajoutez votre adresse e-mail dans le fichier de configuration pour activer l’envoi direct.';
  } catch {
    if (contactStatus) contactStatus.textContent = 'Le formulaire est prêt. L’adresse e-mail professionnelle reste à configurer.';
  }
});

const year = document.querySelector('[data-year]');
if (year) year.textContent = new Date().getFullYear();
