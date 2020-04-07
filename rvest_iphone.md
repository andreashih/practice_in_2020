原本想試用 `rtweet` 搭配 `quanteda` 的日文斷詞功能整理 [twitter
上的武漢肺炎日文資料](https://andreashih.github.io/blog/journal/rtweet-quanteda.html)，但遲遲無法解決在
RStudio 上可以執行但不能輸出成 `.md` 檔的問題，因此先暫緩，回去複習一下
`rvest` 。剛好搭上 2020 新 iPhone 的潮流，決定來爬看看 Mobile01 上
iPhone 版的資料。

偶然發現一個好用的 [Chrome 外掛](https://selectorgadget.com/) 可以抓 CSS
selector

    library(rvest)

    ## Loading required package: xml2

    ## Warning: package 'xml2' was built under R version 3.6.3

    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

### 1. 先把資料爬下來

    #http://r3dmaotech.blogspot.com/2016/05/r-rvest.html  
    links <- paste0("https://www.mobile01.com/topiclist.php?f=383&p=", 1:30)
    data = c()
    for(i in 1:length(links)){
      url <- links[i]
      content <- read_html(url) %>% html_nodes(".u-ellipsis") %>% html_text()
      temp = iconv(content,'utf8')
      data = c(data, temp)
      ##sleep time  
      Sys.sleep(runif(1, 2, 4))
    }
    title <- data[seq(1, length(data), by = 3)]
    post_id <- data[seq(2, length(data), by = 3)]
    reply_id <- data[seq(3, length(data), by = 3)]
    head(title)

    ## [1] "兩指更神速! 10個iPhone、iPad雙指操作小技巧（秒選取必學）"
    ## [2] "iPhone的設計逼我跳槽安卓?"                               
    ## [3] "買iphone 11"                                             
    ## [4] "iPhone 9 (SE2)現身網購平台，通訊行也能買的到"            
    ## [5] "請問6s plus 32g 還是oppo r15 或vivo x23?"                
    ## [6] "[請益]iPhone 11的3D滿版保護貼與保護殼要怎選"

### 2. `jiebaR` 斷詞

    library(jiebaR)

    ## Loading required package: jiebaRD

    # Data: 3 篇文章
    #docs <- title3

    # Initialize jiebaR
    seg <- worker()

    docs_segged <- rep("", 3)
    for (i in seq_along(title)) {
      # Segment each element in docs
      segged <- segment(title[i], seg)

      # Collapse the character vector into a string, separated by space
      docs_segged[i] <- paste0(segged, collapse = " ")
    }

    head(docs_segged)

    ## [1] "兩指 更 神速 10 個 iPhone iPad 雙指 操作 小 技巧 秒 選取 必學"
    ## [2] "iPhone 的 設計 逼 我 跳槽 安卓"                               
    ## [3] "買 iphone 11"                                                 
    ## [4] "iPhone 9 SE2 現身 網購 平台 通訊 行 也 能 買 的 到"           
    ## [5] "請問 6 s plus 32 g 還是 oppo r15 或 vivo x23"                 
    ## [6] "請益 iPhone 11 的 3 D 滿版 保護 貼 與 保護 殼 要 怎選"

### 3. 用斷好詞的 title 建立 dataframe

    docs_df <- tibble::tibble(
      doc_id = seq_along(docs_segged),
      content = docs_segged
    )

    knitr::kable(docs_df, align = "c")

<table>
<thead>
<tr class="header">
<th style="text-align: center;">doc_id</th>
<th style="text-align: center;">content</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: center;">1</td>
<td style="text-align: center;">兩指 更 神速 10 個 iPhone iPad 雙指 操作 小 技巧 秒 選取 必學</td>
</tr>
<tr class="even">
<td style="text-align: center;">2</td>
<td style="text-align: center;">iPhone 的 設計 逼 我 跳槽 安卓</td>
</tr>
<tr class="odd">
<td style="text-align: center;">3</td>
<td style="text-align: center;">買 iphone 11</td>
</tr>
<tr class="even">
<td style="text-align: center;">4</td>
<td style="text-align: center;">iPhone 9 SE2 現身 網購 平台 通訊 行 也 能 買 的 到</td>
</tr>
<tr class="odd">
<td style="text-align: center;">5</td>
<td style="text-align: center;">請問 6 s plus 32 g 還是 oppo r15 或 vivo x23</td>
</tr>
<tr class="even">
<td style="text-align: center;">6</td>
<td style="text-align: center;">請益 iPhone 11 的 3 D 滿版 保護 貼 與 保護 殼 要 怎選</td>
</tr>
<tr class="odd">
<td style="text-align: center;">7</td>
<td style="text-align: center;">IPHONE 9 的 新聞 算是 假新聞 嗎 要 不要 罰錢 呀</td>
</tr>
<tr class="even">
<td style="text-align: center;">8</td>
<td style="text-align: center;">想 請問 怎麼樣 充電 的 方式 對 哀鳳 手機 是 好的</td>
</tr>
<tr class="odd">
<td style="text-align: center;">9</td>
<td style="text-align: center;">內建 悠遊 卡</td>
</tr>
<tr class="even">
<td style="text-align: center;">10</td>
<td style="text-align: center;">Lightning 數位 AV 轉接 想 請教 一下 好用嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">11</td>
<td style="text-align: center;">Facebook 開啟 雙重 認證 手機 泡水 後 無法 使用 雙重 認證 登入</td>
</tr>
<tr class="even">
<td style="text-align: center;">12</td>
<td style="text-align: center;">充電 頭</td>
</tr>
<tr class="odd">
<td style="text-align: center;">13</td>
<td style="text-align: center;">我 的 iphoneX face Id 無法 使用</td>
</tr>
<tr class="even">
<td style="text-align: center;">14</td>
<td style="text-align: center;">11 pro 重量 不 一樣</td>
</tr>
<tr class="odd">
<td style="text-align: center;">15</td>
<td style="text-align: center;">2020 iPhone SE2 模型 機 流出</td>
</tr>
<tr class="even">
<td style="text-align: center;">16</td>
<td style="text-align: center;">iPhone 鈴聲 好 難懂 6 種 困擾 解法 分享</td>
</tr>
<tr class="odd">
<td style="text-align: center;">17</td>
<td style="text-align: center;">iPhone12 最新 爆料 無 瀏海 屏</td>
</tr>
<tr class="even">
<td style="text-align: center;">18</td>
<td style="text-align: center;">iPhone 9 SE2 的 最新消息</td>
</tr>
<tr class="odd">
<td style="text-align: center;">19</td>
<td style="text-align: center;">Line 搜尋 功能 一直 讀取 中</td>
</tr>
<tr class="even">
<td style="text-align: center;">20</td>
<td style="text-align: center;">奉勸 各位 維修 手機 千萬別 到 神腦 去</td>
</tr>
<tr class="odd">
<td style="text-align: center;">21</td>
<td style="text-align: center;">iPhone 9 上架 中 有人 訂到 拿到 貨了嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">22</td>
<td style="text-align: center;">我 的 iPhone 上面 一直 有 一個 我 的 Mac 的 相簿 請問 要 怎樣才能 刪除 了 裡面 有 一千多 張 的 照片</td>
</tr>
<tr class="odd">
<td style="text-align: center;">23</td>
<td style="text-align: center;">I11 跟 11 pro 的 cp 值 那款 比較 好</td>
</tr>
<tr class="even">
<td style="text-align: center;">24</td>
<td style="text-align: center;">恢復 line 聊天記錄</td>
</tr>
<tr class="odd">
<td style="text-align: center;">25</td>
<td style="text-align: center;">看 影片 會 縮放 成全 螢幕 還是 一般 畫面</td>
</tr>
<tr class="even">
<td style="text-align: center;">26</td>
<td style="text-align: center;">2019 英國 iPhone 8 London Street Photography 均 有後 製</td>
</tr>
<tr class="odd">
<td style="text-align: center;">27</td>
<td style="text-align: center;">IPhone X 無法 分享 任何 東西</td>
</tr>
<tr class="even">
<td style="text-align: center;">28</td>
<td style="text-align: center;">輸入 太 多次 密碼 背鎖 螢幕 要 怎麼辦</td>
</tr>
<tr class="odd">
<td style="text-align: center;">29</td>
<td style="text-align: center;">閒聊 iOS 的 語音 朗讀 功能</td>
</tr>
<tr class="even">
<td style="text-align: center;">30</td>
<td style="text-align: center;">iOS 13.4.5 Developer Beta 1</td>
</tr>
<tr class="odd">
<td style="text-align: center;">31</td>
<td style="text-align: center;">深色 模式</td>
</tr>
<tr class="even">
<td style="text-align: center;">32</td>
<td style="text-align: center;">我頭 有點 暈</td>
</tr>
<tr class="odd">
<td style="text-align: center;">33</td>
<td style="text-align: center;">iPhone Apple Pay 的 北京 交通卡 設定 成 門禁卡</td>
</tr>
<tr class="even">
<td style="text-align: center;">34</td>
<td style="text-align: center;">跪求 犀牛 盾 生日 折扣 碼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">35</td>
<td style="text-align: center;">LINE 手動 刪除 對話 後 可以 恢復 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">36</td>
<td style="text-align: center;">我 的 iphone se 更新 無法 登入</td>
</tr>
<tr class="odd">
<td style="text-align: center;">37</td>
<td style="text-align: center;">網頁 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">38</td>
<td style="text-align: center;">開箱 bitplay 手機 殼 開箱</td>
</tr>
<tr class="odd">
<td style="text-align: center;">39</td>
<td style="text-align: center;">已 解決 air pod 如何 購買 applecare</td>
</tr>
<tr class="even">
<td style="text-align: center;">40</td>
<td style="text-align: center;">Apple watch 都 能 塞 esim 了 就 不能 給 iPod touch 一個 機會 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">41</td>
<td style="text-align: center;">電池 數也會 變動</td>
</tr>
<tr class="even">
<td style="text-align: center;">42</td>
<td style="text-align: center;">分享 功能 失效</td>
</tr>
<tr class="odd">
<td style="text-align: center;">43</td>
<td style="text-align: center;">11 還是 11 pro</td>
</tr>
<tr class="even">
<td style="text-align: center;">44</td>
<td style="text-align: center;">Apple watch 都 能 塞 esim 了 就 不能 給 iPod touch 一個 機會 嗎 此 主題 理性 討論區 被 黑 取暖 區 請 fz280 勿 入</td>
</tr>
<tr class="odd">
<td style="text-align: center;">45</td>
<td style="text-align: center;">iOS 13.4.5 Developer Beta</td>
</tr>
<tr class="even">
<td style="text-align: center;">46</td>
<td style="text-align: center;">iOS 13.4 iphone11 pro 更新 後 手機 有時 會 一片 黑</td>
</tr>
<tr class="odd">
<td style="text-align: center;">47</td>
<td style="text-align: center;">電池 健康 度 幾 才 算 該換</td>
</tr>
<tr class="even">
<td style="text-align: center;">48</td>
<td style="text-align: center;">從 舊款 的 hTC one 上 的 Line 要 轉移 至 iPhone 6 S 上 的 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">49</td>
<td style="text-align: center;">iphone11 鏡頭 白點 求解</td>
</tr>
<tr class="even">
<td style="text-align: center;">50</td>
<td style="text-align: center;">iPHONE11 拍照 分享 夜拍 好強</td>
</tr>
<tr class="odd">
<td style="text-align: center;">51</td>
<td style="text-align: center;">iOS13 4 功能 大 整理 觀望 要 不要 更新</td>
</tr>
<tr class="even">
<td style="text-align: center;">52</td>
<td style="text-align: center;">IPHONE XS MAX 有 辦法 當 門禁 感應 扣 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">53</td>
<td style="text-align: center;">iPhone X 還魂 維修 實記</td>
</tr>
<tr class="even">
<td style="text-align: center;">54</td>
<td style="text-align: center;">iphone 8 s 什麼 時候 要 上市</td>
</tr>
<tr class="odd">
<td style="text-align: center;">55</td>
<td style="text-align: center;">youtube 影片 跑 很慢</td>
</tr>
<tr class="even">
<td style="text-align: center;">56</td>
<td style="text-align: center;">iOS 13.4 更新 後 的 感想</td>
</tr>
<tr class="odd">
<td style="text-align: center;">57</td>
<td style="text-align: center;">NeuralCam</td>
</tr>
<tr class="even">
<td style="text-align: center;">58</td>
<td style="text-align: center;">iPhone11 奇怪 的 電流 聲</td>
</tr>
<tr class="odd">
<td style="text-align: center;">59</td>
<td style="text-align: center;">IOS13 4 SIRI 要 解鎖 才能 控制 設備</td>
</tr>
<tr class="even">
<td style="text-align: center;">60</td>
<td style="text-align: center;">iphone7 電池 更換 抉擇 推薦 店家</td>
</tr>
<tr class="odd">
<td style="text-align: center;">61</td>
<td style="text-align: center;">iPhone XS 借屍還魂 起死回生 記</td>
</tr>
<tr class="even">
<td style="text-align: center;">62</td>
<td style="text-align: center;">開啟 icloud 會 刪除 照片 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">63</td>
<td style="text-align: center;">iTunes 小額</td>
</tr>
<tr class="even">
<td style="text-align: center;">64</td>
<td style="text-align: center;">iPhone 11 Pro Max 搭配 的 藍芽 耳機 請問 有 好 的 建議 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">65</td>
<td style="text-align: center;">Xr 使用 控制中心 回覆 line 訊息 當機</td>
</tr>
<tr class="even">
<td style="text-align: center;">66</td>
<td style="text-align: center;">請教 iPhone6s 資料 轉移 iPhone11</td>
</tr>
<tr class="odd">
<td style="text-align: center;">67</td>
<td style="text-align: center;">解決 iPhone Line 無法 備份</td>
</tr>
<tr class="even">
<td style="text-align: center;">68</td>
<td style="text-align: center;">iphone 真的 慢 很多</td>
</tr>
<tr class="odd">
<td style="text-align: center;">69</td>
<td style="text-align: center;">ipone11 手機 影片 抓到 windows 無法 撥放</td>
</tr>
<tr class="even">
<td style="text-align: center;">70</td>
<td style="text-align: center;">iPhone 11 能 在 海裡 操作 手機 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">71</td>
<td style="text-align: center;">目前 的 iphone11 pro max 目前 還 手機 很 燙 的 問題 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">72</td>
<td style="text-align: center;">iPhone 11 Pro Max 快速 開啟 相機 畫面 會 變黑</td>
</tr>
<tr class="odd">
<td style="text-align: center;">73</td>
<td style="text-align: center;">IPHONE 黑屏 發燙 後 打不開</td>
</tr>
<tr class="even">
<td style="text-align: center;">74</td>
<td style="text-align: center;">13.4 版 播放 短片 有聲 無影 尋求 協助</td>
</tr>
<tr class="odd">
<td style="text-align: center;">75</td>
<td style="text-align: center;">心得 iTunes 被盜 刷 處理 經過</td>
</tr>
<tr class="even">
<td style="text-align: center;">76</td>
<td style="text-align: center;">Xs max 的 使用者 會 願意 花錢 升級成 i11 pro max 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">77</td>
<td style="text-align: center;">iPhone 多 年來 的 攝影集 均 有後 製</td>
</tr>
<tr class="even">
<td style="text-align: center;">78</td>
<td style="text-align: center;">lightening 轉 3.5 mm</td>
</tr>
<tr class="odd">
<td style="text-align: center;">79</td>
<td style="text-align: center;">iPhone 6 s Plus 跑 分</td>
</tr>
<tr class="even">
<td style="text-align: center;">80</td>
<td style="text-align: center;">更新 完 13.4 中間 有 黑點</td>
</tr>
<tr class="odd">
<td style="text-align: center;">81</td>
<td style="text-align: center;">iphone xr 鏡頭 有 問題 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">82</td>
<td style="text-align: center;">Itunes 更新 後 連不上 手機</td>
</tr>
<tr class="odd">
<td style="text-align: center;">83</td>
<td style="text-align: center;">請問 11 的 螢幕 比例 是 多少 18 9</td>
</tr>
<tr class="even">
<td style="text-align: center;">84</td>
<td style="text-align: center;">IPhone 11 藍寶石 保護 貼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">85</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">86</td>
<td style="text-align: center;">iPhone SE 是不是 不能 更新 了</td>
</tr>
<tr class="odd">
<td style="text-align: center;">87</td>
<td style="text-align: center;">iPhone 吉他 大 改裝 以前 的 iPhone 浪人 情歌</td>
</tr>
<tr class="even">
<td style="text-align: center;">88</td>
<td style="text-align: center;">更新 13.4 後 可退 13.3.1 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">89</td>
<td style="text-align: center;">ios13 4 正式版 4 G</td>
</tr>
<tr class="even">
<td style="text-align: center;">90</td>
<td style="text-align: center;">問 XS 螢幕 凸起 可以 當 陀螺 旋轉</td>
</tr>
<tr class="odd">
<td style="text-align: center;">91</td>
<td style="text-align: center;">購買 iphone11 的 一些 問題 想 請教</td>
</tr>
<tr class="even">
<td style="text-align: center;">92</td>
<td style="text-align: center;">XR 當機 頻率 變 很高</td>
</tr>
<tr class="odd">
<td style="text-align: center;">93</td>
<td style="text-align: center;">IOS 13.4 更新 來 了</td>
</tr>
<tr class="even">
<td style="text-align: center;">94</td>
<td style="text-align: center;">2020 新 iPhone 將採 少量 生產</td>
</tr>
<tr class="odd">
<td style="text-align: center;">95</td>
<td style="text-align: center;">終於 實現 指定 時間 關掉 飛航 自動化 執行 捷徑</td>
</tr>
<tr class="even">
<td style="text-align: center;">96</td>
<td style="text-align: center;">iphone7plus 鈴聲</td>
</tr>
<tr class="odd">
<td style="text-align: center;">97</td>
<td style="text-align: center;">iPhone 11 戴 口罩 自動 學習 Face ID 面容 解鎖</td>
</tr>
<tr class="even">
<td style="text-align: center;">98</td>
<td style="text-align: center;">請問 安桌換 蘋果 LINE</td>
</tr>
<tr class="odd">
<td style="text-align: center;">99</td>
<td style="text-align: center;">請問 如果 不 小心 在 itune 上 同步 音樂 通通 不見 有 辦法 救 的 回來 嗎 QQ</td>
</tr>
<tr class="even">
<td style="text-align: center;">100</td>
<td style="text-align: center;">iphone 怎麼 用 VPN</td>
</tr>
<tr class="odd">
<td style="text-align: center;">101</td>
<td style="text-align: center;">iPhone 照片 該 如何 海量 同步 跟 刪除</td>
</tr>
<tr class="even">
<td style="text-align: center;">102</td>
<td style="text-align: center;">從 iPhone 連線 回 電腦 硬碟 聽歌 的 方法</td>
</tr>
<tr class="odd">
<td style="text-align: center;">103</td>
<td style="text-align: center;">iPhoneX 匹配 藍芽 耳機 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">104</td>
<td style="text-align: center;">xs max 充電 及 基地 台 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">105</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">106</td>
<td style="text-align: center;">iphone 11 pro 發熱</td>
</tr>
<tr class="odd">
<td style="text-align: center;">107</td>
<td style="text-align: center;">iOS 13.4 12.4.6 更新</td>
</tr>
<tr class="even">
<td style="text-align: center;">108</td>
<td style="text-align: center;">13.4 正式版</td>
</tr>
<tr class="odd">
<td style="text-align: center;">109</td>
<td style="text-align: center;">2 手 iPhone6sp 入手 後 無法 更新</td>
</tr>
<tr class="even">
<td style="text-align: center;">110</td>
<td style="text-align: center;">請問 有 什麼 方法 能用 iphone 遠端 控制 ipad 呢</td>
</tr>
<tr class="odd">
<td style="text-align: center;">111</td>
<td style="text-align: center;">有 的 app 可以 背景 執行 有 的 又 不行</td>
</tr>
<tr class="even">
<td style="text-align: center;">112</td>
<td style="text-align: center;">第一次 充電 出現 傳輸線 接觸點 上潮 濕 不能 充 有人 遇過 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">113</td>
<td style="text-align: center;">line 爆掉 現在 又 好了</td>
</tr>
<tr class="even">
<td style="text-align: center;">114</td>
<td style="text-align: center;">大家 推薦 甚麼 手機 殼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">115</td>
<td style="text-align: center;">iPhone 如何 關閉 記事本 地址 開啟 地圖功能</td>
</tr>
<tr class="even">
<td style="text-align: center;">116</td>
<td style="text-align: center;">airpods pro 好 嗎 都 買不到 很 猶豫</td>
</tr>
<tr class="odd">
<td style="text-align: center;">117</td>
<td style="text-align: center;">iphone11 莫名 綠線</td>
</tr>
<tr class="even">
<td style="text-align: center;">118</td>
<td style="text-align: center;">iphone 11 pro 在 使用 2 x 焦段 鏡頭 切換 疑問 就算 是 按 2 x 好像 也 有 機會 會 變成 以主 鏡頭 放大 裁切 而 非 以長 焦 鏡頭 拍攝</td>
</tr>
<tr class="odd">
<td style="text-align: center;">119</td>
<td style="text-align: center;">原廠 的 lighting 轉 SD 讀卡機 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">120</td>
<td style="text-align: center;">IPHONE 11 PROMAX 在 聯絡人 時 畫面 跳動 無法 修改 資料</td>
</tr>
<tr class="odd">
<td style="text-align: center;">121</td>
<td style="text-align: center;">請問 IPHONE 如何 快速 開 定位 呢</td>
</tr>
<tr class="even">
<td style="text-align: center;">122</td>
<td style="text-align: center;">分享 鎖屏 用 ig 也 能 聽 YouTube 音樂 安 卓 也 適用 的 方法 推推</td>
</tr>
<tr class="odd">
<td style="text-align: center;">123</td>
<td style="text-align: center;">XS Face ID 摔機 加進 水 維修 實記</td>
</tr>
<tr class="even">
<td style="text-align: center;">124</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">125</td>
<td style="text-align: center;">iPhone 市占率 年 年 掉</td>
</tr>
<tr class="even">
<td style="text-align: center;">126</td>
<td style="text-align: center;">求助 請問 iPhone XS 支援 5 CA 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">127</td>
<td style="text-align: center;">iPhone 9 SE2 系列 的 銷售 關鍵點 雙卡 續航</td>
</tr>
<tr class="even">
<td style="text-align: center;">128</td>
<td style="text-align: center;">有人 遇過 iphone 11 觸控 不靈敏 的 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">129</td>
<td style="text-align: center;">在 什麼 情況 下 需要 出示 購買 證明</td>
</tr>
<tr class="even">
<td style="text-align: center;">130</td>
<td style="text-align: center;">已經 上市 快 一年 的 iphone XS 會 不會 烙印 呢</td>
</tr>
<tr class="odd">
<td style="text-align: center;">131</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">132</td>
<td style="text-align: center;">小 宅 開箱 iPhone 11 開箱 不 嫌 晚 隱藏 秘技 告訴 你</td>
</tr>
<tr class="odd">
<td style="text-align: center;">133</td>
<td style="text-align: center;">我 的 i7plus 的 watch 錶 面 圖庫 怎麼 比 i6s plus</td>
</tr>
<tr class="even">
<td style="text-align: center;">134</td>
<td style="text-align: center;">iOS 13.1.2 默默 支援 卡 1 能 讓 卡 2 連上 VoWiFi 功能 反之亦然 這 厲害 惹</td>
</tr>
<tr class="odd">
<td style="text-align: center;">135</td>
<td style="text-align: center;">LINE 有 條件 的 來電 不會 顯示</td>
</tr>
<tr class="even">
<td style="text-align: center;">136</td>
<td style="text-align: center;">徵求 犀牛 盾 3 月 禮金</td>
</tr>
<tr class="odd">
<td style="text-align: center;">137</td>
<td style="text-align: center;">iPhone 6 各種 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">138</td>
<td style="text-align: center;">怎麼 增加 自定義 鈴聲</td>
</tr>
<tr class="odd">
<td style="text-align: center;">139</td>
<td style="text-align: center;">轉貼 iPhone 12 的 A14 處理器 跑 分 曝光 工程版 已超 S865 一倍 有多</td>
</tr>
<tr class="even">
<td style="text-align: center;">140</td>
<td style="text-align: center;">有人 回 原廠 修過 iPhoneSE 的 home 鍵 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">141</td>
<td style="text-align: center;">重要 位置 歷程 紀錄 無法 清除</td>
</tr>
<tr class="even">
<td style="text-align: center;">142</td>
<td style="text-align: center;">iPhone XS 螢幕 偏黃</td>
</tr>
<tr class="odd">
<td style="text-align: center;">143</td>
<td style="text-align: center;">電腦 重灌 後 itunes 備份 找 不到</td>
</tr>
<tr class="even">
<td style="text-align: center;">144</td>
<td style="text-align: center;">iphoneX 及 iphone8 更新 IOS13 無法 分享 熱點</td>
</tr>
<tr class="odd">
<td style="text-align: center;">145</td>
<td style="text-align: center;">iPhone XS Max 長時間 閱讀 螢幕 主動 變暗</td>
</tr>
<tr class="even">
<td style="text-align: center;">146</td>
<td style="text-align: center;">iPhone 連接 電腦 的 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">147</td>
<td style="text-align: center;">iphone xs max 的 line 掃不出 筆電 的 line Qrcode</td>
</tr>
<tr class="even">
<td style="text-align: center;">148</td>
<td style="text-align: center;">手機 殼 幫 挑 gusha 手機 殼 跟 rhinoshield 犀牛 盾</td>
</tr>
<tr class="odd">
<td style="text-align: center;">149</td>
<td style="text-align: center;">iphone XR 加入 esim 卡 後 常常 沒 網路</td>
</tr>
<tr class="even">
<td style="text-align: center;">150</td>
<td style="text-align: center;">Iphone 11 256 G 遠傳 缺貨</td>
</tr>
<tr class="odd">
<td style="text-align: center;">151</td>
<td style="text-align: center;">iOS 13 13.1.1 熱點 失敗 無法 開啟 網頁 暫時 解法</td>
</tr>
<tr class="even">
<td style="text-align: center;">152</td>
<td style="text-align: center;">xs max 耳機 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">153</td>
<td style="text-align: center;">怎麼 清潔 iPhone 蘋果 官方 更新 消毒 說明</td>
</tr>
<tr class="even">
<td style="text-align: center;">154</td>
<td style="text-align: center;">iPhone 11 充電 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">155</td>
<td style="text-align: center;">在 菲律賓 官網 買 iphone</td>
</tr>
<tr class="even">
<td style="text-align: center;">156</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">157</td>
<td style="text-align: center;">iphone x 電池 膨脹 蓋 大樓</td>
</tr>
<tr class="even">
<td style="text-align: center;">158</td>
<td style="text-align: center;">iPhone 11 pro 無線 充電 真的 提升 了</td>
</tr>
<tr class="odd">
<td style="text-align: center;">159</td>
<td style="text-align: center;">iPhone X 使用 兩年 後 電池 狀態</td>
</tr>
<tr class="even">
<td style="text-align: center;">160</td>
<td style="text-align: center;">我 的 i7 沒有 carplay</td>
</tr>
<tr class="odd">
<td style="text-align: center;">161</td>
<td style="text-align: center;">Iphone11 連安博 無法 上網</td>
</tr>
<tr class="even">
<td style="text-align: center;">162</td>
<td style="text-align: center;">現在 買 7 plus 好 還是 8 plus</td>
</tr>
<tr class="odd">
<td style="text-align: center;">163</td>
<td style="text-align: center;">iOS 13.4 Beta3</td>
</tr>
<tr class="even">
<td style="text-align: center;">164</td>
<td style="text-align: center;">iPhone 7 傳說 對決</td>
</tr>
<tr class="odd">
<td style="text-align: center;">165</td>
<td style="text-align: center;">勿擾 模式 的 排程 設定</td>
</tr>
<tr class="even">
<td style="text-align: center;">166</td>
<td style="text-align: center;">iOS 13.4 Developer Beta 5 更新 囉</td>
</tr>
<tr class="odd">
<td style="text-align: center;">167</td>
<td style="text-align: center;">沒有 apple watch 可是 一直 跳出 配對</td>
</tr>
<tr class="even">
<td style="text-align: center;">168</td>
<td style="text-align: center;">Iphone 11 v s Iphone 11 pro</td>
</tr>
<tr class="odd">
<td style="text-align: center;">169</td>
<td style="text-align: center;">更新 apple id 設定 一直 失敗</td>
</tr>
<tr class="even">
<td style="text-align: center;">170</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">171</td>
<td style="text-align: center;">使用 無線 充電 手機 電量 卻 沒有 增加</td>
</tr>
<tr class="even">
<td style="text-align: center;">172</td>
<td style="text-align: center;">為 什麼 手機 會 突然 白 蘋果</td>
</tr>
<tr class="odd">
<td style="text-align: center;">173</td>
<td style="text-align: center;">開箱 以 專業 之姿 登場 iPhone 11 Pro 夜幕 綠 開箱 分享</td>
</tr>
<tr class="even">
<td style="text-align: center;">174</td>
<td style="text-align: center;">太樂芬 手機 殼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">175</td>
<td style="text-align: center;">今晚 一起 看 全程 口譯 直播 跟 小 惡魔 一起 倒數 Apple 秋季 新品 發表 會吧</td>
</tr>
<tr class="even">
<td style="text-align: center;">176</td>
<td style="text-align: center;">請問 如何 下載 相簿 呢</td>
</tr>
<tr class="odd">
<td style="text-align: center;">177</td>
<td style="text-align: center;">APPLE bitplay 攝影 手機 殼 腳架 藍芽 開關 開箱</td>
</tr>
<tr class="even">
<td style="text-align: center;">178</td>
<td style="text-align: center;">iPhone 如何 下載 檔案 來測 網速</td>
</tr>
<tr class="odd">
<td style="text-align: center;">179</td>
<td style="text-align: center;">iPhone 11 Pro Max 又 一 攝影 巨作 5 小時 19 分 全程 一鏡 到底 埃爾米 塔日 博物館</td>
</tr>
<tr class="even">
<td style="text-align: center;">180</td>
<td style="text-align: center;">就算 用 了 imos 2.5 D 還是 一堆 細 刮痕 on Max</td>
</tr>
<tr class="odd">
<td style="text-align: center;">181</td>
<td style="text-align: center;">iPhone 11 算不算 旗艦機</td>
</tr>
<tr class="even">
<td style="text-align: center;">182</td>
<td style="text-align: center;">當 iPhone 的 Face ID 遇到 口罩</td>
</tr>
<tr class="odd">
<td style="text-align: center;">183</td>
<td style="text-align: center;">兩種 使用 方式 電量 掉 的 速度 不同</td>
</tr>
<tr class="even">
<td style="text-align: center;">184</td>
<td style="text-align: center;">請問 IOS13 3.1 目前 推薦 更新 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">185</td>
<td style="text-align: center;">iphone 11 拍照 大樓</td>
</tr>
<tr class="even">
<td style="text-align: center;">186</td>
<td style="text-align: center;">iPhone 好像 會 自動 關閉 小米 運動 的後台</td>
</tr>
<tr class="odd">
<td style="text-align: center;">187</td>
<td style="text-align: center;">請問 各位 的 iPhone11 pro 的 電池 健康 度 還有 多少</td>
</tr>
<tr class="even">
<td style="text-align: center;">188</td>
<td style="text-align: center;">iTunes 換機 回 復 備份 失敗</td>
</tr>
<tr class="odd">
<td style="text-align: center;">189</td>
<td style="text-align: center;">Google Project Fi 搭配 esim 出國 旅遊 最強 組合</td>
</tr>
<tr class="even">
<td style="text-align: center;">190</td>
<td style="text-align: center;">徵求 大大 犀牛 盾 生日 禮金</td>
</tr>
<tr class="odd">
<td style="text-align: center;">191</td>
<td style="text-align: center;">iOS 13.4 Developer Beta 5</td>
</tr>
<tr class="even">
<td style="text-align: center;">192</td>
<td style="text-align: center;">facetime 和 電話 可 通話 但傳 訊息 imessage 不會 顯示 已 送達</td>
</tr>
<tr class="odd">
<td style="text-align: center;">193</td>
<td style="text-align: center;">line 的 訊息 通知 鈴聲</td>
</tr>
<tr class="even">
<td style="text-align: center;">194</td>
<td style="text-align: center;">可以 不同 的 Iphone 用同 一組 line 帳號 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">195</td>
<td style="text-align: center;">Iphone 7 S 藍芽 忘記 此 裝置 設定 後 無法 再 恢復 此 裝置 設定</td>
</tr>
<tr class="even">
<td style="text-align: center;">196</td>
<td style="text-align: center;">iPhone 使用 otg 或 隨身 碟 隨身 硬碟 的 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">197</td>
<td style="text-align: center;">ios13 提醒 事項 異常</td>
</tr>
<tr class="even">
<td style="text-align: center;">198</td>
<td style="text-align: center;">絕對 不 考慮 拿安卓 的 男生 可是 他 不是 拿 iPhone 最近 兩篇 刷新 我 三觀 的 Dcard 文章</td>
</tr>
<tr class="odd">
<td style="text-align: center;">199</td>
<td style="text-align: center;">徵求 犀牛 盾 3 月 生日 禮金</td>
</tr>
<tr class="even">
<td style="text-align: center;">200</td>
<td style="text-align: center;">靜音 鍵 其實 是 不錯 的 設計</td>
</tr>
<tr class="odd">
<td style="text-align: center;">201</td>
<td style="text-align: center;">Phone 連接 iTunes 後 無法 將 影片 從 電腦 拉到 手機 內</td>
</tr>
<tr class="even">
<td style="text-align: center;">202</td>
<td style="text-align: center;">iPhone XS 電池 健康 度會 不會 降太快</td>
</tr>
<tr class="odd">
<td style="text-align: center;">203</td>
<td style="text-align: center;">iPhone XR 升級 IOS 13.3.1 耗電</td>
</tr>
<tr class="even">
<td style="text-align: center;">204</td>
<td style="text-align: center;">請問 為 什麼 我 的 FB App 右上方 訊息 一直 出現 1 呢</td>
</tr>
<tr class="odd">
<td style="text-align: center;">205</td>
<td style="text-align: center;">iPhone xs max 解鎖 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">206</td>
<td style="text-align: center;">徵求 犀牛 盾 3 月 生日 禮金</td>
</tr>
<tr class="odd">
<td style="text-align: center;">207</td>
<td style="text-align: center;">三月底 悠遊 付 上線 iPhone 確定 不 支援 交通 載具 支付</td>
</tr>
<tr class="even">
<td style="text-align: center;">208</td>
<td style="text-align: center;">IPHONE X 針對 4 G 頻率 900 無法 連</td>
</tr>
<tr class="odd">
<td style="text-align: center;">209</td>
<td style="text-align: center;">我 想 用 IPHONE 11 雙卡通 訊 有 朋友 可以 分享 經驗 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">210</td>
<td style="text-align: center;">不 只要 拿 iPhone 連 配件 都 要 原廠</td>
</tr>
<tr class="odd">
<td style="text-align: center;">211</td>
<td style="text-align: center;">明明 沒 照片 但 照片 與 相機 卻 佔 了 3.7 G</td>
</tr>
<tr class="even">
<td style="text-align: center;">212</td>
<td style="text-align: center;">iphone 6 64 g 有 維修 的 必要 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">213</td>
<td style="text-align: center;">iPhone XS Line 非常 卡頓</td>
</tr>
<tr class="even">
<td style="text-align: center;">214</td>
<td style="text-align: center;">APPLE MOSHI 腕繩 手機 殼 開箱 文</td>
</tr>
<tr class="odd">
<td style="text-align: center;">215</td>
<td style="text-align: center;">現在 買 iPhone 8 還 值得 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">216</td>
<td style="text-align: center;">請問 ios 要 常常 更新 嗎 還是 都 不要 更新 比較 好</td>
</tr>
<tr class="odd">
<td style="text-align: center;">217</td>
<td style="text-align: center;">apple pay 無法 感應</td>
</tr>
<tr class="even">
<td style="text-align: center;">218</td>
<td style="text-align: center;">siri 聲控 小米 設備 捷徑 重複 疑問</td>
</tr>
<tr class="odd">
<td style="text-align: center;">219</td>
<td style="text-align: center;">明年 iPhone 5 G 出來 也 不用 急著 出手</td>
</tr>
<tr class="even">
<td style="text-align: center;">220</td>
<td style="text-align: center;">請問 怎麼 把 電腦 的 照片 傳輸 到 iphone 上</td>
</tr>
<tr class="odd">
<td style="text-align: center;">221</td>
<td style="text-align: center;">已 解決 請 幫忙 刪除</td>
</tr>
<tr class="even">
<td style="text-align: center;">222</td>
<td style="text-align: center;">請問 有人 XR 虛擬 sim 不見 了 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">223</td>
<td style="text-align: center;">iPhone XS OLED 頭暈</td>
</tr>
<tr class="even">
<td style="text-align: center;">224</td>
<td style="text-align: center;">現在 瀏海 機種 FaceID 機種 的 可見度 誰 比較 高</td>
</tr>
<tr class="odd">
<td style="text-align: center;">225</td>
<td style="text-align: center;">我 跟 大家 相反 今年 iPhone11 要大賣 了</td>
</tr>
<tr class="even">
<td style="text-align: center;">226</td>
<td style="text-align: center;">蘋果 將 支付 高達 5 億美元 和解</td>
</tr>
<tr class="odd">
<td style="text-align: center;">227</td>
<td style="text-align: center;">有人 的 XR 後 相 機會 抖動 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">228</td>
<td style="text-align: center;">傳 excel 到 line 無法 開啟 裏面 的 網頁 連結</td>
</tr>
<tr class="odd">
<td style="text-align: center;">229</td>
<td style="text-align: center;">Carplay 連線 最近 出 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">230</td>
<td style="text-align: center;">iPhone 11 Pro 聰穎 電池 殼 用 在 iPhone XS</td>
</tr>
<tr class="odd">
<td style="text-align: center;">231</td>
<td style="text-align: center;">下載 youtube mp3</td>
</tr>
<tr class="even">
<td style="text-align: center;">232</td>
<td style="text-align: center;">電池 健康 度 89 還 可以 撐 多久 才換</td>
</tr>
<tr class="odd">
<td style="text-align: center;">233</td>
<td style="text-align: center;">iOS 13.4 Developer Beta 4</td>
</tr>
<tr class="even">
<td style="text-align: center;">234</td>
<td style="text-align: center;">AirPods Pro 2 7 準備 出貨 囉</td>
</tr>
<tr class="odd">
<td style="text-align: center;">235</td>
<td style="text-align: center;">分享 XR 入手 300 天 213 循環 健康 度 103- 101 的 使用 日常</td>
</tr>
<tr class="even">
<td style="text-align: center;">236</td>
<td style="text-align: center;">Gartner 2019 第四季 手機 銷量 疲軟 但 蘋果 和 小米 逆勢 成長</td>
</tr>
<tr class="odd">
<td style="text-align: center;">237</td>
<td style="text-align: center;">請 從 其他 裝置 核准 此 IPHONE 我 只有 一支 IPHONE XR</td>
</tr>
<tr class="even">
<td style="text-align: center;">238</td>
<td style="text-align: center;">結案 IPHONE11 沒 使用 卻 狂 發熱 關機 30 分鐘 吹 電風扇 還是 熱的</td>
</tr>
<tr class="odd">
<td style="text-align: center;">239</td>
<td style="text-align: center;">iPhone 11 夜間 攝影 大賽 揭曉 看看 新 模式 捕捉到 哪些 美麗 的 夜景 照 吧</td>
</tr>
<tr class="even">
<td style="text-align: center;">240</td>
<td style="text-align: center;">系統 或 軟體 崩潰 有 可能 導致 自動關機 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">241</td>
<td style="text-align: center;">跟 別人 的 相簿 同步 了 出現 不知 哪裡 冒 出 的 照片</td>
</tr>
<tr class="even">
<td style="text-align: center;">242</td>
<td style="text-align: center;">iOS 13.4 Beta4 這次 提早 更新 這 版本 比 3 省電</td>
</tr>
<tr class="odd">
<td style="text-align: center;">243</td>
<td style="text-align: center;">iPhone X 相機 出現 雜點</td>
</tr>
<tr class="even">
<td style="text-align: center;">244</td>
<td style="text-align: center;">iphone11 instagram 限時 動態</td>
</tr>
<tr class="odd">
<td style="text-align: center;">245</td>
<td style="text-align: center;">iPhone 11 Pro 更新 iOS 13.3.1 觀看 youtube 容易 閃退</td>
</tr>
<tr class="even">
<td style="text-align: center;">246</td>
<td style="text-align: center;">iPhone 的 Google Map 時間軸 沒有 地點 紀錄</td>
</tr>
<tr class="odd">
<td style="text-align: center;">247</td>
<td style="text-align: center;">求助 iPhone 11 常常 4 G 網速慢 到 卡死 但重 開機 又 正常</td>
</tr>
<tr class="even">
<td style="text-align: center;">248</td>
<td style="text-align: center;">請問 有 辦法 在將 所有 照片 中 的 照片 加入 相簿 之後 在 所有 相片 中將 此 照片 移除 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">249</td>
<td style="text-align: center;">ios 更新 13.3.1 後 電話 擴音 不能 按</td>
</tr>
<tr class="even">
<td style="text-align: center;">250</td>
<td style="text-align: center;">IPHONE 11 VS SONY A73 4 K 畫質 表現 對比</td>
</tr>
<tr class="odd">
<td style="text-align: center;">251</td>
<td style="text-align: center;">徵求 用 不到 的 犀牛 盾 三月 禮金</td>
</tr>
<tr class="even">
<td style="text-align: center;">252</td>
<td style="text-align: center;">iPhone XS Max Wi Fi 熱點問題 Apple 客服 的 回覆</td>
</tr>
<tr class="odd">
<td style="text-align: center;">253</td>
<td style="text-align: center;">iphone 11 的 訊號</td>
</tr>
<tr class="even">
<td style="text-align: center;">254</td>
<td style="text-align: center;">我 想 買 iphone 機 需要 推薦 容量</td>
</tr>
<tr class="odd">
<td style="text-align: center;">255</td>
<td style="text-align: center;">如何 主動 讓 iPhone 記住 APP 的 登 入帳 密</td>
</tr>
<tr class="even">
<td style="text-align: center;">256</td>
<td style="text-align: center;">UAG 手機 殼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">257</td>
<td style="text-align: center;">Line 通話 自動 變 擴音</td>
</tr>
<tr class="even">
<td style="text-align: center;">258</td>
<td style="text-align: center;">iPhone 居然 會 自己 移動</td>
</tr>
<tr class="odd">
<td style="text-align: center;">259</td>
<td style="text-align: center;">夜間 模式 選項</td>
</tr>
<tr class="even">
<td style="text-align: center;">260</td>
<td style="text-align: center;">目前 CP 值 最優 的 iPhone 手機</td>
</tr>
<tr class="odd">
<td style="text-align: center;">261</td>
<td style="text-align: center;">Xs Max 不 習慣 換回 小 隻 iPhone</td>
</tr>
<tr class="even">
<td style="text-align: center;">262</td>
<td style="text-align: center;">手機 使用 一段時間 到底 要 不要 關閉 分頁</td>
</tr>
<tr class="odd">
<td style="text-align: center;">263</td>
<td style="text-align: center;">設定 上方 的 Apple ID 變灰 無法 進入</td>
</tr>
<tr class="even">
<td style="text-align: center;">264</td>
<td style="text-align: center;">通話 結束 後 出現 通話 失敗 該 如何 解決</td>
</tr>
<tr class="odd">
<td style="text-align: center;">265</td>
<td style="text-align: center;">照片 共享 出現 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">266</td>
<td style="text-align: center;">IPHONE 6 S 最佳 韌體 版本</td>
</tr>
<tr class="odd">
<td style="text-align: center;">267</td>
<td style="text-align: center;">一個 重度 使用者 的 心得 iphone 11 不 需要 快充</td>
</tr>
<tr class="even">
<td style="text-align: center;">268</td>
<td style="text-align: center;">Ulanzi 多 鏡頭 保護 殼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">269</td>
<td style="text-align: center;">怎麼 會 有 簡體字</td>
</tr>
<tr class="even">
<td style="text-align: center;">270</td>
<td style="text-align: center;">iphone11 pro max 主 鏡頭 模糊</td>
</tr>
<tr class="odd">
<td style="text-align: center;">271</td>
<td style="text-align: center;">iphone 7 plus wifi 更新 白 蘋果</td>
</tr>
<tr class="even">
<td style="text-align: center;">272</td>
<td style="text-align: center;">螢幕 使用 時間 密碼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">273</td>
<td style="text-align: center;">android 轉 ios iphone xs 無法 移轉</td>
</tr>
<tr class="even">
<td style="text-align: center;">274</td>
<td style="text-align: center;">11 PRO MAX 更新 13.3.1 前 鏡頭 變黑</td>
</tr>
<tr class="odd">
<td style="text-align: center;">275</td>
<td style="text-align: center;">Dropbox 互助 區 互助 互惠 相互 扶持</td>
</tr>
<tr class="even">
<td style="text-align: center;">276</td>
<td style="text-align: center;">舊 ipad 2 真的 都 轉移 不了 了嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">277</td>
<td style="text-align: center;">itunes 上 買 的 Disney 及 皮克斯 電影 會 因為 Disney 上架 而 消失 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">278</td>
<td style="text-align: center;">6 s 換 電池</td>
</tr>
<tr class="odd">
<td style="text-align: center;">279</td>
<td style="text-align: center;">鬧鐘 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">280</td>
<td style="text-align: center;">有人 用過 原廠 2 M USB Lightning 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">281</td>
<td style="text-align: center;">iOS 13.4 Developer Beta 3</td>
</tr>
<tr class="even">
<td style="text-align: center;">282</td>
<td style="text-align: center;">iPhone8 居然 會 自己 移動</td>
</tr>
<tr class="odd">
<td style="text-align: center;">283</td>
<td style="text-align: center;">hTC one 的 Line 過往 對話 紀錄 有 辦法 保存 至 iPhone 6 S 裡面 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">284</td>
<td style="text-align: center;">想 問問 App Store 有 什麼 影片 播放器 推薦</td>
</tr>
<tr class="odd">
<td style="text-align: center;">285</td>
<td style="text-align: center;">Line 訊息 顯示 時間</td>
</tr>
<tr class="even">
<td style="text-align: center;">286</td>
<td style="text-align: center;">大家 有 感覺 更新 到 13 版 之後 變得 很 耗電</td>
</tr>
<tr class="odd">
<td style="text-align: center;">287</td>
<td style="text-align: center;">applre TV 的 疑問</td>
</tr>
<tr class="even">
<td style="text-align: center;">288</td>
<td style="text-align: center;">iphone11 個人 熱點 有 連線 但 卻 無法 上網</td>
</tr>
<tr class="odd">
<td style="text-align: center;">289</td>
<td style="text-align: center;">蘋果 手機 越來越 不 保值</td>
</tr>
<tr class="even">
<td style="text-align: center;">290</td>
<td style="text-align: center;">太樂芬 跟 犀牛 盾</td>
</tr>
<tr class="odd">
<td style="text-align: center;">291</td>
<td style="text-align: center;">iphone wifi 問題 雖 不知 原因 但 已 解決</td>
</tr>
<tr class="even">
<td style="text-align: center;">292</td>
<td style="text-align: center;">iPhone 11 充電 斷續</td>
</tr>
<tr class="odd">
<td style="text-align: center;">293</td>
<td style="text-align: center;">雙卡 雙代 的 iphone 應用</td>
</tr>
<tr class="even">
<td style="text-align: center;">294</td>
<td style="text-align: center;">Iphone X 電池 膨脹</td>
</tr>
<tr class="odd">
<td style="text-align: center;">295</td>
<td style="text-align: center;">iphone 的 照片 影片 有 什麼 方法 直接 備份 到 ipad</td>
</tr>
<tr class="even">
<td style="text-align: center;">296</td>
<td style="text-align: center;">雲嘉 地區 換 電池</td>
</tr>
<tr class="odd">
<td style="text-align: center;">297</td>
<td style="text-align: center;">有關 Safari chrome edge 的 我 的 最愛 同步</td>
</tr>
<tr class="even">
<td style="text-align: center;">298</td>
<td style="text-align: center;">iPhone XS iPhone XS Max 和 iPhone XR 的 聰穎 電池 護殼 更換 方案</td>
</tr>
<tr class="odd">
<td style="text-align: center;">299</td>
<td style="text-align: center;">Messenger app 降回 舊版本</td>
</tr>
<tr class="even">
<td style="text-align: center;">300</td>
<td style="text-align: center;">iPhone 8 Plus 和 iPhone 11 速度 的 比較</td>
</tr>
<tr class="odd">
<td style="text-align: center;">301</td>
<td style="text-align: center;">請教 如何 將 iPhone 上 的 畫面 投影 到 電視</td>
</tr>
<tr class="even">
<td style="text-align: center;">302</td>
<td style="text-align: center;">I PHONE 11 PRO MAX 1 X 人像 模式 邊緣 易 模糊</td>
</tr>
<tr class="odd">
<td style="text-align: center;">303</td>
<td style="text-align: center;">app 上 的 QRcode 無法 顯示 該 怎麼辦</td>
</tr>
<tr class="even">
<td style="text-align: center;">304</td>
<td style="text-align: center;">XR 幾款 透明 殼 請問</td>
</tr>
<tr class="odd">
<td style="text-align: center;">305</td>
<td style="text-align: center;">AppleMusic 有 辦法 把 電台 建立 成 播放 清單 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">306</td>
<td style="text-align: center;">app 閃退</td>
</tr>
<tr class="odd">
<td style="text-align: center;">307</td>
<td style="text-align: center;">iPhone XR 螢幕 左下角 出現 像是 烙印 的 痕跡</td>
</tr>
<tr class="even">
<td style="text-align: center;">308</td>
<td style="text-align: center;">iPhone XR Haptic Touch 震動 回饋 忽大忽小</td>
</tr>
<tr class="odd">
<td style="text-align: center;">309</td>
<td style="text-align: center;">大量 iPhone SE2 渲染 圖 流出</td>
</tr>
<tr class="even">
<td style="text-align: center;">310</td>
<td style="text-align: center;">請問 國外 版本 下載 台灣 APP 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">311</td>
<td style="text-align: center;">第一款 iphone ipad 的 vm 模擬器 已 發佈 可 安裝 安卓 windows linux 等 任何 作業系統</td>
</tr>
<tr class="even">
<td style="text-align: center;">312</td>
<td style="text-align: center;">如何 不讓 相簿 內 的 照片 同時 出現 在 手機 及 iPad</td>
</tr>
<tr class="odd">
<td style="text-align: center;">313</td>
<td style="text-align: center;">iphone 維修</td>
</tr>
<tr class="even">
<td style="text-align: center;">314</td>
<td style="text-align: center;">為何 Google Maps 的 摩托車 模式 MotorCycle Mode 會 消失</td>
</tr>
<tr class="odd">
<td style="text-align: center;">315</td>
<td style="text-align: center;">iOS 13.4 Developer Beta 2 更新 囉 晚上 又 跳出 更新 修正版</td>
</tr>
<tr class="even">
<td style="text-align: center;">316</td>
<td style="text-align: center;">就 想 問問 有沒有 人 拿 iPhone X 跟 我 一樣 這麼 衰</td>
</tr>
<tr class="odd">
<td style="text-align: center;">317</td>
<td style="text-align: center;">iPhone 所用 的 OLED 技術 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">318</td>
<td style="text-align: center;">有人 的 iphone XR 掉 漆 了嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">319</td>
<td style="text-align: center;">iPhone 11 上下 喇叭 聲音 不 一樣 大聲</td>
</tr>
<tr class="even">
<td style="text-align: center;">320</td>
<td style="text-align: center;">iphone6 無線 充電 貼片 疑問</td>
</tr>
<tr class="odd">
<td style="text-align: center;">321</td>
<td style="text-align: center;">請問 鈴聲 只能 響 一聲</td>
</tr>
<tr class="even">
<td style="text-align: center;">322</td>
<td style="text-align: center;">iPhone XS max 線式 耳機 插上 無 反應</td>
</tr>
<tr class="odd">
<td style="text-align: center;">323</td>
<td style="text-align: center;">IPHONE11 有夜 拍 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">324</td>
<td style="text-align: center;">取貨 日期 竟然 早於 訂單 日期</td>
</tr>
<tr class="odd">
<td style="text-align: center;">325</td>
<td style="text-align: center;">關於 IPHONE XS WIFI 問題 是否 改善</td>
</tr>
<tr class="even">
<td style="text-align: center;">326</td>
<td style="text-align: center;">airpods 偶爾 斷斷續續</td>
</tr>
<tr class="odd">
<td style="text-align: center;">327</td>
<td style="text-align: center;">如何 讓 一張 信用卡 錢包 支付 多支 iphone 西瓜 卡 使用</td>
</tr>
<tr class="even">
<td style="text-align: center;">328</td>
<td style="text-align: center;">iPhone 11 pro 斷訊</td>
</tr>
<tr class="odd">
<td style="text-align: center;">329</td>
<td style="text-align: center;">台灣 大哥大 換 iphone 的 電池 好 嗎 有沒有 有 經驗 的 網友 提供 意見 謝謝</td>
</tr>
<tr class="even">
<td style="text-align: center;">330</td>
<td style="text-align: center;">iPhone X 更換 舊 的 螢幕 原彩 寫 過去 會 影響 效能 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">331</td>
<td style="text-align: center;">都 是 OLED</td>
</tr>
<tr class="even">
<td style="text-align: center;">332</td>
<td style="text-align: center;">用 藍寶石 點綴 iphone pro max</td>
</tr>
<tr class="odd">
<td style="text-align: center;">333</td>
<td style="text-align: center;">有人 知道 更新 後 的 藍點 消除 方式 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">334</td>
<td style="text-align: center;">iPhone xs 或 iPhone 11 要 買 那款 只 差 1000 元</td>
</tr>
<tr class="odd">
<td style="text-align: center;">335</td>
<td style="text-align: center;">XS 夜拍 怎麼 拍成 11 的 日 拍感</td>
</tr>
<tr class="even">
<td style="text-align: center;">336</td>
<td style="text-align: center;">Iphone 11 保護 殼 除 犀牛 盾外 還可選 什麼 殼呢</td>
</tr>
<tr class="odd">
<td style="text-align: center;">337</td>
<td style="text-align: center;">讓 舊 iPhone 恢復 滿血 狀態 台哥 大 推換 原廠 電池 62 折 活動</td>
</tr>
<tr class="even">
<td style="text-align: center;">338</td>
<td style="text-align: center;">求助 iphoneX 的 前置 鏡頭 收音 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">339</td>
<td style="text-align: center;">iPhone 11 pro 螢幕</td>
</tr>
<tr class="even">
<td style="text-align: center;">340</td>
<td style="text-align: center;">APP 無法 更新 出現 該 項目 已 退款 的 怪 訊息</td>
</tr>
<tr class="odd">
<td style="text-align: center;">341</td>
<td style="text-align: center;">我 的 iPhone 手機 突然 出現 這個 符號 有人 知道 怎麼 關閉 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">342</td>
<td style="text-align: center;">iphone8plus 如何 分享 手機 的 vpn 網路 給 其他 device</td>
</tr>
<tr class="odd">
<td style="text-align: center;">343</td>
<td style="text-align: center;">蘋果 證實 受 疫情 影響 本季 營收將 無法 達到 預期 目標</td>
</tr>
<tr class="even">
<td style="text-align: center;">344</td>
<td style="text-align: center;">戴 口罩 竟然 能夠 臉部 解鎖 僅供參考</td>
</tr>
<tr class="odd">
<td style="text-align: center;">345</td>
<td style="text-align: center;">iOS 13.4 Developer Beta 2</td>
</tr>
<tr class="even">
<td style="text-align: center;">346</td>
<td style="text-align: center;">不明 的 應用程式 消耗 流量</td>
</tr>
<tr class="odd">
<td style="text-align: center;">347</td>
<td style="text-align: center;">寒 流來 手機 比較 耗電</td>
</tr>
<tr class="even">
<td style="text-align: center;">348</td>
<td style="text-align: center;">蘋果 不滿 iPhone 12 高通 5 G 天線 決定 要 自行設計</td>
</tr>
<tr class="odd">
<td style="text-align: center;">349</td>
<td style="text-align: center;">iPhone 9 要 推出 了</td>
</tr>
<tr class="even">
<td style="text-align: center;">350</td>
<td style="text-align: center;">請問 為何 停產 的 是 XS 而 不是 XR</td>
</tr>
<tr class="odd">
<td style="text-align: center;">351</td>
<td style="text-align: center;">來自 美國 的 軍規 殼 Element Case 與 Case Mate 詳細 開箱</td>
</tr>
<tr class="even">
<td style="text-align: center;">352</td>
<td style="text-align: center;">iphone6s plus 用到 一半 螢幕 漸暗 熄掉 無法 關機</td>
</tr>
<tr class="odd">
<td style="text-align: center;">353</td>
<td style="text-align: center;">已經 用 高效率 拍 的 照片 如何 重新 轉存 jpg 格式</td>
</tr>
<tr class="even">
<td style="text-align: center;">354</td>
<td style="text-align: center;">想 請教 i7 128 G 無故 白 蘋果 資料 還能 救回 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">355</td>
<td style="text-align: center;">新 發現 熱點 連線 不用 再 開啟 iPhone 的 畫面 了</td>
</tr>
<tr class="even">
<td style="text-align: center;">356</td>
<td style="text-align: center;">iphone11 pro 望遠鏡 頭的 實用性</td>
</tr>
<tr class="odd">
<td style="text-align: center;">357</td>
<td style="text-align: center;">提醒 事項 到底 是 有 什麼 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">358</td>
<td style="text-align: center;">用 5 V3A 充 Xs Max 會傷 電池 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">359</td>
<td style="text-align: center;">請問 為何 iPhone XS Max 使用 airdrop 給 acbook pro 2019 傳輸 的 速度 為何 那麼 慢</td>
</tr>
<tr class="even">
<td style="text-align: center;">360</td>
<td style="text-align: center;">請問 現在 買 IPhone11 128 GB 去 那 買 最 划算</td>
</tr>
<tr class="odd">
<td style="text-align: center;">361</td>
<td style="text-align: center;">想 把 iPhone 照片 影片 檔 傳到 PC 但 必須 要 原 尺寸 大小 原 拍攝 時間</td>
</tr>
<tr class="even">
<td style="text-align: center;">362</td>
<td style="text-align: center;">按照 蘋果 的 設定 是不是 A11 用 了 兩年 效能 剩 A10 甚至 A9</td>
</tr>
<tr class="odd">
<td style="text-align: center;">363</td>
<td style="text-align: center;">iPohone11 拍照 疑問</td>
</tr>
<tr class="even">
<td style="text-align: center;">364</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">365</td>
<td style="text-align: center;">分期 買手機 有 划算 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">366</td>
<td style="text-align: center;">推薦 的 iPhone XS 手機 殼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">367</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">368</td>
<td style="text-align: center;">IPHONE 配件 總結 影片</td>
</tr>
<tr class="odd">
<td style="text-align: center;">369</td>
<td style="text-align: center;">GameCenter 設定 當機</td>
</tr>
<tr class="even">
<td style="text-align: center;">370</td>
<td style="text-align: center;">iphone xs vs iphone11 pro 你會 選哪 隻</td>
</tr>
<tr class="odd">
<td style="text-align: center;">371</td>
<td style="text-align: center;">Iphone Xs 換 11 的 必要性 工作 上 需 相機 功能</td>
</tr>
<tr class="even">
<td style="text-align: center;">372</td>
<td style="text-align: center;">iphone11 大家 覺得 的 優缺點 討論</td>
</tr>
<tr class="odd">
<td style="text-align: center;">373</td>
<td style="text-align: center;">iphone XS 電池 損耗</td>
</tr>
<tr class="even">
<td style="text-align: center;">374</td>
<td style="text-align: center;">iPhone 11 VS iPhone 11 Pro 買 哪 一個 好 優缺點 分析</td>
</tr>
<tr class="odd">
<td style="text-align: center;">375</td>
<td style="text-align: center;">有 推薦 的 有 支架 型 的 防 摔殼嗎 iPhone 11 Pro</td>
</tr>
<tr class="even">
<td style="text-align: center;">376</td>
<td style="text-align: center;">為何 IPHONE6S 刪除 LINE 的 暫 存檔 以及 照片 完全 沒有 釋放出 任何 空間 呢 已 解決</td>
</tr>
<tr class="odd">
<td style="text-align: center;">377</td>
<td style="text-align: center;">iPhone XR vs iPhone XS</td>
</tr>
<tr class="even">
<td style="text-align: center;">378</td>
<td style="text-align: center;">請問 8 PLUS 更新 13.3.1 是否 有 災情</td>
</tr>
<tr class="odd">
<td style="text-align: center;">379</td>
<td style="text-align: center;">iphone6S 用 了 4 年 想 換手 機</td>
</tr>
<tr class="even">
<td style="text-align: center;">380</td>
<td style="text-align: center;">Bitplay 攝影 手機 殼 HD 高階 廣角鏡 產品 開箱</td>
</tr>
<tr class="odd">
<td style="text-align: center;">381</td>
<td style="text-align: center;">請問 m01 的 先進 們 一件 問題 我用 iTunes 還原 備份 後 為 什麼 LINE 顯示 也 需要 用 iCloud 還原 一次 啊 我 的 舊 照片 都 變空 白了</td>
</tr>
<tr class="even">
<td style="text-align: center;">382</td>
<td style="text-align: center;">xs 無線 充電 會 無法 開機</td>
</tr>
<tr class="odd">
<td style="text-align: center;">383</td>
<td style="text-align: center;">iPhone xs 國外 充電</td>
</tr>
<tr class="even">
<td style="text-align: center;">384</td>
<td style="text-align: center;">關於 小米 無線 充電器 充 iphone XS 的 速度 請教</td>
</tr>
<tr class="odd">
<td style="text-align: center;">385</td>
<td style="text-align: center;">iphone11 夜拍 也 可以 這樣 玩</td>
</tr>
<tr class="even">
<td style="text-align: center;">386</td>
<td style="text-align: center;">用 上 一代 iphone xs max 的 有 意願 想換 11 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">387</td>
<td style="text-align: center;">iPhone 11 LTE 比 Xs 快 20</td>
</tr>
<tr class="even">
<td style="text-align: center;">388</td>
<td style="text-align: center;">iPhone Xs 盒裝 豆腐 頭</td>
</tr>
<tr class="odd">
<td style="text-align: center;">389</td>
<td style="text-align: center;">iPhone 11 pro 相簿 照片 模糊</td>
</tr>
<tr class="even">
<td style="text-align: center;">390</td>
<td style="text-align: center;">iPhone Xs 續航力 不佳</td>
</tr>
<tr class="odd">
<td style="text-align: center;">391</td>
<td style="text-align: center;">全台 首發 港版 開箱 與 雙卡 完整 測試</td>
</tr>
<tr class="even">
<td style="text-align: center;">392</td>
<td style="text-align: center;">iphone 11 pro max GPS 定位 一直 出錯</td>
</tr>
<tr class="odd">
<td style="text-align: center;">393</td>
<td style="text-align: center;">iTunes 傳輸 鈴聲 的 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">394</td>
<td style="text-align: center;">iPhone 11 貼 上 犀牛皮 鏡頭 貼 後 的 照片</td>
</tr>
<tr class="odd">
<td style="text-align: center;">395</td>
<td style="text-align: center;">前所未見 的 強大 IPHONE 11</td>
</tr>
<tr class="even">
<td style="text-align: center;">396</td>
<td style="text-align: center;">蘋果 請 奧斯卡 陣容 用 iPhone 11 Pro 拍 了 今年 的 新春 電影 但 外加 設備 可能 是 最 簡單 的</td>
</tr>
<tr class="odd">
<td style="text-align: center;">397</td>
<td style="text-align: center;">關於 iphone 手機 殼 選擇</td>
</tr>
<tr class="even">
<td style="text-align: center;">398</td>
<td style="text-align: center;">詢問 IPHONE11 的 前 鏡頭 錄影 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">399</td>
<td style="text-align: center;">各位 的 iPhone 11 pro 網路 連線 都 沒 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">400</td>
<td style="text-align: center;">XR 螢幕 漏光 問題 免費 更換 後 三個 月 不到 又 出現</td>
</tr>
<tr class="odd">
<td style="text-align: center;">401</td>
<td style="text-align: center;">用 iTUNES 備份 但 資料 卻 救 不 回來 了</td>
</tr>
<tr class="even">
<td style="text-align: center;">402</td>
<td style="text-align: center;">iphone11</td>
</tr>
<tr class="odd">
<td style="text-align: center;">403</td>
<td style="text-align: center;">輔助 觸控</td>
</tr>
<tr class="even">
<td style="text-align: center;">404</td>
<td style="text-align: center;">想問 大家 對 手機 說 嘿 誰 會 跳出 siri 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">405</td>
<td style="text-align: center;">iphone 7 4.7 吋 問題 請教</td>
</tr>
<tr class="even">
<td style="text-align: center;">406</td>
<td style="text-align: center;">iPhone 11 震動 異音</td>
</tr>
<tr class="odd">
<td style="text-align: center;">407</td>
<td style="text-align: center;">3 月份 iPhone9 SE2 開賣 後 iPhone8 系列 會 停掉 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">408</td>
<td style="text-align: center;">在 iTunes Store 上 下載 的 影片 刪除 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">409</td>
<td style="text-align: center;">請問 Apple pay 之 日本 Suica 西瓜 卡 的 相關 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">410</td>
<td style="text-align: center;">如何 用 iPhone 掃描 QRcode</td>
</tr>
<tr class="odd">
<td style="text-align: center;">411</td>
<td style="text-align: center;">iPhone 7 Plus 犀牛 盾 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">412</td>
<td style="text-align: center;">告別 Lightning 下一代 iPhone 採用 USB C 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">413</td>
<td style="text-align: center;">iPhone XS 可以 用 QC 快充 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">414</td>
<td style="text-align: center;">iphone 11 pro 實拍 帶給 我 的 震撼 及 失落 寶藏 巖 人 像 創作</td>
</tr>
<tr class="odd">
<td style="text-align: center;">415</td>
<td style="text-align: center;">i xr 耗電 異常</td>
</tr>
<tr class="even">
<td style="text-align: center;">416</td>
<td style="text-align: center;">要是 摔到 iphone 就是 這樣 子 了吧</td>
</tr>
<tr class="odd">
<td style="text-align: center;">417</td>
<td style="text-align: center;">Iphone 11 近 二週 耗電 異常</td>
</tr>
<tr class="even">
<td style="text-align: center;">418</td>
<td style="text-align: center;">公用 wif 只能 連 一台 設備 這有 解決 方法 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">419</td>
<td style="text-align: center;">想 送 Xs 給 別人 但 人家 習慣 戴 口罩 適合 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">420</td>
<td style="text-align: center;">要選 Xr 還是 11</td>
</tr>
<tr class="odd">
<td style="text-align: center;">421</td>
<td style="text-align: center;">iPhone 12 大 預測 外 媒 復古 外形 搭配 四 鏡頭 及 玫瑰 金</td>
</tr>
<tr class="even">
<td style="text-align: center;">422</td>
<td style="text-align: center;">徵求 用 不到 的 犀牛 盾 2 月份 生日 禮金</td>
</tr>
<tr class="odd">
<td style="text-align: center;">423</td>
<td style="text-align: center;">iPhone X 的 Face ID 常常 發生 失敗 後 只能 輸 密碼 要 重新 開機 才 正常 的 原因</td>
</tr>
<tr class="even">
<td style="text-align: center;">424</td>
<td style="text-align: center;">求救 iphone 8 plus 降版</td>
</tr>
<tr class="odd">
<td style="text-align: center;">425</td>
<td style="text-align: center;">iPhone XR 明年 如果 15900 應該 很 有 搞頭</td>
</tr>
<tr class="even">
<td style="text-align: center;">426</td>
<td style="text-align: center;">請問 ios13 之後 的 熱點 分享</td>
</tr>
<tr class="odd">
<td style="text-align: center;">427</td>
<td style="text-align: center;">IOS 13.3 版本 LINE 竟然 會 常常 閃退</td>
</tr>
<tr class="even">
<td style="text-align: center;">428</td>
<td style="text-align: center;">iPhone 11 錄影 測試 全 鏡頭 4 K 60 fps 電影 級 防震 三 鏡頭 切換 全都 來試 拍</td>
</tr>
<tr class="odd">
<td style="text-align: center;">429</td>
<td style="text-align: center;">iphone 檔案 這個 東西 佔 很多 容量</td>
</tr>
<tr class="even">
<td style="text-align: center;">430</td>
<td style="text-align: center;">iPhone11 重又貴 一票 果粉 死守 3 年前 神機 輕 耐用 網 真心 推 經典 不敗</td>
</tr>
<tr class="odd">
<td style="text-align: center;">431</td>
<td style="text-align: center;">徵求 犀牛 盾 二月 禮金</td>
</tr>
<tr class="even">
<td style="text-align: center;">432</td>
<td style="text-align: center;">iPhone 11 pro 這樣 的 網路 速度 正常 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">433</td>
<td style="text-align: center;">關於 OLED 和 LCD</td>
</tr>
<tr class="even">
<td style="text-align: center;">434</td>
<td style="text-align: center;">iPhone 11 和 iPhone 11 Pro 的 差異</td>
</tr>
<tr class="odd">
<td style="text-align: center;">435</td>
<td style="text-align: center;">請問 IPHONE 11 匯出 照片 到 WIN7 電腦 的 方法</td>
</tr>
<tr class="even">
<td style="text-align: center;">436</td>
<td style="text-align: center;">IPhone 11 pro 和 proMax 這 二支 女生 拿 那 只 比較 順手</td>
</tr>
<tr class="odd">
<td style="text-align: center;">437</td>
<td style="text-align: center;">6 s 手機 電壓 與 耗電 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">438</td>
<td style="text-align: center;">iPhone 11 系列 hoda 藍寶石 金屬 框 鏡頭 保護 貼 開箱</td>
</tr>
<tr class="odd">
<td style="text-align: center;">439</td>
<td style="text-align: center;">請問 電池 健康 剩下 73 沒換 可以 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">440</td>
<td style="text-align: center;">用 C to L 的 線 充電 被 人家 當成 白痴</td>
</tr>
<tr class="odd">
<td style="text-align: center;">441</td>
<td style="text-align: center;">小 白點 顯示 不 一樣</td>
</tr>
<tr class="even">
<td style="text-align: center;">442</td>
<td style="text-align: center;">遇到 內購 問題 怎麼辦 教 你 如何 退款 討回 摳 摳</td>
</tr>
<tr class="odd">
<td style="text-align: center;">443</td>
<td style="text-align: center;">已 解決 請問 line 備份 相關 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">444</td>
<td style="text-align: center;">iPhone XS 錄影 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">445</td>
<td style="text-align: center;">IPhone XS 拍照 陽光 黑影</td>
</tr>
<tr class="even">
<td style="text-align: center;">446</td>
<td style="text-align: center;">iPhone xs 剛過 保 就 自然 死亡</td>
</tr>
<tr class="odd">
<td style="text-align: center;">447</td>
<td style="text-align: center;">iphone xs 側邊 拋光</td>
</tr>
<tr class="even">
<td style="text-align: center;">448</td>
<td style="text-align: center;">iphone xs 疑問</td>
</tr>
<tr class="odd">
<td style="text-align: center;">449</td>
<td style="text-align: center;">請問 版上 有人 使用 iPhone XS Max 皮革 雙面 夾嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">450</td>
<td style="text-align: center;">iphone X iphone XS iPhone 11 Pro 速度 測試</td>
</tr>
<tr class="odd">
<td style="text-align: center;">451</td>
<td style="text-align: center;">XS 微 開箱 現在 手機 越來越 貴 精打細算 是 必須</td>
</tr>
<tr class="even">
<td style="text-align: center;">452</td>
<td style="text-align: center;">XR 更換 電池 一定 要 回 原廠 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">453</td>
<td style="text-align: center;">還在 吵 3.5 吋 與 4 吋 重點 在 寬度 不變</td>
</tr>
<tr class="even">
<td style="text-align: center;">454</td>
<td style="text-align: center;">關於 Qi 無線 充電 座 心得 與 推薦</td>
</tr>
<tr class="odd">
<td style="text-align: center;">455</td>
<td style="text-align: center;">iphone 接非 原廠 快 充頭會 叫 兩聲 原廠 只會 一聲</td>
</tr>
<tr class="even">
<td style="text-align: center;">456</td>
<td style="text-align: center;">現在 買 i7p 好嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">457</td>
<td style="text-align: center;">地標 網通 i11pro 可否 還有 跳水 空間</td>
</tr>
<tr class="even">
<td style="text-align: center;">458</td>
<td style="text-align: center;">iPhone XS 系列 照片 蓋 大樓</td>
</tr>
<tr class="odd">
<td style="text-align: center;">459</td>
<td style="text-align: center;">蘋果 原廠 豆腐 頭 充電 就 已經 很夠 了</td>
</tr>
<tr class="even">
<td style="text-align: center;">460</td>
<td style="text-align: center;">iOS 13 及 Line 通話 響鈴 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">461</td>
<td style="text-align: center;">iPhone 摔 到 有 保險 了 蘋果 Apple Care 正式 登台</td>
</tr>
<tr class="even">
<td style="text-align: center;">462</td>
<td style="text-align: center;">請教 iphone 11 保護 貼 疑問</td>
</tr>
<tr class="odd">
<td style="text-align: center;">463</td>
<td style="text-align: center;">iphone xs 深色 模式 下有 殘影</td>
</tr>
<tr class="even">
<td style="text-align: center;">464</td>
<td style="text-align: center;">關於 iPhone 輔助 觸控 解鎖 疑問</td>
</tr>
<tr class="odd">
<td style="text-align: center;">465</td>
<td style="text-align: center;">iPhone XS 和 iPhone11 比 哪個 比較 好</td>
</tr>
<tr class="even">
<td style="text-align: center;">466</td>
<td style="text-align: center;">iPhone XR with eSIM</td>
</tr>
<tr class="odd">
<td style="text-align: center;">467</td>
<td style="text-align: center;">IPHONE XR 忽然 打字 失效</td>
</tr>
<tr class="even">
<td style="text-align: center;">468</td>
<td style="text-align: center;">i8 iTunes 備份 i11 無法 從此 裝備 恢復</td>
</tr>
<tr class="odd">
<td style="text-align: center;">469</td>
<td style="text-align: center;">川普 喊話 蘋果 要 iPhone 裝回 Home 鍵</td>
</tr>
<tr class="even">
<td style="text-align: center;">470</td>
<td style="text-align: center;">很少 人用 GOOGLE 硬碟 備份 資料 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">471</td>
<td style="text-align: center;">11 pro max 的 相 機會 抖動 順便 抱怨 神腦 大安 信義 APPLE 授權 維修中心</td>
</tr>
<tr class="even">
<td style="text-align: center;">472</td>
<td style="text-align: center;">iPhone 11 拍照 大樓 蓋起來</td>
</tr>
<tr class="odd">
<td style="text-align: center;">473</td>
<td style="text-align: center;">apple pay 使用 注意 多刷款 更新 已 退款</td>
</tr>
<tr class="even">
<td style="text-align: center;">474</td>
<td style="text-align: center;">apple id 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">475</td>
<td style="text-align: center;">美版 iPhone XS 不 開機 維修 實記</td>
</tr>
<tr class="even">
<td style="text-align: center;">476</td>
<td style="text-align: center;">Google iphone XS 夜拍 輸給 pixel 3 a</td>
</tr>
<tr class="odd">
<td style="text-align: center;">477</td>
<td style="text-align: center;">iphone 換 電池 要 注意 什麼 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">478</td>
<td style="text-align: center;">如何 不 強制 使用 apple map</td>
</tr>
<tr class="odd">
<td style="text-align: center;">479</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">480</td>
<td style="text-align: center;">維修 iPhone</td>
</tr>
<tr class="odd">
<td style="text-align: center;">481</td>
<td style="text-align: center;">XR 通話 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">482</td>
<td style="text-align: center;">防水 功能</td>
</tr>
<tr class="odd">
<td style="text-align: center;">483</td>
<td style="text-align: center;">11 11 pro 螢幕 硬度 比較</td>
</tr>
<tr class="even">
<td style="text-align: center;">484</td>
<td style="text-align: center;">iPhone XS 512 G</td>
</tr>
<tr class="odd">
<td style="text-align: center;">485</td>
<td style="text-align: center;">iPhone SE2 你 會 買 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">486</td>
<td style="text-align: center;">XS 64 G 還是 11 64 G</td>
</tr>
<tr class="odd">
<td style="text-align: center;">487</td>
<td style="text-align: center;">11 跟 pro11 拍照 評價 哪個 好以 女生 的 角度</td>
</tr>
<tr class="even">
<td style="text-align: center;">488</td>
<td style="text-align: center;">iphone 11 pro max 的 電磁波 是不是 太強了 講 電話會 有 頭暈 的 感覺</td>
</tr>
<tr class="odd">
<td style="text-align: center;">489</td>
<td style="text-align: center;">我 讓 iPhone 音樂 音質 爆棚 啦 分享</td>
</tr>
<tr class="even">
<td style="text-align: center;">490</td>
<td style="text-align: center;">IPHONE11 相機 對焦 異常</td>
</tr>
<tr class="odd">
<td style="text-align: center;">491</td>
<td style="text-align: center;">iPhone 9 iPhone SE2</td>
</tr>
<tr class="even">
<td style="text-align: center;">492</td>
<td style="text-align: center;">iOS 13.4 Developer Beta</td>
</tr>
<tr class="odd">
<td style="text-align: center;">493</td>
<td style="text-align: center;">Iphone11 line 圖片 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">494</td>
<td style="text-align: center;">iPhone xs 還是 iPhone 8</td>
</tr>
<tr class="odd">
<td style="text-align: center;">495</td>
<td style="text-align: center;">iPhone 11 保護 殼</td>
</tr>
<tr class="even">
<td style="text-align: center;">496</td>
<td style="text-align: center;">手機 開 熱點 給 車用 裝置 卻 一直 斷線</td>
</tr>
<tr class="odd">
<td style="text-align: center;">497</td>
<td style="text-align: center;">Apple iPhone 11 128 GB 6.1 吋 白 22699 可買嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">498</td>
<td style="text-align: center;">iPhone OTA 失敗 後 的 照片 回 復 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">499</td>
<td style="text-align: center;">可以 分享 一下 紅色 iPhone 11 使用 的 手機 殼嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">500</td>
<td style="text-align: center;">2 月 犀牛 盾 生日 禮金 或 折扣 碼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">501</td>
<td style="text-align: center;">XR 熱點</td>
</tr>
<tr class="even">
<td style="text-align: center;">502</td>
<td style="text-align: center;">iphone 可以 自動 關屏 嗎 非 定時</td>
</tr>
<tr class="odd">
<td style="text-align: center;">503</td>
<td style="text-align: center;">IPhone XS 錄影 有 加強 景深 的 部分 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">504</td>
<td style="text-align: center;">9 月 新 的 iphone 出來 XS XR 一 各位 經驗 大概 會降 多少</td>
</tr>
<tr class="odd">
<td style="text-align: center;">505</td>
<td style="text-align: center;">有人 買 AppleCare 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">506</td>
<td style="text-align: center;">要 怎麼 買 iphone xs max256g 金色 最 划算</td>
</tr>
<tr class="odd">
<td style="text-align: center;">507</td>
<td style="text-align: center;">請問 IPHONE XS 雙卡 的 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">508</td>
<td style="text-align: center;">戴 口罩 解開 FACE ID</td>
</tr>
<tr class="odd">
<td style="text-align: center;">509</td>
<td style="text-align: center;">iPhone 7 Plus 使用 PD 快充 疑問</td>
</tr>
<tr class="even">
<td style="text-align: center;">510</td>
<td style="text-align: center;">求救 iOS 13.3.1 更新 後 無 信號</td>
</tr>
<tr class="odd">
<td style="text-align: center;">511</td>
<td style="text-align: center;">iPhone 11 msg 好怪</td>
</tr>
<tr class="even">
<td style="text-align: center;">512</td>
<td style="text-align: center;">iOS 13.4 Developer Beta 1 更新</td>
</tr>
<tr class="odd">
<td style="text-align: center;">513</td>
<td style="text-align: center;">XR 拍照 分享 大樓</td>
</tr>
<tr class="even">
<td style="text-align: center;">514</td>
<td style="text-align: center;">螢幕 下 指紋 辨識 將要 復出 了</td>
</tr>
<tr class="odd">
<td style="text-align: center;">515</td>
<td style="text-align: center;">XR 升級 ios 13.2.3 後 照相 有時 會 出現 色斑 條</td>
</tr>
<tr class="even">
<td style="text-align: center;">516</td>
<td style="text-align: center;">求 iphone11 綠色 手機 殼 推薦</td>
</tr>
<tr class="odd">
<td style="text-align: center;">517</td>
<td style="text-align: center;">連接 電腦 出現 錯誤 連結 到 系統 的 某個 裝置 失去 作用</td>
</tr>
<tr class="even">
<td style="text-align: center;">518</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">519</td>
<td style="text-align: center;">iPhone 8 開機 密碼 忘記 清除 裝置 後 照片 都 不見 了 有救 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">520</td>
<td style="text-align: center;">YouTube Premium 藍芽 背景 播放 BUG</td>
</tr>
<tr class="odd">
<td style="text-align: center;">521</td>
<td style="text-align: center;">戴 口罩 解鎖 iPhone 一直 失敗 這 3 招讓 Face ID 更 聰明</td>
</tr>
<tr class="even">
<td style="text-align: center;">522</td>
<td style="text-align: center;">為 什麼 Twitter 自動 追蹤 大量 陌生 帳號</td>
</tr>
<tr class="odd">
<td style="text-align: center;">523</td>
<td style="text-align: center;">I6S 無法 連結 Wifi</td>
</tr>
<tr class="even">
<td style="text-align: center;">524</td>
<td style="text-align: center;">iphone 相機 開 濾鏡 後 相片 處理 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">525</td>
<td style="text-align: center;">iphone 相機 開 濾鏡 後 相片 處理 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">526</td>
<td style="text-align: center;">Element case Ronin for iPhone 11 pro max 使用 心得</td>
</tr>
<tr class="odd">
<td style="text-align: center;">527</td>
<td style="text-align: center;">iPhone6S 開啟 部份 程式 一直 閃退 有解 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">528</td>
<td style="text-align: center;">iOS13 3.1 電量 體驗 i 11</td>
</tr>
<tr class="odd">
<td style="text-align: center;">529</td>
<td style="text-align: center;">老婆 的 I7 我 居然 可以 用 食指 喚醒</td>
</tr>
<tr class="even">
<td style="text-align: center;">530</td>
<td style="text-align: center;">Apple Watch 使用 疑問 不好意思 跑 錯版 了</td>
</tr>
<tr class="odd">
<td style="text-align: center;">531</td>
<td style="text-align: center;">13.3 的 尋找 功能</td>
</tr>
<tr class="even">
<td style="text-align: center;">532</td>
<td style="text-align: center;">iPhone 11 pro 曼谷 行</td>
</tr>
<tr class="odd">
<td style="text-align: center;">533</td>
<td style="text-align: center;">iphone11 二個月 體驗</td>
</tr>
<tr class="even">
<td style="text-align: center;">534</td>
<td style="text-align: center;">iPhone 11 系列 雙 鏡頭 同步 錄影 功能 上線</td>
</tr>
<tr class="odd">
<td style="text-align: center;">535</td>
<td style="text-align: center;">ios13 3 個人 熱點 改善</td>
</tr>
<tr class="even">
<td style="text-align: center;">536</td>
<td style="text-align: center;">iphone11 pro 熱點問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">537</td>
<td style="text-align: center;">Lightning to RJ45 網路 4 G To RJ45</td>
</tr>
<tr class="even">
<td style="text-align: center;">538</td>
<td style="text-align: center;">為 了 玩遊戲 值得 嘛</td>
</tr>
<tr class="odd">
<td style="text-align: center;">539</td>
<td style="text-align: center;">調查 大家 iPhone 11 pro max 的 電池 健康狀況</td>
</tr>
<tr class="even">
<td style="text-align: center;">540</td>
<td style="text-align: center;">T 客邦 這 兩篇 文章 奇文共賞 2019 年 後 我 不再 是 果粉</td>
</tr>
<tr class="odd">
<td style="text-align: center;">541</td>
<td style="text-align: center;">iphone 遊戲 刪除 後 重新安裝 進度 仍 在</td>
</tr>
<tr class="even">
<td style="text-align: center;">542</td>
<td style="text-align: center;">一直 維持 在 4 電源 無法 充電</td>
</tr>
<tr class="odd">
<td style="text-align: center;">543</td>
<td style="text-align: center;">剛 購買 iOSGods APP 卻 不 懂 怎麼 安裝 未 簽名 APP</td>
</tr>
<tr class="even">
<td style="text-align: center;">544</td>
<td style="text-align: center;">iPhone 公眾 wifi 狂 斷線</td>
</tr>
<tr class="odd">
<td style="text-align: center;">545</td>
<td style="text-align: center;">iphoneX 黑色 配 犀牛 盾 什麼 顏色 手機 殼 會 比較 好看</td>
</tr>
<tr class="even">
<td style="text-align: center;">546</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">547</td>
<td style="text-align: center;">如何 讓 個人 熱點 不 中斷</td>
</tr>
<tr class="even">
<td style="text-align: center;">548</td>
<td style="text-align: center;">請問 Iphone 換 電池</td>
</tr>
<tr class="odd">
<td style="text-align: center;">549</td>
<td style="text-align: center;">請問 IPhone 11 近 拍 對焦 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">550</td>
<td style="text-align: center;">ios13 2.3 pro max 熱點 分享 給 電腦 無法 連結</td>
</tr>
<tr class="odd">
<td style="text-align: center;">551</td>
<td style="text-align: center;">雙卡版 XSMax 好 難用</td>
</tr>
<tr class="even">
<td style="text-align: center;">552</td>
<td style="text-align: center;">IPHONE 的 訊息 問題 想要 在 電腦 傳</td>
</tr>
<tr class="odd">
<td style="text-align: center;">553</td>
<td style="text-align: center;">帶 口罩 時用 iphone face ID 真 麻煩</td>
</tr>
<tr class="even">
<td style="text-align: center;">554</td>
<td style="text-align: center;">求 推薦 支援 快充 耐用 的 行動 電源</td>
</tr>
<tr class="odd">
<td style="text-align: center;">555</td>
<td style="text-align: center;">跪求 犀牛 盾 折扣 碼</td>
</tr>
<tr class="even">
<td style="text-align: center;">556</td>
<td style="text-align: center;">熱點 分享 有限 流量</td>
</tr>
<tr class="odd">
<td style="text-align: center;">557</td>
<td style="text-align: center;">iOS 13.3.1 17 D50 正式版 推出 在家 更新 保平安</td>
</tr>
<tr class="even">
<td style="text-align: center;">558</td>
<td style="text-align: center;">iPhone 11 Pro Max 太重 了 再見 了 懷念 6 plus 年代 的 重量</td>
</tr>
<tr class="odd">
<td style="text-align: center;">559</td>
<td style="text-align: center;">現在 還在 用 哀鳳 7 會 很 丟臉 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">560</td>
<td style="text-align: center;">請板主 幫忙 刪除</td>
</tr>
<tr class="odd">
<td style="text-align: center;">561</td>
<td style="text-align: center;">tvOS 12 beta developer profile 已 失效</td>
</tr>
<tr class="even">
<td style="text-align: center;">562</td>
<td style="text-align: center;">iPhone 11 來電 鈴聲</td>
</tr>
<tr class="odd">
<td style="text-align: center;">563</td>
<td style="text-align: center;">iPhone 個人 熱點 無法 連網 windows</td>
</tr>
<tr class="even">
<td style="text-align: center;">564</td>
<td style="text-align: center;">iPhone 播放 iTunes 同步 的 影片 檔 以 解答</td>
</tr>
<tr class="odd">
<td style="text-align: center;">565</td>
<td style="text-align: center;">UAG iPhone 11 全系列 軍規 保護 殼 開箱 手持 無懼 率性 百搭</td>
</tr>
<tr class="even">
<td style="text-align: center;">566</td>
<td style="text-align: center;">iPhone 11 Pro 瀏覽 yahoo 網頁 無法 上下 滑動</td>
</tr>
<tr class="odd">
<td style="text-align: center;">567</td>
<td style="text-align: center;">有關 FACE ID 失效 重新 設定 失敗 的 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">568</td>
<td style="text-align: center;">iOS 13.3.1</td>
</tr>
<tr class="odd">
<td style="text-align: center;">569</td>
<td style="text-align: center;">現在 買 iphone 11 pro 是 時候 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">570</td>
<td style="text-align: center;">徵求 犀牛 盾 1 月 生日 禮金</td>
</tr>
<tr class="odd">
<td style="text-align: center;">571</td>
<td style="text-align: center;">iOS 13.3.1 Developer Beta 3</td>
</tr>
<tr class="even">
<td style="text-align: center;">572</td>
<td style="text-align: center;">Apple ID 更換</td>
</tr>
<tr class="odd">
<td style="text-align: center;">573</td>
<td style="text-align: center;">iOS 13.3.1 Developer Beta 3 更新 囉 超 有感 省電</td>
</tr>
<tr class="even">
<td style="text-align: center;">574</td>
<td style="text-align: center;">買 蘋果 手機 當場 發現 瑕疵 不能 退換貨</td>
</tr>
<tr class="odd">
<td style="text-align: center;">575</td>
<td style="text-align: center;">iphone 11 手寫輸入 法 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">576</td>
<td style="text-align: center;">最佳化 電池 充電</td>
</tr>
<tr class="odd">
<td style="text-align: center;">577</td>
<td style="text-align: center;">zenpower 可以 充 蘋果 手機 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">578</td>
<td style="text-align: center;">更換 保護 貼 螢幕 內部 裂痕 刮痕</td>
</tr>
<tr class="odd">
<td style="text-align: center;">579</td>
<td style="text-align: center;">請問 Face ID 解鎖 後 能 自動 進入 桌面 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">580</td>
<td style="text-align: center;">分享 幾張 iPhone 11 Pro Max 台北 信義 區 照片 蓋 大樓</td>
</tr>
<tr class="odd">
<td style="text-align: center;">581</td>
<td style="text-align: center;">有人 iphone xs max 打字 輸入 鍵盤 會當 掉 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">582</td>
<td style="text-align: center;">iphone11 msg 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">583</td>
<td style="text-align: center;">7 plus 充電 期間 螢幕 會 無故 亮起</td>
</tr>
<tr class="even">
<td style="text-align: center;">584</td>
<td style="text-align: center;">請問</td>
</tr>
<tr class="odd">
<td style="text-align: center;">585</td>
<td style="text-align: center;">請問 想升 去 Beta 版 手機 資料 會 被 清空 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">586</td>
<td style="text-align: center;">SGP 手機 殼 差別</td>
</tr>
<tr class="odd">
<td style="text-align: center;">587</td>
<td style="text-align: center;">i11 pro max 連拍 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">588</td>
<td style="text-align: center;">iCloud 雲端 上 照片 無法 刪除</td>
</tr>
<tr class="odd">
<td style="text-align: center;">589</td>
<td style="text-align: center;">傳進 電腦 的 時間 不是 拍攝 當天</td>
</tr>
<tr class="even">
<td style="text-align: center;">590</td>
<td style="text-align: center;">iOS 13 apple music 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">591</td>
<td style="text-align: center;">iPhone SE2 有譜了</td>
</tr>
<tr class="even">
<td style="text-align: center;">592</td>
<td style="text-align: center;">請問 iphone 11 pro 換 iphone 8 該 如何 回 復 資料 呢</td>
</tr>
<tr class="odd">
<td style="text-align: center;">593</td>
<td style="text-align: center;">iphone 11 dxo 相機 評分 出爐</td>
</tr>
<tr class="even">
<td style="text-align: center;">594</td>
<td style="text-align: center;">求助 急 聯絡人 照片 不見 了</td>
</tr>
<tr class="odd">
<td style="text-align: center;">595</td>
<td style="text-align: center;">iphone 11 pro 能夠 拍人 像 禮服 創作 嗎 新年 特輯 祝 大家 新年快樂</td>
</tr>
<tr class="even">
<td style="text-align: center;">596</td>
<td style="text-align: center;">Line 更新 10.0.2 版本</td>
</tr>
<tr class="odd">
<td style="text-align: center;">597</td>
<td style="text-align: center;">4 地方 買 iphone 保固 和 售後服務 有何 不同</td>
</tr>
<tr class="even">
<td style="text-align: center;">598</td>
<td style="text-align: center;">秀出 你 的 得意 作品 蘋果 舉辦 首次 iPhone 11 夜間 模式 攝影 大賽</td>
</tr>
<tr class="odd">
<td style="text-align: center;">599</td>
<td style="text-align: center;">11 pro 行事曆 一直 跳出 通知</td>
</tr>
<tr class="even">
<td style="text-align: center;">600</td>
<td style="text-align: center;">一 整晚 i11 直接 沒電</td>
</tr>
<tr class="odd">
<td style="text-align: center;">601</td>
<td style="text-align: center;">iOS wifi 連線 的 切換 的 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">602</td>
<td style="text-align: center;">iOS 13.3 17 C54 正式版 推出 囉 更新 一排 刷起來</td>
</tr>
<tr class="odd">
<td style="text-align: center;">603</td>
<td style="text-align: center;">line 更新 10.0.1</td>
</tr>
<tr class="even">
<td style="text-align: center;">604</td>
<td style="text-align: center;">line 系統 發生 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">605</td>
<td style="text-align: center;">11 pro max 開機 要 三 小時</td>
</tr>
<tr class="even">
<td style="text-align: center;">606</td>
<td style="text-align: center;">iPhone GPS</td>
</tr>
<tr class="odd">
<td style="text-align: center;">607</td>
<td style="text-align: center;">雜談 關於 iPhone11 Pro Max 之耀光 鬼影 光斑 反光 探討 對比 S10E</td>
</tr>
<tr class="even">
<td style="text-align: center;">608</td>
<td style="text-align: center;">iPhone X 螢幕 用 酒精 擦 過後 感覺 怪怪的</td>
</tr>
<tr class="odd">
<td style="text-align: center;">609</td>
<td style="text-align: center;">i8 摔 到 後 有點 怪怪的</td>
</tr>
<tr class="even">
<td style="text-align: center;">610</td>
<td style="text-align: center;">Line 閃退</td>
</tr>
<tr class="odd">
<td style="text-align: center;">611</td>
<td style="text-align: center;">Innergie 27 M 跟 原廠 18 W 充電器 比較</td>
</tr>
<tr class="even">
<td style="text-align: center;">612</td>
<td style="text-align: center;">請問 有 相同 狀況 的 人嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">613</td>
<td style="text-align: center;">要 怎麼 分辨 APPLE 網路 郵件 的 真假</td>
</tr>
<tr class="even">
<td style="text-align: center;">614</td>
<td style="text-align: center;">Razer Arctech 散熱 手機 殼 不僅 信仰 也 有 實效</td>
</tr>
<tr class="odd">
<td style="text-align: center;">615</td>
<td style="text-align: center;">Element Case Black Ops for iphone 11 pro max 使用 心得 2020.01.22 新增 VAPOR S 藍色</td>
</tr>
<tr class="even">
<td style="text-align: center;">616</td>
<td style="text-align: center;">跪求 犀牛 盾 1 月 的 生日 折扣 碼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">617</td>
<td style="text-align: center;">媽 網路 有人 賣 iPhone 8 Plus 只要 二千 給我錢</td>
</tr>
<tr class="even">
<td style="text-align: center;">618</td>
<td style="text-align: center;">實測 證實 iPhone 11 Pro 夜間 模式 怪怪的</td>
</tr>
<tr class="odd">
<td style="text-align: center;">619</td>
<td style="text-align: center;">安卓 手機 轉來 蘋果 能 轉移 過來 的 帳號 有 哪些</td>
</tr>
<tr class="even">
<td style="text-align: center;">620</td>
<td style="text-align: center;">請問 qq 音樂 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">621</td>
<td style="text-align: center;">行動 數據 無 預警 斷線</td>
</tr>
<tr class="even">
<td style="text-align: center;">622</td>
<td style="text-align: center;">充電 時 畫面 黑屏 凍結</td>
</tr>
<tr class="odd">
<td style="text-align: center;">623</td>
<td style="text-align: center;">Apple ID 更換 與 app 更新 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">624</td>
<td style="text-align: center;">徵求 犀牛 盾 1 月 生日 禮金</td>
</tr>
<tr class="odd">
<td style="text-align: center;">625</td>
<td style="text-align: center;">無法 更新 app</td>
</tr>
<tr class="even">
<td style="text-align: center;">626</td>
<td style="text-align: center;">有關 回收 舊 IPHONE</td>
</tr>
<tr class="odd">
<td style="text-align: center;">627</td>
<td style="text-align: center;">徵求 一月份 犀牛 盾 生日 禮金</td>
</tr>
<tr class="even">
<td style="text-align: center;">628</td>
<td style="text-align: center;">如何 取消 自動 出現 最近 聯絡人 名單</td>
</tr>
<tr class="odd">
<td style="text-align: center;">629</td>
<td style="text-align: center;">iPhone 8 通話 中 突然 斷訊</td>
</tr>
<tr class="even">
<td style="text-align: center;">630</td>
<td style="text-align: center;">美國 買 iphone 手機</td>
</tr>
<tr class="odd">
<td style="text-align: center;">631</td>
<td style="text-align: center;">IOS 家庭 分享 設定</td>
</tr>
<tr class="even">
<td style="text-align: center;">632</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">633</td>
<td style="text-align: center;">iphone 11 拍攝</td>
</tr>
<tr class="even">
<td style="text-align: center;">634</td>
<td style="text-align: center;">7 plus</td>
</tr>
<tr class="odd">
<td style="text-align: center;">635</td>
<td style="text-align: center;">iPhone 7 會 自己 重新 啟動 多次 同時 電池 掉電</td>
</tr>
<tr class="even">
<td style="text-align: center;">636</td>
<td style="text-align: center;">通話 封鎖 與 識別 不見 了</td>
</tr>
<tr class="odd">
<td style="text-align: center;">637</td>
<td style="text-align: center;">強力 不 推薦 樂天 的 愛買線 上 購物 買 IPHONE 11 經驗談</td>
</tr>
<tr class="even">
<td style="text-align: center;">638</td>
<td style="text-align: center;">安卓 裝置 轉入 ios 系統 後 無法 編輯 照片</td>
</tr>
<tr class="odd">
<td style="text-align: center;">639</td>
<td style="text-align: center;">求救 出 已 停用 iphone 的 照片 等 資訊 拆機 破壞 可</td>
</tr>
<tr class="even">
<td style="text-align: center;">640</td>
<td style="text-align: center;">請問 I PHONE 11 PRO MAX 的 散熱</td>
</tr>
<tr class="odd">
<td style="text-align: center;">641</td>
<td style="text-align: center;">iPhone 11 pro</td>
</tr>
<tr class="even">
<td style="text-align: center;">642</td>
<td style="text-align: center;">iOS 13 照片 編輯 自動 修正</td>
</tr>
<tr class="odd">
<td style="text-align: center;">643</td>
<td style="text-align: center;">esim 的 優缺點</td>
</tr>
<tr class="even">
<td style="text-align: center;">644</td>
<td style="text-align: center;">PD 快充 線材 選擇</td>
</tr>
<tr class="odd">
<td style="text-align: center;">645</td>
<td style="text-align: center;">iPhone MDM</td>
</tr>
<tr class="even">
<td style="text-align: center;">646</td>
<td style="text-align: center;">iPhone11 使用 擴音 講 電話 時 對方 會 有 嚴重 回音</td>
</tr>
<tr class="odd">
<td style="text-align: center;">647</td>
<td style="text-align: center;">這 就是 iPhone 為 什麼 比較 重 的 原因</td>
</tr>
<tr class="even">
<td style="text-align: center;">648</td>
<td style="text-align: center;">有人 有 遇過 這種 狀況 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">649</td>
<td style="text-align: center;">Iphone 充電 線 請教</td>
</tr>
<tr class="even">
<td style="text-align: center;">650</td>
<td style="text-align: center;">請問 圖中 icloud 佔用 的 空間 如何 釋放</td>
</tr>
<tr class="odd">
<td style="text-align: center;">651</td>
<td style="text-align: center;">iPhone 11 pro max 4 g 網路 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">652</td>
<td style="text-align: center;">iphone XR 使用 usb c 會 充壞 手機</td>
</tr>
<tr class="odd">
<td style="text-align: center;">653</td>
<td style="text-align: center;">台灣 買 iphone 帶去 國外 的 保固 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">654</td>
<td style="text-align: center;">有人 知道 griffin 這間 iphone 配件 品牌 的 台灣 代理商 是 誰嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">655</td>
<td style="text-align: center;">IOS 13.3 LINE 來電 不想 鈴 等 對方 掛掉 才 跳出 未接 來電 通知</td>
</tr>
<tr class="even">
<td style="text-align: center;">656</td>
<td style="text-align: center;">iphone11 手機 殼 推薦</td>
</tr>
<tr class="odd">
<td style="text-align: center;">657</td>
<td style="text-align: center;">iphone wifi 速度 很慢</td>
</tr>
<tr class="even">
<td style="text-align: center;">658</td>
<td style="text-align: center;">iPhone 11 Pro Max 熱點 分享 問題 剛剛 致電 蘋果 客服 建議 處理方式</td>
</tr>
<tr class="odd">
<td style="text-align: center;">659</td>
<td style="text-align: center;">iOS 13.3.1 Developer Beta 2</td>
</tr>
<tr class="even">
<td style="text-align: center;">660</td>
<td style="text-align: center;">iOS 13.3.1 Developer Beta 2 更新</td>
</tr>
<tr class="odd">
<td style="text-align: center;">661</td>
<td style="text-align: center;">iPhone garmin 導航 的 圖資 下載 不了</td>
</tr>
<tr class="even">
<td style="text-align: center;">662</td>
<td style="text-align: center;">ios13 3.1 beta 版本 3 個 禮拜 沒 更新 了</td>
</tr>
<tr class="odd">
<td style="text-align: center;">663</td>
<td style="text-align: center;">徵求 犀牛 盾 1 月 生日 禮金</td>
</tr>
<tr class="even">
<td style="text-align: center;">664</td>
<td style="text-align: center;">App Store 更新 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">665</td>
<td style="text-align: center;">跪求 犀牛 盾 1 月份 生日 禮金</td>
</tr>
<tr class="even">
<td style="text-align: center;">666</td>
<td style="text-align: center;">每年 9 月 iPhone 新機 上市 舊款 降價 資訊</td>
</tr>
<tr class="odd">
<td style="text-align: center;">667</td>
<td style="text-align: center;">徵求 犀牛 盾 1 月 生日 禮金 謝謝</td>
</tr>
<tr class="even">
<td style="text-align: center;">668</td>
<td style="text-align: center;">iPhone XS Max Google 相簿 影片 無法 下載 已 解決</td>
</tr>
<tr class="odd">
<td style="text-align: center;">669</td>
<td style="text-align: center;">iPhone XR 中華 亞太 esim 網路 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">670</td>
<td style="text-align: center;">慶祝 新年 蘋果 新春 電影 女儿 上映 由 周迅 主演 iPhone 11 Pro 拍攝</td>
</tr>
<tr class="odd">
<td style="text-align: center;">671</td>
<td style="text-align: center;">問題 關於 Safari 解析 網頁 元件</td>
</tr>
<tr class="even">
<td style="text-align: center;">672</td>
<td style="text-align: center;">IphoneX</td>
</tr>
<tr class="odd">
<td style="text-align: center;">673</td>
<td style="text-align: center;">iPhone xr 值得 升級 iPhone 11 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">674</td>
<td style="text-align: center;">蘋果 以 iPhone 11 Pro 拍攝 新年 微 電影 女兒</td>
</tr>
<tr class="odd">
<td style="text-align: center;">675</td>
<td style="text-align: center;">關於 11 pro max 夜拍 功能</td>
</tr>
<tr class="even">
<td style="text-align: center;">676</td>
<td style="text-align: center;">我 也 想要 徵求 犀牛 盾 一月 生日 禮金</td>
</tr>
<tr class="odd">
<td style="text-align: center;">677</td>
<td style="text-align: center;">求助 line 來電 1 小時 後 才 響</td>
</tr>
<tr class="even">
<td style="text-align: center;">678</td>
<td style="text-align: center;">如何 將 iphone 手機 儲存 的 照片 分類 直接 儲存 到 電腦 備份</td>
</tr>
<tr class="odd">
<td style="text-align: center;">679</td>
<td style="text-align: center;">iphone 11 pro 不斷 定位</td>
</tr>
<tr class="even">
<td style="text-align: center;">680</td>
<td style="text-align: center;">Xs Smart Battery Case 開箱</td>
</tr>
<tr class="odd">
<td style="text-align: center;">681</td>
<td style="text-align: center;">iPhone XS Max 無法 同步</td>
</tr>
<tr class="even">
<td style="text-align: center;">682</td>
<td style="text-align: center;">iPhone 11 11 pro max</td>
</tr>
<tr class="odd">
<td style="text-align: center;">683</td>
<td style="text-align: center;">iPhone XS Max</td>
</tr>
<tr class="even">
<td style="text-align: center;">684</td>
<td style="text-align: center;">xr 充了 整晚 電 早上 還是 沒電</td>
</tr>
<tr class="odd">
<td style="text-align: center;">685</td>
<td style="text-align: center;">Youtube 的 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">686</td>
<td style="text-align: center;">徵求 犀牛 盾 一月 生日 禮金</td>
</tr>
<tr class="odd">
<td style="text-align: center;">687</td>
<td style="text-align: center;">手機 保固 內不給修</td>
</tr>
<tr class="even">
<td style="text-align: center;">688</td>
<td style="text-align: center;">分享 iphone 系列 手機 好用 的 廣角鏡頭 及 加倍 鏡</td>
</tr>
<tr class="odd">
<td style="text-align: center;">689</td>
<td style="text-align: center;">分享 XR 透背 保護 殼 by Ringke Fusion 與 Fusion X 與 Onyx 系列</td>
</tr>
<tr class="even">
<td style="text-align: center;">690</td>
<td style="text-align: center;">i11 開 幾個 程式 瘋狂 閃退</td>
</tr>
<tr class="odd">
<td style="text-align: center;">691</td>
<td style="text-align: center;">iPhone XS Max 的 otterbox 炫彩 幾何 透明 保護 殼 經典 晶透 保護 殼 用 了 一年 開口笑</td>
</tr>
<tr class="even">
<td style="text-align: center;">692</td>
<td style="text-align: center;">iphone 11 pro 與 apple watch 4 的 聯動</td>
</tr>
<tr class="odd">
<td style="text-align: center;">693</td>
<td style="text-align: center;">iPhone 的 注音 鍵盤 排列</td>
</tr>
<tr class="even">
<td style="text-align: center;">694</td>
<td style="text-align: center;">請教 一下 剛剛 在 玩 iphone 11 來電 時 鈴聲 正常 手握手 機 聲音 會 變小 這 功能 有 辦法 取消 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">695</td>
<td style="text-align: center;">iphone8 的 line 的 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">696</td>
<td style="text-align: center;">iPhone 6 螢幕 全黑 沒 反應 但 插 充電 線有 聲音</td>
</tr>
<tr class="odd">
<td style="text-align: center;">697</td>
<td style="text-align: center;">i11 錄影 一直 閃爍</td>
</tr>
<tr class="even">
<td style="text-align: center;">698</td>
<td style="text-align: center;">iPhone X max 快充 求解</td>
</tr>
<tr class="odd">
<td style="text-align: center;">699</td>
<td style="text-align: center;">iPhone 7 Plus 尋求 不 影響 光源 感應器 的 鋼化 膜</td>
</tr>
<tr class="even">
<td style="text-align: center;">700</td>
<td style="text-align: center;">i11 64 G 使用 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">701</td>
<td style="text-align: center;">如何 保護 11 系列 相機 呢</td>
</tr>
<tr class="even">
<td style="text-align: center;">702</td>
<td style="text-align: center;">iphone11 使用 google map 耗電 快</td>
</tr>
<tr class="odd">
<td style="text-align: center;">703</td>
<td style="text-align: center;">全機 包膜 後 有沒有 適合 的 軟殼 透明 而且 是 邊框 的 殼</td>
</tr>
<tr class="even">
<td style="text-align: center;">704</td>
<td style="text-align: center;">好像 沒什麼 人 討論 手機 架</td>
</tr>
<tr class="odd">
<td style="text-align: center;">705</td>
<td style="text-align: center;">此 國家 無法 使用 Line out 錯誤 訊息</td>
</tr>
<tr class="even">
<td style="text-align: center;">706</td>
<td style="text-align: center;">想問 一下 有關 LINE 的 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">707</td>
<td style="text-align: center;">iPhone11 裝殼 後 無法 平穩 的 放在 桌上</td>
</tr>
<tr class="even">
<td style="text-align: center;">708</td>
<td style="text-align: center;">iPhone 11 Pro Max 藍牙 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">709</td>
<td style="text-align: center;">求救 此 問題 是 什麼 狀況 siri 也 不能 用</td>
</tr>
<tr class="even">
<td style="text-align: center;">710</td>
<td style="text-align: center;">買 了 蘋果 以後 是不是 就 別裝 google 那些 程式</td>
</tr>
<tr class="odd">
<td style="text-align: center;">711</td>
<td style="text-align: center;">iOS 13.3 YouTube 播放 解析度 及 USB 傳檔 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">712</td>
<td style="text-align: center;">iphone11 pro 使用 舊 充電 線</td>
</tr>
<tr class="odd">
<td style="text-align: center;">713</td>
<td style="text-align: center;">line 來電 手機 沒 反應</td>
</tr>
<tr class="even">
<td style="text-align: center;">714</td>
<td style="text-align: center;">請問 有人 用過 勁量 電池 的 行動 電源 嗎 謝謝</td>
</tr>
<tr class="odd">
<td style="text-align: center;">715</td>
<td style="text-align: center;">iPhone 11 控制中心 無法 播放 音樂</td>
</tr>
<tr class="even">
<td style="text-align: center;">716</td>
<td style="text-align: center;">請問 如何 關閉 iphone 整合 通話</td>
</tr>
<tr class="odd">
<td style="text-align: center;">717</td>
<td style="text-align: center;">蘋果 真的 有 可能 出 平價 機 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">718</td>
<td style="text-align: center;">SGP ultra hybrid 保護 殼 不 衝突 的 保護 貼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">719</td>
<td style="text-align: center;">iOS13 1 捷徑 自動化 執行 沒有 自動 執行</td>
</tr>
<tr class="even">
<td style="text-align: center;">720</td>
<td style="text-align: center;">iphone 6 ios 12.4.3 玩遊戲 真的 是 閃 退王</td>
</tr>
<tr class="odd">
<td style="text-align: center;">721</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">722</td>
<td style="text-align: center;">I 11 螢幕 解鎖 延遲</td>
</tr>
<tr class="odd">
<td style="text-align: center;">723</td>
<td style="text-align: center;">iPhone 11 Pro max 相機 倍率</td>
</tr>
<tr class="even">
<td style="text-align: center;">724</td>
<td style="text-align: center;">手機 更新 完 螢幕 亮度 變黃</td>
</tr>
<tr class="odd">
<td style="text-align: center;">725</td>
<td style="text-align: center;">有人 研究 過 無線 充電 線圈 擺放 位置 的 相對效率 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">726</td>
<td style="text-align: center;">ios 13.3 熱點 分享 無法 正常 連線</td>
</tr>
<tr class="odd">
<td style="text-align: center;">727</td>
<td style="text-align: center;">我 相信 庫克 不會 打臉 自己</td>
</tr>
<tr class="even">
<td style="text-align: center;">728</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">729</td>
<td style="text-align: center;">iphone 可以 使用 它牌 充電器 快 充嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">730</td>
<td style="text-align: center;">IPHONE 6 S 換 電池 經驗 分享 相機 失效 電池 差異 照片</td>
</tr>
<tr class="odd">
<td style="text-align: center;">731</td>
<td style="text-align: center;">iphone 螢幕 使用 時間 怎麼 看 超時</td>
</tr>
<tr class="even">
<td style="text-align: center;">732</td>
<td style="text-align: center;">關於 FB Messenger 切換 帳號</td>
</tr>
<tr class="odd">
<td style="text-align: center;">733</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">734</td>
<td style="text-align: center;">關於 提醒 事項 App 的 時間 設定</td>
</tr>
<tr class="odd">
<td style="text-align: center;">735</td>
<td style="text-align: center;">iPhone 相機 適合 用來 拍 開箱 文嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">736</td>
<td style="text-align: center;">iOS 13.3.1 Developer Beta 1 更新</td>
</tr>
<tr class="odd">
<td style="text-align: center;">737</td>
<td style="text-align: center;">iPhone 6 s 自行 刪除 遊戲 檔案</td>
</tr>
<tr class="even">
<td style="text-align: center;">738</td>
<td style="text-align: center;">音樂 app 未 顯示 最近 播放歌曲</td>
</tr>
<tr class="odd">
<td style="text-align: center;">739</td>
<td style="text-align: center;">有 什麼 是 以前 安 卓有 果迷 說 很廢 然後 蘋果 出 又 變好 棒棒 了</td>
</tr>
<tr class="even">
<td style="text-align: center;">740</td>
<td style="text-align: center;">求救 iphone 語音 備忘錄 無法 播放</td>
</tr>
<tr class="odd">
<td style="text-align: center;">741</td>
<td style="text-align: center;">iphone 11 pro 三顆 鏡頭 都 能 錄影 4 k 60 fps 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">742</td>
<td style="text-align: center;">關閉 iphone 相簿 同步 google 相簿</td>
</tr>
<tr class="odd">
<td style="text-align: center;">743</td>
<td style="text-align: center;">已 解決</td>
</tr>
<tr class="even">
<td style="text-align: center;">744</td>
<td style="text-align: center;">iPhone 12 支援 5 G 手機 價格 會漲 漲 多少 可以</td>
</tr>
<tr class="odd">
<td style="text-align: center;">745</td>
<td style="text-align: center;">iCloud 照片 同步 但 相簿 排序 亂掉</td>
</tr>
<tr class="even">
<td style="text-align: center;">746</td>
<td style="text-align: center;">iphone11 使用 行動 支付 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">747</td>
<td style="text-align: center;">Xs Max 後面 按壓 有 聲音</td>
</tr>
<tr class="even">
<td style="text-align: center;">748</td>
<td style="text-align: center;">無法 叫 siri 撥號</td>
</tr>
<tr class="odd">
<td style="text-align: center;">749</td>
<td style="text-align: center;">Google 相簿 的 分享 影片</td>
</tr>
<tr class="even">
<td style="text-align: center;">750</td>
<td style="text-align: center;">Apple Pay 將在 108 年底 前 支援 台鐵 閘門 進出 感應</td>
</tr>
<tr class="odd">
<td style="text-align: center;">751</td>
<td style="text-align: center;">已 解除 安裝 的 app 網路 流量 使用</td>
</tr>
<tr class="even">
<td style="text-align: center;">752</td>
<td style="text-align: center;">iPhone 8 連接 WIFI 超慢</td>
</tr>
<tr class="odd">
<td style="text-align: center;">753</td>
<td style="text-align: center;">臉部 辨識 Face ID 狀況 疑問</td>
</tr>
<tr class="even">
<td style="text-align: center;">754</td>
<td style="text-align: center;">前 鏡頭 如何 拍攝 景深 效果</td>
</tr>
<tr class="odd">
<td style="text-align: center;">755</td>
<td style="text-align: center;">IPHONE XS 容量 和 電腦 不 一樣</td>
</tr>
<tr class="even">
<td style="text-align: center;">756</td>
<td style="text-align: center;">APPLE Caudabe LUCID CLEAR 晶透 保護 殼 與 VEIL 超薄 裸機 殼 開箱</td>
</tr>
<tr class="odd">
<td style="text-align: center;">757</td>
<td style="text-align: center;">iPhone 6 還 可以 更新 耶</td>
</tr>
<tr class="even">
<td style="text-align: center;">758</td>
<td style="text-align: center;">請 推薦 透明 防 摔 殼 IPhone 11 Pro Max</td>
</tr>
<tr class="odd">
<td style="text-align: center;">759</td>
<td style="text-align: center;">IPhone11 裸機 想掛 吊飾 防塵 塞有 辦法 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">760</td>
<td style="text-align: center;">iphone11 pro max 瑕疵</td>
</tr>
<tr class="odd">
<td style="text-align: center;">761</td>
<td style="text-align: center;">有 推薦 的 iphone 付 掛繩 手機 殼嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">762</td>
<td style="text-align: center;">犀牛 盾 生日 禮金 優惠</td>
</tr>
<tr class="odd">
<td style="text-align: center;">763</td>
<td style="text-align: center;">如何 從 FaceID 快速 切換 成 密碼 解鎖</td>
</tr>
<tr class="even">
<td style="text-align: center;">764</td>
<td style="text-align: center;">iPhone 影片 傳到 電腦 開啟 後 只有 聲音 沒有 畫面</td>
</tr>
<tr class="odd">
<td style="text-align: center;">765</td>
<td style="text-align: center;">請問 iphone11 的 音量 大小 按鈕</td>
</tr>
<tr class="even">
<td style="text-align: center;">766</td>
<td style="text-align: center;">11 pro 相簿 圖片 無法 下載 到 電腦</td>
</tr>
<tr class="odd">
<td style="text-align: center;">767</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">768</td>
<td style="text-align: center;">如何 永久 移 除掉 Apple Pay 裡 曾經 加入 過的 卡片</td>
</tr>
<tr class="odd">
<td style="text-align: center;">769</td>
<td style="text-align: center;">無發 驗證 更新 項目</td>
</tr>
<tr class="even">
<td style="text-align: center;">770</td>
<td style="text-align: center;">急 iphone 聲音 檔 打不開</td>
</tr>
<tr class="odd">
<td style="text-align: center;">771</td>
<td style="text-align: center;">ios 可以 顯示 流量 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">772</td>
<td style="text-align: center;">來電 畫面 的 bug</td>
</tr>
<tr class="odd">
<td style="text-align: center;">773</td>
<td style="text-align: center;">000000000000000</td>
</tr>
<tr class="even">
<td style="text-align: center;">774</td>
<td style="text-align: center;">GPS 定位 開關</td>
</tr>
<tr class="odd">
<td style="text-align: center;">775</td>
<td style="text-align: center;">AirPods2 切換 時有 啪 聲</td>
</tr>
<tr class="even">
<td style="text-align: center;">776</td>
<td style="text-align: center;">Iphone X 電池 最大 容量 97 健康 度 已 明顯降低</td>
</tr>
<tr class="odd">
<td style="text-align: center;">777</td>
<td style="text-align: center;">有人 iPhone 透過 USB 接到 MACBook Pro 充電 會 斷斷續續 的嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">778</td>
<td style="text-align: center;">iPhone 6 s 更新 到 13.3</td>
</tr>
<tr class="odd">
<td style="text-align: center;">779</td>
<td style="text-align: center;">iphone11 夜拍 有 暗角</td>
</tr>
<tr class="even">
<td style="text-align: center;">780</td>
<td style="text-align: center;">iPhoneX 的 電池</td>
</tr>
<tr class="odd">
<td style="text-align: center;">781</td>
<td style="text-align: center;">沒設 鬧鐘 iphone 卻 自動 把 我 叫醒</td>
</tr>
<tr class="even">
<td style="text-align: center;">782</td>
<td style="text-align: center;">請問 XS max 臉部 解鎖 後 能 不往 上 滑 直接 進主 畫面 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">783</td>
<td style="text-align: center;">iphone11 有沒有 更新 ios13 3 的 人</td>
</tr>
<tr class="even">
<td style="text-align: center;">784</td>
<td style="text-align: center;">Iphone 5 S DIY 更換 電池 後</td>
</tr>
<tr class="odd">
<td style="text-align: center;">785</td>
<td style="text-align: center;">13.3 XR 更改 LINE 鈴聲 改不 過去</td>
</tr>
<tr class="even">
<td style="text-align: center;">786</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">787</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">788</td>
<td style="text-align: center;">iphone11 錄影 品質</td>
</tr>
<tr class="odd">
<td style="text-align: center;">789</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">790</td>
<td style="text-align: center;">iphone8 是不是 已經 無法 升到 iOS 12. x</td>
</tr>
<tr class="odd">
<td style="text-align: center;">791</td>
<td style="text-align: center;">ios 13 更新 超 耗電 發燙</td>
</tr>
<tr class="even">
<td style="text-align: center;">792</td>
<td style="text-align: center;">6 S 如何 從 12.4 升到 12.4.4</td>
</tr>
<tr class="odd">
<td style="text-align: center;">793</td>
<td style="text-align: center;">舊 手機 轉 新手機 無法 移轉</td>
</tr>
<tr class="even">
<td style="text-align: center;">794</td>
<td style="text-align: center;">手機 無 使用 狀態 下 電力 一直 掉</td>
</tr>
<tr class="odd">
<td style="text-align: center;">795</td>
<td style="text-align: center;">iPhone Mixerbox3 關閉 螢幕 會 停止 播放</td>
</tr>
<tr class="even">
<td style="text-align: center;">796</td>
<td style="text-align: center;">iphone11 的 GPS 定位問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">797</td>
<td style="text-align: center;">大陸 牌 都 來 致敬 Apple</td>
</tr>
<tr class="even">
<td style="text-align: center;">798</td>
<td style="text-align: center;">關於 官網 的 退貨</td>
</tr>
<tr class="odd">
<td style="text-align: center;">799</td>
<td style="text-align: center;">男生 都 是 拿 Iphone 11 pro 還是 max 居多</td>
</tr>
<tr class="even">
<td style="text-align: center;">800</td>
<td style="text-align: center;">晚上 鎖定 畫面 都 會 變暗 可以 調亮嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">801</td>
<td style="text-align: center;">apple ID 一直 無法 登入 ip not in subnet range</td>
</tr>
<tr class="even">
<td style="text-align: center;">802</td>
<td style="text-align: center;">請問 IPHONE 解鎖 跟 備料 的 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">803</td>
<td style="text-align: center;">想 請問 先進 iphone 鏡射 到 電視 上 除了 appleTV 還有 沒有 買 了 不 後悔 的 選擇</td>
</tr>
<tr class="even">
<td style="text-align: center;">804</td>
<td style="text-align: center;">指南針</td>
</tr>
<tr class="odd">
<td style="text-align: center;">805</td>
<td style="text-align: center;">大家 來 分享 一下 耗電 吧</td>
</tr>
<tr class="even">
<td style="text-align: center;">806</td>
<td style="text-align: center;">電池 小 工具 不見 了</td>
</tr>
<tr class="odd">
<td style="text-align: center;">807</td>
<td style="text-align: center;">請問 這 顯示 要 如何 關閉</td>
</tr>
<tr class="even">
<td style="text-align: center;">808</td>
<td style="text-align: center;">qq 註冊 系統 繁忙</td>
</tr>
<tr class="odd">
<td style="text-align: center;">809</td>
<td style="text-align: center;">Andromoney 匯入 出 裡 同步 備份 CSV 的 差別 和 目的 是 什麼 呢</td>
</tr>
<tr class="even">
<td style="text-align: center;">810</td>
<td style="text-align: center;">i7 iOS 13.1.3 異常 耗電</td>
</tr>
<tr class="odd">
<td style="text-align: center;">811</td>
<td style="text-align: center;">ios13 耗電</td>
</tr>
<tr class="even">
<td style="text-align: center;">812</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">813</td>
<td style="text-align: center;">日版 iphone11 pro max 跟 台版 晶片 一樣 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">814</td>
<td style="text-align: center;">大家 怎麼 選擇 iphone 11 跟 iphone 11 pro 的 呢</td>
</tr>
<tr class="odd">
<td style="text-align: center;">815</td>
<td style="text-align: center;">要 怎樣 擋掉 youtube 上 廣告</td>
</tr>
<tr class="even">
<td style="text-align: center;">816</td>
<td style="text-align: center;">關於 iclud 備份</td>
</tr>
<tr class="odd">
<td style="text-align: center;">817</td>
<td style="text-align: center;">siri 畫面</td>
</tr>
<tr class="even">
<td style="text-align: center;">818</td>
<td style="text-align: center;">Line 雙開</td>
</tr>
<tr class="odd">
<td style="text-align: center;">819</td>
<td style="text-align: center;">手機 用 icloud 備份 遇到 的 難題 急</td>
</tr>
<tr class="even">
<td style="text-align: center;">820</td>
<td style="text-align: center;">iPhone4 7 寸 的 抉擇</td>
</tr>
<tr class="odd">
<td style="text-align: center;">821</td>
<td style="text-align: center;">廢文 一篇</td>
</tr>
<tr class="even">
<td style="text-align: center;">822</td>
<td style="text-align: center;">iCloud 照片 檔案 名稱 問題 大家 都 怎麼 整理 跟 分類 照片 的</td>
</tr>
<tr class="odd">
<td style="text-align: center;">823</td>
<td style="text-align: center;">iOS 13.3.1 Developer Beta</td>
</tr>
<tr class="even">
<td style="text-align: center;">824</td>
<td style="text-align: center;">過保 iphone8 64 g 的 殘值</td>
</tr>
<tr class="odd">
<td style="text-align: center;">825</td>
<td style="text-align: center;">facebook 按 讚 聲 會 忽大忽小</td>
</tr>
<tr class="even">
<td style="text-align: center;">826</td>
<td style="text-align: center;">11 PRO 訊號 不穩</td>
</tr>
<tr class="odd">
<td style="text-align: center;">827</td>
<td style="text-align: center;">有關 IPhone SE 一直 重 開機 的 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">828</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">829</td>
<td style="text-align: center;">這是 為 什麼 iPhone 的 螢幕 將 永遠 是 3.5 吋 的 原因</td>
</tr>
<tr class="even">
<td style="text-align: center;">830</td>
<td style="text-align: center;">看到 隔壁 樓 6 s 用 好久 有感而發</td>
</tr>
<tr class="odd">
<td style="text-align: center;">831</td>
<td style="text-align: center;">iclod 照片 一直 卡 在 1</td>
</tr>
<tr class="even">
<td style="text-align: center;">832</td>
<td style="text-align: center;">女友 每個 禮拜 會用 酒精 消毒 手機 前 幾天 她 說 她 兩支 手機 觸碰 被 用到 秀逗 想 起來 覺得 是 用 了 酒精 的 關係</td>
</tr>
<tr class="odd">
<td style="text-align: center;">833</td>
<td style="text-align: center;">11 pro 更新 13.3</td>
</tr>
<tr class="even">
<td style="text-align: center;">834</td>
<td style="text-align: center;">請問 為何 iPhone 使用 line 跟 別人 視訊 別人 看到 我 的 畫面 會 變成 黑白 的 影像</td>
</tr>
<tr class="odd">
<td style="text-align: center;">835</td>
<td style="text-align: center;">時間 顯示 在 螢幕</td>
</tr>
<tr class="even">
<td style="text-align: center;">836</td>
<td style="text-align: center;">請問 I phone 6 電池 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">837</td>
<td style="text-align: center;">分享 不會 駛船 嫌溪 彎 升級 IOS11 iPhon7 HEIC 格式 2019 更新</td>
</tr>
<tr class="even">
<td style="text-align: center;">838</td>
<td style="text-align: center;">11 PRO MAX 個人 熱點 分享 問題</td>
</tr>
<tr class="odd">
<td style="text-align: center;">839</td>
<td style="text-align: center;">Iphone 11 缺點</td>
</tr>
<tr class="even">
<td style="text-align: center;">840</td>
<td style="text-align: center;">照片 影片 匯出 到 電腦 有 辦法 部分 匯出 後 立即 刪除 部分 手機 空間 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">841</td>
<td style="text-align: center;">iPhone XR 更新 至 13.3 無法 使用 英文</td>
</tr>
<tr class="even">
<td style="text-align: center;">842</td>
<td style="text-align: center;">iPhone 卡貼</td>
</tr>
<tr class="odd">
<td style="text-align: center;">843</td>
<td style="text-align: center;">有關 雙重 認證</td>
</tr>
<tr class="even">
<td style="text-align: center;">844</td>
<td style="text-align: center;">無限 網路 與 WIFI 開啟 後 無 網路</td>
</tr>
<tr class="odd">
<td style="text-align: center;">845</td>
<td style="text-align: center;">iPhone XR 關機 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">846</td>
<td style="text-align: center;">自動更新 問題 請教</td>
</tr>
<tr class="odd">
<td style="text-align: center;">847</td>
<td style="text-align: center;">請問 Line 轉移 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">848</td>
<td style="text-align: center;">請問 關於 iOS 捷徑</td>
</tr>
<tr class="odd">
<td style="text-align: center;">849</td>
<td style="text-align: center;">iphones 截圖 後 標記 存檔 常會 掉 了 標記 只 剩 截圖 Orz</td>
</tr>
<tr class="even">
<td style="text-align: center;">850</td>
<td style="text-align: center;">IPHONE 11 PRO MAX 相機 有時候 開啟 螢幕 會 卡住 有人 有 這種 情況 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">851</td>
<td style="text-align: center;">i11 更新 到 13.3 4 G 斷線 問題 已 改善</td>
</tr>
<tr class="even">
<td style="text-align: center;">852</td>
<td style="text-align: center;">Iphone11 Pro max 手機 出 問題 一堆 求解</td>
</tr>
<tr class="odd">
<td style="text-align: center;">853</td>
<td style="text-align: center;">eSIM 問題 請教</td>
</tr>
<tr class="even">
<td style="text-align: center;">854</td>
<td style="text-align: center;">請問 目前 市價 35200 的 iphone11 pro max 64 G 若 現在 買 後 一個月 內 脫手 可以 賣 多少</td>
</tr>
<tr class="odd">
<td style="text-align: center;">855</td>
<td style="text-align: center;">iphone x 13.3 熱點 分享</td>
</tr>
<tr class="even">
<td style="text-align: center;">856</td>
<td style="text-align: center;">為 什麼 itunes 更新 ota 更新 都 能 激烈 爭辯</td>
</tr>
<tr class="odd">
<td style="text-align: center;">857</td>
<td style="text-align: center;">iphone 11 顏色 選擇 障礙</td>
</tr>
<tr class="even">
<td style="text-align: center;">858</td>
<td style="text-align: center;">首次 使用 IPHONE 手機 型號 為 11 PRO MAX 多處 地方 不解 懇請 前備 賜教 謝謝 先</td>
</tr>
<tr class="odd">
<td style="text-align: center;">859</td>
<td style="text-align: center;">I Phone 11 pro max 衛星 導航 問題</td>
</tr>
<tr class="even">
<td style="text-align: center;">860</td>
<td style="text-align: center;">iTunes 刷機 與 OTA 更新 有 差別 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">861</td>
<td style="text-align: center;">關於 iphone 移除 鏡頭</td>
</tr>
<tr class="even">
<td style="text-align: center;">862</td>
<td style="text-align: center;">App store 退款 失敗</td>
</tr>
<tr class="odd">
<td style="text-align: center;">863</td>
<td style="text-align: center;">i11 pro max 更新 後 4 g 不穩</td>
</tr>
<tr class="even">
<td style="text-align: center;">864</td>
<td style="text-align: center;">iphone 11 問題 請教 最 上面 時間 訊號 電量 欄位 往 下移</td>
</tr>
<tr class="odd">
<td style="text-align: center;">865</td>
<td style="text-align: center;">iPhone 8 原廠 電池 更換 台 中</td>
</tr>
<tr class="even">
<td style="text-align: center;">866</td>
<td style="text-align: center;">ios 13.2.2 求 垃圾桶 郵件 如何 一鍵 全刪</td>
</tr>
<tr class="odd">
<td style="text-align: center;">867</td>
<td style="text-align: center;">開 safari 瀏覽器 時 右邊 會 出現 一條</td>
</tr>
<tr class="even">
<td style="text-align: center;">868</td>
<td style="text-align: center;">鎖定 螢幕 之下 如何 叫 出嘿 Siri</td>
</tr>
<tr class="odd">
<td style="text-align: center;">869</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">870</td>
<td style="text-align: center;">手機 續航力 膨風 最扯 的 竟是 這款</td>
</tr>
<tr class="odd">
<td style="text-align: center;">871</td>
<td style="text-align: center;">iPhone 升 iOS 13.3 省電 還是 耗電 國外 實測</td>
</tr>
<tr class="even">
<td style="text-align: center;">872</td>
<td style="text-align: center;">如何 在 手機 上 使用 Chrome 搜尋 圖片 的 功能</td>
</tr>
<tr class="odd">
<td style="text-align: center;">873</td>
<td style="text-align: center;">求救 USB 無線 網卡 無法 與 iPhone11 搭配</td>
</tr>
<tr class="even">
<td style="text-align: center;">874</td>
<td style="text-align: center;">iphone 11 line 閃退</td>
</tr>
<tr class="odd">
<td style="text-align: center;">875</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="even">
<td style="text-align: center;">876</td>
<td style="text-align: center;">一堆 人 罵 line 鈴聲 不 通知 那 請問</td>
</tr>
<tr class="odd">
<td style="text-align: center;">877</td>
<td style="text-align: center;">iphone 分享 出來 的 網路 不算 wifi</td>
</tr>
<tr class="even">
<td style="text-align: center;">878</td>
<td style="text-align: center;">請問 apple pay 能 跨國 使用 嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">879</td>
<td style="text-align: center;">抗 指紋 保護 貼 推薦</td>
</tr>
<tr class="even">
<td style="text-align: center;">880</td>
<td style="text-align: center;">IOS 13.3 釋出 了 有人 衝了嗎</td>
</tr>
<tr class="odd">
<td style="text-align: center;">881</td>
<td style="text-align: center;">iPhone SE 後繼機 不 叫 iPhone SE2 是 iphone 9</td>
</tr>
<tr class="even">
<td style="text-align: center;">882</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">883</td>
<td style="text-align: center;">I 11 更新 13.3 後</td>
</tr>
<tr class="even">
<td style="text-align: center;">884</td>
<td style="text-align: center;">可以 辨識 Deep Fusion 照片 的 app Metapho</td>
</tr>
<tr class="odd">
<td style="text-align: center;">885</td>
<td style="text-align: center;">更新 到 13.3 解鎖 密碼 一直 錯誤</td>
</tr>
<tr class="even">
<td style="text-align: center;">886</td>
<td style="text-align: center;">13.3 版 切換 app 時 的 頓挫 感</td>
</tr>
<tr class="odd">
<td style="text-align: center;">887</td>
<td style="text-align: center;">Apple 會 儘快 修復 新版 iOS 中 家長 控制 能 被 輕易 饒過 的 漏洞</td>
</tr>
<tr class="even">
<td style="text-align: center;">888</td>
<td style="text-align: center;">重置 完成 後</td>
</tr>
<tr class="odd">
<td style="text-align: center;">889</td>
<td style="text-align: center;">iOS13 3 基帶 版號 有 改 嗎</td>
</tr>
<tr class="even">
<td style="text-align: center;">890</td>
<td style="text-align: center;">iPhone 11 256 G Airplay 按 下去 凍結</td>
</tr>
<tr class="odd">
<td style="text-align: center;">891</td>
<td style="text-align: center;">iOS 13.3</td>
</tr>
<tr class="even">
<td style="text-align: center;">892</td>
<td style="text-align: center;">相機 膠卷 所有 照片 在 哪 呢</td>
</tr>
<tr class="odd">
<td style="text-align: center;">893</td>
<td style="text-align: center;">iPhone 傳 檔案 到 PC</td>
</tr>
<tr class="even">
<td style="text-align: center;">894</td>
<td style="text-align: center;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: center;">895</td>
<td style="text-align: center;">Apple iPhone 11 Pro Max 廣角 拍照 台中 輕并澤 公益 店</td>
</tr>
<tr class="even">
<td style="text-align: center;">896</td>
<td style="text-align: center;">iPhone AWB 自動 白平衡 正確性 測試</td>
</tr>
<tr class="odd">
<td style="text-align: center;">897</td>
<td style="text-align: center;">Iphone 11 Pro 開箱</td>
</tr>
<tr class="even">
<td style="text-align: center;">898</td>
<td style="text-align: center;">IPHONE7 PLUS</td>
</tr>
<tr class="odd">
<td style="text-align: center;">899</td>
<td style="text-align: center;">iPhone 11 Pro Cinematic 4 k Hokkaido 北海道 自駕</td>
</tr>
<tr class="even">
<td style="text-align: center;">900</td>
<td style="text-align: center;">電池 顯示 電量</td>
</tr>
<tr class="odd">
<td style="text-align: center;">901</td>
<td style="text-align: center;">感覺 被 耍 了 Apple tv</td>
</tr>
</tbody>
</table>

    docs_df

    ## # A tibble: 901 x 2
    ##    doc_id content                                                      
    ##     <int> <chr>                                                        
    ##  1      1 兩指 更 神速 10 個 iPhone iPad 雙指 操作 小 技巧 秒 選取 必學
    ##  2      2 iPhone 的 設計 逼 我 跳槽 安卓                               
    ##  3      3 買 iphone 11                                                 
    ##  4      4 iPhone 9 SE2 現身 網購 平台 通訊 行 也 能 買 的 到           
    ##  5      5 請問 6 s plus 32 g 還是 oppo r15 或 vivo x23                 
    ##  6      6 請益 iPhone 11 的 3 D 滿版 保護 貼 與 保護 殼 要 怎選        
    ##  7      7 IPHONE 9 的 新聞 算是 假新聞 嗎 要 不要 罰錢 呀              
    ##  8      8 想 請問 怎麼樣 充電 的 方式 對 哀鳳 手機 是 好的             
    ##  9      9 內建 悠遊 卡                                                 
    ## 10     10 Lightning 數位 AV 轉接 想 請教 一下 好用嗎                   
    ## # ... with 891 more rows

### 將 docs\_df 轉成 tidytext format

    library(tidytext)

    tidy_text_format <- docs_df %>%
      unnest_tokens(output = "word", input = "content",
                    token = "regex", pattern = " ")
    tidy_text_format

    ## # A tibble: 6,717 x 2
    ##    doc_id word  
    ##     <int> <chr> 
    ##  1      1 兩指  
    ##  2      1 更    
    ##  3      1 神速  
    ##  4      1 10    
    ##  5      1 個    
    ##  6      1 iphone
    ##  7      1 ipad  
    ##  8      1 雙指  
    ##  9      1 操作  
    ## 10      1 小    
    ## # ... with 6,707 more rows

### 4. 詞頻表

    # Equivalent to ...
    tidy_text_format %>%
      count(word) %>%
      arrange(desc(n))

    ## # A tibble: 2,043 x 2
    ##    word       n
    ##    <chr>  <int>
    ##  1 iphone   370
    ##  2 的       220
    ##  3 11       142
    ##  4 pro       92
    ##  5 問題      82
    ##  6 嗎        81
    ##  7 xs        72
    ##  8 max       64
    ##  9 手機      64
    ## 10 更新      59
    ## # ... with 2,033 more rows
