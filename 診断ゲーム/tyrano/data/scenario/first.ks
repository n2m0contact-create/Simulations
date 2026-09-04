;一番最初に呼び出されるファイル

[eval exp="f.chara_select = new URLSearchParams(location.search).get('chara')"]

[if exp="f.chara_select == 'lauren'"]
[jump storage="lauren_route.ks" target=*lauren_start]
[elsif exp="f.chara_select == 'mike'"]
[jump storage="mike_route.ks" target=*mike_start]
[else]
[jump storage="devmenu.ks"]
[endif]


[title name="ティラノスクリプト解説"]

[stop_keyconfig]



;ティラノスクリプトが標準で用意している便利なライブラリ群
;コンフィグ、CG、回想モードを使う場合は必須
@call storage="tyrano.ks"

;ゲームで必ず必要な初期化処理はこのファイルに記述するのがオススメ

;メッセージボックスは非表示
@layopt layer="message" visible=false

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

;タイトル画面へ移動
@jump storage="title.ks"


[s]


