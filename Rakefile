require 'rubygems/package_task'
require 'rake/testtask'

LLVM_TARGET_VERSION = '2.9'

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new do |t|
    t.libs << "test"
    t.rcov_opts << "--exclude gems"
    t.test_files = FileList["test/**/*_test.rb"]
  end
rescue LoadError
  warn "Proceeding without Rcov. gem install rcov on supported platforms."
end

begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    yardlib = File.join(File.dirname(__FILE__), "yardlib/llvm.rb")
    t.options = %W[-e #{yardlib} --no-private]
    t.files = Dir['lib/**/*.rb']
  end
rescue LoadError
  warn "Yard is not installed. `gem install yard` to build documentation."
end

def spec
  Gem::Specification.new do |s|
    s.platform = Gem::Platform::RUBY
    
    s.name = 'ruby-llvm'
    s.version = '2.9.1'
    s.summary = "LLVM bindings for Ruby"
    
    s.add_dependency('ffi', '>= 1.0.0')
    s.files = Dir['lib/**/*rb']
    s.require_path = 'lib'
    
    s.extra_rdoc_files = 'README.rdoc'
    
    s.author = "Jeremy Voorhis"
    s.email = "jvoorhis@gmail.com"
    s.homepage = "http://github.com/jvoorhis/ruby-llvm"
  end
end

Gem::PackageTask.new(spec)

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :check_bindings, :verbose do |t, args|
	(args = args.to_hash)[:verbose] = if args[:verbose] == 'true' then true else false end
	
	require 'lib/llvm/bindings'
	
	# Check for objdump.
	if not (bin = `which objdump`.chomp)[0,1] == '/'
		puts 'objdump binary not found.'
		return
	end
	
	# Locate the LLVM shared library.
	lib_path = nil
	
	paths  = ENV['LD_LIBRARY_PATH'].split(/:/).uniq
	paths << '/usr/lib/'
	paths << '/usr/lib64/'
	
	paths.each do |path|
		test_path = File.join(path, "libLLVM-#{LLVM_TARGET_VERSION}.so")
		if File.exists?(test_path)
			lib_path = test_path
		end
	end
	
	if not lib_path
		puts "libLLVM-#{LLVM_TARGET_VERSION}.so not found."
		return
	end
	
	# Grab library symbols.
	lines = `#{bin} -t #{lib_path}`
	
	lsyms = lines.map do |l|
		md = l.match(/\s(LLVM\w+)/)
		if md then md[1] else nil end
	end.compact.uniq
	
	# Defined symbols.
	dsyms = Symbol.all_symbols.map do |sym|
		sym = sym.to_s
		if sym.match(/^LLVM[a-zA-Z]+/) then sym else nil end
	end.compact
	
	# Sort the symbols.
	bound	= Array.new
	unbound	= Array.new
	unbinds	= Array.new

	lsyms.each do |sym|
		if dsyms.include?(sym) then bound else unbound end << sym
	end
	
	dsyms.each do |sym|
		if not lsyms.include?(sym) then unbinds << sym end
	end
	
	puts "Bound Functions: #{bound.length}"
	puts "Unbound Functions: #{unbound.length}"
	puts "Bad Bindings: #{unbinds.length}"
	puts "Completeness: #{((bound.length / lsyms.length.to_f) * 100).to_i}%"
	
	if args[:verbose]
		puts() if unbound.length > 0 and unbinds.length > 0
		
		if unbound.length > 0
			puts 'Unbound Functions:'
			unbound.sort.each {|sym| puts sym}
			puts
		end
		
		if unbinds.length > 0
			puts 'Bad Bindings:'
			unbinds.sort.each {|sym| puts sym}
		end
	end
end

task :default => [:test]
