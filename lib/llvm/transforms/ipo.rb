# Interprocedural optimization (IPO)
require 'llvm'
require 'llvm/core'

module LLVM
  class PassManager
    # @LLVMpass function_attrs
    def fun_attrs!
      C.LLVMAddFunctionAttersPass(self)
    end
    
    # @LLVMpass inline
    def inline!
      C.LLVMAddFunctionInliningPass(self)
    end
    
    # @LLVMpass gdce
    def gdce!
      C.LLVMAddGlobalDCEPass(self)
    end
    
    # @LLVMpass ipcp
    def ipcp!
      C.LLVMAddIPConstantPropagationPass(self)
    end
    
    # @LLVMpass ipsccp
    def ipsccp!
      C.LLVMAddIPSCCPPass(self)
    end
    
    # @LLVMpass prune_eh
    def prune_eh!
      C.LLVMAddPruneEHPass(self)
    end
  end
end
