//
//  BattleViewController.swift
//  TechMon
//
//  Created by MAC on 2023/05/09.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPBar: UIProgressView!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPBar: UIProgressView!
    
    var player: Player!
    var enemy: Enemy!
    
    var enemyAttackTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //デフォルトだと細かいので拡大
        playerHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        enemyHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        
        //ステータスを設定
        //fireAttackPointの初期化
        player = Player(name: "勇者", imageName: "yusya.png", attackPoint: 20, fireAttackPoint: 50.0, maxHP: 100, maxTP: 10)
        enemy = Enemy(name: "ドラゴン", imageName: "monster.png", attackPoint: 10, maxHP: 300)
        
        playerNameLabel.text = player.name
        playerImageView.image = player.image
        
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TechMonManager.playBGM(fileName: "BGM_battle001")
        
        enemyAttackTimer = Timer.scheduledTimer(
            timeInterval: 1.5,
            target: self,
            selector: #selector(enemyAttack),
            userInfo: nil,
            repeats: true
        )
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        TechMonManager.stopBGM()
    }
    
    func updateUI() {
        playerHPBar.progress = player.currentHP / player.maxHP
        
        enemyHPBar.progress = enemy.currentHP / enemy.maxHP
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        TechMonManager.vanishAnimation(imageView: vanishImageView)
        TechMonManager.stopBGM()
        enemyAttackTimer.invalidate()

        var finishMesssage: String = ""
        if isPlayerWin {
            TechMonManager.playSE(fileName: "SE_fanfare")
            finishMesssage = "勇者の勝利！！"
        }
        else {
            TechMonManager.playSE(fileName: "SE_gameover")
            finishMesssage = "勇者の敗北"
        }

        let alert = UIAlertController(
            title: "バトル終了",
            message: finishMesssage,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in self.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    @IBAction func attackAction() {
        TechMonManager.damageAnimation(imageView: enemyImageView)
        TechMonManager.playSE(fileName: "SE_attack")
        
        //こうげき
        enemy.currentHP -= player.attackPoint
        
        //TPを貯める
        player.currentTP += 5
        if player.currentTP >= player.maxTP {
            player.currentTP = player.maxTP
        }
        
        updateUI()
        
        if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    //ためる
    @IBAction func chargeAction() {
        TechMonManager.playSE(fileName: "SE_charge")
        
        player.currentTP += 20
        if player.currentTP >= player.maxTP {
            player.currentTP = player.maxTP
        }
        
        updateUI()
    }
    
    //ファイア
    @IBAction func fireAction() {
        if player.currentTP >= player.maxTP {
            TechMonManager.damageAnimation(imageView: enemyImageView)
            TechMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= player.fireAttackPoint
            
            player.currentTP = 0
        }
        
        updateUI()
        
        if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    @objc func enemyAttack() {
        TechMonManager.damageAnimation(imageView: playerImageView)
        TechMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= enemy.attackPoint
        
        updateUI()
        
        if player.currentHP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }
    }
    
    

        
        
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
