
@Entry
@Component
struct TestTabs {
  build(){
    Tabs({barPosition: BarPosition.Start}) {
      TabContent() {
        Text('首页的内容').fontSize(30)
      }
      .tabBar('首页')

      TabContent() {
        Text('推荐的内容').fontSize(30)
      }
      .tabBar('推荐')

      TabContent() {
        Text('发现的内容').fontSize(30)
      }
      .tabBar('发现')

      TabContent() {
        Text('我的内容').fontSize(30)
      }
      .tabBar("我的")
    }.barMode(BarMode.Fixed)
    // .scrollable(false)
    // .vertical(true).barWidth(100).barHeight(200)
  }
}