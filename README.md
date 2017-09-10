# Eatvago<img src="https://github.com/masonchang1991/Eatvago/blob/main/iTunesArtwork%402x.png" width = "50" height = "50" alt="Eatvago" align=center />

## 簡介 
讓使用者能快速知道附近有什麼餐廳，並提供隨機的方式幫助使用者快速決定吃什麼，也能透過配對機制找到飯友。<br />
App Store: https://itunes.apple.com/us/app/eatvago/id1273533366

＊ 串接 Google Map API取得附近店家資訊 <br/>
＊ 呼叫 Google Map 進行導航 <br/>
＊ 使用 Core Location 判斷使用者位置 <br/>
＊ 使用 Firebase 作為後端資料庫 <br/>
＊ 使用 Swiftlint 管理code的撰寫 <br/>
＊ 使用 Firebase Analytics 跟 Fabric Crashlytics <br/>

### Note: 
      如果要下載專案，請自行申請 Google MAP API 金鑰，並在依照 AppDelegate 使用的參數名稱加入金鑰的值。
      另外請自行下載 Firebase 的 GoogleService-Info.plist。

## 畫面截圖


### 登入畫面

 - 需要註冊帳號與信箱認證才可以登入(因為內有與陌生人配對的功能，故設定需要信箱認證) <br />

<img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/loginScreen.png" width = "275" height = "500" alt="Eatvago" align=center />


### 鄰近使用者附近店家畫面

 - 根據使用者位置找到鄰近的餐廳，並提供店家的相關資訊以及距離，也提供導航與加入我的最愛List的功能。<br/>
 - 也能設定使用者頭像以及搜尋條件。<br/>

<img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/nearbyViewcontroller%20screen.png" width = "275" height = "500" align=center />                    <img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/nearbySetupFilterScreen.png" width = "275" height = "500" align=center />

### 提供使用者隨機選取畫面

 - 根據使用者現在位置附近的鄰近餐廳，提供使用者隨機選取的戳泡泡功能，幫助有選擇困難症的使用者快速決定要吃什麼。 <br/>
 - 使用者也能設定她想要的條件進行隨機選取（包含距離、餐廳類別、隨機的數量）。<br/>
 - 提供使用者導航功能 。 <br />

<img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/randomScreen.png" width = "275" height = "500" align=center />

### 提供使用者加入最愛List畫面

 - 使用者可以加入自己想去吃的餐廳選項。
 - 透過輪盤的旋轉提供隨機選取的功能，餐廳選到後可以使用導航功能。

<img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/FavoriteListScreen.png" width = "275" height = "500" align=center />

### 提供使用者找飯友畫面

 - 使用者若想與別人一起吃飯，可以透過找飯友機制與別人一起吃飯。 <br />
 - 使用者可以設定想吃飯的類型，與同樣類型的人一起吃飯。 <br />
 - 可以根據飯友的自我介紹決定是否要與他一起用餐。 <br />


<img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/preMatchScreen.png" width = "275" height = "500" align=center />    <img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/match%20screen.png" width = "275" height = "500" align=center />

### 與飯友的聊天室畫面

 - 根據使用者與飯友的位置，根據使用者選擇的餐廳類型搜尋在這兩個位置中間有的餐廳。 <br />
 - 使用者與飯友能相互聊天，共同決定要一起去哪裡吃飯。 <br />
 - 使用者可以透過導航知道該用什麼交通工具到達該地點。 <br />
 - 使用這與飯友可以將喜愛的餐廳加入共同的List中，讓對方知道自己想要去的餐廳是哪一家。 <br />

<img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/ChatScreen%20A%20first.PNG" width = "275" height = "500" align=center />    <img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/ChatScreen%20B.png" width = "275" height = "500" align=center />  <img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/ChatScreen%20A.PNG" width = "275" height = "500" align=center />

<br />

<img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/MapScreen.PNG" width = "275" height = "500" align=center />    <img src="https://github.com/masonchang1991/Eatvago/blob/main/Demo%20Screen%20Shot/ChatNavigationItem.png" width = "275" height = "500" align=center /> 
