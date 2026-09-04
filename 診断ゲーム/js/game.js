// ゲーム本体のロジック（画面遷移・診断・ノベルパートなど）
(function(){
  "use strict";


  const byId = id => CHARACTERS.find(c => c.id === id);

  function monitorIconSVG(color, size){
    size = size || 64;
    return '<svg viewBox="0 0 64 56" width="'+size+'" height="'+Math.round(size*56/64)+'" aria-hidden="true">'
      + '<rect x="4" y="4" width="56" height="40" rx="7" fill="'+color+'" stroke="#0b0e13" stroke-width="2.5"/>'
      + '<rect x="10" y="10" width="30" height="20" rx="2" fill="rgba(255,255,255,0.16)"/>'
      + '<rect x="26" y="46" width="12" height="6" fill="#20262f"/>'
      + '<rect x="17" y="52" width="30" height="4" rx="2" fill="#20262f"/>'
      + '</svg>';
  }

  // モニター画面に「表情」を描き足したバージョン。ノベルパートの立ち絵に使う。
  // expr: 'normal' | 'smile' | 'shy' | 'surprised' | 'dark' のいずれか
  const FACE_PARTS = {
    normal:{
      eyes:'<rect x="15" y="16.5" width="6" height="2.6" rx="1.3" fill="#0b0e13"/><rect x="29" y="16.5" width="6" height="2.6" rx="1.3" fill="#0b0e13"/>',
      mouth:'<rect x="19" y="25" width="12" height="2" rx="1" fill="#0b0e13"/>',
      extra:''
    },
    smile:{
      eyes:'<path d="M14 19 Q17.5 14.5 21 19" stroke="#0b0e13" stroke-width="2.2" fill="none" stroke-linecap="round"/><path d="M29 19 Q32.5 14.5 36 19" stroke="#0b0e13" stroke-width="2.2" fill="none" stroke-linecap="round"/>',
      mouth:'<path d="M18 24 Q25 30 32 24" stroke="#0b0e13" stroke-width="2.4" fill="none" stroke-linecap="round"/>',
      extra:''
    },
    shy:{
      eyes:'<rect x="15" y="17" width="6" height="2.2" rx="1.1" fill="#0b0e13"/><rect x="29" y="17" width="6" height="2.2" rx="1.1" fill="#0b0e13"/>',
      mouth:'<path d="M20 25.5 Q25 28 30 25.5" stroke="#0b0e13" stroke-width="2" fill="none" stroke-linecap="round"/>',
      extra:'<circle cx="13" cy="23" r="3" fill="#ff9ab0" opacity=".55"/><circle cx="37" cy="23" r="3" fill="#ff9ab0" opacity=".55"/>'
    },
    surprised:{
      eyes:'<circle cx="18" cy="18" r="3.6" fill="#0b0e13"/><circle cx="32" cy="18" r="3.6" fill="#0b0e13"/>',
      mouth:'<ellipse cx="25" cy="26" rx="3.6" ry="4.4" fill="#0b0e13"/>',
      extra:''
    },
    dark:{
      eyes:'<path d="M13 15.5 L21 18.5" stroke="#0b0e13" stroke-width="2.2" stroke-linecap="round"/><path d="M37 15.5 L29 18.5" stroke="#0b0e13" stroke-width="2.2" stroke-linecap="round"/><path d="M13 21.5 L21 18.5" stroke="#0b0e13" stroke-width="2.2" stroke-linecap="round"/><path d="M37 21.5 L29 18.5" stroke="#0b0e13" stroke-width="2.2" stroke-linecap="round"/>',
      mouth:'<path d="M17 24.5 L21 28 L25 24.5 L29 28 L33 24.5" stroke="#0b0e13" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>',
      extra:''
    }
  };

  function charSpriteSVG(color, size, expr){
    size = size || 64;
    const f = FACE_PARTS[expr] || FACE_PARTS.normal;
    return '<svg viewBox="0 0 64 56" width="'+size+'" height="'+Math.round(size*56/64)+'" aria-hidden="true">'
      + '<rect x="4" y="4" width="56" height="40" rx="7" fill="'+color+'" stroke="#0b0e13" stroke-width="2.5"/>'
      + '<rect x="10" y="10" width="30" height="20" rx="2" fill="rgba(255,255,255,0.16)"/>'
      + f.extra + f.eyes + f.mouth
      + '<rect x="26" y="46" width="12" height="6" fill="#20262f"/>'
      + '<rect x="17" y="52" width="30" height="4" rx="2" fill="#20262f"/>'
      + '</svg>';
  }

  // ---------- 立ち絵に自前のイラストを使う場合の仕組み ----------
  // キャラのオブジェクトに以下のような `sprites` を追加すると、
  // 自動生成の顔SVGの代わりに、そのイラスト画像が表示される。
  //   sprites: {
  //     normal: 'data:image/png;base64,xxxxx....',   // 通常
  //     smile:  'data:image/png;base64,xxxxx....',   // 笑顔（無くてもOK）
  //     shy:    'data:image/png;base64,xxxxx....',   // 照れ（無くてもOK）
  //     surprised: 'data:image/png;base64,xxxxx....',
  //     dark:   'data:image/png;base64,xxxxx....'
  //   }
  // 表情ごとの画像が足りない場合は sprites.normal にフォールバックし、
  // sprites 自体が無いキャラは今まで通り自動生成の顔（モニターSVG）が使われる。
  function spriteHTML(c, expr, size){
    size = size || 96;
    if(c.sprites){
      const src = c.sprites[expr] || c.sprites.normal;
      if(src){
        return '<img src="'+src+'" alt="'+c.name+'">';
      }
    }
    return charSpriteSVG(c.tint, size, expr);
  }

  // ステージ（画面上部の立ち絵エリア）を更新する。画像を使うキャラは
  // 表示エリアを少し広げるため、#vnStage に has-photo クラスを付け外しする。
  function updateStageSprite(c, expr){
    const stage = document.getElementById('vnStage');
    const hasPhoto = !!(c.sprites && (c.sprites[expr] || c.sprites.normal));
    stage.classList.toggle('has-photo', hasPhoto);
    document.getElementById('vnSprite').innerHTML = spriteHTML(c, expr, 96);
  }

  const DANGER_MAX = 10; // 危険度は10段階固定（キャラ数が増えても変わらない）

  function dangerMeterHTML(level){
    let out = '<span class="lbl">危険度</span>';
    for(let i=1;i<=DANGER_MAX;i++){
      out += '<span class="dm-tick'+(i<=level?' on':'')+'"></span>';
    }
    return out;
  }

  function chLabel(order){
    return 'CH.' + String(order).padStart(2,'0');
  }

  // ビジュアルノベル風：セリフを1文字ずつ表示する（動きを減らす設定の人には即表示）
  // onDone: 表示完了時（スキップ含む）に呼ばれるコールバック。次の行へ進む合図に使う。
  function typeDialogue(el, text, onDone){
    clearInterval(el._typeTimer);
    el._typing = true;
    el._onDone = onDone || null;
    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if(reduceMotion){
      el.textContent = text;
      el._typing = false;
      if(onDone) onDone();
      return;
    }
    el.textContent = '';
    let i = 0;
    el._typeTimer = setInterval(() => {
      i++;
      el.textContent = text.slice(0, i);
      if(i >= text.length){
        clearInterval(el._typeTimer);
        el._typing = false;
        if(el._onDone) el._onDone();
      }
    }, 26);
  }

  // 表示中のセリフをクリックすると、タイピング演出をスキップして全文表示する
  function skipTyping(el, text){
    clearInterval(el._typeTimer);
    el.textContent = text;
    const wasTyping = el._typing;
    el._typing = false;
    // スキップ時も「表示完了」扱いにして、そのままクリックで次へ進めるようにする
    if(wasTyping && el._onDone) el._onDone();
  }

  // キャラの色でステージ（背景）を染める
  function setStageTint(color){
    const stage = document.getElementById('vnStage');
    stage.style.background =
      'radial-gradient(ellipse 130% 110% at 50% 25%, ' + color + '40 0%, #0b0e13 72%)';
  }

  function shuffle(arr){
    const a = arr.slice();
    for(let i=a.length-1;i>0;i--){
      const j = Math.floor(Math.random()*(i+1));
      [a[i],a[j]] = [a[j],a[i]];
    }
    return a;
  }

  // ---------- screens ----------
  const screens = {};
  document.querySelectorAll('.screen').forEach(el => screens[el.id] = el);
  const chIndicator = document.getElementById('chIndicator');

  function showScreen(name, opts){
    Object.values(screens).forEach(s => s.classList.remove('active'));
    screens[name].classList.add('active');
    if(!opts || !opts.noFlicker){
      screens[name].classList.remove('flicker');
      // force reflow to restart animation
      void screens[name].offsetWidth;
      screens[name].classList.add('flicker');
    }
  }

  // roster strip on title
  (function renderRoster(){
    const strip = document.getElementById('rosterStrip');
    CHARACTERS.forEach(c => {
      strip.insertAdjacentHTML('beforeend', monitorIconSVG(c.tint, 34));
    });
  })();

  // ---------- quiz ----------
  let qIndex = 0;
  let scores = {};
  let currentOptionOrder = [];

  function resetScores(){
    scores = {}; CHARACTERS.forEach(c => scores[c.id] = 0);
  }

  function startQuiz(){
    resetScores();
    qIndex = 0;
    chIndicator.textContent = 'CH.--';
    showScreen('screen-quiz');
    renderQuestion();
  }

  function renderDots(){
    const dotsEl = document.getElementById('quizDots');
    dotsEl.innerHTML = '';
    for(let i=0;i<QUESTIONS.length;i++){
      const d = document.createElement('span');
      d.className = 'dot' + (i < qIndex ? ' done' : '') + (i === qIndex ? ' now' : '');
      dotsEl.appendChild(d);
    }
  }

  function renderQuestion(){
    renderDots();
    document.getElementById('qCount').textContent = 'Q.' + (qIndex+1) + ' / ' + QUESTIONS.length;
    document.getElementById('qText').textContent = QUESTIONS[qIndex];
    // 各キャラのanswers配列から、この質問番号(qIndex)に対応する回答だけを集めて選択肢にする
    const opts = CHARACTERS.map(c => ({ c: c.id, t: c.answers[qIndex] }));
    currentOptionOrder = shuffle(opts);
    const optWrap = document.getElementById('qOptions');
    optWrap.innerHTML = '';
    currentOptionOrder.forEach(opt => {
      const btn = document.createElement('button');
      btn.className = 'opt';
      btn.type = 'button';
      btn.textContent = opt.t;
      btn.addEventListener('click', () => answer(opt.c, btn));
      optWrap.appendChild(btn);
    });
  }

  function answer(charId, btnEl){
    document.querySelectorAll('#qOptions .opt').forEach(b => b.disabled = true);
    btnEl.classList.add('picked');
    scores[charId]++;
    setTimeout(() => {
      qIndex++;
      if(qIndex < QUESTIONS.length){
        renderQuestion();
        showScreen('screen-quiz');
      } else {
        finishQuiz();
      }
    }, 260);
  }

  function finishQuiz(){
    let best = [];
    let bestScore = -1;
    CHARACTERS.forEach(c => {
      if(scores[c.id] > bestScore){ bestScore = scores[c.id]; best = [c.id]; }
      else if(scores[c.id] === bestScore){ best.push(c.id); }
    });
    const winner = best[Math.floor(Math.random()*best.length)];
    showResult(winner);
  }

  // ---------- result ----------
  const flipCard = document.getElementById('flipCard');

  function showResult(charId){
    flipCard.classList.remove('flipped');
    const c = byId(charId);
    chIndicator.textContent = chLabel(c.order);

    document.getElementById('resIconFront').innerHTML = monitorIconSVG(c.tint, 78);
    document.getElementById('resNameFront').textContent = c.name;
    document.getElementById('resRoleFront').textContent = c.role;
    document.getElementById('resDangerFront').innerHTML = dangerMeterHTML(c.danger);
    document.getElementById('resFront').textContent = c.front;

    document.getElementById('resIconBack').innerHTML = monitorIconSVG(c.tint, 60);
    document.getElementById('resNameBack').textContent = c.name;
    document.getElementById('resBack').textContent = c.back;

    document.getElementById('toScenarioBtn').onclick = () => showScenario(charId);
    showScreen('screen-result');
    flipCard.currentChar = charId;
  }

  document.getElementById('flipBtn').addEventListener('click', () => {
    flipCard.classList.add('flipped');
  });

  // ティラノスクリプト側にルートを用意したキャラのID一覧
  // （今後キャラを移行したら、ここに追加していく）
  const TYRANO_CHARACTERS = ['lauren', 'mike'];

  // ---------- scenario (visual-novel style) ----------
  function showScenario(charId){
    if(TYRANO_CHARACTERS.includes(charId)){
      location.href = 'tyrano/index.html?chara=' + charId;
      return;
    }

    const c = byId(charId);
    chIndicator.textContent = chLabel(c.order);
    setStageTint(c.tint);
    updateStageSprite(c, 'normal');
    document.getElementById('scName').textContent = c.name;
    document.getElementById('scName').classList.remove('is-hidden');
    document.getElementById('scEndingWrap').style.display = 'none';

    if(c.route){
      startNovelRoute(c);
    } else {
      showClassicScenario(c);
    }
  }
  
  // 旧形式：状況説明1つ＋2択→即エンディング（scenarioフィールドを持つキャラ用）
  function showClassicScenario(c){
    document.getElementById('scProgress').style.display = 'none';
    document.getElementById('scNext').classList.remove('show');

    const dialogueEl = document.getElementById('scSetup');
    dialogueEl.classList.remove('is-narration');
    typeDialogue(dialogueEl, c.scenario.setup);
    dialogueEl.onclick = () => skipTyping(dialogueEl, c.scenario.setup);

    const choiceWrap = document.getElementById('scChoices');
    choiceWrap.style.display = 'flex';
    choiceWrap.innerHTML = '';
    c.scenario.choices.forEach(choice => {
      const btn = document.createElement('button');
      btn.className = 'opt';
      btn.type = 'button';
      btn.textContent = choice.label;
      btn.addEventListener('click', () => {
        choiceWrap.style.display = 'none';
        const badgeEl = document.getElementById('scBadge');
        const endTextEl = document.getElementById('scEndingText');
        badgeEl.textContent = choice.tag;
        typeDialogue(endTextEl, choice.text);
        endTextEl.onclick = () => skipTyping(endTextEl, choice.text);
        document.getElementById('scEndingWrap').style.display = 'block';
      });
      choiceWrap.appendChild(btn);
    });

    showScreen('screen-scenario');
  }

  // ==========================================================================
  // 新形式：分岐つき・複数セリフのノベルルート（routeフィールドを持つキャラ用）
  //
  // データ構造：
  //   route.start  : 最初のシーンID（例 's1'）
  //   route.scenes : { シーンID: { act:1, lines:[...], choices:[...] } , ... }
  //     - lines  : そのシーンで順番に表示するセリフの配列。
  //                { speaker:'char'|'you'|'narr', text:'…', expr:'normal'|'smile'|'shy'|'surprised'|'dark' }
  //                speaker が 'char' ならキャラ本人のセリフ（名前プレートを表示）、
  //                'narr' ならナレーション（ト書き。名前プレートは隠す）。
  //     - choices: 全ての行を読み終えた後に出す選択肢。
  //                { label:'…', delta:2, next:'s2' }   next が次のシーンID。
  //                next:'END' でルート終了 → エンディング判定へ。
  //   route.endings: 従来通り、meter（選んだ delta の合計）の範囲でエンディングを出し分ける。
  //
  //   分岐は「合流する分岐」＝途中で選択肢によって見えるシーンの中身が変わるが、
  //   数シーン後にまた同じ本筋に戻る作り。act番号は分岐先どうしで同じ数字にしてあるので、
  //   どちらを選んでも進行バー（ACT n/9）はズレない。
  // ==========================================================================
  let novelState = null;

  function startNovelRoute(c){
    novelState = { char:c, sceneId:c.route.start, lineIndex:0, meter:0 };
    document.getElementById('scChoices').style.display = 'none';
    renderNovelLine();
    showScreen('screen-scenario');
  }

  function currentScene(){
    return novelState.char.route.scenes[novelState.sceneId];
  }

  function totalActs(){
    const scenes = novelState.char.route.scenes;
    return Object.keys(scenes).reduce((max, id) => Math.max(max, scenes[id].act), 0);
  }

  // シーン内の lines を1行ずつ、クリックで送りながら表示する
  function renderNovelLine(){
    const scene = currentScene();
    const line = scene.lines[novelState.lineIndex];

    document.getElementById('scEndingWrap').style.display = 'none';
    const choiceWrap = document.getElementById('scChoices');
    choiceWrap.style.display = 'none';
    choiceWrap.innerHTML = '';

    const progress = document.getElementById('scProgress');
    progress.style.display = 'block';
    progress.textContent = 'ACT ' + scene.act + ' / ' + totalActs();

    const nameEl = document.getElementById('scName');
    const dialogueEl = document.getElementById('scSetup');
    const nextIndicator = document.getElementById('scNext');
    nextIndicator.classList.remove('show');

    if(line.speaker === 'narr'){
      nameEl.classList.add('is-hidden');
      dialogueEl.classList.add('is-narration');
    } else {
      nameEl.classList.remove('is-hidden');
      nameEl.textContent = line.speaker === 'you' ? 'あなた' : novelState.char.name;
      dialogueEl.classList.remove('is-narration');
    }

    updateStageSprite(novelState.char, line.expr || 'normal');

    const isLastLine = novelState.lineIndex >= scene.lines.length - 1;

    typeDialogue(dialogueEl, line.text, () => {
      nextIndicator.classList.add('show');
    });

    dialogueEl.onclick = () => {
      if(dialogueEl._typing){
        skipTyping(dialogueEl, line.text);
        return;
      }
      nextIndicator.classList.remove('show');
      if(isLastLine){
        renderNovelChoices(scene);
      } else {
        novelState.lineIndex++;
        renderNovelLine();
      }
    };
  }

  function renderNovelChoices(scene){
    const choiceWrap = document.getElementById('scChoices');
    choiceWrap.style.display = 'flex';
    choiceWrap.innerHTML = '';
    scene.choices.forEach(choice => {
      const btn = document.createElement('button');
      btn.className = 'opt';
      btn.type = 'button';
      btn.textContent = choice.label;
      btn.addEventListener('click', () => {
        novelState.meter += choice.delta;
        if(choice.next === 'END'){
          finishNovelRoute();
        } else {
          novelState.sceneId = choice.next;
          novelState.lineIndex = 0;
          renderNovelLine();
        }
      });
      choiceWrap.appendChild(btn);
    });
  }

  function finishNovelRoute(){
    const { char, meter } = novelState;
    const ending = char.route.endings.find(e => meter >= e.min && meter <= e.max)
                || char.route.endings[char.route.endings.length-1];

    document.getElementById('scProgress').style.display = 'none';
    document.getElementById('scNext').classList.remove('show');
    // scSetup/scName はあえてクリアしない → 直前のシーンの最後のセリフを
    // 「ログ」のようにそのまま残し、その下にエンディングを重ねて表示する
    document.getElementById('scChoices').style.display = 'none';
    document.getElementById('scChoices').innerHTML = '';

    const badgeEl = document.getElementById('scBadge');
    const endTextEl = document.getElementById('scEndingText');
    badgeEl.textContent = ending.tag;
    typeDialogue(endTextEl, ending.text);
    endTextEl.onclick = () => skipTyping(endTextEl, ending.text);
    document.getElementById('scEndingWrap').style.display = 'block';
  }

  // ---------- gallery ----------
  function renderGallery(){
    const grid = document.getElementById('galleryGrid');
    grid.innerHTML = '';
    CHARACTERS.slice().sort((a,b) => a.order - b.order).forEach(c => {
      const card = document.createElement('button');
      card.className = 'g-card';
      card.type = 'button';
      card.innerHTML =
        monitorIconSVG(c.tint, 48) +
        '<div class="chara-name">'+c.name+'</div>' +
        '<div class="chara-role">'+c.role+'</div>' +
        '<div class="danger-meter">'+dangerMeterHTML(c.danger)+'</div>' +
        '<div class="catchphrase">「'+c.front+'」</div>';
      card.addEventListener('click', () => showResult(c.id));
      grid.appendChild(card);
    });
  }

  function showGallery(){
    chIndicator.textContent = 'CH.ALL';
    renderGallery();
    showScreen('screen-gallery');
  }

  // ---------- bonus (non-romance) ----------
  function renderBonus(){
    const list = document.getElementById('bonusList');
    list.innerHTML = '';
    BONUS_CHARACTERS.forEach(c => {
      const card = document.createElement('div');
      card.className = 'b-card';
      card.innerHTML =
        monitorIconSVG(c.tint, 40) +
        '<div class="b-body">' +
          '<div class="no-romance-tag">恋愛不可</div>' +
          '<div class="chara-name">'+c.name+'</div>' +
          '<div class="chara-role">'+c.role+'</div>' +
          '<div class="catchphrase">「'+c.front+'」</div>' +
          '<div class="vignette">'+c.vignette+'</div>' +
        '</div>';
      list.appendChild(card);
    });
  }

  function showBonus(){
    chIndicator.textContent = 'CH.EX';
    renderBonus();
    showScreen('screen-bonus');
  }

  // ---------- wiring ----------
  document.getElementById('startBtn').addEventListener('click', startQuiz);
  document.getElementById('toGalleryFromTitle').addEventListener('click', showGallery);
  document.getElementById('resToGallery').addEventListener('click', showGallery);
  document.getElementById('scToGallery').addEventListener('click', showGallery);
  document.getElementById('resRestart').addEventListener('click', startQuiz);
  document.getElementById('scRestart').addEventListener('click', startQuiz);
  document.getElementById('galToTitle').addEventListener('click', () => {
    chIndicator.textContent = 'CH.--';
    showScreen('screen-title');
  });
  document.getElementById('galToBonus').addEventListener('click', showBonus);
  document.getElementById('bonusToGallery').addEventListener('click', showGallery);

})();
