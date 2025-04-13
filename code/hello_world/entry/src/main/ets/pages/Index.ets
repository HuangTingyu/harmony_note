import { router } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  build() {
    Row(){
      Button(){
        Text('hello harmony')
          .fontSize(22)
          .fontColor('#fff')
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Normal)
      .borderRadius('10%')
      .margin({
        top: 20
      }).backgroundColor('#ff9c6e')
      .width('50%')
      .height('5%')
      .onClick(()=>{
        router.pushUrl({url:'pages/testWeb'})
        // router.pushUrl({url:'pages/NotesPage'})
      })

    }.width('100%').height('100%')
    .backgroundColor('#E68933')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}