require 'date'
class SerimayasController < ApplicationController
	def index
		@items = Array.new
		@prices = Array.new
		@parent = Hash.new
		pagecounter = 1
		ncounter = 1
		starts = (Date.today - 31)
		
		counter = 1
		while pagecounter < 10
			page = Nokogiri::HTML(open("http://www.propwall.my/setiawangsa/seri_maya/24?tab=classifieds&page=#{pagecounter}"))
			@items = page.css('.media-body').text.split('Info')
			while counter <= @items.length
				@total = page.css('div.media:nth-child(' + counter.to_s + ') > div:nth-child(2) > div:nth-child(2) > div:nth-child(1)').text.split(' ')
				@parent[ncounter] = Hash.new
				@by = @total.index('by')
				@on = @total.index('on')
				@parent[ncounter]['name'] = @total[(@by+1)..(@on-1)].join(' ')
				if @total[(@on+1)][10] == "*"
					@parent[ncounter]['bed'] = @total[(@on+1)][11]
				else
					@parent[ncounter]['bed'] = @total[(@on+1)][10]
				end
				if @total[@on+1].include?("Fully")
					@parent[ncounter]['furnish'] = "Fully"
				elsif @total[@on+1].include?("Semi")
					@parent[ncounter]['furnish'] = "Semi"
				else	
					@parent[ncounter]['furnish'] = "No"
				end
				@parent[ncounter]['size'] = @total[-2]
				@price = page.css('div.media:nth-child(' + counter.to_s + ') > div:nth-child(2) > div:nth-child(2) > div:nth-child(2) > p:nth-child(1)')
				link = page.css('div.media:nth-child(' + counter.to_s + ') > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > p:nth-child(1) > a:nth-child(1)')
				@parent[ncounter]['link'] = link.map { |link| link['href'] }.join
				@parent[ncounter]['price'] = @price.text.split(' ').second.gsub(/,/, '').to_i
				if Date.parse(@total[(@on+1)][0..9]) > starts
					@parent[ncounter]['date'] = @total[(@on+1)][0..9]
				else 
					@parent.delete(ncounter)	
				end
				counter += 1
				ncounter += 1
				
			end
			if counter == 31
				counter = 1
			end
			pagecounter += 1
			
		end	
		@parent = @parent.sort_by {|key, value| value['price']}.to_h

	end
end

# #person
# div.media:nth-child(1) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1)
# div.media:nth-child(2) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1)
# #fully furnished?
# div.media:nth-child(1) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1)
# div.media:nth-child(2) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1)


# #price pattern
# div.media:nth-child(1) > div:nth-child(2) > div:nth-child(2) > div:nth-child(2) > p:nth-child(1)
# div.media:nth-child(2) > div:nth-child(2) > div:nth-child(2) > div:nth-child(2) > p:nth-child(1)



# #no. of rooms
# div.media:nth-child(1) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)
# div.media:nth-child(2) > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2)