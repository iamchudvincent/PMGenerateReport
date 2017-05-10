class CsvController < ApplicationController

	#CONSTANT VARIABLES

	def api_response(url)
		success = false

		until success
			begin
				resp = JSON.parse RestClient.get url
				success = true
				rescue Exception => e
					puts "Error: #{e.response.code}" + "Message: #{e.message}"
			end
		end

		return resp
	end

	def check_searchpath(url)
		success = false
		begin
			resp = JSON.parse RestClient.get url
			success = true
			rescue => e
				success = false 
				logger.error("Message for the log file #{e.message}")
				flash[:error] = "ERROR: Company or Library is Invalid. Please try again!"
				redirect_to(:action => 'form',:url => params[:url], :company => params[:company], :key => params[:key], :library => params[:library]) and return
		end
		return success
	end

	def check_signature(url)
		success = false
		begin
			resp = RestClient.get url
			success = true
			rescue => e
				success = false 
				logger.error("Message for the log file #{e.message}")
				flash[:error] = "ERROR: URL or Key is INVALID. Please try again!"
				redirect_to(:action => 'form',:url => params[:url], :company => params[:company], :key => params[:key], :library => params[:library]) and return
		end
		return success
	end

	def downloadcsv(csvfile)
		file = csvfile
    	send_file 'config/twistage/' + file, :type=>"text/csv", :x_sendfile=>true
    end

	def create
		@location_url = params[:url]
		@company = params[:company]
		@per_page = params[:perpage]
		@key = params[:key]
		@library = params[:library]
	 
	 	if !@key.nil? && !@key.empty?

	 		sign_url = "#{@location_url}/api/view_key?licenseKey=#{@key}&duration=60"
	 		@validate_sign = check_signature(sign_url)

	 		#CHECKING SIGNATURE URL 
	 		if @validate_sign == true
	 			sign = RestClient.get sign_url

	 			if !@library.nil? && !@library.empty?
					searchpath = "#{@location_url}/companies/#{@company}/libraries/#{@library}/videos.json?signature=#{sign}"
				else
					searchpath = "#{@location_url}/companies/#{@company}/videos.json?signature=#{sign}"
				end
				
				@validate = check_searchpath(searchpath)

				#CHECKING COMPANY AND URL
				if @validate == true
		    		object_j = api_response(searchpath)
		    		#fields names
					@fields = object_j['videos'][0]
					#custom field names
					@custom_fields = object_j['videos'][0]['custom_fields']
					@allvalue = object_j['videos']
					
    			end

	 		end #END - @validate_sign == true

	 	end #END - !@key.nil? && !@key.empty?

	end


	def createcsv_all
		@key = params[:key]
		@company = params[:company]
		@location_url = params[:url]
		@cf_headers = params[:cf_arr]
		@libraries = params[:library]
		@per_page = params[:per_page]
		@arr = params[:arr]

		sign_url = "#{@location_url}/api/view_key?licenseKey=#{@key}&duration=60"
		sign = RestClient.get sign_url

		if !@libraries.nil? && !@libraries.empty?
			lib_arr = @libraries.split(" ")
		end

		if !@arr.nil? && !@arr.empty?
			array = @arr
		end

		if !@cf_headers.nil? && !@cf_headers.empty?
			customfields_head = @cf_headers
			header_labels = array.clone().concat customfields_head
		else
			header_labels = array.clone()
		end
		
		# IF COMPANY WITH LIBRARY/IES
		if !@libraries.nil? && !@libraries.empty?

			CSV.open("config/twistage/report_all.csv", "w") do |csv|
				csv << header_labels

					#LOOP IF ONE OR MORE LIBRARY
					lib_arr.each do |library_each|

						searchpath = "#{@location_url}/companies/#{@company}/libraries/#{library_each}/videos.json?signature=#{sign}"
						pginfo     = api_response("#{searchpath}&per_page=#{@per_page}")
			    		last_page	= pginfo['page_info']['page_count']

			    		(1..last_page).each do |i|

							page = api_response("#{searchpath}&per_page=#{@per_page}&page=#{i}&verbosity=high")
						    @allvalue = page['videos']
						    i = 1

								@allvalue.each do |hash|
									values = []
									array.each do |header|
										values.push(hash[header])
									end

									#IF CUSTOM FIELDS HAVE VALUES
									if @cf_headers

										if !hash["custom_fields"].nil? && !customfields_head.empty?
											c = {}
											hash["custom_fields"].each { |cf| c[cf['name']] = cf['value'] }
											customfields_head.each do |field|		
												values.push(c[field])
											end
										end
									end

									csv << values
									i += 1 #ADD PAGE COUNT NUMBER

								end #END - @allvalue
						
						end #END - (1..last_page).each do |i|

					end #END - @libraries.each do |library_each|

			end #CSV END

		#IF COMPANY ONLY
		else
			#GET ALL LIBRARIES FROM THE COMPANY
			search_library = "#{@location_url}/companies/#{@company}/libraries.json?signature=#{sign}"
			lib_info = api_response("#{search_library}&per_page=#{@per_page}")
			last_page_lib = lib_info['page_info']['page_count']

			(1..last_page_lib).each do |lib_num|

				page = api_response("#{search_library}&per_page=#{@per_page}&page=#{lib_num}&verbosity=high")
				@all_library = page['libraries']
				lib_num = 1

				@libraries_arr = []
					@all_library.each do |name_of_library|
						@libraries_arr.push(name_of_library['name'])
					end
				lib_num += 1 #ADD PAGE COUNT NUMBER
			end

			CSV.open("config/twistage/report_all.csv", "w") do |csv|
				csv << header_labels

				#LOOP TO ALL LIBRARY
				@libraries_arr.each do |library_each|

					searchpath = "#{@location_url}/companies/#{@company}/libraries/#{library_each}/videos.json?signature=#{sign}"
					pginfo     = api_response("#{searchpath}&per_page=#{@per_page}")
			    	last_page	= pginfo['page_info']['page_count']

				    	(1..last_page).each do |num|

							page = api_response("#{searchpath}&per_page=#{@per_page}&page=#{num}&verbosity=high")
							@allvalue = page['videos']
							num = 1

								@allvalue.each do |hash|
								values = []

									array.each do |header|
										values.push(hash[header])
									end

								#IF CUSTOM FIELDS HAVE VALUES
									if @cf_headers

										if !hash["custom_fields"].nil? && !customfields_head.empty?
											c = {}
											hash["custom_fields"].each { |cf| c[cf['name']] = cf['value'] }
											customfields_head.each do |field|		
												values.push(c[field])
											end
										end
									end

									csv << values
									num += 1 #ADD PAGE COUNT NUMBER

								end #END - @allvalue
							
						end #END - (1..last_page).each do |i|

					end #END - @libraries.each do |library_each|

			end #END - CSV

		end #END - IF ELSE

		csvfile = "report_all.csv"
		downloadcsv(csvfile)

	end
end