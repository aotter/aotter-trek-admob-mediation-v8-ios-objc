# trek-ios-AdMobMediation_v8-sample

專案內同時有 Object-C 跟 Swift target，

<img width="242" alt="截圖 2021-05-31 下午6 03 34" src="https://user-images.githubusercontent.com/46350143/120177045-8c241a00-c23a-11eb-84a2-a2f6fe56e5b7.png">


若想要測試 AdMobMediation_v8 Demo，請在 podfile 的 AdMobMediation_v8 target 安裝相關 SDK

<img width="669" alt="AdMobMediation_v8" src="https://user-images.githubusercontent.com/46350143/120177071-93e3be80-c23a-11eb-93a1-1ab609145966.png">


若想要測試 AdMobMediation_v8_Swift Demo，請在 podfile 的 AdMobMediation_v8_Swift target 安裝相關 SDK

<img width="672" alt="AdMobMediation_v8_Swift" src="https://user-images.githubusercontent.com/46350143/120177095-9d6d2680-c23a-11eb-9cbf-b6267fa9d3c2.png">


若在測試 AdMobMediation_v8 Demo，可以先將 AdMobMediation_v8_Swift Demo bridge file 內的 import 註解起來

![截圖 2021-05-31 下午5 59 17](https://user-images.githubusercontent.com/46350143/120177198-baa1f500-c23a-11eb-860f-d685fa452ccf.png)


要在測試 AdMobMediation_v8_Swift Demo 時，再把 bridge file 內的 import 註解拿掉

![截圖 2021-05-31 下午5 59 26](https://user-images.githubusercontent.com/46350143/120177208-bd044f00-c23a-11eb-8a93-0f2eb8902ce8.png)
