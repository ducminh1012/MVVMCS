//
//  MainViewController.swift
//  MVVMCS
//
//  Created by Duc Le on 10/21/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import EasyPeasy
import SnapKit

class MainViewController: UIViewController, Storyboardable {
    weak var coordinator: MainCoordinator?
    let scrollView = UIScrollView()
    let circle = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupContentView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.backgroundColor = .blue
        scrollView.easy.layout(Top().to(view.safeAreaLayoutGuide, .top),
                               Bottom().to(view.safeAreaLayoutGuide, .bottom),
                               Leading(),
                               Trailing()
        )
    }
    
    private func setupContentView() {
        let contentView = UIView()
        contentView.backgroundColor = .white
        scrollView.addSubview(contentView)
        contentView.easy.layout(Edges())
        contentView.easy.layout(Width().like(scrollView),
                                Height().like(scrollView).with(.low)
        )


        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = """
        Apple vừa phát đi thông báo kêu gọi người dùng cập nhật các thiết bị cũ ngay lập tức. Nếu không cập nhật trước ngày 3/11, một số thiết bị của Apple sẽ gặp sự cố về GPS và không thể hiển thị ngày giờ chính xác. Đồng thời, nếu không cập nhật, người dùng sẽ không truy cập được các dịch vụ của Apple như mail, iCloud...

        Những bản cập nhật này đã được Apple chuẩn bị từ ngày 22/7. Tuy có vẻ nghiêm trọng nhưng chỉ có 6 model máy bị ảnh hưởng gồm iPhone 2G, 3G, 3GS, 4, 4S và 5. Ngoài iPhone, những mẫu iPad như 1, 2, 3, 4 và mini cũng thuộc diện bị ảnh hưởng. Các model này đều có tuổi đời trên 7 năm.
        """
        
        contentView.addSubview(titleLabel)
        titleLabel.easy.layout(Top(20).to(contentView),
                               Leading(8),
                               Trailing(8)
        )
        
        let square = UIView()
        square.backgroundColor = .yellow
        contentView.addSubview(square)
        square.easy.layout(CenterX(),
                           Top(20).to(titleLabel, .bottom)
        )
        square.easy.layout(Size(100))
        square.layoutIfNeeded()
        square.layer.cornerRadius = square.bounds.width / 2
        
        circle.backgroundColor = .green
        circle.clipsToBounds = true
        contentView.addSubview(circle)
        circle.snp.makeConstraints { (make) in
            make.top.equalTo(square.snp.bottom).offset(500)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        circle.layoutIfNeeded()
        circle.layer.cornerRadius = circle.bounds.width / 2
        
        let circle2 = UIView()
        circle2.backgroundColor = .blue
        circle2.clipsToBounds = true
        contentView.addSubview(circle2)
        circle2.easy.layout(CenterX(),
                             Top(20).to(circle, .bottom),
                             Size(100),
                             Bottom(20).to(contentView)
        )
        circle2.layoutIfNeeded()
        circle2.layer.cornerRadius = circle2.bounds.width / 2
    }
}
