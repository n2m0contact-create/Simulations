;===============================================================
; ミケ ルート（本編）
; 置き場所： プロジェクト/data/scenario/mike_route.ks
;
; 必要な画像（プロジェクト/data/fgimage/ に置いてください）：
;   mike_normal.png    … 通常
;   mike_surprised.png … 驚き
;   mike_shy.png       … 照れ
;
; 好感度は f.mike_meter に貯めます（0〜18の偶数）。
;===============================================================

*mike_start

;テキストボックス
[position layer="message0" frame="framw1.png" left="0" top="520" width="1280" height="200" visible="true"]
[position layer="message0" margint="20" marginl="40" marginr="40" marginb="20"]


[chara_new name="mike" storage="mike_normal.png" jname="ミケ"]
[chara_face name="mike" face="surprised" storage="mike_surprised.png"]
[chara_face name="mike" face="shy"       storage="mike_shy.png"]

[eval exp="f.mike_meter = 0"]

[cm]
[chara_show name="mike" time=400 top=80]

*m1
[cm]
[chara_mod name="mike" face="default"]
残業終わりの給湯室。ミケが淡々とコーヒーを淹れている。[p]
ミケ「あ、○○さんの分もありますよ。……好みの濃さ、覚えてますので」[p]

[glink target=*m2_plus text="「ミケさん、いつも助かってます。可愛いですね」と伝える"]
[glink target=*m2_zero text="「ありがとう」とだけ言って受け取る"]
[s]

*m2_plus
[eval exp="f.mike_meter += 2"]
[jump target=*m2_body]
*m2_zero
[jump target=*m2_body]

*m2_body
[cm]
[chara_mod name="mike" face="default"]
資料を渡す拍子に、指先が触れる。[p]
[chara_mod name="mike" face="surprised"]
ミケの猫耳が、ぴくりと震えた。[p]
ミケ「……今の、静電気でしょうか」[p]

[glink target=*m3a text="わざとゆっくり手を離す"]
[glink target=*m3b text="何事もなかったように資料を受け取る"]
[s]

*m3a
[cm]
[chara_mod name="mike" face="surprised"]
ミケは手を引くのが少し遅れて、耳がまた小さく震える。[p]
[chara_mod name="mike" face="shy"]
ミケ「……離すの、遅くないですか。処理待ち、ですか」[p]
本人は気づいていないが、頬のあたりの放熱パネルがわずかに赤く灯っている。[p]

[glink target=*m4_plus text="「その耳、触ってもいいですか？」と聞いてみる"]
[glink target=*m4_zero text="「気のせいです」と笑って流す"]
[s]

*m3b
[cm]
[chara_mod name="mike" face="default"]
ミケはいつも通り、平静な顔で資料を受け取る。[p]
ミケ「……特に、異常はありません」[p]
ただ、あなたが立ち去った後、猫耳だけがしばらく小さく揺れていたらしい。[p]

[glink target=*m4_plus text="「その耳、触ってもいいですか？」と聞いてみる"]
[glink target=*m4_zero text="「気のせいです」と笑って流す"]
[s]

*m4_plus
[eval exp="f.mike_meter += 2"]
[jump target=*m4_body]
*m4_zero
[jump target=*m4_body]

*m4_body
[cm]
[chara_mod name="mike" face="surprised"]
「その耳、触ってもいいですか？」と聞くと、ミケは少し戸惑った顔をする。[p]
ミケ「……前例が、ありません。処理に、時間がかかります」[p]

[glink target=*m5a text="反応を見たくて、そっと耳に触れてみる"]
[glink target=*m5b text="「冗談です」と笑って流す"]
[s]

*m5a
[eval exp="f.mike_meter += 2"]
[cm]
[chara_mod name="mike" face="shy"]
触れた瞬間、ミケの耳がびくっと跳ね、背中の排熱口から小さく蒸気が上がる。[p]
ミケ「……っ、これは、想定外の負荷です」[p]
拒否はしない。ただ、次に会うときも心なしか耳がこちらを気にしていた。[p]

[glink target=*m6_plus text="「大丈夫？」と気遣う"]
[glink target=*m6_zero text="「くすぐったかった？」とからかう"]
[s]

*m5b
[cm]
[chara_mod name="mike" face="default"]
ミケはほっとしたように表情を戻す。[p]
けれど、少しだけ耳の先が名残惜しそうに、こちらへ傾いていた気がする。[p]

[glink target=*m6_plus text="気になって、もう一度聞いてみる"]
[glink target=*m6_zero text="そのまま話題を変える"]
[s]

*m6_plus
[eval exp="f.mike_meter += 2"]
[jump target=*m6_body]
*m6_zero
[jump target=*m6_body]

*m6_body
[cm]
[chara_mod name="mike" face="default"]
「最近、処理に負荷がかかっている気がします」とミケがぽつり。[p]
背中の排熱口が、いつもより開いている。[p]
ミケ「原因不明です。……機体の経年劣化、かもしれません」[p]

[glink target=*m7_plus text="「無理してない？何かあったら言ってね」と踏み込む"]
[glink target=*m7_zero text="「機体の調整、お疲れ様です」と当たり障りなく返す"]
[s]

*m7_plus
[eval exp="f.mike_meter += 2"]
[jump target=*m7_body]
*m7_zero
[jump target=*m7_body]

*m7_body
[cm]
[chara_mod name="mike" face="default"]
給湯室で、ミケが同僚に相談している声が、たまたま聞こえてしまう。[p]
[chara_mod name="mike" face="surprised"]
ミケ「特定の状況で、排熱量が増えて……原因を、調べてもらえますか」[p]

[glink target=*m8_plus text="気づかれないよう、後でさりげなく本人に理由を聞いてみる"]
[glink target=*m8_zero text="聞かなかったことにして、その場を離れる"]
[s]

*m8_plus
[eval exp="f.mike_meter += 2"]
[jump target=*m8_body]
*m8_zero
[jump target=*m8_body]

*m8_body
[cm]
[chara_mod name="mike" face="default"]
あなたが別の同僚と談笑していると、ミケの猫耳が心なしかぺたりと伏せている。[p]
ミケ「……いえ、何でもありません。処理落ち、していただけです」[p]

[glink target=*m9_plus text="気づいて、すぐミケのところへ戻る"]
[glink target=*m9_zero text="特に気にせず、そのまま談笑を続ける"]
[s]

*m9_plus
[eval exp="f.mike_meter += 2"]
[jump target=*m9_body]
*m9_zero
[jump target=*m9_body]

*m9_body
[cm]
[chara_mod name="mike" face="default"]
退勤時間、ミケが珍しく切り出してくる。[p]
[chara_mod name="mike" face="shy"]
ミケ「今日は、その……一緒に帰りませんか。……理由は、後で処理します」[p]
猫耳の先が、忙しなくこちらを窺っている。[p]

[glink target=*end_plus text="「もちろん」と笑って隣を歩く"]
[glink target=*end_zero text="「今日は用事があって」と断る"]
[s]

*end_plus
[eval exp="f.mike_meter += 2"]
[jump target=*ending]
*end_zero
[jump target=*ending]

*ending
[cm]
[if exp="f.mike_meter <= 5"]
[chara_mod name="mike" face="default"]
【同僚エンド】[p]
変わらず、良き同僚としての日々が続く。ミケは今日も真面目に、淡々と仕事をこなしている。特別なことは何も起きないまま、穏やかな時間が過ぎていく。[p]
[elsif exp="f.mike_meter <= 11"]
[chara_mod name="mike" face="default"]
【友情エンド】[p]
ある日、ミケが自分から「耳、触ってもいいですよ」と申し出てくる。「……これは、友情というものなんですね」と、誰に言うでもなく静かに納得する声が聞こえた。[p]
[else]
[chara_mod name="mike" face="shy"]
【恋愛自覚エンド】[p]
他の同僚と親しげにしているあなたを見た日、ミケの排熱口が急に開く。「……そうか。私は、○○さんが好きなんですね」　初めて自分の感情に、はっきりと言葉がついた瞬間だった。[p]
[endif]

[chara_hide name="mike"]
[s]
;; ここでタイトル/ギャラリー画面へ戻す処理を追加してください。例：
;; [jump storage="title.ks" target=*gallery]
