def most_caloric_elf
  elfcals_sums.sort.last
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
  File.read('calories.txt')
end
