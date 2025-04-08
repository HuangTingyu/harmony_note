class Tmp{
  label: string = '';
}

@Builder function overBuilder($$: Tmp) {
  Text($$.label)
    .width(400)
    .height(50)
    .backgroundColor(Color.Green)
}

@Component
struct Child {
  label: string = 'Child';
  @Builder customBuilder() {};
  // 无参数类型，指向的customBuilder也是无参数类型
  @BuilderParam customBuilderParam: () => void = this.customBuilder;
  // 有参数类型，指向的overBuilder也是有参数类型的方法
  @BuilderParam customOverBuilderParam: ($$: Tmp) => void = overBuilder;

  build() {
    Column() {
      this.customBuilderParam()
      this.customOverBuilderParam({label: 'global Builder label' } )
    }
  }
}

@Entry
@Component
struct Parent {
  label: string = 'Parent';

  @Builder componentBuilder() {
    Text(`label_${this.label}`)
  }

  build() {
    Column() {
      this.componentBuilder()
      Child({ customBuilderParam: ()=>{
        this.componentBuilder() //this指向父类label
      },
        //可以覆盖原来指向overBuilder的状态
        customOverBuilderParam:()=>{
          this.componentBuilder()
        },
      })
      Child({
        customBuilderParam: this.componentBuilder //this指向子类label
      })
    }
  }
}