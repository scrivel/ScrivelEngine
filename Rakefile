# デフォルトのタスクを記述
task :default => ["clean","build","test"]

base = "xctool -workspace ScrivelEngine.xcworkspace "

task :clean do
    exit 2 unless base + "-scheme ScrivelEngine clean"
    exit 2 unless base + "-scheme ScrivelEngineMac clean"
end

task :build do
    exit 2 unless system base + "-scheme ScrivelEngine build"
    exit 2 unless system base + "-scheme ScrivelEngineMac build"
end

task :test do
    exit 2 unless system base + "-scheme ScrivelEngine -sdk iphonesimulator test  -test-sdk iphonesimulator -parallelize"
    exit 2 unless system base + "-scheme ScrivelEngineMac test"
end

task :setup do
    system "git submodule update --init --recursive"
end

task :assembler do
    system "ruby scripts/assembller.rb"
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
