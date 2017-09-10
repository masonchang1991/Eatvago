# Eatvago<img src="https://github.com/masonchang1991/Eatvago/blob/main/iTunesArtwork%402x.png" width = "50" height = "50" alt="Eatvago" align=center />

## 簡介 
讓使用者能快速知道附近有什麼餐廳，並提供隨機的方式幫助使用者快速決定吃什麼，也能透過配對機制找到飯友。
App Store: https://itunes.apple.com/us/app/eatvago/id1273533366

＊ 串接 Google Map API取得附近店家資訊 <br/>
＊ 呼叫 Google Map 進行導航 <br/>
＊ 使用 Core Location 判斷使用者位置 <br/>
＊ 使用 Firebase 作為後端資料庫 <br/>
＊ 使用 Swiftlint 管理code的撰寫 <br/>
＊ 使用 Firebase Analytics 跟 Fabric Crashlytics <br/>

Note: 如果要下載專案，請自行申請 Google MAP API 金鑰，並在依照 AppDelegate 使用的參數名稱加入金鑰的值。 <br/> 
      另外請自行下載 Firebase 的 GoogleService-Info.plist。

## 畫面截圖


### 登入畫面

需要註冊帳號與信箱認證才可以登入(因為內有與陌生人配對的功能，故設定需要信箱認證)

<img src="https://github.com/masonchang1991/Eatvago/blob/main/loginScreen.png" width = "375" height = "667" alt="Eatvago" align=center />


### 鄰近使用者附近店家畫面

根據使用者位置找到鄰近的餐廳，並提供店家的相關資訊以及距離，也提供導航與加入我的最愛List的功能。
也能設定使用者頭像以及搜尋條件。

<img src="https://github.com/masonchang1991/Eatvago/blob/main/nearbyViewcontroller%20screen.png" width = "375" height = "667" align=center />                    <img src="https://github.com/masonchang1991/Eatvago/blob/main/nearbySetupFilterScreen.png" width = "375" height = "667" align=center />
