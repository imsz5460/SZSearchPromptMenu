
## 实现效果【Effect】

去年写的一个框架，今次做了些许优化和简单封装。功能效果是这样的：

![demo.gif](https://upload-images.jianshu.io/upload_images/4320229-a703e15454eaeae3.gif?imageMogr2/auto-orient/strip)

![demo2.jpg](https://upload-images.jianshu.io/upload_images/4320229-a1f6916d4ec07ad2.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 基本功能【function】


结合本demo进行说明：
 *  输入任意字符后，点击查询，即保存到了历史记录。下次输入时输入框下方列表会有该历史记录，点击该条目自动填充输入。
 *  多个记录条目按时间由近及远排列，且去除重复条目。
 *  点击下拉列表外的空白区域，即可收起列表，若点击非空白区域（如按钮），则响应该区域事件。
 *  即时搜索匹配，关键字高亮（可选）。
 *  一键清除历史记录（可选）。
 *  弹出菜单
 
【 
   *  Enter an arbitrary string to click the query, and the string will be saved to the history record.Next time the input box would show the history list, click on a certain item will automatically enter.
   *  Multiple entries are sorted from near to far, and duplicate entries are removed.
   *  Click the blank area outside the drop-down list to pick up the list, and if you click on a non blank area (such as a button), then response the event in the region.
   *  Instant search matching, highlighted keywords (optional).
   *  Onestep to clear history record (optional). 
   *  pop-up menu.】

  
## 如何使用【How To Use】
输入框使用SZSearchTextfield即自带关键字搜索提示框。具体方法详见下载的demo。

【Please reference to Demo.】


## 声明【Statement】
SZSearchPromptMenu是在XHPopMenu的基础上进行了较大的修改及扩展，XHPopMenu的功能仅为pop菜单。感谢作者曾宪华(@xhzengAIB)。实际上SZSearchPromptMenu保留了XHPopMenu弹出菜单的功能。

【SZSearchPromptMenu has been modified and expanded on the basis of XHPopMenu, XHPopMenu function for the pop menu.Thank the author 曾宪华 (@ xhzengAIB)
  In fact SZSearchPromptMenu kept the function of the pop-up menu.】

