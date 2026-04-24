class pcie_dll_init2_seq extends pcie_dll_base_seq;

// registeration 
`uvm_object_utils(pcie_dll_init2_seq)

// construction
function new (string name = "pcie_dll_init2_seq");
super.new(name);
endfunction

// generate a sequence of sequence items
virtual task body ();
pcie_dll_dllp_seq_item init2_transaction ; // handle


repeat (5000) begin
init2_transaction= pcie_dll_dllp_seq_item::type_id::create ("init2_transaction"); // instance in factory 

start_item (init2_transaction);

// randomization
if (! init2_transaction.randomize() with {current_state == DL_INIT_FC2 ;} ) // current state = init two state.
  `uvm_fatal ("FATAL", $sformatf("RANDOMIZATION FAILED !!"));

finish_item (init2_transaction);

end

endtask
//TODO : make the values for credits fixed and equal to initfc1

endclass : pcie_dll_init2_seq 