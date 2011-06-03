require 'llvm'
require 'llvm/core'

module LLVM
  class Module
    # Verify that the module is valid.
    # @return [nil, String] human-readable description of any invalid
    #   constructs if invalid.
    def verify
      do_verification(:return_status)
    end
    
    # Verify that a module is valid, and abort the process if not.
    # @return [nil]
    def verify!
      do_verification(:abort_process)
    end
    
    private
      def do_verification(action)
        str = FFI::MemoryPointer.new(FFI.type_size(:pointer))
        status = C.LLVMVerifyModule(self, action, str)
        case status
        when 1 then str.read_string
        else nil
        end
      end
  end
  
  class Function
    # Verify that a function is valid.
    # @return [true, false]
    def verify
      do_verification(:return_status)
    end

    # Verify that a function is valid, and abort the process if not.
    # @return [true, false]
    def verify!
      do_verification(:abort_process)
    end

    private

    def do_verification(action)
      C.LLVMVerifyFunction(self, action) != 0
    end
  end
end
