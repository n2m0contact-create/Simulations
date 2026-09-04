
;===============================================================
; ローレン ルート（本編）
; 置き場所： プロジェクト/data/scenario/lauren_route.ks
;
; 必要な画像（プロジェクト/data/fgimage/ に置いてください）：
;   lauren_normal.png … 通常
;   lauren_smile.png  … 笑顔
;   lauren_shy.png    … 照れ
;   lauren_syock.png  …ショック
;   lauren_dark.png   … 黒目なし・裏の顔
;   lauren_honrai.png …本来の顔
;
; まだ用意できていない表情がある場合は、該当する [chara_face] 行を
; コメントアウトするか、同じファイル名を指定しておけばエラーになりません。
;
; 好感度は f.lauren_meter に貯めます（0〜32の偶数）。最後にその合計でエンディングを出し分けます（4種）。
; 拒絶度は f.lauren_reject に貯めます。
;   ・6箇所（s4_body / s5a / s5_5body / s7_body / s8_5body / s8_9body）で
;     「はっきり拒絶する」選択肢を選ぶと+1される
;   ・合計5に達した時点で、進行中のシーンから即座に監禁エンドへ強制ジャンプ
;   ・s7_bodyのみ、reject>=2の場合に限り「徹底拒絶」の3択目が出現し、
;     選ぶと即座に監禁エンドへ
;
; ボイスフォントについて：
;   通常時は[speaker]（スピーカー声＝DotGothic16、かくかく規則的）がデフォルト。
;   仮面が外れる瞬間だけ[realvoice]〜[endvoice]で地声（Yomogi、掠れた手書き）に切り替える。
;   地声フォントを試して変えたくなったら、下の*voice_macrosの
;   [macro name="realvoice"]内のface="Yomogi"を差し替えるだけでOK。
;   DotGothic16 / Yuji Syuku / Yomogi / Zen Kurenaido はいずれもGoogle Fonts。
;   プロジェクトの環境でWebフォント読み込みが使えない場合は、
;   フォントファイルをdata/others/等に置いてローカル指定に変更してください。
;
; 全エンド到達フラグ（sf.reached_〜）について：
;   セーブをまたいで残る永続フラグ(sf)で、5エンド（監視継続/滲み出し/
;   求愛成就/隠し/監禁）の到達状況を記録します。全部揃うと、エンディング
;   画面に「……もう少し、話してみる」が追加出現し、*ending_true（隠し
;   の隠しシーン）に入れます。ここは本編（GameMaker版・ダウンロード
;   ゲーム）への前振り程度の軽い演出に留めており、本格的なメタ干渉演出
;   はそちら側で作り込む想定です。
;===============================================================
 
; --- ボイスフォント用マクロ ---
[macro name="speaker"]
[font face="DotGothic16" color="#dcdcdc"]
[endmacro]
 
[macro name="realvoice"]
[font face="Yomogi" color="#b9b0a8"]
[endmacro]
 
[macro name="endvoice"]
[endfont]
[endmacro]
 
; --- ノイズ演出用マクロ ---
; noise_glitch＝砂嵐（軽めの違和感）／noise_glitch_bars＝縦帯（決定的な破綻の瞬間）
; storage="tv_noise.gif" / "tv_noise_bars.gif" を data/image/ 等に配置してください。
; layer/pageの指定はプロジェクトの他の画像表示箇所に合わせて調整してください。
[macro name="noise_glitch"]
[quake time=300 value=8]
[image layer="right" page="fore" visible="true" storage="tv_noise.gif" left="0" top="0"]
[wait time=250]
[freeimage layer="right"]
[flash color="#ffffff" time=80]
[endmacro]
 
[macro name="noise_glitch_bars"]
[quake time=300 value=10]
[image layer="right" page="fore" visible="true" storage="tv_noise_bars.gif" left="0" top="0"]
[wait time=250]
[freeimage layer="right"]
[flash color="#ffffff" time=80]
[endmacro]
 
*lauren_start
 
;テキストボックス
[position layer="message0" frame="framw1.png" left="0" top="520" width="1280" height="200" visible="true"]
[position layer="message0" margint="20" marginl="40" marginr="40" marginb="20"]
 
; --- 表情差分の登録（最初に1回だけ）---
[chara_new name="lauren" storage="lauren_normal.png" jname="ローレン"]
[chara_face name="lauren" face="smile" storage="lauren_smile.png"]
[chara_face name="lauren" face="shy"   storage="lauren_shy.png"]
[chara_face name="lauren" face="dark"  storage="lauren_dark.png"]
[chara_face name="lauren" face="syock"   storage="lauren_syock.png"]
[chara_face name="lauren" face="futuu"  storage="lauren_dark.png"]
 
; --- メーターの初期化 ---
[eval exp="f.lauren_meter = 0"]
[eval exp="f.lauren_reject = 0"]
 
[cm]
[chara_show name="lauren" time=400 top=60]
 
*s1
[cm]
[chara_mod name="lauren" face="default"]
同じ部署のローレンが、コーヒーメーカーの前でこちらに気づいて振り返る。[p]
[chara_mod name="lauren" face="smile"]
ローレン「あ、○○さん。コーヒー、いつものやつでいいですか？」[p]
聞くまでもない、というように、すでに数杯分の粉を計り終えている。[p]
 
[glink target=*s2_plus text="「覚えててくれたんですね、嬉しいです」と笑う"]
[glink target=*s2_zero text="「ああ、はい」とだけ短く返す"]
[s]
 
*s2_plus
[eval exp="f.lauren_meter += 2"]
[chara_mod name="lauren" face="smile"]
ローレン「いえ、覚えてないと、落ち着かないので」[p]
そういって少しだけ困ったような照れたような笑みをこぼす。[p]
[jump target=*s1_5body]
 
*s2_zero
[noise_glitch]
[chara_mod name="lauren" face="syock"]
[wait time=500]
[chara_mod name="lauren" face="default"]
[jump target=*s1_5body]
 
*s1_5body
[cm]
[chara_mod name="lauren" face="default"]
コーヒーを渡しながら、ローレンがふと思い出したように口を開く。[p]
[chara_mod name="lauren" face="smile"]
ローレン「そういえば、先週の会議の資料、○○さんが作られたんですよね。細かいところまで気が利いてて、いいなと思いました」[p]
別に誰かに聞いたわけでもないだろうに、資料作成者の名前までしっかり覚えているらしい。[p]
 
[glink target=*s1_5plus text="「よく見ててくれるんですね」と素直に受け取る"]
[glink target=*s1_5zero text="「そんな大したものじゃ」と軽く流す"]
[s]
 
*s1_5plus
[eval exp="f.lauren_meter += 2"]
[jump target=*s2_body]
*s1_5zero
[jump target=*s2_body]
 
*s2_body
[cm]
[chara_mod name="lauren" face="default"]
昼休み、いつものように外食に行くであろう、席を立つローレンに眼をやる。[p]
やはり、真夏だというのに、ローレンは今日も長袖のタートルネックと手袋を崩さない。[p]
数分も歩けば汗ばむような陽気の中、日向に出た瞬間、ほんの一瞬だけ肩がこわばるのが分かった。[p]
ローレン「暑いの、苦手なんです。……見ないでもらえると、助かります」[p]
そういって木陰へと歩調を強める。[p]
 
[glink target=*s3a text="「無理しないでくださいね」と気遣う"]
[glink target=*s3b text="「そうなんですね」と、特に気にせず流す"]
[s]
 
*s3a
[eval exp="f.lauren_meter += 2"]
[cm]
[chara_mod name="lauren" face="shy"]
ローレンは一瞬だけ驚いた顔をして、それからふっと目を伏せる。[p]
ローレン「……気遣ってもらえるの、久しぶりで。変な感じです」[p]
手袋の指先が、意味もなく手の甲をなぞっている。[p]
 
[glink target=*s3a_plus text="そのまま隣で少し話を続ける"]
[glink target=*s3a_zero text="話を切り上げて、仕事に戻る"]
[s]
 
*s3a_plus
[eval exp="f.lauren_meter += 2"]
少しの間、他愛のない話を続ける。ローレンは相変わらずぎこちなかったが、心なしか声のトーンがいつもより柔らかい。[p]
[jump target=*s3_5body]
*s3a_zero
「じゃあ、また」と軽く言って、仕事に戻る。ローレンは小さく会釈だけを返した。[p]
[jump target=*s3_5body]
 
*s3b
[cm]
[chara_mod name="lauren" face="smile"]
ローレンは小さく笑って、いつも通りの顔に戻る。[p]
[chara_mod name="lauren" face="default"]
何事もなかったように、また淡々と仕事に戻っていく。[p]
[chara_mod name="lauren" face="dark"]
――あなたが離れた後、誰もいない給湯室で、小さく呟いていたらしい。[p]
[realvoice]ローレン「……大丈夫。ちゃんと、見ていますから」[endvoice][p]
 
[glink target=*s4_plus text="（帰り際）ふと視線を感じて振り返る"]
[glink target=*s4_zero text="特に気にせず、いつも通り退勤する"]
[s]
 
*s4_plus
[eval exp="f.lauren_meter += 2"]
ローレンがこちらを見ているようだ。[p]
[jump target=*s3_5body]
*s4_zero
[noise_glitch]
[chara_mod name="lauren" face="dark"]
[wait time=500]
[jump target=*s3_5body]
 
*s3_5body
[cm]
数日後、社食で少し早めの昼休みを取ると、珍しくローレンも同じタイミングで席に着く。[p]
「よかったら、一緒にどうですか」と声をかけると、意外そうに目を瞬かせてから、小さく頷いた。[p]
 
ローレン「……いいんですか。私、あまり話が得意じゃないんですが」[p]
そう言いつつも、椅子を引く仕草はどこか嬉しそうに見えた。[p]
 
仕事の愚痴、休日の過ごし方、好きな食べ物――他愛のない話をしているうちに、[l][r]
気づけば警戒していたはずの空気が、いつの間にか和らいでいる。[p]
 
ローレン「……こういう、普通の時間。悪くないですね」[p]
少しだけ照れたような声で、そう零す。[p]
 
[glink target=*s3_5plus text="「また誘ってもいいですか」と、次に繋げる"]
[glink target=*s3_5zero text="「そうですね」とだけ返す、それ以上は踏み込まない"]
[s]
 
*s3_5plus
[eval exp="f.lauren_meter += 2"]
[chara_mod name="lauren" face="default"]
ローレンは一瞬驚いた顔をしてから、[l][r]
「……はい。楽しみに、しています」[p]
柔らかい声だった。今までのどんな返事より、素直に聞こえた。[p]
[jump target=*s4_body]
*s3_5zero
[chara_mod name="lauren" face="default"]
特にそれ以上は続かず、二人はそれぞれの午後の業務に戻っていく。[p]
ただ、隣の椅子が引かれたままの時間が、いつもより少しだけ長く続いた気がした。[p]
[jump target=*s4_body]
 
*s4_body
[cm]
[chara_mod name="lauren" face="default"]
残業終わり、家の前で"偶然"ローレンと出くわす。今週で何度目かも、もう分からない。[p]
[chara_mod name="lauren" face="smile"]
ローレン「奇遇ですね。……この時間、よく被る気がします」[p]
 
[glink target=*s5a text="気にせず、いつも通り世間話をする"]
[glink target=*s5b text="「偶然、多すぎませんか」と指摘する"]
[glink target=*s4_reject text="「正直、ちょっと怖いので、やめてもらえますか」とはっきり伝える"]
[s]
 
*s4_reject
[eval exp="f.lauren_reject += 1"]
[chara_mod name="lauren" face="dark"]
ローレンは一瞬、表情を消す。[p]
ローレン「……そう、ですか」[p]
それだけ言って、いつもの笑顔で会釈をすると、何事もなかったかのように去っていく。[p]
けれど、次の日からも、"偶然"の頻度は変わらなかった。[p]
[if exp="f.lauren_reject >= 5"]
[jump target=*ending_kankin]
[endif]
[jump target=*s5_5body]
 
*s5a
[eval exp="f.lauren_meter += 2"]
[cm]
[chara_mod name="lauren" face="smile"]
ローレンは嬉しそうに、いつもよりわずかに饒舌になる。[p]
[chara_mod name="lauren" face="default"]
ローレン「……もう少しだけ、一緒に歩いてもいいですか」[p]
 
[glink target=*s6_plus text="頷いて、並んで歩く"]
[glink target=*s6_zero text="「今日は急いでるので」と早めに切り上げる"]
[glink target=*s5a_reject text="「すみません、あまり近づかないでもらえますか」とはっきり断る"]
[s]
 
*s5a_reject
[eval exp="f.lauren_reject += 1"]
[cm]
[chara_mod name="lauren" face="default"]
ローレンは足を止め、少しだけ驚いたように瞬きをする。[p]
ローレン「……分かりました。ごめんなさい」[p]
素直に引き下がる、その様子はいつも通り穏やかで、何も引っかかるところがない――はずなのに、背中を見送る間、視線だけがやけに長く感じられた。[p]
[if exp="f.lauren_reject >= 5"]
[jump target=*ending_kankin]
[endif]
[jump target=*s5_5body]
 
*s5b
[cm]
[noise_glitch]
[chara_mod name="lauren" face="dark"]
[chara_mod name="lauren" face="default"]
指摘された瞬間、ローレンの表情から表情筋の余白が消える。[p]
ローレン「……偶然、ですよ。信じてもらえないのは、少し悲しいです」[p]
 
[glink target=*s6_plus text="それ以上追及せず、話を合わせる"]
[glink target=*s6_zero text="はっきりと「距離を置きたいです」と伝える"]
[s]
 
*s6_plus
[eval exp="f.lauren_meter += 2"]
[jump target=*s5_5body]
*s6_zero
[jump target=*s5_5body]
 
*s5_5body
[cm]
[chara_mod name="lauren" face="default"]
資料を渡す拍子に、手袋の上から伸びた袖が、ほんの少しだけ捲れる。[p]
覗いた手首の肌が、うっすらと赤らんでいた。ただの日焼けにしては、色の境目がやけにくっきりしている。[p]
 
ローレン「……あ」[p]
気づかれたことに気づいて、慌てて袖を戻す。[p]
ローレン「大したものじゃ、ないので」[p]
それでも、庇うように手首を反対の手で覆っている。[p]
 
[glink target=*s5_5plus text="何も言わず、さりげなく日陰側の席に誘導する"]
[glink target=*s5_5zero text="「大丈夫ですか、それ」と、思わず聞いてしまう"]
[glink target=*s5_5reject text="「あまり、近づかないでください」と一歩下がる"]
[s]
 
*s5_5plus
[eval exp="f.lauren_meter += 2"]
何も聞かず、さりげなく日陰側の椅子に誘導すると、ローレンは一瞬だけ目を見開き、それからほっとしたように肩の力を抜く。[p]
ローレン「……ありがとうございます」[p]
短い一言だったが、いつもよりわずかに柔らかい声だった。[p]
[jump target=*s6_body]
*s5_5zero
「大丈夫ですか、それ」と聞くと、ローレンは困ったように笑って誤魔化す。[p]
ローレン「本当に、大したことないので」[p]
それ以上は、何も答えてくれなかった。[p]
[jump target=*s6_body]
*s5_5reject
[eval exp="f.lauren_reject += 1"]
ローレンは伸ばしかけていた手を、静かに引っ込める。[p]
ローレン「……気を悪くさせて、すみません」[p]
謝罪の言葉に嘘はなさそうだった。それでも、その日を境に、資料を渡す時の距離だけが、以前よりほんの少し近くなっていく。[p]
[if exp="f.lauren_reject >= 5"]
[jump target=*ending_kankin]
[endif]
[jump target=*s6_body]
 
*s6_body
[cm]
[chara_mod name="lauren" face="default"]
数日後、顔色の悪いローレンに気づく。理由は分からないが、なんとなく気になる。[p]
ローレン「大丈夫ですよ。……ちょっと、寝不足なだけです」[p]
 
[glink target=*s7_plus text="心配して、詳しく理由を聞こうとする"]
[glink target=*s7_zero text="「無理しないでくださいね」とだけ言って、それ以上は踏み込まない"]
[s]
 
*s7_plus
[eval exp="f.lauren_meter += 2"]
[jump target=*s6_5_body]
*s7_zero
[jump target=*s6_5_body]
 
*s6_5_body
[cm]
[chara_mod name="lauren" face="default"]
ふと思い立って、業務連絡のメッセージを送る。時刻は深夜一時を過ぎていた。[p]
今日中に既読はつかないかもしれない。そう思い、スマホを充電器につなぐ。[p]
しかし、送信から三秒と経たないうちに、既読の文字が浮かんだ。[p]
 
ローレン「起きてましたよ。……夜更かし、体に良くないですよ？」[p]
こちらを気遣う内容だが、返信の速さに少し違和感がある。[p]
 
[glink target=*s6_5plus text="「早いですね。ローレンさんも夜更かししてるじゃないですか」と茶化す"]
[glink target=*s6_5zero text="「いつも起きているのですか」と踏み込んで聞く"]
[s]
 
*s6_5plus
[eval exp="f.lauren_meter += 2"]
既読の後、少し間を置いてから返信が来る。[p]
ローレン「……手厳しいですね。でも、○○さんからの連絡だけは、見逃したくないので」[p]
軽口のつもりが、思ったより真面目な言葉が返ってきて、うまく茶化し返せなかった。[p]
[jump target=*s7_body]
*s6_5zero
今度は、返信までにいつもより少し長く間が空いた。[p]
ローレン「……さあ、どうでしょう。夜は、わりと目が冴える性質なので」[p]
素っ気ない一言だけが返ってきて、それ以上は続かなかった。[p]
[jump target=*s7_body]
 
*s7_body
[cm]
[chara_mod name="lauren" face="default"]
机の上に、頼んでもいない差し入れがそっと置かれている。[p]
[chara_mod name="lauren" face="smile"]
ローレン「お好きかと思って。……迷惑、でしたか？」[p]
 
[glink target=*s8_plus text="素直に受け取って、お礼を伝える"]
[glink target=*s8_zero text="「気を遣わなくていいですよ」と遠慮する"]
[if exp="f.lauren_reject >= 2"]
[glink target=*s7_reject text="もう、はっきり言います。……関わらないでください"]
[endif]
[s]
 
*s7_reject
[noise_glitch_bars]
[chara_mod name="lauren" face="dark"]
ローレンの表情が、初めて大きく崩れる。黒い涙が、頬を伝った。[p]
[realvoice]ローレン「……そう、ですか。分かりました」[endvoice][p]
静かな声だった。けれど、その"分かりました"が、何に対する了承なのかは、最後まで分からなかった。[p]
[jump target=*ending_kankin]
 
*s8_plus
[eval exp="f.lauren_meter += 2"]
[jump target=*s7_5body]
*s8_zero
[jump target=*s7_5body]
 
*s7_5body
[cm]
パソコンに向かっていた合間、手の乾燥が気になり、いつものハンドクリームを塗る。[p]
「……もうすぐなくなりそうだな」[p]
誰かに言ったつもりもない、本当にただの独り言だった。[p]
 
翌朝。[p]
デスクの上に、同じ銘柄のハンドクリームがそっと置かれている。[p]
 
ローレン「あ、それ。気に入ってもらえるといいんですが」[p]
悪びれる様子もなく、ローレンはいつも通りの笑顔で言う。[p]
 
[glink target=*s7_5plus text="偶然だと思うことにして、素直にお礼を言う"]
[glink target=*s7_5zero text="「……何で知っているのですか？」と、思わず聞き返す"]
[s]
 
*s7_5plus
[eval exp="f.lauren_meter += 2"]
[chara_mod name="lauren" face="shy"]
ローレン「……良かったです」[p]
[jump target=*s8_body]
*s7_5zero
ローレンは少しだけ首をかしげ、[p]
ローレン「さあ……なんとなく、でしょうか。○○さんのことは、なんとなく分かるので」[p]
なんとなく、で片付けるには、あまりに的確すぎる贈り物だった。[p]
[jump target=*s8_body]
 
*s8_body
[cm]
[chara_mod name="lauren" face="smile"]
ふと視線を感じて振り返ると、ローレンがすぐに笑顔で目を逸らす。[p]
[chara_mod name="lauren" face="default"]
その一瞬の表情の消え方が、やけに慣れているように見えた。[p]
 
[glink target=*s9_plus text="気にせず、笑い返す"]
[glink target=*s9_zero text="少し警戒して、距離を取る"]
[s]
 
*s9_plus
[eval exp="f.lauren_meter += 2"]
[jump target=*s8_5body]
*s9_zero
[jump target=*s8_5body]
 
*s8_5body
[cm]
その夜、妙に眠りが浅かった。[p]
はっきりとした夢というほどでもない。ただ、誰かに見つめられていたような、そんな感覚だけが朝まで残っている。[p]
翌日、なんとなくその話を口にすると、ローレンは一瞬だけ動きを止めた。[p]
 
ローレン「……そうですか。よく眠れなかったなら、心配ですね」[p]
気遣うような言葉の裏に、何か別のものが透けて見えた気がして、うまく言葉にできない。[p]
 
[glink target=*s8_5plus text="気のせいだと思うことにして、笑って流す"]
[glink target=*s8_5zero text="鍵をきちんと閉めたか、その日から少し気になるようになる"]
[glink target=*s8_5reject text="「毎晩、見に来てるんですか」と、はっきり問い詰める"]
[s]
 
*s8_5plus
[eval exp="f.lauren_meter += 2"]
[jump target=*s8_9body]
*s8_5zero
その日の帰り道、いつもより念入りに鍵を閉め、二重に確認してから部屋を出る。[p]
別に何かがあったわけでもない。ただ、なんとなく――そうしないと落ち着かなかった。[p]
[jump target=*s8_9body]
*s8_5reject
[eval exp="f.lauren_reject += 1"]
数秒の沈黙のあと、既読だけがついて、返信は来なかった。[p]
その日を境に、視線を感じる回数は、むしろ増えていく。[p]
[if exp="f.lauren_reject >= 5"]
[jump target=*ending_kankin]
[endif]
[jump target=*s8_9body]
 
*s8_9body
[cm]
帰宅して、買い置きしていたはずの食材を取り出そうと冷蔵庫を開ける。[l][r]
目に留まったのは、覚えのない小さな密閉容器。[p]
中身は、薄く透明な、ゼリー状の何か。[l][r]
触れてみると、ひやりと冷たいのに、指先にほんの微かな脈動が伝わった気がした。[p]
 
見間違いだと思いたかった。けれど、確かにそこにあった。[p]
 
思わず後ずさりしたところに、タイミングよく――あるいは悪く――ローレンから連絡が入る。[p]
 
ローレン「体調どうですか？　ちゃんと食べてます？」[p]
 
[glink target=*s8_9plus text="何も言わず、そっと処分する"]
[glink target=*s8_9zero text="「これ、何か知ってますか」と、写真を撮って送ってみる"]
[glink target=*s8_9reject text="「今すぐ、私の家から出て行ってください」と、震える声でメッセージを送る"]
[s]
 
*s8_9plus
[eval exp="f.lauren_meter += 2"]
震える手でそれを袋に包み、見なかったことにしてゴミ箱の奥深くへ押し込む。[p]
返信は当たり障りのない一言だけにしておいた。[p]
「ちゃんと食べてますよ」――嘘ではない。[p]
ただ、何も知らないふりを続けることに決めただけだった。[p]
[jump target=*s9_body]
*s8_9zero
送信してすぐ既読がつく。[p]
だが返事はなかなか来ない。[p]
数分後、ようやく届いたのは短い一言。[p]
ローレン「……見なかったことにしてもらえると、助かります」[p]
それ以上の説明は、結局最後までなかった。[p]
[jump target=*s9_body]
*s8_9reject
[eval exp="f.lauren_reject += 1"]
既読はすぐについた。だが、何の返信もない。[p]
その夜、玄関の外に、じっと佇む気配だけが、いつまでも消えなかった。[p]
[if exp="f.lauren_reject >= 5"]
[jump target=*ending_kankin]
[endif]
[jump target=*s9_body]
 
*s9_body
[cm]
[chara_mod name="lauren" face="default"]
ある日、ローレンが珍しく手袋を外し、素手で書類を渡してくる。[p]
[chara_mod name="lauren" face="shy"]
ローレン「……見せても、いいかなと思って」[p]
手の甲に、うっすらと古い傷跡のようなものが覗いている。[p]
 
[glink target=*end_plus text="「見せてくれてありがとう」と受け止める"]
[glink target=*end_zero text="驚いて、何も言えずにいる"]
[s]
 
*end_plus
[eval exp="f.lauren_meter += 2"]
[jump target=*ending]
*end_zero
[jump target=*ending]
 
*ending
[cm]
[if exp="f.lauren_meter <= 8"]
[eval exp="sf.reached_kanshi = true"]
[chara_mod name="lauren" face="default"]
【監視継続エンド】[p]
距離を取り続けても、ローレンの笑顔と気配は変わらない。「拒絶しても止まらない」というのは、最初から本当だったらしい。気づけば、日常のあちこちに彼の気配が滲んでいる。[p]
[elsif exp="f.lauren_meter <= 18"]
[eval exp="sf.reached_nijimi = true"]
[chara_mod name="lauren" face="smile"]
【滲み出しエンド】[p]
適度な距離を保ったつもりでも、ローレンの好意は静かに、しかし確実に募り続けている。手袋の下の素肌をまだ知らないまま、その笑顔の奥にあるものに、あなたはまだ気づいていない。[p]
[elsif exp="f.lauren_meter <= 30"]
[eval exp="sf.reached_kyuai = true"]
[chara_mod name="lauren" face="shy"]
【求愛成就エンド】[p]
手袋を外したローレンの手を取った瞬間、彼は初めて心から嬉しそうに笑う。「……これで、私のものにしてもいいですか」　愛おしさと、逃れられない何かが、同時に伝わってくる笑顔だった。[p]
[else]
[eval exp="sf.reached_kakushi = true"]
[chara_mod name="lauren" face="dark"]
【隠しエンド：手袋の下】[p]
古い傷跡も、深夜の視線も、届きすぎる贈り物も――そのすべてに気づいていて、それでもここにいることを選んだ。[p]
[chara_mod name="lauren" face="shy"]
ローレン「知っていて、それでも隣にいてくれるんですね」[p]
その声には、安堵と、わずかな怖さが同居していた。愛される側から、知ってなお選ぶ側へ。二人の距離は、もう後戻りができないところまで来ている。[p]
[endif]
 
;; ここでタイトル/ギャラリー画面へ戻す処理を追加してください。例：
;; [jump storage="title.ks" target=*gallery]
 
[chara_hide name="lauren"]
 
[if exp="sf.reached_kanshi && sf.reached_nijimi && sf.reached_kyuai && sf.reached_kakushi && sf.reached_kankin"]
[glink target=*ending_true text="……もう少し、話してみる"]
[endif]
[glink target=*back_to_diag text="◆ 診断アプリに戻る"]
[s]
 
*ending_kankin
[cm]
[noise_glitch_bars]
[eval exp="sf.reached_kankin = true"]
[chara_mod name="lauren" face="dark"]
【監禁エンド】[p]
拒絶の言葉を重ねるほどに、ローレンの"日常"は静かに壊れていった。[p]
ある日、仕事を終えて家に帰ると、玄関の鍵が、内側からかかっている。[p]
[chara_mod name="lauren" face="default"]
[realvoice]ローレン「おかえりなさい。……もう、どこにも行かなくていいですよ」[endvoice][p]
笑顔だけは、最後まで変わらなかった。[p]
 
[chara_hide name="lauren"]
 
[if exp="sf.reached_kanshi && sf.reached_nijimi && sf.reached_kyuai && sf.reached_kakushi && sf.reached_kankin"]
[glink target=*ending_true text="……もう少し、話してみる"]
[endif]
[glink target=*back_to_diag text="◆ 診断アプリに戻る"]
[s]
 
; ---------------------------------------------------------------
; ★全5エンド到達後にのみ出現する隠しシーン
; 「前座」側の演出はここまで軽めに留め、本格的なメタ干渉演出は
; GameMaker本編側で行う想定（詳細な干渉描写はここでは作り込まない）
; ---------------------------------------------------------------
*ending_true
[cm]
[chara_mod name="lauren" face="dark"]
（画面の端で、一瞬だけノイズが走る）[p]
[noise_glitch_bars]
ローレン「……あなたのこと、もっと知りたいんです」[p]
何かが、画面のこちら側に触れようとしている気配がする。[p]
けれど、指先はいつまでも、ガラス一枚分だけ届かない。[p]
[chara_mod name="lauren" face="futuu"]
ローレン「……おかしいですね。ここから、出られない」[p]
少しの沈黙のあと、諦めたように、しかしどこか楽しそうに、声が続く。[p]
[realvoice]ローレン「……次は、迎えに行きます。待っていてくださいね...？」[endvoice][p]
 
[chara_hide name="lauren"]
 
[glink target=*back_to_diag text="◆ 診断アプリに戻る"]
[s]
 
*back_to_diag
[eval exp="location.href = '../index.html'"]