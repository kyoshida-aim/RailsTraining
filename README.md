# RailsTraining

## 今回作成したアプリ
タスク管理を行うアプリケーション  
URL : https://ky-railstraining-2019.herokuapp.com/

## アプリケーション設計
[DB設計](https://github.com/kyoshida-aim/RailsTraining/issues/1)  
[UIイメージ](https://github.com/kyoshida-aim/RailsTraining/issues/2)  

## 自動ビルド
[![CircleCI](https://circleci.com/gh/kyoshida-aim/RailsTraining.svg?style=svg)](https://circleci.com/gh/kyoshida-aim/RailsTraining)

## 研修内容(複製)
Railsの新人研修  
https://github.com/kyoshida-aim/RailsTraining/blob/master/todo/el-training.md

# デプロイ手順
## 必要なもの
バージョン表記は執筆時点のもの
- `ruby`(2.6.3)
- `rails`(5.2.3)
- `bundler`
  - `$ gem install bundler` でインストールできる(要Ruby)
- [Heroku](https://jp.heroku.com/)のアカウント
- gitのリポジトリであるRailsアプリケーション

## 手順1: Herokuへのログイン
1. [Heroku CLI](https://devcenter.heroku.com/articles/getting-started-with-ruby#set-up)を導入する  
2. アプリケーションのディレクトリに移動  
`$ cd {アプリケーションのディレクトリ}`  
3. `$ heroku login` でHerokuにログインする

## 手順2: Herokuアプリの作成
1. `$ heroku create`でHeroku上にソースコードを受け取るアプリを作成する  
> アプリケーションのディレクトリ上で上記コマンドを実行してアプリを作成した場合、  
remoteにHerokuのremoteが追加される(はず)  
追加されている場合は`$ git remote rm heroku`で一旦Herokuへの接続設定を消す。  
2. herokuのダッシュボードを開き `Settings` → `Name` からアプリの名称を変更する  
3. `$ heroku git:remote -a アプリ名`でremoteを追加する

## 手順3: アプリをデプロイ・更新する
1. `$ git push heroku master`で`master`ブランチの内容をherokuにプッシュしてデプロイ  
2. (migrationがある場合)`$ heroku run rake db:migrate`でHeroku側にデータベースを作成する  
3. (migrationを実行した場合) `heroku restart` でアプリを再起動する
4. `$ heroku open`でアプリを開き正常に動作しているか確認する。  
> エラーが発生した場合はまず`2` のデータベースの更新を行ったかどうかを確認する

# メンテナンス等で使用する各コマンド
## 初期データ作成
`$ heroku run rake db:seed`

## railsコンソールを起動する
`$ heroku run rails console`
