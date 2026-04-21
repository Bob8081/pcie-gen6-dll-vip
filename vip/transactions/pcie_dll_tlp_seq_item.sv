class pcie_dll_tlp_seq_item extends pcie_dll_base_seq_item;

    bit [1:0]   current_state= 2'b11; // active state 

    bit [127:0] tlp;


    // registeration
    `uvm_object_utils_begin (pcie_dll_tlp_seq_item)
    `uvm_field_int (tlp,UVM_ALL_ON)
    `uvm_object_utils_end

    // construction
    function new (string name= "pcie_dll_tlp_seq_item" );
        super.new(name);
    endfunction

endclass : pcie_dll_tlp_seq_item