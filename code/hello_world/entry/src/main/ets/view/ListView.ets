@Component
struct ListView {
  build() {
    Column({space: 10}){
      Column({space: 10}){
        Row(){
          Image($r('app.media.list_icon')).width(20).height(20)
          Text('4月1日写完TaskList').fontColor($r('app.color.text_title')).fontWeight(FontWeight.Bold).fontSize(18)

        }.width('100%')
        Text('9:00-12:00').fontColor('#888')
        Row(){
          Text('生活').fontColor(Color.White)
        }.width(80).height(30).backgroundColor('#D94339').borderRadius(10).justifyContent(FlexAlign.Center)

      }.width('100%').height(120).alignItems(HorizontalAlign.Start)
      .backgroundColor(Color.White).borderRadius(10).padding(10)

      Column({space: 10}){
        Row(){
          Image($r('app.media.list_icon')).width(20).height(20)
          Text('4月1日写完TaskList').fontColor($r('app.color.text_title')).fontWeight(FontWeight.Bold).fontSize(18)

        }.width('100%')
        Text('9:00-12:00').fontColor('#888')
        Row(){
          Text('生活').fontColor(Color.White)
        }.width(80).height(30).backgroundColor('#D94339').borderRadius(10).justifyContent(FlexAlign.Center)

      }.width('100%').height(120).alignItems(HorizontalAlign.Start)
      .backgroundColor(Color.White).borderRadius(10).padding(10)

      Column({space: 10}){
        Row(){
          Image($r('app.media.list_icon')).width(20).height(20)
          Text('4月1日写完TaskList').fontColor($r('app.color.text_title')).fontWeight(FontWeight.Bold).fontSize(18)

        }.width('100%')
        Text('9:00-12:00').fontColor('#888')
        Row(){
          Text('生活').fontColor(Color.White)
        }.width(80).height(30).backgroundColor('#D94339').borderRadius(10).justifyContent(FlexAlign.Center)

      }.width('100%').height(120).alignItems(HorizontalAlign.Start)
      .backgroundColor(Color.White).borderRadius(10).padding(10)
    }

  }
}

export default ListView