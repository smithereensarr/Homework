# Homework

## 完成功能

- 使用 [Unsplash API](https://unsplash.com/documentation#list-curated-photos) 获取编辑精选的照片，并以瀑布流形式展现
- 图片列表支持下拉刷新和加载更多
- 支持查看大图，大图可在一定比例内缩放
- 支持大图加载过程可视化
- 增加客户端本地缓存功能，可离线浏览已获取过的列表图片
- 支持保存大图到相册的功能
- 主界面入场物理动效
- 完成图片详情页与列表页转场动效
- 自动布局适配异形屏手机（iPhone X）界面

## 第三方库引入

- AFNetworking
- YYModel
- YYWebImage
- Masonry
- MJRefresh
- JGProgressHUD

## 待完善

- 网络库针对服务端缓存协议进行缓存时效性判断等
- 大图缩放空白处交互待优化
- 其他面向对象的高级封装和架构设计
- 高扩展复用性等设计

## 其他

>  [Unsplash API](https://unsplash.com/documentation#list-curated-photos) 图片请求较为缓慢，图片尺寸过大，加载时间较长，请耐心等待
>
>  [Unsplash API](https://unsplash.com/documentation#list-curated-photos) 后端数据少有渐进格式图片数据，导致加载效果没有达到预期（渐进加载）
>
>  [Unsplash API](https://unsplash.com/documentation#list-curated-photos) 有访问流量限制（具体见API文档，暂未触发过）
>
> 未做性能测试，界面较为简单，iPhone7以上实测满帧运行