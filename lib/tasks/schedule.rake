namespace :cron do
  task :backup_images => :environment do
    backup_dir  = ENV['backup_dir']
    backup_file = "images_#{Time.now.strftime("%d-%m-%Y-%I-%S-%p")}.tar.gz"
    tar_binary  = `which tar`.strip

    puts "Changing directory to #{FileUtils.pwd}/public/system/...(current location: #{FileUtils.pwd})"

    FileUtils.cd "public/system/"

    puts FileUtils.pwd

    system("#{tar_binary} -cvzpf #{backup_file} ./")

    puts "Copying to storage dir: #{File.expand_path(backup_dir)} ..."

    FileUtils.mkdir_p("#{backup_dir}") unless File.exists?("#{backup_dir}")

    system("mv ./#{backup_file} #{backup_dir}/#{backup_file}")

    puts "Done!"

  end
end
