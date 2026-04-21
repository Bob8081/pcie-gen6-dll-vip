class pcie_dll_DL_ACTIVE extends pcie_dll_base_state;



    `uvm_object_utils(pcie_dll_DL_ACTIVE)

    
    function new(string name = "pcie_dll_DL_ACTIVE");
        super.new(name);
    endfunction 

    task start_state(pcie_dll_state_mgr manager);
        `uvm_info("STATE", "Entered DL_ACTIVE state", UVM_LOW)
        manager.target_reached.trigger(); //trigger the event to let the testbench know that we have reached the target state, which is used for coverage purposes and to control the flow in the testbench
        //TODO: here add the active state logic in next stage
    endtask

endclass : pcie_dll_DL_ACTIVE