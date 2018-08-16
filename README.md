# 缘由

TextureTangram是一个布局工具，它定义了几种常用的布局类型，足以应付大部分情况的布局。通过一个简单，可读性强的布局配置文件，就可以生成一个个丰富的原生高性能的页面。这种方式是需要牺牲一定灵活性为前提，带来开发量的降低和重复造轮子。

TextureTangram是一个布局工具并不是[Tangram](https://github.com/alibaba/Tangram-iOS)的分支，但很大程度地启发自它的布局思想，并尽量做到兼容。

[Tangram](https://github.com/alibaba/Tangram-iOS)存在一些问题：
1. Demo中的瀑布流已经不可用。
2. Draggable Layout加载到scrollView上，我认为是没必要的，滑动的时候会抖动。
3. 存在耦合，难以添加新定义的布局类型。
4. 没必要的事件总线。
5. layout使用view来做容器，造成没必要的性能损耗。 

# TextureTangram
为此，我另起炉灶，重新造一个轮子，底层使用ASDK/Texture的`ASCollectionNode`，目前看来有几点优势：
1. ASDK对Cell的渲染基本上是60PS，性能的瓶颈就在于自己定义的`CollectionViewLayout`里面的布局计算。
2. 自适应高度，不需要预计算cell内所有元素的高度，而且非常适合用来做瀑布流布局。作为选择，你仍然可以自己在Model指定高度。
3. 非常容易添加新的布局类型，只要继承`TangramLayoutComponent`，然后重写`- (void)computeLayoutsWithOrigin:(CGPoint)origin width:(CGFloat)width;`即可。
4. 浮动窗口和固定窗口放在跟`ASCollectionNode`同一个层级，不会影响`ASCollectionNode`的滑动。
5. `TangramLayoutComponent`是一个布局描述，不会产生一个view，也不需要复用它。
6. 使用`ASCollectionNode`没有复用的问题。

# TODO
目前炉灶初开，轮子未成，项目中还有很多未完成的东西：
1. Header 、Footer、Background还没测试过。（重要）
2. 固定布局、浮窗还没实现。（优先级比较低）
3. 横向布局、Banner的实现。（需要做一层转化和delegate判断）（重要）
4. `TangramNode`需要暴露的接口、代理。（开发一个完整的demo应用，看看哪些api是必须的，哪些是可选的）
5. ~~插入、删除部分布局元素有待检验;~~
6. 数据解析层，事件传递还没动工。
