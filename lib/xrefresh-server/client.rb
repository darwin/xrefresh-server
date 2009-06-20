require 'json'

module XRefreshServer

    # client representation on server side
    class Client
        attr_accessor :id, :dead, :type, :agent

        def initialize(id, socket)
            @id = id
            @socket = socket
            @dead = false
            @type = '?'
            @agent = '?'
        end
        
        def name
            green("#{@type}(#{@id})")
        end
    
        def send(data)
            return if @dead
            begin
                @socket << data.to_json + XREFRESH_MESSAGE_SEPARATOR
            rescue
                OUT.puts "Client #{name} #{red("is dead")}"
                @dead = true
            end
        end

        def send_about(version, agent)
            send({
              "command" => "AboutMe", 
              "version" => version, 
              "agent" => agent
            })
        end

        def send_do_refresh(root, name, type, date, time, files)
            # read all CSS files and add them into response
            contents = {}
            files.each do |item|
                next unless item["path1"] =~ /\.css$/
                path = File.join(root, item["path1"]) 
                content = File.open(path).read
                contents[item["path1"]] = content
            end
            
            send({
              "command" => "DoRefresh", 
              "root" => root, 
              "name" => name, 
              "date" => date, 
              "time" => time, 
              "type" => type, 
              "files" => files,
              "contents" => contents
            })
        end
    end

end