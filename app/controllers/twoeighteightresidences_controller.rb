require 'date'
class TwoeighteightresidencesController < ApplicationController
	def index
		@temp = []
		link = []
		@temp1 = Hash.new
		pagecounter = 1
		starts = (Date.today - 31)
		counter = 1
		while pagecounter <= 10
			@temp << Nokogiri::HTML(open("http://www.propwall.my/kuchai/288_residences/7660?tab=classifieds&page=#{pagecounter}")).css('.media-body').text.split(' Info')
			link << Nokogiri::HTML(open("http://www.propwall.my/kuchai/288_residences/7660?tab=classifieds&page=#{pagecounter}")).css('.media-heading a').map{|link| link['href']}
			pagecounter += 1
		end
		@temp.each_with_index do |t,t_index|
			t.each_with_index do |inner,i_index|
				inner = inner.split(' ')
				# byebug
				inner.delete("288")
				inner.delete("Residences,")
				inner.delete("KuchaiPosted")
				inner.delete("by")
				# inner.delete("on")
				inner.delete("Condominium")
				inner.delete("for")
				inner.delete("sale")
				inner.delete("#")
				inner.delete("sfRM")
				inner.delete("(RM")
				inner.delete("psf)Contact")
				inner.delete("|")
				inner.delete("More")
				if Date.parse(inner[(inner.index('on')+1)][0..9]) > starts
					@temp1[counter] = Hash.new
					@temp1[counter]['name'] = inner[0..(inner.index('on')-1)].join(' ')
					@temp1[counter]['date'] = inner[(inner.index('on')+1)][0..9]
					@temp1[counter]['size'] = inner[-3]
					@temp1[counter]['price'] = (inner[-2]).gsub(/,/, '').to_i
					@temp1[counter]['link'] = link[t_index][i_index]
					inner[(inner.index('on')+1)][10] != "*" ? @temp1[counter]['bed'] = inner[(inner.index('on')+1)][10] : @temp1[counter]['bed'] = inner[(inner.index('on')+1)][11]
					if inner[(inner.index('on')+1)].include?("Fully")
						@temp1[counter]['furnish'] = "Fully"
					elsif inner[(inner.index('on')+1)].include?("Semi")
						@temp1[counter]['furnish'] = "Semi"
					else	
						@temp1[counter]['furnish'] = "No"
					end
					counter+=1
				end
			end
		end	
		@temp1 = @temp1.sort_by {|key, value| value['price']}.to_h
	end
end
