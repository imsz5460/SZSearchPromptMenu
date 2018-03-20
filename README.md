
## 实现效果【effect】

去年写的一个框架，今次做了些许优化和简单封装。功能效果是这样的：

![demo.gif](https://upload-images.jianshu.io/upload_images/4320229-a703e15454eaeae3.gif?imageMogr2/auto-orient/strip)


## 基本功能【Features】


结合本demo进行说明：
 *  输入任意字符后，点击查询，即保存到了历史记录。下次输入时输入框下方列表会有该历史记录，点击该条目自动填充输入。
 *  多个记录条目按时间由近及远排列，且去除重复条目。
 *  点击下拉列表外的空白区域，即可收起列表，若点击非空白区域（如按钮），则响应该区域事件。
 *  即时搜索匹配，关键字高亮（可选）。
 *  一键清除历史记录（可选）。
 *  弹出菜单
 
【 
   *  Enter an arbitrary string to click the query, and the string will be saved to the history record.Next time the input box could show the history list, click a certain item could automatic input.
   *  Multiple entries sorting from near to far , and remove duplicate entries.
   *  Instant search matching, highlighted keywords (optional).
   *  Onestep to clear history record (optional). 
   *  pop-up menu.】

  
## 如何使用【How To Use】
输入框使用SZSerchTextfield即自带关键字搜索提示框。具体方法详见下载的demo。

【Please reference to Demo.】


## 声明【statement】
SZSearchPromptMenu是在XHPopMenu的基础上进行了较大的修改及扩展，XHPopMenu的功能仅为pop菜单。感谢作者曾宪华(@xhzengAIB)。实际上SZSearchPromptMenu保留了XHPopMenu弹出菜单的功能。

【SZSearchPromptMenu has been modified and expanded on the basis of XHPopMenu, XHPopMenu function for the pop menu.Thank the authors 曾宪华 (@ xhzengAIB)
  In fact SZSearchPromptMenu kept the function of the pop-up menu.】

