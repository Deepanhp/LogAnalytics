class LogsController < ApplicationController
  def index
  	@response = Dir["/Users/mybataz/Downloads/*"]
  end

  def show
  	hits = Hash.new(0)
		lar_req = {}
		suc_req = 0
		tota_req = 0
		hour_req = {}
		File.open("#{params['file']}", "r") do |infile|
		  while (line = infile.gets)
		    match = /(GET|POST) (\S+)/.match(line)
		    if match
			    suc_req += 1 if (line.split[line.split.length - 2] == "200")

			    size = line.split[line.split.length - 1]
			    if lar_req.empty?
			    	lar_req[size.to_i] = match[2]
			    elsif (size.to_i > lar_req.keys[0])
			    	lar_req.delete(lar_req.keys[0])
			    	lar_req[size.to_i] = match[2] 
			    end
			end
			tota_req += 1 
			d = line.split[3]
			key = DateTime.strptime(d, "[%d/%b/%Y:%H:%M:%S").strftime("%m/%d/%Y %H")
			hour_req[key].nil? ? (hour_req[key] = 1) : (hour_req[key] += 1)
		    #hits[match[2]] += 1 if match
		  end
		end
		@suc_req = suc_req
		@lar_req = lar_req
		@tota_req = tota_req
		@max_hour_req = (hour_req.max_by{|k,v| v})
		
		# print "Successful requests = #{suc_req}\n"
		# print "Largest request = #{lar_req}\n"
		# print "Total requests = #{tota_req}"
		# print (hour_req.max_by{|k,v| v})
  end
end
