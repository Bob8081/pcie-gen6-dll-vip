class pcie_dll_tlp_seq extends pcie_dll_base_seq;

// registeration 
`uvm_object_utils(pcie_dll_tlp_seq)

// construction
function new (string name = "pcie_dll_tlp_seq");
super.new(name);
endfunction

// generate a sequence of TLP sequence item
virtual task body ();
pcie_dll_tlp_seq_item tlp_transaction ; // handle


tlp_transaction= pcie_dll_tlp_seq_item::type_id::create ("tlp_transaction"); // instance in factory 

start_item (tlp_transaction);

// assign dummy value for tlp
tlp_transaction.tlp = 128'hDEADBEEF_CAFEBABE_11223344_55667788;

finish_item (tlp_transaction);


endtask


endclass : pcie_dll_tlp_seq 