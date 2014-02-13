import "farm.rake"

# デフォルトのタスクを記述
task :default => ["clean","build","test"]
task :setup do
    system "git submodule init"
    system "git submodule update"
end

# 必要があればプロジェクトとワークスペースのパス
# $PROJECT = "Hoge.xcodeproj"
# $WORKSPACE = "Hoge.workspace"

# デフォルトのビルドスキーム
$PRIMARY_SCHEME = :ScrivelEngine
