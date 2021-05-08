<h1>Best-Lab</h1>

<p>大学研究者のための情報交換サイトです。</br>
研究に関する質問を投稿し、他のユーザーとメッセージを通じて解決していきます。</br>
研究内容の盗用が心配な場合は、ダイレクトメッセージを利用いただけます。</p>
<p>（スマートフォンのブラウザからでも閲覧できます）</p>

<img src="readme-fig1.png">
<img src="readme-fig2.png">
<img src="readme-fig3.png" width="320px">

<h2>URL</h2>

<p>https://best-laboratory.com</br>
トップページのゲストログインボタンから、メールアドレスとパスワードを入力せずにログインできます。</p>

<h2>使用技術</h2>

<ul>
  <li>Ruby 2.7.1</li>
  <li>Ruby on Rails 6.0.3</li>
  <li>Docker/Docker-Compose</li>
  <ul>
    <li>PostgresQL 11.11</li>
    <li>Nginx</li>
    <li>Puma</li>
  </ul>
  <li>AWS</li>
  <ul>
    <li>ALB</li>
    <li>ECR</li>
    <li>ECS</li>
    <li>RDS</li>
    <li>Route53</li>
    <li>VPC</li>
  </ul>
  <li>CircleCI CI/CD</li>
  <li>Rspec</li>
</ul>

<h2>AWS 構成図</h2>

<img src="best-lab-figure-AWS.svg">

<h3>CircleCI</h3>

<p>Githubにpush時に、RubocopとESLint、Rspecが自動で実行されます。</br>
masterブランチにマージした場合は、Rspecのテスト成功後に自動でECSにデプロイされます。</p>

<h2>機能一覧</h2>

<ul>
  <li>ユーザー登録、アカウント有効化、ログイン、パスワードリセット機能（gem devise）</li>
  <li>ユーザープロフィール作成機能</li>
  <li>ユーザープロフィール検索機能(gem ransack)</li>
  <li>質問掲示板機能</li>
  <ul>
    <li>質問の投稿</li>
    <li>質問への回答</li>
    <li>回答に対するリプライ</li>
    <li>ベストアンサー</li>
  </ul>
  <li>質問検索機能(gem ransack)</li>
  <li>ダイレクトメッセージ機能</li>
  <li>画像添付機能（*）</li>
  <ul>
    <li>画像の拡大表示</li>
  </ul>
  <li>通知機能（*）</li>
</ul>
<p>( * 質問掲示板、ダイレクトメッセージ共に対応 )</p>

<h2>テスト</h2>

<ul>
  <li>Rspec</li>
  <ul>
    <li>単体テスト（gem simplecov）</li>
	  <li>機能テスト（gem simplecov）</li>
    <li>システムテスト</li>
  </ul>
</ul>

<h2>ER図</h2>

<img src="best-lab-figure-ER.svg">
