class pcie_dll_feature_seq extends pcie_dll_base_seq;

// registeration 
`uvm_object_utils(pcie_dll_feature_seq)

// construction
function new (string name = "pcie_dll_feature_seq");
super.new(name);
endfunction

// generate a sequence of sequence items
virtual task body ();
pcie_dll_dllp_seq_item feature_transaction ; // handle


repeat (5000) begin
feature_transaction= pcie_dll_dllp_seq_item::type_id::create ("feature_transaction"); // instance in factory 

start_item (feature_transaction);

// randomization
if (! feature_transaction.randomize() with {current_state == 2'b01 ;} ) // current state = feature state.
  `uvm_fatal ("FATAL", $sformatf("RANDOMIZATION FAILED !!"));

finish_item (feature_transaction);

end

endtask


endclass : pcie_dll_feature_seq 