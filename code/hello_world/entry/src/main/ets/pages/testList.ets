


@Entry
@Component
struct Parent {
  @State egLanes: LengthConstrain = {minLength:200, maxLength:300}
  private listScroller: Scroller = new Scroller()
  @State listData:string[]=['item1','item2']

  @Builder itemEnd(index:number){
    Row(){
      Button({type: ButtonType.Circle}){
        Image($r(`app.media.del`)).width(20).height(20)
      }.backgroundColor('#00000000')
    }.width(40).height('100%').backgroundColor(Color.Red).justifyContent(FlexAlign.Center)
  }

  build(){
    Column(){
      Button(){
        Text('Back to top')
      }.onClick(()=>{
        this.listScroller.scrollToIndex(0)
      }).margin({bottom:10}).width(100).height(20).fontColor('#fff')

      List({space: 20, scroller: this.listScroller}){
        ForEach(this.listData,(item:string, index)=>{
          ListItem(){
            Row(){
              Text(item)
            }.width('100%').height(30).justifyContent(FlexAlign.SpaceBetween).backgroundColor('#888')

          }.swipeAction({
            end:{
              builder: ()=>{
                this.itemEnd(index)
              }
            }
          })

        },(item:string)=>item)
      }
      // .lanes(this.egLanes) //如果要充满屏幕，记得注释这里
      .scrollBar(BarState.Auto)
      .divider({
        strokeWidth:1,
        startMargin:0,
        endMargin:0,
        color: '#888'
      }).width('100%')
    }.width('100%')


  }
}