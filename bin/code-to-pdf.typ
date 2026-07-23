// コマンドラインで指定されたソースコードを印刷用 PDF にするテンプレート

#import "@preview/zebraw:0.6.3": *

#let target-file = sys.inputs.at("target", default: "")
#let lang-type = sys.inputs.at("lang", default: none)
#let syntax-file = sys.inputs.at("syntax", default: ())

#set page(
  paper: "a4",
  margin: (
    top: 11mm,
    rest: 7mm,
  ),
  header: context {
    let i = counter(page).get().first()
    let am = counter(page).final().first()
    set text(8pt, fill: luma(127))
    [File: #target-file #h(2em) Page: #i / #am]
  },
)

#columns(2, gutter: 2mm,
  // 読み込み実行
  if target-file != "" {
    // zebraw が文字を描画するため、set text はここで指定する
    set text(font: "Myrica M", size: 8pt)
    block(
      stroke: 0.5pt,
      clip: true,
      zebraw(
        numbering: false, // 行番号非表示
        lang: false,      // 言語タブ非表示
        //background-color: luma(250),
        background-color: white,
        raw(
          lang: lang-type,
          block: true,
          syntaxes: syntax-file,
          read(target-file).trim(at: end)
        )
      )
    )
  } else {
    [印刷対象のファイルが指定されていません。]
  }
)
