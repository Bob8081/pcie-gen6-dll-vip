class pcie_dll_init1_seq extends pcie_dll_base_seq;

// registeration 
`uvm_object_utils(pcie_dll_init1_seq)

// construction
function new (string name = "pcie_dll_init1_seq");
super.new(name);
endfunction

// generate a sequence of sequence items
virtual task body ();
pcie_dll_dllp_seq_item init1_transaction ; // handle


repeat (5000) begin
init1_transaction= pcie_dll_dllp_seq_item::type_id::create ("init1_transaction"); // instance in factory 

start_item (init1_transaction);

// randomization
if (! init1_transaction.randomize() with {current_state == DL_INIT_FC1 ;} ) // current state = init one state.
  `uvm_fatal ("FATAL", $sformatf("RANDOMIZATION FAILED !!"));

finish_item (init1_transaction);

end

endtask
//TODO : make the values for credits fixed

endclass : pcie_dll_init1_seq 