class pcie_dll_DL_FEATURE_EXCH extends pcie_dll_base_state;

    pcie_dlcmsm_state_e next_state; 

    pcie_dll_feature_seq feature_seq;

    `uvm_object_utils(pcie_dll_DL_FEATURE_EXCH)

    
    function new(string name = "pcie_dll_DL_FEATURE_EXCH");
        super.new(name);
    endfunction 

    task start_state(pcie_dll_state_mgr manager);
        `uvm_info("STATE", "Entered DL_FEATURE_EXCH state", UVM_LOW)
         
        feature_seq = pcie_dll_feature_seq::type_id::create("feature_seq");
        feature_seq.start(manager.dllp_sequencer); 
        
        //TODO:add the feature exhcange logic
        next_state = DL_INIT_FC1;
        manager.change_state(next_state); 
    endtask

endclass : pcie_dll_DL_FEATURE_EXCH