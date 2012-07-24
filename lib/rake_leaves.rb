require 'pry'

module RakeLeaves
  require 'rake_leaves/railtie' if defined?(Rails)
  extend self

  def leaves
    [
      { match: 'binding.pry' },
      { match: 'show me the page'},
    ]
  end

  def status
    `git status -uall --porcelain`.split("\n")
  end

  def files
    status.reject { |f| f.match(/^ D/) }.map { |f| f[3..f.size] }
  end

  def matches
    leaves.map do |leaf|
      `grep -n -H '#{leaf[:match]}' #{files.join(' ')}`
    end.map { |m| m.match(/^(?<file>.*):(?<line>\d)+:(?<data>.*)$/) }
  end

  def results
    matches.map { |r| Hash[r.names.zip(r.to_a.pop(3))] }
  end

  def find
    results.each do |r|
      puts "Found the following on line #{r['line']} of #{r['file']}:"
      puts r['data']
    end
  end

end
