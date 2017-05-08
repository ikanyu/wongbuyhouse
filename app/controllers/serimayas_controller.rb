require 'date'
class SerimayasController < ApplicationController
	def index
		if Serimaya.all.empty? || Time.now >= Serimaya.first.updated_at + 1.day
			Serimaya.destroy_all
			@temp = []
			link = []
			image = []
			pagecounter = 1
			imagecounter = 1
			starts = (Date.today - 15)
			counter = 1
			while pagecounter <= 10
				@temp << Nokogiri::HTML(open("http://www.propwall.my/setiawangsa/seri_maya/24?tab=classifieds&page=#{pagecounter}")).css('.media-body').text.gsub("\n","").gsub("\t","").split("Seri Maya, Setiawangsa").reject(&:empty?)
				while imagecounter <= 30
					begin
						link << Nokogiri::HTML(open("http://www.propwall.my/setiawangsa/seri_maya/24?tab=classifieds&page=#{pagecounter}")).at_xpath("//*[@id='list-content']/div[#{imagecounter}]/div[2]/div[1]/div/h4/a[1]").values()[0]
						image << Nokogiri::HTML(open("http://www.propwall.my/setiawangsa/seri_maya/24?tab=classifieds&page=#{pagecounter}")).at_xpath("//*[@id='list-content']/div[#{imagecounter}]/div[1]/img").values()[0]
					rescue
						break
					end
					imagecounter += 1
				end
				imagecounter = 1
				pagecounter += 1
			end
			# image = image.in_groups_of(30)
			@temp.each_with_index do |t,t_index|
				t.each_with_index do |inner,i_index|
					inner = inner.gsub("Seri Maya, SetiawangsaPosted by ","").gsub(/(?<=\().+?(?=\))/,'').gsub("() ","").gsub("for sale ","").gsub("sf","").gsub(" ()Contact | More","").gsub("# ","")
					# inner = inner.split(' ')
					if Date.parse(inner[/\d{1,2}\/\d{1,2}\/\d{4}/]) > starts
						house = Hash.new
						house['name'] = "Seri Maya"
						house['date'] = inner[/\d{1,2}\/\d{1,2}\/\d{4}/].to_date
						house['size'] = inner[/\|\d+.*sqft/].split("|")[-1].gsub(" sqft","").gsub(",","").to_i
						begin
							house['price'] = inner[/RM \d+.*\(/].gsub(" (", '').gsub("RM ","").gsub(",","")
						rescue
							house['price'] = nil
						end
						# house['link'] = link[t_index][i_index]
						house['link'] = link[t_index]
						# house['image_link'] = image[t_index][i_index]
						house['image_link'] = image[t_index]
						begin
							house['bed'] = inner[/\*+.*\|/].gsub("*","").delete(" |")
						rescue
							house['bed'] = nil
						end
						# inner[(4+1)][10] != "*" ? house['bed'] = inner[(4+1)][10].to_i : house['bed'] = inner[(4+1)][11].to_i
						if inner.include?("Fully")
							house['furnish'] = "Fully furnished"
						elsif inner[(4+1)].include?("Semi")
							house['furnish'] = "Semi furnished"
						else	
							house['furnish'] = "Not furnished"
						end
						Serimaya.create(house)
					end
				end
			end
			@houses = Serimaya.order(:price)
		else
			@houses = Serimaya.order(:price)
		end
	end
end