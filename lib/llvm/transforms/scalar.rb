require 'llvm'
require 'llvm/core'

module LLVM
  class PassManager
    # @LLVMpass adce
    def adce!
      C.LLVMAddAggressiveDCEPass(self)
    end
    
    # @LLVMpass arg_promotion
    def arg_promote!
      C.LLVMAddArgumentPromotionPass(self)
    end
    
    # @LLVMpass simplifycfg
    def simplifycfg!
      C.LLVMAddCFGSimplificationPass(self)
    end
    
    # @LLVMpass const_merge
    def const_merge!
      C.LLVMAddConstantMergePass(self)
    end
    
    # @LLVMpass constprop
    def constprop!
      C.LLVMAddConstantPropagationPass(self)
    end
    
    # @LLVMpass dae
    def dae!
      C.LLVMAddDeadArgEliminationPass(self)
    end
    
    # @LLVMpass dse
    def dse!
      C.LLVMAddDeadStoreEliminationPass(self)
    end
    
    # @LLVMpass dte
    def dte!
      C.LLVMAddDeadTypeEliminationPass(self)
    end
    
    # @LLVMpass reg2mem
    def reg2mem!
      C.LLVMAddDemoteMemoryToRegisterPass(self)
    end
    
    # @LLVMpass global_opt
    def global_opt!
      C.LLVMAddGlobalOptimizerPass(self)
    end
    
    # @LLVMpass gvn
    def gvn!
      C.LLVMAddGVNPass(self)
    end
    
    # @LLVMpass indvars
    def indvars!
      C.LLVMAddIndVarSimplifyPass(self)
    end
    
    # @LLVMpass instcombine
    def instcombine!
      C.LLVMAddInstructionCombiningPass(self)
    end
    
    # @LLVMpass init
    def init!
      C.LLVMAddInternalizePass(self)
    end
    
    # @LLVMpass jump-threading
    def jump_threading!
      C.LLVMAddJumpThreadingPass(self)
    end
    
    # @LLVMpass licm
    def licm!
      C.LLVMAddLICMPass(self)
    end
    
    # @LLVMpass loop-deletion
    def loop_deletion!
      C.LLVMAddLoopDeletionPass(self)
    end
    
    # @LLVMpass loop-rotate
    def loop_rotate!
      C.LLVMAddLoopRotatePass(self)
    end
    
    # @LLVMpass loop-unroll
    def loop_unroll!
      C.LLVMAddLoopUnrollPass(self)
    end
    
    # @LLVMpass loop-unswitch
    def loop_unswitch!
      C.LLVMAddLoopUnswitchPass(self)
    end
    
    # @LLVMpass lsj
    def lsj!
      C.LLVMAddLowerSetJmpPass(self)
    end
    
    # @LLVMpass memcpyopt
    def memcpyopt!
      C.LLVMAddMemCpyOptPass(self)
    end
    
    # @LLVMpass mem2reg
    def mem2reg!
      C.LLVMAddPromoteMemoryToRegisterPass(self)
    end
    
    # @LLVMpass raise_alloc
    def raise_alloc!
      C.LLVMAddRaiseAllocationsPass(self)
    end
    
    # @LLVMpass reassociate
    def reassociate!
      C.LLVMAddReassociatePass(self)
    end
    
    # @LLVMpass sccp
    def sccp!
      C.LLVMAddSCCPPass(self)
    end
    
    # @LLVMpass scalarrepl
    def scalarrepl!
      C.LLVMAddScalarReplAggregatesPass(self)
    end
    
    # @LLVMpass simplify-libcalls
    def simplify_libcalls!
      C.LLVMAddSimplifyLibCallsPass(self)
    end
    
    # @LLVMpass sdp
    def sdp!
      C.LLVMAddStripDeadPrototypesPass(self)
    end
    
    # @LLVMpass sds
    def sds!
      C.LLVMAddStripSymbolsPass(self)
    end
    
    # @LLVMpass tailcallelim
    def tailcallelim!
      C.LLVMAddTailCallEliminationPass(self)
    end
    
    # @LLVMpass verifier
    def verifier!
      C.LLVMAddVerifierPass(self)
    end
  end
end
