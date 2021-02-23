//
//  ViewController.swift
//  BoketeDemoSwift
//
//  Created by Saori Kanenobu on 2021/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

// 入力•検索するView
class ViewController: UIViewController {
    
    // 検索テキスト
    @IBOutlet weak var searchText: UITextField!
    // 検索ボタン
    @IBOutlet weak var searchButton: UIButton!
    // 検索したイメージ
    @IBOutlet weak var searchImage: UIImageView!
    // 次の画像のボタン
    @IBOutlet weak var nextButton: UIButton!
    // ボケてのテキスト
    @IBOutlet weak var inputBoketeText: UITextView!
    // 決定ボタン
    @IBOutlet weak var doneButton: UIButton!
    // 何番目の画像か
    public var count = 0
    // 画像のURL
    private var imageUrlString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUiView()
        
        // フォトライブラリへのアクセス許可
        PHPhotoLibrary.requestAuthorization { (states) in
            switch (states) {
            case .authorized: break
            case .denied: break
            case .notDetermined: break
            case .restricted: break
            case .limited: break
            @unknown default: break
            }
        }
        
        getImage(keyword: "funny")
        setDismissKeyboard()
    }
    
    //MARK: UiView
    // Uiを作成
    public func createUiView() {
        // ViewControllerのサイズ
        let width = view.frame.width
        let height = view.frame.height
        
        // 検索テキスト
        searchText.frame = CGRect(x: width * 0.1, y: 100.0, width: width * 0.8 - 40.0, height: 30.0)
        searchText.backgroundColor = .white
        
        // 検索ボタン
        searchButton.frame = CGRect(x: searchText.frame.maxX + 10, y: searchText.frame.minY, width: 30.0, height: 30.0)
        
        // 検索したイメージ
        searchImage.frame = CGRect(x: width * 0.2, y: searchButton.frame.maxY + height * 0.02, width: width * 0.6, height: width * 0.6)
        searchImage.layer.cornerRadius = 5.0
        
        // 次の画像のボタン
        nextButton.frame = CGRect(x: width * 0.25, y: searchImage.frame.maxY + height * 0.03, width: width * 0.5, height: 30.0)
        nextButton.layer.cornerRadius = 5.0
        
        // ボケてのテキストinputBoketeText
        inputBoketeText.frame = CGRect(x: width * 0.1, y: nextButton.frame.maxY + height * 0.03, width: width * 0.8, height: height * 0.2)
        inputBoketeText.text = ""
        inputBoketeText.backgroundColor = .white
        
        // 決定ボタンdoneButton
        doneButton.frame = CGRect(x: width * 0.25, y: inputBoketeText.frame.maxY + height * 0.03, width: width * 0.5, height: 30.0)
        doneButton.layer.cornerRadius = 5.0
    }
    
    // 検索キーワードの値を元に画像を引っ張ってくる16145656-9e2a9b32bbd501e000a56c27d
    private func getImage(keyword: String) {
        
        // APIKEY 16145656-9e2a9b32bbd501e000a56c27d
        let url = "https://pixabay.com/api/?key=16145656-9e2a9b32bbd501e000a56c27d&q=\(keyword)"
        // Alamofireを使ってhttpリクエストを投げる
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ [self] (responds) in
            switch responds.result { // 成功した場合
            case .success:
                let json: JSON = JSON(responds.data as Any)
                var imageString = json["hits"][self.count]["webformatURL"].string
                if imageString == nil {
                    self.count = 0
                    imageString = json["hits"][self.count]["webformatURL"].string
                }
                self.searchImage.sd_setImage(with: URL(string: imageString!), completed: nil)
                self.imageUrlString = imageString!
                
            case .failure(let error): // 失敗した場合
                print(error)
            }
            
        }
    
    
    }

    // NextViewControllerへ遷移
    @IBAction func next(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "nextView") as! NextViewController
        nextView.previousText = inputBoketeText.text
        nextView.previousUrl = self.imageUrlString
        navigationController?.pushViewController(nextView, animated: true)
    }
    
    // 次の画像を表示する
    @IBAction func nextImage(_ sender: Any) {
        // 次の画像を検索するので、カウントアップ
        count += 1
        
        if searchText.text == "" { // 検索ワードに何も入っていない時
            getImage(keyword: "funny")
        } else { // それ以外の時
            getImage(keyword: searchText.text!)
        }

    }
    
    // 検索する
    @IBAction func searchImage(_ sender: Any) {
        // 初めて検索するので、初期化
        count = 0
        
        if searchText.text == "" { // 検索ワードに何も入っていない時
            getImage(keyword: "funny")
        } else { // それ以外の時
            getImage(keyword: searchText.text!)
        }
        // キーボードを閉じる
        searchText.resignFirstResponder()
    }
    
    
}

