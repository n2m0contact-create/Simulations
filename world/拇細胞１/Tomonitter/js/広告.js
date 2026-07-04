window.onload = function(){

const ad = document.getElementById("gameAd");
const closeBtn = document.getElementById("closeAd");

if(!ad) return;

//閉じるボタン
if(closeBtn){
closeBtn.onclick = function(){
ad.style.display = "none";
};
}

//今日の日付
const today = new Date().toDateString();

//保存されているデータ
let adData = JSON.parse(localStorage.getItem("adData")) || {
date: today,
count: 0
};

//日付が変わったらリセット
if(adData.date !== today){
adData = {date: today, count: 0};
}

//1日2回まで
if(adData.count >= 5){
return;
}

//スクロール検知
let adTriggered = false;

window.addEventListener("scroll", function(){

if(adTriggered) return;

//ページの20%スクロールしたら
let scrollPosition = window.scrollY + window.innerHeight;
let pageHeight = document.body.offsetHeight;

if(scrollPosition > pageHeight * 0.2){

adTriggered = true;

//50%確率
if(Math.random() < 0.5){

setTimeout(function(){

ad.classList.add("show");

//表示回数記録
adData.count++;
localStorage.setItem("adData", JSON.stringify(adData));

},3000);

}

}

});

};