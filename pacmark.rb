
require 'base64'

# PacMark
class PacMark
  @@file_pattern = /<!-- base.*?-->/m

  def self.to_base64(filepath)
    Base64.encode64(IO.binread(filepath))
  end

  def self.slurp(path)
    file = open(path, "r")
    str = file.read()
    file.close()
    return str
  end

  def self.spit(path, str)
    file = open(path, "w")
    file.write(str)
    file.close()
  end
  
  def self.pack_md(path_md)
    # Read Non-packed markdown file.
    str = slurp(path_md)

    # Create packed markdown file.
    out_str = str + ""
    str.gsub(/!\[.*?\]\((.*)?\)/).each do |e|
      filename = e.match(/\((.*)?\)/)[1].to_s()
      basename = File.basename(filename)
      base64 = to_base64(filename)
      bin_str = "\n\n<!-- base64:#{basename}\n#{base64}-->"
      out_str += bin_str
    end
    spit(File.basename(path_md), out_str)
  end

  def self.unpack_md(path_md)
    # Read packed markdown file.
    str = slurp(path_md)

    # Write unpacked markdown file.
    spit(path_md, str.gsub(@@file_pattern, ""))

    # Unpack resource file.
    str.gsub(@@file_pattern).each do |e|
      bin_str = e.split("\n")
      bin_str.pop
      filename = bin_str.shift().match(/base64:(.*)$/)[1]
      bin = Base64.decode64(bin_str.join("\n"))
      File.binwrite("./"+filename, bin)
    end
  end
end

# exec
if ARGV[0] == "pack"
  PacMark.pack_md(ARGV[1])
elsif (ARGV[0] == "unpack")
  PacMark.unpack_md(ARGV[1])
else
  p "Error!"
end




