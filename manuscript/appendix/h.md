# 付録H Hotwire Native の最小アプリを起動する

この付録は WebView で Relay のログイン・一覧・詳細を開くための最小構成です。2026年10月9日に公式の Getting Started と照合しました。以下の Swift / Kotlin は構成例であり、本書の Web テストにネイティブの実機ビルドは含みません。署名付き実機配布やネイティブ認証連携まで完成したプロジェクトではありません。

## H.1 Rails と接続先

```bash
bin/rails server -b 0.0.0.0
```

| 実行先 | 開始 URL の例 |
| --- | --- |
| Mac の iOS Simulator | `http://localhost:3000` |
| Android Emulator | `http://10.0.2.2:3000` |
| 同じ LAN の実機 | `http://開発MacのLANアドレス:3000` |

実機の localhost は実機自身です。実機から Mac へ届くネットワークとファイアウォール設定を確認します。Rails の Host Authorization で拒否された場合は、開発環境で使うホストを `config.hosts` に明示します。最初に実機のブラウザでアクセスできることを確認します。

## H.2 iOS

Xcode の新規 iOS App で Swift / Storyboard を選びます。Package Dependencies に `https://github.com/hotwired/hotwire-native-ios` を追加してアプリのターゲットへ組み込みます。解決された版は `Package.resolved` に保存してください。

`SceneDelegate.swift` を次の形にします。

```swift
import UIKit
import HotwireNative

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let navigator = Navigator(configuration: .init(
        name: "relay",
        startLocation: URL(string: "http://localhost:3000")!
    ))

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        window?.rootViewController = navigator.rootViewController
        navigator.start()
    }
}
```

ローカル HTTP を使う Debug 構成では、Info.plist の `NSAppTransportSecurity` 内に `NSAllowsLocalNetworking` を Boolean の YES で設定します。実機の LAN 接続で求められる場合は `NSLocalNetworkUsageDescription` に開発サーバーへ接続する理由を設定します。製品版のサーバーは HTTPS にし、開発用の広い HTTP 例外を持ち込みません。

Simulator を選び Product → Run で起動し、Relay の Web ログインを使います。[iOS Getting Started](https://native.hotwired.dev/ios/getting-started) はプロジェクトの作成から掲載しています。

## H.3 Android

Android Studio の Empty Views Activity を選び、minimum SDK は API 28 以上、言語は Kotlin とします。アプリの `build.gradle.kts` に次を追加します。ここでは [1.3.1](https://github.com/hotwired/hotwire-native-android/releases/tag/1.3.1) に固定します。動的な `+` は使いません。

```kotlin
val hotwireVersion = "1.3.1"
dependencies {
    implementation("dev.hotwire:core:$hotwireVersion")
    implementation("dev.hotwire:navigation-fragments:$hotwireVersion")
}
```

`AndroidManifest.xml` の manifest 直下へ INTERNET 権限を追加します。

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

ローカル HTTP の許可は `src/debug/AndroidManifest.xml` に限定します。

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <application android:usesCleartextTraffic="true" />
</manifest>
```

`res/layout/activity_main.xml`:

```xml
<androidx.fragment.app.FragmentContainerView
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:id="@+id/main_nav_host"
    android:name="dev.hotwire.navigation.navigator.NavigatorHost"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    app:defaultNavHost="false" />
```

`MainActivity.kt`（package は作成したアプリに合わせます）:

```kotlin
package com.example.relay

import android.os.Bundle
import android.view.View
import androidx.activity.enableEdgeToEdge
import dev.hotwire.navigation.activities.HotwireActivity
import dev.hotwire.navigation.navigator.NavigatorConfiguration
import dev.hotwire.navigation.util.applyDefaultImeWindowInsets

class MainActivity : HotwireActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        findViewById<View>(R.id.main_nav_host).applyDefaultImeWindowInsets()
    }
    override fun navigatorConfigurations() = listOf(
        NavigatorConfiguration(
            name = "relay",
            startLocation = "http://10.0.2.2:3000",
            navigatorHostId = R.id.main_nav_host
        )
    )
}
```

Gradle Sync 後、Emulator を選んで Run します。[Android Getting Started](https://native.hotwired.dev/android/getting-started) と同じ最小構成です。依存版を選ぶ際には、そのリリースが必要とする Kotlin / Gradle / SDK も合わせて確認します。

## H.4 動作確認と次の拡張

1. WebView 内で `alice@example.com` / `password` でログインする。外部ブラウザのログイン cookie は自動共有されません。
2. タスクの詳細へ進み、ネイティブの戻る操作で一覧へ戻る。
3. 新規作成ページを直接開き、保存・エラー・ログアウトを確認する。
4. 通信を止めたときのエラー表示を確認する。

モーダルの Path Configuration は第33章の JSON を使います。ファイルを置くだけでは読み込まれません。導入した版の [iOS の設定読み込み](https://native.hotwired.dev/ios/path-configuration) または [Android の設定読み込み](https://native.hotwired.dev/android/path-configuration) に従って登録します。

Bridge を追加する場合は、[iOS Bridge Components](https://native.hotwired.dev/ios/bridge-components) / [Android Bridge Components](https://native.hotwired.dev/android/bridge-components) の登録手順まで実施します。Web の `static component` とネイティブの登録名を一致させます。ログインを独自ネイティブ画面へ移す場合のトークン交換は、この最小構成には含めません。
