@Component
 struct TaskView {
  @State containBgColor:string = '#F26A62'
  @Styles
  processingContain() {
    .height(128)
    .width(168)
    .backgroundColor(this.containBgColor)
    .borderRadius(5)
    .padding(10)
    .onClick(()=>{
      this.containBgColor = `#888`
    })
  }
  build(){
  /**/
    Row(){
      Column({space: 10}){
        Column({space: 10}){
          Text('已完成').fontWeight(FontWeight.Bold).fontSize(18)
          Text('0任务').fontWeight(FontWeight.Bold).fontSize(18)

        }.height(164).width(168).backgroundColor('#DCEBFD').borderRadius(5).padding(10)

        Column() {
          Text('进行中').fontWeight(FontWeight.Bold).fontSize(18)
          Text('0任务').fontWeight(FontWeight.Bold).fontSize(18)
        }.processingContain()

      }.width('50%').height('100%')

      // ------分割线
      Column({space: 10}){

        Column({space: 10}){
          Text('未完成').fontWeight(FontWeight.Bold).fontSize(18)
          Text('0任务').fontWeight(FontWeight.Bold).fontSize(18)

        }.height(130).width(168).backgroundColor('#FFEDDE').borderRadius(5).padding(10)

        Column(){
          Text('未来任务').fontWeight(FontWeight.Bold).fontSize(18)
          Text('0任务').fontWeight(FontWeight.Bold).fontSize(18)
        }.height(162).width(168).backgroundColor('#7FDA98').borderRadius(5).padding(10)

      }.width('50%').height('100%')

    }.width('100%').height(300)
  }


}

export default TaskView