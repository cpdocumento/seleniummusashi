require 'rake/testtask'

namespace 'musashi' do
  desc "Execute ScenarioA n times; include TIMES=n at end of command"
  task :all do
    times = ENV['TIMES'].to_i
    file = "test_scripts/wholeoperation.rb"
    times.times do
      system("ruby #{ file }")
    end
  end

  desc "Execute ScenarioB n times; include TIMES=n at end of command"
  task :iaas  do
    times = ENV['TIMES'].to_i
    file = "test_scripts/iaasoperation.rb"
    times.times do
      system("ruby #{ file }")
    end
  end
  
  desc "Execute ScenarioC with preparation n times; include TIMES=n="
  task :projectpreprun  do
    times = ENV['TIMES'].to_i
    prepfile = "test_scripts/projectoperationprep.rb"
    file = "test_scripts/projectoperation.rb"
    system("ruby #{ prepfile }")
    times.times do
      system("ruby #{ file }")
    end
  end

  desc "Execute ScenarioC steps 9-32 n times; include TIMES=n="
  task :project  do
    times = ENV['TIMES'].to_i
    file = "test_scripts/projectoperation.rb"
    times.times do
      system("ruby #{ file }")
    end
  end
  
  desc "Execute ScenarioD with rpeparation n times; include TIMES=n"
  task :vmpreprun do
    times = ENV['TIMES'].to_i
    prepfile = "test_scripts/vmoperationprep.rb"
    file = "test_scripts/vmoperation.rb"
    system("ruby #{ prepfile }")
    times.times do
      system("ruby #{ file }")
    end
  end

  desc "Execute ScenarioD steps 16-25 n times; include TIMES=n"
  task :vmpreprun do
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