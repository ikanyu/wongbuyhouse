require 'date'
class SerimayasController < ApplicationController
	def index
		if Serimaya.all.empty? || ((Time.now - Serimaya.first.created_at)/1.hour).round >= 1
			Serimaya.destroy_all
			@temp = []
			link = []
			image = []
			pagecounter = 1
			imagecounter = 1
			starts = (Date.today - 15)
			counter = 1
			while pagecounter <= 10
				@temp << Nokogiri::HTML(open("http://www.propwall.my/setiawangsa/seri_maya/24?tab=classifieds&page=#{pagecounter}")).css('.media-body').text.split(' Info')
				link << Nokogiri::HTML(open("http://www.propwall.my/setiawangsa/seri_maya/24?tab=classifieds&page=#{pagecounter}")).css('.media-heading a').map{|link| link['href']}
				while imagecounter <= 30
					image << Nokogiri::HTML(open("http://www.propwall.my/setiawangsa/seri_maya/24?tab=classifieds&page=#{pagecounter}")).at_xpath("//*[@id='list-content']/div[#{imagecounter}]/div[1]/img").values()[0]
					imagecounter += 1
				end
				imagecounter = 1
				pagecounter += 1
			end
			image = image.in_groups_of(30)
			@temp.each_with_index do |t,t_index|
				t.each_with_index do |inner,i_index|
					inner = inner.gsub("Seri Maya, SetiawangsaPosted by ","").gsub(/(?<=\().+?(?=\))/,'').gsub("() ","").gsub("for sale ","").gsub("sf","").gsub(" ()Contact | More","").gsub("# ","")
					inner = inner.split(' ')
					if Date.parse(inner[(inner.index('on')+1)][0..9]) > starts
						house = Hash.new
						house['name'] = inner[0..(inner.index('on')-1)].join(' ')
						house['date'] = inner[(inner.index('on')+1)][0..9].to_date
						house['size'] = inner[-3].gsub!(',','').to_i
						house['price'] = (inner[-1]).gsub(/,/, '').to_i
						house['link'] = link[t_index][i_index]
						house['image_link'] = image[t_index][i_index]
						inner[(inner.index('on')+1)][10] != "*" ? house['bed'] = inner[(inner.index('on')+1)][10].to_i : house['bed'] = inner[(inner.index('on')+1)][11].to_i
						if inner[(inner.index('on')+1)].include?("Fully")
							house['furnish'] = "Fully furnished"
						elsif inner[(inner.index('on')+1)].include?("Semi")
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