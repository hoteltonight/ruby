# frozen_string_literal: true

path = File.expand_path(File.dirname(__FILE__))
all_dockerfiles = Dir.glob("#{path}/**/Dockerfile")
# Alpine Linux has dropped official support for jemalloc
non_alpine_dockerfiles = all_dockerfiles.reject { |df| df.match("alpine") }

non_alpine_dockerfiles.each do |file|
  text = File.read(file)
  # Slim images are installing packages twice, we want to place jemalloc inside second one
  # so we need to place file content inside one line, use keep operator (\K) with sub!
  # to replace last occurrence and then gsub once again to place end line chars
  text.gsub!("\n", "CRLF")
      .sub!(/.*\Kapt-get install -y --no-install-recommends/, "apt-get install -y --no-install-recommends libjemalloc-dev")
      .gsub!("CRLF", "\n")
  text.gsub!(/\.\/configure/, "./configure --with-jemalloc")
  # Mark libjemalloc-dev as manually installed package to avoid removal via apt-get purge
  text.gsub!(/apt-mark manual \$savedAptMark/, "apt-mark manual libjemalloc-dev $savedAptMark")
  File.open(file, "w") { |file| file.puts(text) }
end
