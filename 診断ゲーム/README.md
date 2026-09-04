# ティラノスクリプト連携メモ

## 前提
ティラノスクリプト本体（エンジン）はすでにお持ちとのことなので、
「まっさらなティラノスクリプトのプロジェクト」に、今回作った
`lauren_route.ks` / `mike_route.ks` の2ファイルをそのまま追加する形を
想定しています。

## フォルダ構成（一般的な標準構成）

```
あなたのプロジェクト/
├── index.html              ← 起動用（テンプレートのまま）
├── tyrano/                 ← エンジン本体（ダウンロードしたまま置くフォルダ）
├── data/
│   ├── scenario/
│   │   ├── first.ks        ← 起動時に最初に読まれるファイル
│   │   ├── title.ks        ← タイトル・キャラ選択画面（あれば）
│   │   ├── lauren_route.ks ← 今回渡したファイル①
│   │   ├── mike_route.ks   ← 今回渡したファイル②
│   │   └── ...（他キャラを増やす時はここに追加）
│   ├── fgimage/            ← 立ち絵（キャラ画像）を置く場所
│   │   ├── lauren_normal.png
│   │   ├── lauren_smile.png
│   │   ├── lauren_shy.png
│   │   ├── lauren_dark.png
│   │   ├── mike_normal.png
│   │   ├── mike_surprised.png
│   │   └── mike_shy.png
│   ├── bgimage/            ← 背景画像
│   ├── bgm/ , sound/       ← 音声関連
│   └── system/             ← エンジンの設定ファイル一式（自動生成される）
```

## 命名ルール（今回のファイルが前提にしているもの）

- 画像ファイル名は `キャラID_表情.png` で統一しています
  （例：`lauren_smile.png`）。この名前で `data/fgimage/` に置けば
  そのまま動くはずです。ファイル名を変えたい場合は、`.ks`ファイル内の
  `[chara_new]` / `[chara_face]` の `storage="..."` を書き換えてください。
- 好感度（隠しメーター）は `f.lauren_meter` / `f.mike_meter` という
  変数名にしています。`f.` はセーブデータに残る変数です。

## 動かし方（お試し用の最短ルート）

タイトル画面がまだ無い場合は、`data/scenario/first.ks` の中身を
いったん以下のようにすると、起動して即ローレンのルートが始まります。

```
[jump storage="lauren_route.ks" target=*lauren_start]
```

ミケの方を試したい場合は `mike_route.ks` / `*mike_start` に変えてください。

## 選択肢・分岐・エンディングの仕組み

- `[glink target=*ラベル text="選択肢の文言"]` を選択肢の数だけ並べて、
  最後に `[s]`（進行を止める）を書く、という形になっています。
- 選択によって `f.lauren_meter` に2点ずつ加算し、9シーン分の選択が
  終わったところ（`*ending`）で、その合計点数によって
  `[if]` / `[elsif]` / `[else]` でエンディングを出し分けています。
- 表情の切り替えは `[chara_mod name="lauren" face="smile"]` のように、
  セリフの前に1行足すだけです。増やしたい表情があれば、冒頭の
  `[chara_face name="lauren" face="◯◯" storage="◯◯.png"]` を
  1行追加するだけで使えるようになります。

## 注意点（正直なところ）

タグの書き方は公式ドキュメント（[tyrano.jp](https://tyrano.jp/)、
[ティラノスクリプト完全に理解する](https://tyrano-complete.blogspot.com/)）
で確認した仕様に沿って書いていますが、実際にティラノスクリプトの
エンジン上で動かして確認することはこちらではできません。
動かしてみて崩れる箇所があれば、そのままエラーメッセージや
気になった挙動を教えてください。一緒に直していきます。
