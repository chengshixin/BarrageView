import UIKit

// 弹幕方向枚举
enum BarrageDirection {
    case topToBottom    // 从上到下
    case bottomToTop    // 从下到上
    case leftToRight    // 从左到右
    case rightToLeft    // 从右到左（默认）
}

// 弹幕播放模式枚举
enum BarragePlayMode {
    case single    // 单次播放
    case loop      // 循环播放
}

class BarrageView: UIView {
    
    // MARK: - 属性
    private var barrageTexts: [String] = []
    private var direction: BarrageDirection = .rightToLeft
    private var playMode: BarragePlayMode = .loop
    private var animationDuration: TimeInterval = 10.0
    private var fontSize: CGFloat = 16.0
    private var textColor: UIColor = .white
    private var textBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    private var speed: CGFloat = 50.0
    private var labelBorderColor: UIColor = .clear
    private var labelBorderWidth: CGFloat = 0.0
    private var labelCornerRadius: CGFloat = 12.0
    
    private(set) var isPlaying = false
    private var currentIndex = 0
    private var activeLabels: [UILabel] = []
    private var labelEndPoints: [UILabel: CGPoint] = [:] // 保存每个标签的终点位置
    private var timer: Timer?
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
    }
    
    // MARK: - 公共方法
    
    /// 设置弹幕数据
    func setBarrageData(_ texts: [String]) {
        self.barrageTexts = texts
    }
    
    /// 设置方向
    func setDirection(_ direction: BarrageDirection) {
        self.direction = direction
    }
    
    /// 设置播放模式
    func setPlayMode(_ mode: BarragePlayMode) {
        self.playMode = mode
    }
    
    /// 设置动画时长
    func setAnimationDuration(_ duration: TimeInterval) {
        self.animationDuration = duration
    }
    
    /// 设置弹幕速度（像素/秒）
    func setSpeed(_ speed: CGFloat) {
        self.speed = max(speed, 10.0) // 最小速度限制为10像素/秒，避免速度过慢
        
        // 如果弹幕正在播放，更新现有标签的动画速度
        if isPlaying {
            updateExistingBarragesSpeed()
        }
    }
    
    /// 更新现有弹幕的动画速度
    private func updateExistingBarragesSpeed() {
        for label in activeLabels {
            guard let endPoint = labelEndPoints[label] else { continue }
            
            // 获取当前动画的进度
            let presentationLayer = label.layer.presentation()
            let currentPosition = presentationLayer?.frame.origin ?? label.frame.origin
            
            // 移除当前动画
            label.layer.removeAllAnimations()
            
            // 计算剩余距离和新的动画时间
            let remainingDistance = calculateRemainingDistance(from: currentPosition, to: endPoint)
            let remainingDuration = TimeInterval(remainingDistance / speed)
            
            // 创建新的动画，保持当前位置继续移动
            if remainingDuration > 0 {
                UIView.animate(withDuration: remainingDuration, delay: 0, options: .curveLinear, animations: {
                    label.frame.origin = endPoint
                }) { [weak self] _ in
                    label.removeFromSuperview()
                    self?.activeLabels.removeAll { $0 == label }
                    self?.labelEndPoints.removeValue(forKey: label)
                }
            }
        }
    }
    
    /// 计算剩余距离
    private func calculateRemainingDistance(from current: CGPoint, to end: CGPoint) -> CGFloat {
        return sqrt(pow(end.x - current.x, 2) + pow(end.y - current.y, 2))
    }
    
    
    /// 设置字体大小
    func setFontSize(_ size: CGFloat) {
        self.fontSize = size
    }
    
    /// 设置文字颜色
    func setTextColor(_ color: UIColor) {
        self.textColor = color
    }
    
    /// 设置文字背景颜色
    func setTextBackgroundColor(_ color: UIColor) {
        self.textBackgroundColor = color
    }
    
    /// 设置label边框颜色
    func setLabelBorderColor(_ color: UIColor) {
        self.labelBorderColor = color
    }
    
    /// 设置label边框宽度
    func setLabelBorderWidth(_ width: CGFloat) {
        self.labelBorderWidth = max(width, 0.0)
    }
    
    /// 设置label圆角半径
    func setLabelCornerRadius(_ radius: CGFloat) {
        self.labelCornerRadius = max(radius, 0.0)
    }
    
    /// 开始播放弹幕
    func startBarrage() {
        guard !barrageTexts.isEmpty else { return }
        
        stopBarrage()
        isPlaying = true
        currentIndex = 0
        
        // 创建定时器，每隔一段时间创建新的弹幕标签
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.createBarrageLabel()
        }
        
        // 将定时器添加到common modes，确保在滚动和界面切换时也能执行
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
        
        // 立即创建第一个弹幕
        createBarrageLabel()
    }
    
    /// 停止播放弹幕
    func stopBarrage() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
        
        // 移除所有动画和标签
        activeLabels.forEach { label in
            label.layer.removeAllAnimations()
            label.removeFromSuperview()
        }
        activeLabels.removeAll()
        labelEndPoints.removeAll() // 清除保存的终点位置
    }
    
    /// 暂停播放
    func pauseBarrage() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
        
        // 暂停所有动画
        activeLabels.forEach { label in
            label.layer.pauseAnimation()
        }
    }
    
    /// 继续播放
    func resumeBarrage() {
        guard !barrageTexts.isEmpty else { return }
        
        isPlaying = true
        
        // 继续所有动画
        activeLabels.forEach { label in
            label.layer.resumeAnimation()
        }
        
        // 重新开始定时器
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.createBarrageLabel()
        }
        
        // 将定时器添加到common modes，确保在滚动和界面切换时也能执行
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    // MARK: - 私有方法
    
    private func createBarrageLabel() {
        guard isPlaying, !barrageTexts.isEmpty else { return }
        
        let text = barrageTexts[currentIndex]
        let label = createLabel(with: text)
        
        // 根据方向计算起点和终点坐标
        let (startPoint, endPoint) = calculateStartAndEndPoints(for: label)
        
        label.frame.origin = startPoint
        self.addSubview(label)
        activeLabels.append(label)
        
        // 保存终点位置
        labelEndPoints[label] = endPoint
        
        // 开始动画
        startAnimation(for: label, from: startPoint, to: endPoint)
        
        // 更新索引
        currentIndex = (currentIndex + 1) % barrageTexts.count
        
        // 如果是单次播放模式且播放完所有文本，停止播放
        if playMode == .single && currentIndex == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
                self?.stopBarrage()
            }
        }
    }
    
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        label.backgroundColor = textBackgroundColor
        label.layer.cornerRadius = labelCornerRadius
        label.layer.masksToBounds = true
        label.textAlignment = .center
        
        // 设置边框颜色和宽度
        label.layer.borderColor = labelBorderColor.cgColor
        label.layer.borderWidth = labelBorderWidth
        
        // 根据内容和圆角半径动态计算标签大小
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let expectedSize = text.boundingRect(with: maxSize,
                                             options: .usesLineFragmentOrigin,
                                             attributes: [.font: label.font!],
                                             context: nil)
        
        // 基础内边距
        let horizontalPadding: CGFloat = 16
        let verticalPadding: CGFloat = 4
        
        // 计算最小尺寸（考虑圆角半径）
        let minHeight = max(fontSize + verticalPadding * 2, labelCornerRadius * 2 + 4)
        let minWidth = max(expectedSize.width + horizontalPadding * 2, labelCornerRadius * 2 + 4)
        
        // 计算最终尺寸
        let labelWidth = min(minWidth, self.bounds.width * 0.8)
        let labelHeight = minHeight
        
        label.frame.size = CGSize(width: labelWidth, height: labelHeight)
        
        return label
    }
    
    private func calculateRandomYPosition(labelHeight: CGFloat) -> CGFloat {
        let spacing: CGFloat = 10
        let maxY = self.bounds.height - labelHeight - spacing
        
        // 生成随机Y位置，避免与现有标签重叠
        var attempts = 0
        var randomY: CGFloat = 0
        
        repeat {
            randomY = CGFloat.random(in: spacing...maxY)
            attempts += 1
        } while isYPositionOccupied(y: randomY, labelHeight: labelHeight) && attempts < 10
        
        return randomY
    }
    
    private func calculateRandomXPosition(labelWidth: CGFloat) -> CGFloat {
        let spacing: CGFloat = 10
        let maxX = self.bounds.width - labelWidth - spacing
        
        // 生成随机X位置，避免与现有标签重叠
        var attempts = 0
        var randomX: CGFloat = 0
        
        repeat {
            randomX = CGFloat.random(in: spacing...maxX)
            attempts += 1
        } while isXPositionOccupied(x: randomX, labelWidth: labelWidth) && attempts < 10
        
        return randomX
    }
    
    /// 计算弹幕的起点和终点坐标
    private func calculateStartAndEndPoints(for label: UILabel) -> (startPoint: CGPoint, endPoint: CGPoint) {
        let labelWidth = label.frame.width
        let labelHeight = label.frame.height
        
        switch direction {
        case .rightToLeft:
            // 水平从右到左：随机Y，固定X起点和终点
            let randomY = calculateRandomYPosition(labelHeight: labelHeight)
            let startPoint = CGPoint(x: self.bounds.width, y: randomY)
            let endPoint = CGPoint(x: -labelWidth, y: randomY)
            return (startPoint, endPoint)
            
        case .leftToRight:
            // 水平从左到右：随机Y，固定X起点和终点
            let randomY = calculateRandomYPosition(labelHeight: labelHeight)
            let startPoint = CGPoint(x: -labelWidth, y: randomY)
            let endPoint = CGPoint(x: self.bounds.width, y: randomY)
            return (startPoint, endPoint)
            
        case .topToBottom:
            // 垂直从上到下：随机X，固定Y起点和终点
            let randomX = calculateRandomXPosition(labelWidth: labelWidth)
            let startPoint = CGPoint(x: randomX, y: -labelHeight)
            let endPoint = CGPoint(x: randomX, y: self.bounds.height)
            return (startPoint, endPoint)
            
        case .bottomToTop:
            // 垂直从下到上：随机X，固定Y起点和终点
            let randomX = calculateRandomXPosition(labelWidth: labelWidth)
            let startPoint = CGPoint(x: randomX, y: self.bounds.height)
            let endPoint = CGPoint(x: randomX, y: -labelHeight)
            return (startPoint, endPoint)
        }
    }
    
    /// 检查Y轴位置是否被占用（用于水平移动弹幕）
    private func isYPositionOccupied(y: CGFloat, labelHeight: CGFloat) -> Bool {
        for label in activeLabels {
            let labelMinY = label.frame.minY - 10
            let labelMaxY = label.frame.maxY + 10
            
            if y > labelMinY && y < labelMaxY {
                return true
            }
        }
        return false
    }
    
    /// 检查X轴位置是否被占用（用于垂直移动弹幕）
    private func isXPositionOccupied(x: CGFloat, labelWidth: CGFloat) -> Bool {
        for label in activeLabels {
            let labelMinX = label.frame.minX - 10
            let labelMaxX = label.frame.maxX + 10
            
            if x > labelMinX && x < labelMaxX {
                return true
            }
        }
        return false
    }
    
    private func startAnimation(for label: UILabel, from startPoint: CGPoint, to endPoint: CGPoint) {
        let distance = sqrt(pow(endPoint.x - startPoint.x, 2) + pow(endPoint.y - startPoint.y, 2))
        let duration = TimeInterval(distance / speed)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            label.frame.origin = endPoint
        }) { [weak self] _ in
            // 动画完成后移除标签
            label.removeFromSuperview()
            self?.activeLabels.removeAll { $0 == label }
        }
    }
    
    deinit {
        stopBarrage()
    }
}

// MARK: - CALayer扩展，用于暂停和恢复动画
extension CALayer {
    func pauseAnimation() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}
