//シナリオデータ
//セリフ
const scenario = [

    {//初回の相手のセリフ（stepが0のとき）
        text: "初めまして。",//セリフ
        chara: "chara1.png",//立ち絵
        speed: 120,//セリフの表示スピード
    },
    {
        text: ".........。",
        speed: 60,
    },
    {
        text:
            "見ない方ですが、新機の方でしょうか？",
        speed: 120,
    },

    {
        choices: [
            {
                label: "挨拶をする",
                correction: +10,
                mental: -5,
                next: 4
            },
            {
                label: "業務を始める",
                correction: +20,
                mental: -20,
                next: 4
            }
        ]
    },

    {},

    {
        text:
            "ここで終了です。半端で申し訳ない。",
        speed: 60,
    },

    {
        text:
            "シナリオは随時製作中でしてよ。",
        speed: 60,
    },

    {
        text:
            "お楽しみに...",
        speed: 60,
    },

    {
        text:
            "実はまだ、終了できるようになっていないので、各自で閉じてください。",
        speed: 60,
    },

    {
        text:
            "ありがとうございました。",
        speed: 60,
    },

];

//ゲームの状態 進行について
//ゲームフラグ
//let ego = 100;フラグ（自我）max100 min0
let step = 0;//質問進行
let mental = 60;//フラグ（相手の精神状態）max100 min0
let correction = 0;//フラグ（感情抑制プログラムの修正度）
let connectionStage = 0; //フラグ（接続段階）0:未接続 1:友人邂逅 2:友人1477について 3:友人1464について 4:願いと勧誘


const textDiv = document.getElementById("text");
const choicesDiv = document.getElementById("choices");
const charaImg = document.getElementById("character");

function startInterrogation() {
    showScene();
}
/*//精神状態の変化(不安定状態)
if (mental < 50) {
    mental = Math.floor(Math.random() * 50);
}
 
//精神状態の変化(安定状態)
if (mental > 90 && getMentalState() === "stable") {
    mental = 90;
}
*/
//スピード関係
let typing = false;
function showScene() {
    const scene = scenario[step];

    // 立ち絵変更
    if (scene.chara) {
        charaImg.src = `images/${scene.chara}`;
    }

    // テキストがある場合
    if (scene.text) {
        typeText(scene.text, scene.speed || 80);
    }

    // 選択肢がある場合
    if (scene.choices) {
        textDiv.textContent = "";
        choicesDiv.innerHTML = "";

        scene.choices.forEach(choice => {
            const btn = document.createElement("button");
            btn.textContent = choice.label;

            btn.addEventListener("click", () => {
                mental += choice.mental || 0;
                correction += choice.correction || 0;
                step = choice.next;
                showScene();
            });

            choicesDiv.appendChild(btn);
        });
    }
}

let currentInterval;
let fullText = "";

function typeText(text, speed) {
    if (!text) return;
    typing = true;
    fullText = text;
    textDiv.textContent = "";
    let i = 0;

    currentInterval = setInterval(() => {
        textDiv.textContent += text[i];
        i++;

        if (i >= text.length) {
            clearInterval(currentInterval);
            typing = false;
        }
    }, speed);
}

document.querySelector(".textbox").addEventListener("click", () => {

    if (typing) {
        clearInterval(currentInterval);
        textDiv.textContent = fullText;
        typing = false;
        return;
    }

    step++;
    if (step < scenario.length) {
        showScene();
    }
});
