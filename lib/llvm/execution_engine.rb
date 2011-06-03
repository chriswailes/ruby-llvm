require 'llvm'
require 'llvm/core'
require 'llvm/analysis'

module LLVM
  def LLVM.init_arm
    LLVM::C.LLVMInitializeARMTarget
    LLVM::C.LLVMInitializeARMTargetInfo
  end
  
  def LLVM.init_alpha
    LLVM::C.LLVMInitializeAlphaTarget
    LLVM::C.LLVMInitializeAlphaTargetInfo
  end
  
  def LLVM.init_blackfin
    LLVM::C.LLVMInitializeBlackfinTarget
    LLVM::C.LLVMInitializeBlackfinTargetInfo
  end
  
  def LLVM.init_c_backend
    LLVM::C.LLVMInitializeCBackendTarget
    LLVM::C.LLVMInitializeCBackendTargetInfo
  end
  
  def LLVM.init_cell_spu
    LLVM::C.LLVMInitializeCellSPUTarget
    LLVM::C.LLVMInitializeCellSPUTargetInfo
  end
  
  def LLVM.init_cpp_backend
    LLVM::C.LLVMInitializeCppBackendTarget
    LLVM::C.LLVMInitializeCppBackendTargetInfo
  end
  
  def LLVM.init_mblaze
    LLVM::C.LLVMInitializeMBlazeTarget
    LLVM::C.LLVMInitializeMBlazeTargetInfo
  end
  
  def LLVM.init_mips
    LLVM::C.LLVMInitializeMipsTarget
    LLVM::C.LLVMInitializeMipsTargetInfo
  end
  
  def LLVM.init_mips
    LLVM::C.LLVMInitializeMSP430Target
    LLVM::C.LLVMInitializeMSP430TargetInfo
  end
  
  def LLVM.init_ptx
    LLVM::C.LLVMInitializePTXTarget
    LLVM::C.LLVMInitializePTXTargetInfo
  end
  
  def LLVM.init_ppc
    LLVM::C.LLVMInitializePowerPCTarget
    LLVM::C.LLVMInitializePowerPCTargetInfo
  end
  
  def LLVM.init_sparc
    LLVM::C.LLVMInitializeSparcTarget
    LLVM::C.LLVMInitializeSparcTargetInfo
  end
  
  def LLVM.init_sysz
    LLVM::C.LLVMInitializeSystemZTarget
    LLVM::C.LLVMInitializeSystemZTargetInfo
  end
  
  def LLVM.init_xcore
    LLVM::C.LLVMInitializeXCoreTarget
    LLVM::C.LLVMInitializeXCoreTargetInfo
  end
  
  def LLVM.init_x86
    LLVM::C.LLVMInitializeX86Target
    LLVM::C.LLVMInitializeX86TargetInfo
  end

  class JITCompiler
    def initialize(mod, opt_level = 3)
      FFI::MemoryPointer.new(FFI.type_size(:pointer)) do |ptr|
        error   = FFI::MemoryPointer.new(FFI.type_size(:pointer))
        status  = C.LLVMCreateJITCompilerForModule(ptr, mod, opt_level, error)
        errorp  = error.read_pointer
        message = errorp.read_string unless errorp.null?

        if status.zero?
          @ptr = ptr.read_pointer
        else
          C.LLVMDisposeMessage(error)
          error.autorelease=false
          raise RuntimeError, "Error creating JIT compiler: #{message}"
        end
      end
    end

    # @private
    def to_ptr
      @ptr
    end

    # Execute the given LLVM::Function with the supplied args (as
    # GenericValues).
    def run_function(fun, *args)
      FFI::MemoryPointer.new(FFI.type_size(:pointer) * args.size) do |args_ptr|
        args_ptr.write_array_of_pointer fun.params.zip(args).map { |p, a|
          a.kind_of?(GenericValue) ? a : LLVM.make_generic_value(p.type, a)
        }
        return LLVM::GenericValue.from_ptr(
          C.LLVMRunFunction(self, fun, args.size, args_ptr))
      end
    end

    # Obtain an FFI::Pointer to a global within the current module.
    def pointer_to_global(global)
      C.LLVMGetPointerToGlobal(self, global)
    end
  end

  class GenericValue
    # @private
    def to_ptr
      @ptr
    end
    
    # Casts an FFI::Pointer pointing to a GenericValue to an instance.
    def self.from_ptr(ptr)
      return if ptr.null?
      val = allocate
      val.instance_variable_set(:@ptr, ptr)
      val
    end

    # Creates a Generic Value from an integer. Type is the size of integer to
    # create (ex. Int32, Int8, etc.)
    def self.from_i(i, options = {})
      type   = options.fetch(:type, LLVM::Int)
      signed = options.fetch(:signed, true)
      from_ptr(C.LLVMCreateGenericValueOfInt(type, i, signed ? 1 : 0))
    end

    # Creates a Generic Value from a Float.
    def self.from_f(f)
      from_ptr(C.LLVMCreateGenericValueOfFloat(LLVM::Float, f))
    end

    def self.from_d(val)
      from_ptr(C.LLVMCreateGenericValueOfFloat(LLVM::Double, val))
    end
    
    # Creates a GenericValue from a Ruby boolean.
    def self.from_b(b)
      from_i(b ? 1 : 0, LLVM::Int1, false)
    end

    # Creates a GenericValue from an FFI::Pointer pointing to some arbitrary value.
    def self.from_value_ptr(ptr)
      from_ptr(LLVM::C.LLVMCreateGenericValueOfPointer(ptr))
    end

    # Converts a GenericValue to a Ruby Integer.
    def to_i(signed = true)
      C.LLVMGenericValueToInt(self, signed ? 1 : 0)
    end

    # Converts a GenericValue to a Ruby Float.
    def to_f(type = LLVM::Float.type)
      C.LLVMGenericValueToFloat(type, self)
    end
    
    # Converts a GenericValue to a Ruby boolean.
    def to_b
      to_i(false) != 0
    end
    
    def to_value_ptr
      C.LLVMGenericValueToPointer(self)
    end
  end

  # @private
  def make_generic_value(ty, val)
    case ty.kind
    when :double  then GenericValue.from_d(val)
    when :float   then GenericValue.from_f(val)
    when :pointer then GenericValue.from_value_ptr(val)
    when :integer then GenericValue.from_i(val, :type => ty)
    else
      raise "Unsupported type #{ty.kind}."
    end
  end
  module_function :make_generic_value
end
