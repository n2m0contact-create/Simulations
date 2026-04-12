
//読み込み確認用
document.addEventListener("DOMContentLoaded", function () {


    //準備フェーズ
    //資料
    let hasFileA = false;
    let hasFileB = false;

    document.getElementById("fileA").addEventListener("click", () => {
        hasFileA = true;
        alert("資料Aを入手した");
    });

    document.getElementById("fileB").addEventListener("click", () => {
        hasFileB = true;
        alert("資料Bを入手した");
    });

    document.getElementById("startGame").addEventListener("click", () => {
        document.querySelector(".start-screen").style.display = "none";

        document.querySelector(".textbox").classList.add("show");

        const win = document.querySelector(".window");

        setTimeout(() => {
            win.classList.add("open");
        }, 50);

        startInterrogation();
    });

    //接続フラグ
    let connected1 = false;
    let connected2 = false;
    let connected3 = false;
    let connected4 = false;

    //接続４を解放する条件
    function checkFinalConnection() {
        if (
            connected1 &&
            connected2 &&
            connected3 &&
            mental >= 85 &&
            correction >= 95 &&
            !connected4
        ) {
            showFinalConnectionButton();
        }
    }

    let currentInterval;
    let fullText = "";

    function typeText(text, speed) {
        if (typing) return;
        clearInterval(currentInterval);
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

});