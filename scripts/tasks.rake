require "xcodeproj"

# specify your Xcode project and workspace if needed
$PROJECT = `find *.xcodeproj -maxdepth 0 2>/dev/null`.split("\n").first unless $PROJECT
$WORKSPACE = `find *.xcworkspace -maxdepth 0 2>/dev/null`.split("\n").first unless $WORKSPACE
proj = Xcodeproj::Project.open $PROJECT
$TARGETS = proj.targets.map{|t| t.name }
$SCHEMES = Xcodeproj::Project::schemes($PROJECT).map{|s| s }
$PRIMARY_SCHEME = $PRIMARY_SCHEME unless $PRIMARY_SCHEME
$CONFIGURATIONS = proj.build_configurations.map{|c| c.name }
$INFOPLIST_FILES = {}
proj.targets.each do |target|
  name = target.name
  $INFOPLIST_FILES[name] = {}
  $CONFIGURATIONS.each do |configuration|
    $INFOPLIST_FILES[name][configuration] = target.build_settings(configuration)["INFOPLIST_FILE"]
  end
end
# update types
$UPDATES = ["major","minor","patch"]

task :info do
  puts "Project:\t#{$PROJECT}"
  puts "Workspace:\t#{$WORKSPACE}"
  puts "Schemes:\t#{$SCHEMES}"
  puts "Primary Scheme:\t#{$PRIMARY_SCHEME}"
  puts "Targets:\t#{$TARGETS}"
  puts "Configurations:\t#{$CONFIGURATIONS}"
  puts "InfoPlist:"
  puts $INFOPLIST_FILES
  puts "Update Leveles:\t#{$UPDATES}"
end

# action
def build(scheme,configuration="")
  cmd = "xctool #{project_or_workspace} -scheme #{scheme.shellescape} build"
  cmd += " -configuration #{configuration}" unless configuration.empty?
  unless system cmd
    exit 1;
  end
end
# clean scheme
def clean (scheme)
  unless system "xctool clean #{project_or_workspace} -scheme #{scheme.shellescape}"
    exit 1
  end
end
# create archive
def archive(scheme)
  unless system "xctool #{project_or_workspace} archive -scheme #{scheme.shellescape}"
    exit 1
  end
end
# get project or workspace path
def project_or_workspace
  if $WORKSPACE
    "-workspace #{$WORKSPACE}"
  else
    "-project #{$PROJECT}"
  end
end
# run tests
def test(scheme)
  unless system "xctool -sdk iphonesimulator #{project_or_workspace} -scheme #{scheme.shellescape} test -parallelize -test-sdk iphonesimulator"
      exit 1
  end
end

# build tasks
# usage
# build
# build:SCHEME
# build:CONFIGURATION
# build:SCHEME:CONFIGURATION
desc "build primary scheme (currently \"#{$PRIMARY_SCHEME}\")"
task :build do
  build $PRIMARY_SCHEME
end
namespace :build do
  desc "build all schemes in the project"
  task :all do
    $SCHEMES.each{|s| build s }
  end
  # dynamic task definition
  $SCHEMES.each do |scheme|
    # define `build:SCHEME` task
    desc "build \"#{scheme}\" with primary configuration (currentlly \"#{$CONFIGURATIONS.first}\")"
    task "#{scheme}" do
      build scheme
    end
    $CONFIGURATIONS.each do |configuration|
      # define `build:CONFIGURATION` task
      desc "build primary target (currently \"#{$PRIMARY_SCHEME}\") with configuration \"#{configuration}\""
      task "#{configuration}" do
        build $PRIMARY_SCHEME, configuration
      end
      # dfine `build:SCHEME:CONFIGURATION` task
      desc "build \"#{scheme}\" with configuration \"#{configuration}\""
      task "#{scheme}:#{configuration}" do
        build scheme, configuration
      end
    end
  end
end

desc "=> test:alls"
task :test => "test:all"
namespace :test do
  desc "run all tests of schemes"
  task :all do
    $SCHEMES.each do |scheme|
      test scheme
    end
  end
  $SCHEMES.each do |scheme|
    desc "run tests of \"#{scheme}\""
    task "#{scheme}" do
      test scheme
    end
  end
end

# clean project
# usage
# clean
# clean:all
# clean:SCHEME
desc "=> clean:all"
task :clean => "clean:all"
namespace :clean do
  desc "clean all build output of the project"
  task :all do
    $SCHEMES.each do |scheme|
      clean scheme
    end
  end
  # dynamicallly run task with scheme name
  $SCHEMES.each do |scheme|
    desc "clean build output of \"#{scheme}\""
    task scheme do
      clean scheme
    end
  end
end

# usage
# options
# -ib => increment build number (CFBundleVersion)
# -iv => increment version number (CFBundleShortVersionString)
namespace :update do |t, args|
  $UPDATES.each do |update|
    $SCHEMES.each do |scheme|
      desc "increment version and build number of \"#{scheme}\""
      task "#{scheme}:#{update}" do |task|
        increment_version_number(scheme,update)
        increment_build_number(scheme)
      end
    end
  end
  def get_plist_path(scheme, configuration="Release")
    $INFOPLIST_FILES[scheme][configuration]
  end
  def get_version_number(scheme,configuration="Release")
    version = \
    `/usr/libexec/PlistBuddy -c \"Print CFBundleShortVersionString\" \"#{get_plist_path(scheme)}\"`
      .gsub("\n","")
      .to_s
      .split(".")
    # => x.x.x
    if version.length < 3
      until version.length == 3
        version << "0"
      end
    end
    p version
    version.join(".")
  end
  def increment_version_number (scheme,update)
    index = $UPDATES.index(update)
    version = get_version_number(scheme).split(".")
    version[index] = "#{version[index].to_i + 1}"
    for i in index+1..$UPDATES.length-1
      version[i] = "0"
    end
    version = version.join(".")
    write_to_plist \
      get_plist_path(scheme),
      "CFBundleShortVersionString",
      version
    return version
  end
  def increment_build_number (scheme)
    bn = get_version_number(scheme)+" "+`date "+%Y%m%d%H%M"`
    write_to_plist \
      get_plist_path(scheme),
      "CFBundleVersion",
      bn
    return bn
  end
  # write value with key into specified plist file
  def write_to_plist(plist,key,value)
    `/usr/libexec/PlistBuddy -c "Set :#{key} #{value}" "#{plist}"`
  end
end

desc "create archive of primary scheme (currently \"#{$PRIMARY_SCHEME}\")"
task :archive do
  archive $PRIMARY_SCHEME
end
namespace :archive do |t, args|
  $SCHEMES.each do |scheme|
    desc "create achive of \"#{scheme}\""
    task "#{scheme}" do
      archive scheme
      open_archive
    end
  end
  # open archive dir
  def open_archive
    dir = `echo ${HOME}/Library/Developer/Xcode/Archives/$(/bin/date +"%Y-%m-%d")`.gsub("\n","")
    system "open #{dir}"
  end
end
