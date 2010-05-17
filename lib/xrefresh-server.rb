include Term::ANSIColor
# http://kpumuk.info/ruby-on-rails/colorizing-console-ruby-script-output/
if PLATFORM =~ /win32/ then
  include Win32::Console::ANSI
end

module XRefreshServer
    VERSION = File.read(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'VERSION'))
    AGENT = "OSX xrefresh-server"
    CONFIG_FILE = ".xrefresh-server.yml"
    XREFRESH_MESSAGE_SEPARATOR = "---XREFRESH-MESSAGE---"

    def self.die(s)
        $stderr.puts s
        exit 1
    end

    def self.generate_config(path)
        puts "Generating config in #{path}"
        File.open(path, "w") do |file|
            file.puts <<CONFIG\
# here specify list of paths to monitor
paths:
  - #{File.expand_path('~')} # by default watch user's home directory
# - /you/may/add/here/some/other/path
# - /you/may/add/here/some/another/path

# you can various filters (ruby regexp pattern)
# every file is split to dir and file part (for example /Users/mick/proj/coolapp and some_file.rb)
#   both include filters must be satisfied
#   both exclude filters must not be satisfied
# empty value means "apply no filtering"
dir_include:
dir_exclude: ^#{File.expand_path('~')}/Library|/\\.(svn|git|framework|app|pbproj|pbxproj|xcode(proj)?|bundle)/
file_include:
file_exclude: ^(CVS|SCCS|vssver.?.scc|\\.(cvsignore|git|svn|DS_Store)|_svn|Thumbs\\.db)$|~$|^(\\.(?!htaccess)[^/]*|\\.(tmproj|o|pyc)|svn-commit(\\.[2-9])?\\.tmp)$ # merged TextMate and Netbeans patterns

# xpert settings
host: #{GServer::DEFAULT_HOST}
port: 41258 # known port for clients to connect
max_connections: 4 # max client connections
debug: false # run in debug mode?
audit: false # audit server activity
defer_time: 0.5 # aggregation time for events
sleep_time: 0.1 # don't hung cpu in main loop
CONFIG
        end
    end

end

LIB_DIR = File.expand_path(File.dirname(__FILE__))
require File.join(LIB_DIR, 'xrefresh-server/client.rb')
require File.join(LIB_DIR, 'xrefresh-server/server.rb')
require File.join(LIB_DIR, 'xrefresh-server/monitor.rb')
