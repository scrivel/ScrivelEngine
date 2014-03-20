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
    system "pod"
end

task :assembler => ["assembller:script","assembller:text"]
task "assembler:script" do
    system "ruby scripts/assembller.rb SEScriptParser.m"
end
task "assembler:text" do
    system "ruby scripts/assembller.rb SETextParser.m"
end

task :doc do
    system "mkdir docs"
    system "rm docs/*.js"
    Dir.foreach("ScrivelEngine/Protocols"){|p|
        p p
        system "cp -R ScrivelEngine/Protocols/#{p} docs/#{File.basename(p,'.h')}.js" unless File.directory?(p)
    }
    system "cd docs && yuidoc . && cd ../"
end

task :map do
    system "ruby ./scripts/methodmap.rb"
end
# 必要があればプロジェクトとワークスペースのパス
# $PROJECT = "Hoge.xcodeproj"
# $WORKSPACE = "Hoge.workspace"

# デフォルトのビルドスキーム
$PRIMARY_SCHEME = "ScrivelEngine"
