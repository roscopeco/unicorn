require 'mkmf'
require 'shellwords'

extension_name = 'unicorn_engine'

dir_config(extension_name)

(_, uc_ldflags, _ = pkg_config('unicorn')) or raise

libdirs = Shellwords.split(uc_ldflags)
                    .grep(/\A-L/)
                    .map { |f| f[2..] }

have_library('unicorn')

case RbConfig::CONFIG['host_os']
when /darwin|linux|bsd/
  libdirs.each do |dir|
    $LDFLAGS << " -Wl,-rpath,#{dir}"
  end
end

create_makefile(extension_name)
