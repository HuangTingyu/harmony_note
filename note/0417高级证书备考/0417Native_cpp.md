习题

https://developer.huawei.com/consumer/cn/training/course/slightMooc/C101705084078534051



`hilog.info`调试技巧

```
DevEco Studio底部的，点击log
```



### 配置

`build-profile.json5`

```json
"buildOption": {
    "externalNativeOptions": {
      "path": "./src/main/cpp/CMakeLists.txt",
      "arguments": "",
      "cppFlags": "",
      "abiFilters": [
        "arm64-v8a",
        "x86_64"
      ]
    }
  },
```



**注意，这个互联只能在模拟器上运行**

`Previewer`会直接报错！



