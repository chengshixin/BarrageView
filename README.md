# BarrageView - iOS弹幕视图组件

一个功能丰富的iOS弹幕视图组件，支持多种动画方向、播放模式和自定义样式。

## 功能特性

### 🎯 核心功能
- **多方向支持**：右到左、左到右、上到下、下到上
- **播放模式**：单次播放、循环播放
- **实时速度控制**：播放过程中可动态调整弹幕速度
- **暂停/继续**：支持暂停和恢复播放功能
- **防重叠机制**：智能避免弹幕重叠显示

### 🎨 自定义样式
- **字体大小**：可自定义弹幕文字大小
- **文字颜色**：支持自定义文字颜色
- **背景颜色**：支持自定义文字背景颜色和透明度
- **圆角设计**：弹幕标签采用圆角设计
- **边框样式**：支持自定义边框颜色和宽度

### 🚀 高级特性
- **动画平滑**：基于Core Animation的流畅动画
- **内存管理**：自动清理已完成动画的弹幕
- **线程安全**：主线程操作，确保UI响应性
- **性能优化**：高效的碰撞检测和位置计算

## 安装使用

### 基础使用

```swift
import UIKit

// 创建弹幕视图
let barrageView = BarrageView(frame: CGRect(x: 0, y: 100, width: 300, height: 200))
view.addSubview(barrageView)

// 设置弹幕数据
let texts = ["Hello World!", "这是一条弹幕", "Swift真棒"]
barrageView.setBarrageData(texts)

// 开始播放
barrageView.startBarrage()
```

### 高级配置

```swift
// 设置方向（默认：右到左）
barrageView.setDirection(.rightToLeft)  // 可选：.leftToRight, .topToBottom, .bottomToTop

// 设置播放模式（默认：循环）
barrageView.setPlayMode(.loop)  // 可选：.single

// 设置速度（像素/秒，默认：50）
barrageView.setSpeed(150.0)

// 设置样式
barrageView.setFontSize(18)
barrageView.setTextColor(.white)
barrageView.setTextBackgroundColor(UIColor.black.withAlphaComponent(0.7))

// 设置边框样式（新增）
barrageView.setLabelBorderColor(.systemBlue)
barrageView.setLabelBorderWidth(2.0)
barrageView.setLabelCornerRadius(15.0)

// 设置动画时长（默认：10秒）
barrageView.setAnimationDuration(8.0)
```

### 播放控制

```swift
// 开始播放
barrageView.startBarrage()

// 暂停播放
barrageView.pauseBarrage()

// 继续播放
barrageView.resumeBarrage()

// 停止播放
barrageView.stopBarrage()
```

## API文档

### 公共方法

| 方法 | 说明 | 参数 |
|------|------|------|
| `setBarrageData(_:)` | 设置弹幕文本数据 | `[String]` |
| `setDirection(_:)` | 设置弹幕移动方向 | `BarrageDirection` |
| `setPlayMode(_:)` | 设置播放模式 | `BarragePlayMode` |
| `setSpeed(_:)` | 设置弹幕速度（像素/秒） | `CGFloat` |
| `setFontSize(_:)` | 设置字体大小 | `CGFloat` |
| `setTextColor(_:)` | 设置文字颜色 | `UIColor` |
| `setTextBackgroundColor(_:)` | 设置背景颜色 | `UIColor` |
| `setLabelBorderColor(_:)` | 设置边框颜色（新增） | `UIColor` |
| `setLabelBorderWidth(_:)` | 设置边框宽度（新增） | `CGFloat` |
| `setLabelCornerRadius(_:)` | 设置圆角半径（新增） | `CGFloat` |
| `setAnimationDuration(_:)` | 设置动画时长 | `TimeInterval` |
| `startBarrage()` | 开始播放弹幕 | - |
| `stopBarrage()` | 停止播放弹幕 | - |
| `pauseBarrage()` | 暂停播放 | - |
| `resumeBarrage()` | 继续播放 | - |

### 枚举类型

```swift
// 弹幕方向
enum BarrageDirection {
    case topToBottom    // 从上到下
    case bottomToTop    // 从下到上
    case leftToRight    // 从左到右
    case rightToLeft    // 从右到左（默认）
}

// 播放模式
enum BarragePlayMode {
    case single    // 单次播放
    case loop      // 循环播放
}
```

## 测试Demo

项目包含完整的测试用例 `BarrageTestView.swift`，演示了所有功能：

- ✅ 播放控制（开始/停止/暂停/继续）
- ✅ 方向切换（4种方向）
- ✅ 模式切换（单次/循环）
- ✅ 速度调节（50-250像素/秒）
- ✅ 实时反馈

### 运行测试

```swift
// 在ViewController中使用
let testView = BarrageTestView()
view.addSubview(testView)
```

## 技术实现

### 核心架构
- **基于UIView**：继承自UIView，易于集成
- **Core Animation**：使用UIView动画实现流畅移动
- **定时器管理**：使用Timer控制弹幕生成频率
- **碰撞检测**：智能位置计算避免重叠

### 性能优化
- **自动清理**：动画完成后自动移除视图
- **内存管理**：及时释放不再使用的对象
- **主线程优化**：确保UI操作在主线程执行
- **动画暂停/恢复**：支持应用生命周期管理
- **实时速度更新**：动态调整现有弹幕速度，无需重启
- **智能位置计算**：避免弹幕重叠的高效算法

## 兼容性

- **iOS版本**：iOS 11.0+
- **Swift版本**：Swift 5.0+
- **设备支持**：iPhone、iPad
- **屏幕适配**：支持各种屏幕尺寸

## 依赖

- **系统框架**：UIKit、Foundation
- **第三方库**：SnapKit（仅测试Demo使用，核心组件无依赖）

## 许可证

MIT License - 详见LICENSE文件

## 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 联系方式

如有问题或建议，请通过GitHub Issues联系。

