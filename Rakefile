import "./scripts/tasks.rake"

# デフォルトのタスクを記述
task :default => ["clean","build","test"]

task :testall do
    $SCHEMES.each do |s|
        task = "xctool -workspace ScrivelEngine.xcworkspace -scheme #{s}"
        unless  s.match /Mac/
            system task + " -sdk iphonesimulator test -test-sdk iphonesimulator"
        else
            system task + " test"
        end
    end
end

task :setup do
    system "git submodule init"
    system "git submodule update"
end

task :assembler do
    system "ruby scripts/assembller.rb"
end

task :doc do
    system "mkdir docs"
    ["SEObject", "SELayer", "SEBackground", "SETextFrame", "SEBackgroundMusic", "SEUserInterface", "SESoundEffect"].each do |p|
        system "cp -R ./ScrivelEngine/#{p}.h docs/#{p}.js "
    end
    system "cd docs && yuidoc . && cd ../"
end

# 必要があればプロジェクトとワークスペースのパス
# $PROJECT = "Hoge.xcodeproj"
# $WORKSPACE = "Hoge.workspace"

# デフォルトのビルドスキーム
$PRIMARY_SCHEME = "ScrivelEngine"
