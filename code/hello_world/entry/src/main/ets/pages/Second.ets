@Entry
@Component
struct Second {
  @State message: string = 'Second Page'
  build() {
    Row(){
      Column(){
        Text(this.message)
      }.width('100%')

    }.height('100%')
  }
}