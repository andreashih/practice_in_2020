require(rvest)
require(dplyr)

# create a session
# 首先，第一個使用的url為有填寫登入帳號密碼的頁面
url.address <-"https://cool.ntu.edu.tw/login/portal" 

## 使用html_session建立一個session(session其實是用package所建立的，可以保持你在此網站互動的足跡，想更深入可以稍微瞭解一下http協定和這篇文章)
pgsession <-html_session(url.address)
## 抓取填寫帳密欄位的表格（這邊的2是要根據每個人所登入的網頁不同調整，這邊帳密表格剛好在第2個）
pgform    <-html_form(pgsession)[[2]]       ## pull form from session

## 填寫帳密
filled_form <- set_values(pgform,
                          `userId` = "＊＊＊＊@gmail.com",
                          `password` = "＊＊＊＊＊")

## 送出帳密到這個session中，取得進一步爬取資料的授權
submit_form(pgsession,filled_form)

## 接者要跳轉入自己真正有興趣的網頁
rs.url.address <- paste0("https://www.pharmgkb.org/view/variant-annotations.do?variantId=",rsID)

# 使用jump_to函數在此session中送出url request（模擬個人瀏覽網頁的狀況）
web.page <- jump_to(pgsession, rs.url.address) %>%
  read_html


# COOL website links 
num <- c(818,826,838,858,920,930,978,1007,1013,1019,1055,1057,1062,1118,1152,1154,1171,
  1181,1210,1211,1220,1234,1235,1238,1248,1252,1340,1384,1404,1406,1422,1423,
  1430,1431,1453,1463,1492,1498,1504,1505,1552,1559,1631,1634,1659,1691,1715,1727,
  1746,1765,1795,1822,1840,1851,1866,1867,1869,1887,1891,1895,1897,1898,1918,1919,
  1946,1988,1989,2002,2022,2035,2038,2040,2057,2058,2096,2100,2103,2125,2149,2195,
  2201,2268,2340,2361,2399,2505,2534,2555,2559,2578,2579,2600,2601,2603,2623,2750,2793,2885)

num <- c(818, 826, 838)
links <- paste0("https://cool.ntu.edu.tw/courses/", num, "/users")

data <- c()
for(i in seq_along(links)){
  url <- links[i]
  data_course <- read_html(url) %>% html_nodes(".ellipsible") %>%
    html_text()
  data <- data_course
  }

cool <- read_html("https://cool.ntu.edu.tw/courses/814/users")
cool_table <- cool %>% html_node("div") %>% html_table()