import UIKit
import SnapKit

// BarrageView测试用例
class BarrageTestView: UIView {
    
    // MARK: - UI组件
    private let barrageView = BarrageView()
    private let controlPanel = UIView()
    private let startButton = UIButton(type: .system)
    private let stopButton = UIButton(type: .system)
    private let pauseButton = UIButton(type: .system)
    private let resumeButton = UIButton(type: .system)
    private let directionControl = UISegmentedControl(items: ["右到左", "左到右", "上到下", "下到上"])
    private let modeControl = UISegmentedControl(items: ["单次", "循环"])
    private let speedSlider = UISlider()
    private let speedLabel = UILabel()
    
    // 测试弹幕数据
    private let testBarrageTexts = [
        "Hello World! 🎉",
        "这是一条测试弹幕",
        "Swift开发很有趣",
        "弹幕效果真棒！",
        "iOS开发加油💪",
        "这个组件很好用",
        "测试多语言支持",
        "动画效果很流畅",
        "支持多种方向",
        "可以自定义样式"
    ]
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        configureBarrageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
        configureBarrageView()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // 设置弹幕视图
        addSubview(barrageView)
        barrageView.backgroundColor = UIColor.systemGray6
        barrageView.layer.cornerRadius = 12
        barrageView.layer.masksToBounds = true
        
        // 设置控制面板
        addSubview(controlPanel)
        controlPanel.backgroundColor = UIColor.systemGray5
        controlPanel.layer.cornerRadius = 12
        
        // 设置按钮
        setupButton(startButton, title: "开始", color: .systemGreen)
        setupButton(stopButton, title: "停止", color: .systemRed)
        setupButton(pauseButton, title: "暂停", color: .systemOrange)
        setupButton(resumeButton, title: "继续", color: .systemBlue)
        
        // 设置分段控制器
        directionControl.selectedSegmentIndex = 0
        directionControl.backgroundColor = .systemGray6
        
        modeControl.selectedSegmentIndex = 1
        modeControl.backgroundColor = .systemGray6
        
        // 设置速度滑块（实际像素/秒速度）
        speedSlider.minimumValue = 50   // 最慢速度：50像素/秒
        speedSlider.maximumValue = 250  // 最快速度：250像素/秒
        speedSlider.value = 120         // 默认速度：120像素/秒
        speedLabel.text = "速度:120"
        speedLabel.font = .systemFont(ofSize: 14)
        speedLabel.textAlignment = .center
        
        // 添加标签
        let directionLabel = UILabel()
        directionLabel.text = "方向:"
        directionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        let modeLabel = UILabel()
        modeLabel.text = "模式:"
        modeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        let speedTitleLabel = UILabel()
        speedTitleLabel.text = "速度控制:"
        speedTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        // 布局
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        
        // 按钮行
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubview(startButton)
        buttonStack.addArrangedSubview(stopButton)
        buttonStack.addArrangedSubview(pauseButton)
        buttonStack.addArrangedSubview(resumeButton)
        
        // 方向控制行
        let directionStack = UIStackView()
        directionStack.axis = .horizontal
        directionStack.spacing = 10
        directionStack.addArrangedSubview(directionLabel)
        directionStack.addArrangedSubview(directionControl)
        
        // 模式控制行
        let modeStack = UIStackView()
        modeStack.axis = .horizontal
        modeStack.spacing = 10
        modeStack.addArrangedSubview(modeLabel)
        modeStack.addArrangedSubview(modeControl)
        
        // 速度控制行
        let speedStack = UIStackView()
        speedStack.axis = .horizontal
        speedStack.distribution = .fillEqually
        speedStack.spacing = 10
        speedStack.addArrangedSubview(speedTitleLabel)
        speedStack.addArrangedSubview(speedSlider)
        speedStack.addArrangedSubview(speedLabel)
        
        stackView.addArrangedSubview(buttonStack)
        stackView.addArrangedSubview(directionStack)
        stackView.addArrangedSubview(modeStack)
        stackView.addArrangedSubview(speedStack)
        
        controlPanel.addSubview(stackView)
        
        // SnapKit约束
        barrageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(400)
        }
        
        controlPanel.snp.makeConstraints { make in
            make.top.equalTo(barrageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        directionLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        modeLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        speedTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        speedLabel.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
    }
    
    private func setupButton(_ button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    // MARK: - 配置弹幕视图
    private func configureBarrageView() {
        barrageView.setBarrageData(testBarrageTexts)
        barrageView.setDirection(.rightToLeft)
        barrageView.setPlayMode(.loop)
        barrageView.setSpeed(120.0) // 设置默认速度为120像素/秒
        barrageView.setFontSize(16)
        barrageView.setTextColor(.white)
        barrageView.setTextBackgroundColor(UIColor.black.withAlphaComponent(0.7))
    }
    
    // MARK: - 事件处理
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startBarrage), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopBarrage), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseBarrage), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(resumeBarrage), for: .touchUpInside)
        directionControl.addTarget(self, action: #selector(directionChanged), for: .valueChanged)
        modeControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        speedSlider.addTarget(self, action: #selector(speedChanged), for: .valueChanged)
    }
    
    @objc private func startBarrage() {
        barrageView.startBarrage()
        showFeedback("弹幕开始播放")
    }
    
    @objc private func stopBarrage() {
        barrageView.stopBarrage()
        showFeedback("弹幕停止播放")
    }
    
    @objc private func pauseBarrage() {
        barrageView.pauseBarrage()
        showFeedback("弹幕暂停")
    }
    
    @objc private func resumeBarrage() {
        barrageView.resumeBarrage()
        showFeedback("弹幕继续播放")
    }
    
    @objc private func directionChanged() {
        let directions: [BarrageDirection] = [.rightToLeft, .leftToRight, .topToBottom, .bottomToTop]
        let selectedDirection = directions[directionControl.selectedSegmentIndex]
        barrageView.setDirection(selectedDirection)
        showFeedback("方向已切换: \(directionControl.titleForSegment(at: directionControl.selectedSegmentIndex) ?? "")")
    }
    
    @objc private func modeChanged() {
        let modes: [BarragePlayMode] = [.single, .loop]
        let selectedMode = modes[modeControl.selectedSegmentIndex]
        barrageView.setPlayMode(selectedMode)
        showFeedback("模式已切换: \(modeControl.titleForSegment(at: modeControl.selectedSegmentIndex) ?? "")")
    }
    
    @objc private func speedChanged() {
        let speed = CGFloat(speedSlider.value)
        barrageView.setSpeed(speed) // 直接设置弹幕移动速度（像素/秒）
        speedLabel.text = String(format: "速度:%.0f", speed)
    }
    
    // MARK: - 辅助方法
    private func showFeedback(_ message: String) {
        // 简单的反馈提示
        let feedbackLabel = UILabel()
        feedbackLabel.text = message
        feedbackLabel.textColor = .white
        feedbackLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        feedbackLabel.textAlignment = .center
        feedbackLabel.layer.cornerRadius = 8
        feedbackLabel.clipsToBounds = true
        feedbackLabel.font = .systemFont(ofSize: 14)
        
        addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveEaseOut, animations: {
            feedbackLabel.alpha = 0
        }) { _ in
            feedbackLabel.removeFromSuperview()
        }
    }
}

// MARK: - 预览控制器
class KasaBarrageTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "弹幕组件测试"
        view.backgroundColor = .systemBackground
        
        let testView = BarrageTestView()
        view.addSubview(testView)
        
        testView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
