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
                @socket << data.to_json
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
            send({
              "command" => "DoRefresh", 
              "root" => root, 
              "name" => name, 
              "date" => date, 
              "time" => time, 
              "type" => type, 
              "files" => files
            })
        end
    end

end