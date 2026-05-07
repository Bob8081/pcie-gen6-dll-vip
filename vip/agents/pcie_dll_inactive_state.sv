class pcie_dll_DL_INACTIVE extends pcie_dll_base_state;

    pcie_dlcmsm_state_e next_state; 
    `uvm_object_utils(pcie_dll_DL_INACTIVE)

    
    function new(string name = "pcie_dll_DL_INACTIVE");
        super.new(name);
    endfunction 

    task start_state(pcie_dll_state_mgr manager);
        `uvm_info("STATE", "Entered DL_INACTIVE state", UVM_LOW)

        //TODO : here wait for the link up signal
        //check for the supporting of the feature state
        if (manager.role == ROLE_EP & manager.cfg.ep_scaled_fc_supported || manager.role == ROLE_RC & manager.cfg.rc_scaled_fc_supported) begin
            next_state = DL_FEATURE_EXCH;
        end
        else  begin
            next_state = DL_INIT_FC1;   
        end
        manager.change_state(next_state); 
    endtask 
    
endclass : pcie_dll_DL_INACTIVE