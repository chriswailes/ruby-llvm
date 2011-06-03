require 'llvm'

module LLVM
	require 'llvm/bindings'
	
	require 'llvm/core/context'
	require 'llvm/core/module'
	require 'llvm/core/type'
	require 'llvm/core/value'
	require 'llvm/core/builder'
	require 'llvm/core/pass_manager'
	require 'llvm/core/bitcode'
	
	def LLVM::load_library(filename)
		EB::LLVMLoadLibraryPermanently(filename)
	end
end
