require 'rake/testtask'

namespace 'musashi' do
  desc "Execute Scenario A n times; include TIMES=n at end of command"
  task :all do
    times = ENV['TIMES'].to_i
    file = "test_scripts/wholeoperation.rb"
    times.times do
      system("ruby #{ file }")
    end
  end

  desc "Execute Scenario B n times; include TIMES=n at end of command"
  task :iaas  do
    times = ENV['TIMES'].to_i
    file = "test_scripts/iaasoperation.rb"
    times.times do
      system("ruby #{ file }")
    end
  end
  
  desc "Execute Scenario C n times; include TIMES=n at end of command"
  task :project  do
    times = ENV['TIMES'].to_i
    file = "test_scripts/projectoperation.rb"
    times.times do
      system("ruby #{ file }")
    end
  end
  
  desc "Execute Scenario D n times; include TIMES=n at end of command"
  task :vm do
    times = ENV['TIMES'].to_i
    file = "test_scripts/vmoperation.rb"
    times.times do
      system("ruby #{ file }")
    end
  end
end

task :default do
    puts("Please run \'rake -T\' to see possible rake commands")
end