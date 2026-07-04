
document.addEventListener('DOMContentLoaded', () => {

  /* 現住者一覧の全体処理 */
  const tatami = document.querySelector('.tatami');
  const wrapper = document.querySelector('.chara-wrapper');



  tatami.addEventListener('click', () => {
    const isOpen = wrapper.classList.toggle('is-open');

     const lists = wrapper.querySelectorAll('.resident-list');

    if (isOpen) {
      // 開いたら全部表示
      lists.forEach(list => list.classList.add('is-open'));
    } else {
      // 閉じたら全部リセット
      lists.forEach(list => list.classList.remove('is-open'));
    }
  });

  /* 分類ごと */
  document.querySelectorAll('.resident-title').forEach(title => {
    title.addEventListener('click', (e) => {
      e.stopPropagation(); // 親要素への伝播を防止

      const list = title.closest('.resident-list');
      list.classList.toggle('is-open');
    });
  });
});

/*-- Ncクリック処理 --*/
document.addEventListener('DOMContentLoaded', () => {

  const toggle = document.querySelector('.Nc-toggle');
  const wrapper = document.querySelector('.Nc-wrapper');

  toggle.addEventListener('click', () => {
    wrapper.classList.toggle('is-open');
  });

});

/*-- Scクリック処理 --*/
document.addEventListener('DOMContentLoaded', () => {

  const toggle = document.querySelector('.Sc-toggle');
  const wrapper = document.querySelector('.Sc-wrapper');

  toggle.addEventListener('click', () => {
    wrapper.classList.toggle('is-open');
  });

});

/*-- Mcクリック処理 --*/
document.addEventListener('DOMContentLoaded', () => {

  const toggle = document.querySelector('.Mc-toggle');
  const wrapper = document.querySelector('.Mc-wrapper');

  toggle.addEventListener('click', () => {
    wrapper.classList.toggle('is-open');
  });

});

/*-- Icクリック処理 --*/
document.addEventListener('DOMContentLoaded', () => {

  const toggle = document.querySelector('.Ic-toggle');
  const wrapper = document.querySelector('.Ic-wrapper');

  toggle.addEventListener('click', () => {

    wrapper.classList.toggle('is-open');
  });

});

/*-- Hcクリック処理 --*/
document.addEventListener('DOMContentLoaded', () => {

  const toggle = document.querySelector('.Hc-toggle');
  const wrapper = document.querySelector('.Hc-wrapper');

  toggle.addEventListener('click', () => {
    wrapper.classList.toggle('is-open');
  });

});


/*-- Tcクリック処理 --*/
document.addEventListener('DOMContentLoaded', () => {

  const toggle = document.querySelector('.Tc-toggle');
  const wrapper = document.querySelector('.Tc-wrapper');

  toggle.addEventListener('click', () => {
    wrapper.classList.toggle('is-open');
  });

});


document.addEventListener('DOMContentLoaded', () => {

  const navResident = document.querySelector('.nav-resident');
  const overlay = document.getElementById('spoilerOverlay');
  const yesBtn = document.getElementById('spoilerYes');
  const noBtn = document.getElementById('spoilerNo');
  const wrapper = document.querySelector('.chara-wrapper');
  const residentLists = document.querySelectorAll('.resident-list');

  if (!navResident || !overlay) return;

  let confirmed = false;

  navResident.addEventListener('click', (e) => {
    e.preventDefault();

    const isOpen = wrapper.classList.contains('is-open');

    // すでに開いてたら閉じる
    if (isOpen) {
      wrapper.classList.remove('is-open');
      residentLists.forEach(list => list.classList.remove('is-open'));
      return;
    }

    // 未確認ならネタバレ警告
    if (!confirmed) {
      overlay.classList.add('is-show');
      return;
    }

    openResidents();
  });

  yesBtn?.addEventListener('click', () => {
    confirmed = true;
    overlay.classList.remove('is-show');

    const noise = document.createElement('div');
    noise.className = 'noise';
    document.body.appendChild(noise);

    setTimeout(() => {
      noise.remove();
      openResidents();
    }, 400);
  });

  noBtn?.addEventListener('click', () => {
    overlay.classList.remove('is-show');
  });

  function openResidents() {
    wrapper.classList.add('is-open');
    residentLists.forEach(list => list.classList.add('is-open'));
  }

});

//　スマホ用
document.addEventListener('DOMContentLoaded', () => {

  const menuBtn = document.querySelector('.menu-btn');
  const spMenu = document.querySelector('.sp-menu');
  const overlay = document.querySelector('.menu-overlay');
  const header = document.querySelector('.site-header');

  /* ===== スマホメニュー ===== */
  if (menuBtn && spMenu && overlay) {
    menuBtn.addEventListener('click', () => {
      spMenu.classList.toggle('is-open');
      overlay.classList.toggle('is-show');
    });

    overlay.addEventListener('click', () => {
      spMenu.classList.remove('is-open');
      overlay.classList.remove('is-show');
    });
  }

  /* ===== スクロールでヘッダー縮小 ===== */
  if (header) {
    window.addEventListener('scroll', () => {
      if (window.scrollY > 50) {
        header.classList.add('is-small');
      } else {
        header.classList.remove('is-small');
      }
    });
  }

});
