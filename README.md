# WeatherInsight - 天気データトラッキングシステム

WeatherInsight は、世界各地の天気データを取得し、保存・分析できるアプリケーションです。Rails API バックエンドと TypeScript CLI クライアントで構成されています。

## 技術スタック

- **バックエンド**:
  - Ruby on Rails (API モード)
  - Puma
  - MySQL (Docker)
  - HTTParty（外部 API 連携）
- **テスト**:
  - RSpec (rspec-rails)
  - Factory Bot
  - Shoulda Matchers
- **フロントエンド**:
  - TypeScript
  - Node.js
  - axios
  - yargs
- **外部 API**:
  - OpenWeather API
- **開発環境**:
  - Docker（MySQL 用）

## 前提条件

- Ruby および Rails の実行環境
- Node.js および npm の実行環境
- Docker（MySQL コンテナ用）
- OpenWeather API アカウントと API キー

## セットアップ方法

### リポジトリのクローン

```
git clone https://github.com/yourusername/genai-coding-workshop.git
cd genai-coding-workshop
```

### MySQL を Docker で実行

1. Docker で MySQL を起動

プロジェクトのルートディレクトリにある `docker-compose.yml` ファイルを使用して MySQL を起動します:

```bash
docker compose up -d
```

これにより、MySQL コンテナが起動し、ポート 3306 でアクセス可能になります。以下の環境変数が設定されています:

- データベース名: `weather_insight_development`
- ユーザー名: `weather_app`
- パスワード: `yourpassword`
- ホスト: `localhost`（ローカルマシンから接続する場合）

2. MySQL の接続確認（オプション）

```bash
docker compose exec db mysql -u weather_app -p
```

プロンプトでパスワード `yourpassword` を入力すると MySQL に接続できます。

### Rails バックエンドのセットアップ

1. 必要な gem のインストール

```bash
cd backend
bundle install
```

2. データベース設定
   `config/database.yml` ファイルを編集して MySQL 設定を追加:

```yaml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV.fetch("DB_USERNAME") { 'weather_app' } %>
  password: <%= ENV.fetch("DB_PASSWORD") { 'yourpassword' } %>
  host: <%= ENV.fetch("DB_HOST") { 'localhost' } %>

development:
  <<: *default
  database: weather_insight_development

test:
  <<: *default
  database: weather_insight_test

production:
  <<: *default
  database: weather_insight_production
  username: <%= ENV.fetch("DB_USERNAME") { 'weather_app' } %>
  password: <%= ENV.fetch("DB_PASSWORD") { 'yourpassword' } %>
```

3. 環境変数の設定
   `.env`ファイルをバックエンドディレクトリに作成し、以下の内容を追加:

```
OPENWEATHER_API_KEY=あなたのAPIキー
DB_USERNAME=weather_app
DB_PASSWORD=yourpassword
DB_HOST=localhost
```

4. データベースのセットアップ

```bash
rails db:create
rails db:migrate
```

5. サーバーの起動

```bash
rails s
```

※ デフォルトでは http://localhost:3000 で API が提供されます

### TypeScript CLI のセットアップ

1. 必要なパッケージのインストール

```bash
cd frontend
npm install
```

2. 環境設定
   `.env`ファイルをフロントエンドディレクトリに作成し、以下の内容を追加:

```
API_BASE_URL=http://localhost:3000
```

3. CLI のビルド

```bash
npm run build
```

## OpenWeather API キーの取得方法

1. [OpenWeather](https://openweathermap.org/) サイトにアクセスしてアカウントを作成
2. ダッシュボードから「API keys」タブを選択
3. キーが表示されるので、コピーして上記の`.env`ファイルに設定

## 機能

### バックエンド（Rails API）

- 都市名または座標から天気データを取得し DB に記録
- 保存済みの天気データを検索・表示
- 統計情報（気温の平均値、最高/最低など）を計算

### フロントエンド（TypeScript CLI）

以下のコマンドが利用可能:

- `track <都市名>`: 指定した都市の天気データを取得・保存
- `view [都市名]`: 保存済みデータを一覧表示（都市名未指定の場合は全データ）
- `stats <都市名> [期間]`: 統計情報を表示

## 使用例

### CLI コマンド実行例

```bash
# 東京の現在の天気データを取得・保存
npm run cli track Tokyo

# 保存済みの全天気データを表示
npm run cli view

# 特定の都市の天気データを表示
npm run cli view "New York"

# 東京の過去7日間の統計情報を表示
npm run cli stats Tokyo 7
```

### API エンドポイント利用例

```
# 天気データの取得・保存
POST /weather_records
Body: { "city": "Tokyo" }

# 保存済みデータの取得
GET /weather_records
GET /weather_records?city=Tokyo

# 統計情報の取得
GET /stats?city=Tokyo&days=7
```

## 開発

### テスト

バックエンドのテストは RSpec を使用しています。以下のコマンドでテストを実行できます：

```bash
# すべてのテストを実行
cd backend
bundle exec rspec

# 特定のファイルのテストを実行
bundle exec rspec spec/models/city_spec.rb

# 特定のディレクトリのテストを実行
bundle exec rspec spec/controllers

# フォーマットを指定して実行
bundle exec rspec --format documentation

# 失敗したテストのみ再実行
bundle exec rspec --only-failures
```

テストの実行結果は標準出力に表示されます。テストカバレッジレポートを生成するには SimpleCov を使用しています。
テスト実行後、`coverage`ディレクトリに HTML レポートが生成されます。

- API ドキュメントは `/api/docs` にアクセスして確認可能

## トラブルシューティング

### Docker MySQL 関連の問題

1. MySQL コンテナが起動しない場合:

   ```bash
   docker-compose down
   docker-compose up -d
   ```

2. ポートの競合が発生する場合:
   `docker-compose.yml` ファイルのポート設定を変更してください。

3. データベース接続エラーが発生する場合:

   ```bash
   # MySQL コンテナのステータスを確認
   docker-compose ps

   # MySQL コンテナのログを確認
   docker-compose logs db

   # MySQL の接続情報を確認
   cat backend/.env
   ```

4. Rails から MySQL に接続できない場合:
   - `.env` ファイルのホスト名が正しいか確認
   - `config/database.yml` ファイルの設定が正しいか確認

## 参考資料

- [OpenWeather API ドキュメント](https://openweathermap.org/api)
- [Rails ガイド](https://guides.rubyonrails.org/)
- [TypeScript ドキュメント](https://www.typescriptlang.org/docs/)
- [Docker ドキュメント](https://docs.docker.com/)
- [Docker Compose ドキュメント](https://docs.docker.com/compose/)
- [MySQL ドキュメント](https://dev.mysql.com/doc/)
