def most_caloric_elves(numelves)
  elfcals_sums.sort[-(numelves)..-1]
end

def elfcals_sums
  elfcals.map(&:sum)
end

def elfcals
  elfcals_raw.gsub(/\n/, ' ').split('  ').map do |calset|
    calset.split(' ').map(&:to_i)
  end
end

def elfcals_raw
  File.read('input/calories.txt')
end
