require 'directory_watcher'

module XRefreshServer
  class Monitor
    def initialize(server, config)
      @config = config
      @server = server
    end

    def schedule
      @config["paths"].each do |path|
        OUT.puts "Monitoring #{path}"
        dw = DirectoryWatcher.new path, :preload => true, :glob => "**/*.css", :interval => 0.5
        dw.add_observer do |*events|
          events.each do |event|
            OUT.puts "File #{event.type} observed in file: #{event.path}"
            @server.clients.each do |client|
              return if event.type == :added
              event.type = "changed" if event.type == :modified
              event.type = "removed" if event.type == :deleted
              client.send_do_refresh("", "", 'type?', nil, nil, [{"action" => event.type.to_s, "path1" => event.path, "path2" => nil}])
            end
          end
        end
        dw.start
      end
    end

    # blocking call
    def run_loop
      sleep
    end
  end
end


