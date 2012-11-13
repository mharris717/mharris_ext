class File
  class << self
    def create(filename,str)
      open(filename,"w") do |f|
        f << str
      end
    end
    def append(filename,str)
      open(filename,"a") do |f|
        f << str
      end
    end
  end
end