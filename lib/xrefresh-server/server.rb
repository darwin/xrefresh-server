require 'gserver'

module XRefreshServer
  class Server < GServer
    attr_accessor :clients

    def initialize(port, host, max_connections, *args)
      super
      @clients = Set.new
      @last_client_id = 0
      OUT.puts "#{green('Started server')} on #{blue("#{host}:#{port}")} (max #{max_connections} clients)"
    end

    def serve(socket)
      socket.binmode
      @last_client_id += 1
      client = Client.new(@last_client_id, socket)
      @clients.add(client)
      loop do
        begin
          buffer = socket.gets(XREFRESH_MESSAGE_SEPARATOR)
        rescue
          # socket breaks on client disconnection
          break
        end
        break unless buffer
        message = buffer[0...-XREFRESH_MESSAGE_SEPARATOR.size]
        json = JSON.parse(message)
        process(client, json)
      end
    end

    def process(client, msg)
      # see windows implementation in http://github.com/darwin/xrefresh/tree/master/src/winmonitor/Server.cs#ProcessMessage
      case msg["command"]
      when "Hello"
        client.type = msg["type"] || '?'
        client.agent = msg["agent"] || '?'
        OUT.puts "Client #{client.name} [#{magenta(client.agent)}] has connected"
        client.send_about(VERSION, AGENT)
      when "Bye"
        @clients.delete(client)
        OUT.puts "Client #{client.name} has disconnected"
      when "SetPage"
        url = msg["url"] || '?'
        OUT.puts "Client #{client.name} changed page to #{blue(url)}"
      end
    end

  end
end
