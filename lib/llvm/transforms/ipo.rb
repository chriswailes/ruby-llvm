# Interprocedural optimization (IPO)
require 'llvm'
require 'llvm/core'

module LLVM
  class PassManager
    # @LLVMpass gdce
    def gdce!
      C.LLVMAddGlobalDCEPass(self)
    end
    
    # @LLVMpass inline
    def inline!
      C.LLVMAddFunctionInliningPass(self)
    end
  end
end
