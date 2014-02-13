import "farm.rake"

# デフォルトのタスクを記述
task :default => ["clean","build","test"]
task :setup do
    system "gitsubmodule init"
    system "gitsubmodule update"
    system "pod"
end

# 必要があればプロジェクトとワークスペースのパス
# $PROJECT = "Hoge.xcodeproj"
# $WORKSPACE = "Hoge.workspace"

# デフォルトのビルドスキーム
$PRIMARY_SCHEME = :ScrivelEngine
