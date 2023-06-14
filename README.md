# オセロゲーム

## 目次

1.  [セットアップ手順](#セットアップ手順)
1.  [アプリの詳細](#アプリの詳細)
1.  [今後の計画](#今後の計画)
1.  [リソース](#リソース)

## セットアップ手順

1.  ローカルへ clone を実施
1.  Xcodeで　clone　したファイルを開く
1.  [GhatGPT](https://platform.openai.com/account/api-keys)のAPI_KEYを取得する。
1.  `ContentView.swift`を開き、`"Authorization" : "Bearer API_KEY"`へ設定する。
1.  ビルドすれば、セットアップ完了

## アプリ詳細

### 目的

- 人と会話するようにChatGPTと会話が出来ることで人と会話しているかのように気軽に使う事が出来る。

### 基本仕様

- チャット風のやり取りが見れる
- テキスト入力欄は作らず、あくまで音声でやり取りする事が前提
- トップページに選択肢をもうけて、ChatGPTへ的確な返答が貰えるようにしている。
- ウィジェットを作成して、ホーム画面から即時アクセス出来るようにしている。

## 今後の計画

- 今は送ったメッセージに対しての反応しかしてもらえないので、以前のメッセージも含めたメッセージが貰えるようにする
- サーバーと通してChatGPTへアクセスするようにする事でAPI_KEYの切り替えなく、リクエスト出来るようにする

## リソース

- [SwiftUI](https://developer.apple.com/jp/xcode/swiftui/)
- [音声認識　ドキュメント](https://developer.apple.com/documentation/speech/sfspeechrecognizer)
