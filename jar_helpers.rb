class JARHelpers
  class << self
    def require_jars(dir)
      jar_files(dir) do |jar_file|
        require(jar_file)
      end
    end

    private

    def jar_files(dir)
      pattern = File.join(dir, '*.jar')
      Dir.glob(pattern) do |jar_file|
        yield(jar_file)  
      end
    end
  end
end
