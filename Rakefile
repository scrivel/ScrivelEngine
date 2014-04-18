# デフォルトのタスクを記述
task :default => ["clean","build","test"]

base = "xcodebuild -workspace ScrivelEngine.xcworkspace "

task :clean do
    exit 2 unless base + "-scheme ScrivelEngine clean"
    exit 2 unless base + "-scheme ScrivelEngineMac clean"
end

task :build do
    exit 2 unless system base + "-scheme ScrivelEngine -sdk iphoneos7.1 build"
    exit 2 unless system base + "-scheme ScrivelEngine -sdk iphonesimulator7.1 build"
    exit 2 unless system base + "-scheme ScrivelEngineMac -sdk macosx10.9 build"
end

task :test do
    exit 2 unless system base + "-scheme ScrivelEngine -sdk iphonesimulator7.1 -destination \"platform=iOS Simulator,name=iPhone Retina (4-inch)\" test"
    exit 2 unless system base + "-scheme ScrivelEngineMac -sdk macosx10.9 test"
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
