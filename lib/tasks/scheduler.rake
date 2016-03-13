desc "Update listing"
task :update_listing => :environment do
  puts "Updating listing..."
  UpdateListing.update_serimaya_listing
  UpdateListing.update_prima16_listing
  puts "done."
end