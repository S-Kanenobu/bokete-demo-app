//
//  NextViewController.swift
//  BoketeDemoSwift
//
//  Created by Saori Kanenobu on 2021/02/23.
//

import UIKit

// 入力した内容を反映するView
class NextViewController: UIViewController {
    
    // タイトルラベル
    @IBOutlet weak var titleLabel: UILabel!
    // 前の画面から取得した画像
    @IBOutlet weak var resultImage: UIImageView!
    // 前の画面から取得したラベル
    @IBOutlet weak var resultLabel: UILabel!
    // シェアするボタン
    @IBOutlet weak var shareButton: UIButton!
    // 戻るボタン
    @IBOutlet weak var backButton: UIButton!
    
    // 前画面から受け取ったテキスト
    public var previousText = ""
    // 前画面から受け取ったURL
    public var previousUrl = ""
    
    var screenShotImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUi()
        resultLabel.text = previousText
        resultImage.sd_setImage(with: URL(string: previousUrl), completed: nil)
        resultLabel.adjustsFontSizeToFitWidth = true
        
        
    }
    
    //MARK: Ui
    // Uiを作成
    public func createUi() {
        // ViewControllerのサイズ
        let width = view.frame.width
        let height = view.frame.height
        
        // タイトルラベル
        titleLabel.frame = CGRect(x: width * 0.1, y: 100.0, width: width * 0.8, height: 30.0)
        
        // 前の画面から取得した画像
        resultImage.frame = CGRect(x: width * 0.2, y: titleLabel.frame.maxY + height * 0.02, width: width * 0.6, height: width * 0.6)
        resultImage.layer.cornerRadius = 5.0
        
        // 前の画面から取得したラベル
        resultLabel.frame = CGRect(x: width * 0.1, y: resultImage.frame.maxY + height * 0.03, width: width * 0.8, height: height * 0.2)
        
        // シェアするボタン
        shareButton.frame = CGRect(x: width * 0.25, y: resultLabel.frame.maxY + height * 0.03, width: width * 0.5, height: 30.0)
        shareButton.layer.cornerRadius = 5.0
        
        // 戻るボタン
        backButton.frame = CGRect(x: width * 0.25, y: shareButton.frame.maxY + height * 0.03, width: width * 0.5, height: 30.0)
        backButton.layer.cornerRadius = 5.0
    }
    
    // ViewControllerへ戻る
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // シェアする
    @IBAction func share(_ sender: Any) {
        // スクリーンショットをとる
        takeScreenShot()
        
        let items = [screenShotImage] as [Any]
        // アクティビティビューに乗っけてシェアする
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
        
        
    }
    
    // スクリーンショットをとる
    private func takeScreenShot() {
        let width = CGFloat(UIScreen.main.bounds.size.width)
        let height = CGFloat(UIScreen.main.bounds.size.height)/1.25
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // viewに書き出す
        //viewを書き出す
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        screenShotImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    
    
}
