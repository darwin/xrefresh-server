require 'directory_watcher'

module XRefreshServer
  class Monitor
    def initialize(server, config)
      @config = config
      @server = server
      @buckets = Hash.new
    end

    def schedule
      # map DirectoryWatcher events to xrefresh events (dw does not have rename)
      event_map = {:added => "created", :modified => "changed", :removed => "deleted"}

      @config["paths"].each do |path|
        OUT.puts "  monitoring #{yellow(path)}"
        dw = DirectoryWatcher.new path, :pre_load => true, :glob => "**/*", :interval => @config["defer_time"]
        dw.add_observer do |*events|
          events.each do |event|
            dir = File.dirname(event.path)
            file = File.basename(event.path)

            # skip files that do not match the filter
            next unless dir =~ @config["dir_include"]
            next if dir =~ @config["dir_exclude"]
            next unless file =~ @config["file_include"]
            next if file =~ @config["file_exclude"]

            @buckets[path]||=[]
            @buckets[path]<< {
              "action" => event_map[event.type],
              "path1" => event.path[path.size+1..-1],
              "path2" => nil
            }
          end
        end
        dw.start
      end
    end

    # blocking call
    def run_loop
      activities = {"changed" => blue('*'), "deleted" => red('-'), "created" => green('+'), "renamed" => magenta('>')}

      loop do
        if @buckets.size > 0
          @buckets.each do |root, files|
            OUT.puts "  activity in #{yellow(root)}:"
            files.each do |file|
                OUT.puts "    #{activities[file["action"]]} #{blue(file["path1"])}"
            end
            name = root
            type = 'type?'
            date = nil
            time = nil

            @server.clients.each do |client|
              client.send_do_refresh(root, name, type, date, time, files)
            end
          end
          @buckets.clear
        end
        sleep @config["sleep_time"]
      end
    end
  end
end


