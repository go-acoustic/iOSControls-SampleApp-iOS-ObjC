require 'socket'
require 'rake'
#require_relative '../rakefile.rb'
require File.expand_path("#{__dir__}/../rakefile.rb")

class TestServer

  $requestMessage = nil

  attr_accessor :room_count

  def initialize
    @room_count = 0
  end

  def self.stop_server_port(port)
    server_pid = %x[lsof -t -i TCP:#{port}]
    pids = server_pid.split("\n")

    pids.each do |pid|
      system('kill -9 ' + pid)
    end
  end

  def self.start

    stop_server_port(37265)

    #servHost = sampleClass.getServHost_Name

    puts "Starting server with host: #$HOST_NAME"
    server = TCPServer.new($HOST_NAME, 37265)
    requests = []
    counter = 0
    @room_count = counter
    loop do

      counter = counter + 1
      # puts 'sleeping now ... '
      # sleep(45)
      # puts '_______________this is loop number...'
      # puts counter

      Thread.start(server.accept) do |socket|
        content_size = 0
        request = ''
        get = ''
        while line = socket.gets
          if line =~ /^Content-Length:\s+(\d+)/i
            content_size = $1.to_i
          end

          if line =~ /^GET \/\?(.*)\s+HTTP.*/i
            get = $1.to_s
          end

          # if line =~ /^body:\s+(\d+)/i
          #
          #   puts "-------1!!!!"
          #   puts "WOOOOOOOHOOOOOOOOOOOOO"
          #   puts "-------2!!!!"
          # end

          request += line
          break if line == "\r\n"
        end

        message = socket.read(content_size)
        request += "body:\n" + message
          if message != ''
            # puts "++++!!!!start_call!!!!!!"
            # puts message
            # $requestMessage = message

            stringBody = StringIO.new( message)
            gz = Zlib::GzipReader.new( stringBody )
            page = gz.read()
            # puts ""
            # puts "THIS IS THE UNCOMPRESSED ONE!"
            # puts ""
            # puts page
            $requestMessage = page
            request = page                   # new change here
            # puts "++++!!!!!end_call!!!!!!"
            # exit(1)
          end
        response = ''

        if get == 'json'
          if requests.count > 0
            response = requests.shift
          end
        # elsif get == 'clear'
        #   requests = []
        else
          requests.push(request)
        end
         # puts 'JSON Received by Ruby Server'
         # puts request

        socket.print "HTTP/1.1 200 OK\r\n" +
                         "Content-Type: text/plain\r\n" +
                         "Content-Length: #{response.bytesize}\r\n" +
                         "Connection: close\r\n"

        socket.print "\r\n"

        # puts '10)!!!!!!!!!!!!!!!!...... some printing ......'
        # puts message
        $requestMessage = message
        # puts '11)!!!!!!!!!!!!!!!!!!!!_ _ _ _ _ _ _ _ '
        # puts $requestMessage
        # puts '++++++++++++++++'
        # setBody(message)
        # puts $requestMessage
        # puts '+!+!+!+!+!+!+!+'
        socket.print message
        # puts '...............'
        #puts response
        socket.print response
        # puts '...... done with the printing ......'
        # puts response
        # puts message
        # puts 'mhm'
        # puts page
        # puts message
        #puts "1)TTTTTTHIS IS THE REQUEST MESSAGE"
        #puts $requestMessage
        socket.close
        #puts "2)TTTTTTHIS IS THE REQUEST MESSAGE"
        #puts $requestMessage
        # return $requestMessage
      end
    end
  end

  def self.setBody(body)
    $requestMessage = body
  end

  def self.getBody
    return $requestMessage
  end
end
