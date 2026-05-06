class pcie_dll_tx_drv_callbacks extends uvm_callback; // the base class
    `uvm_object_utils(pcie_dll_tx_drv_callbacks)

    function new(string name = "pcie_dll_tx_drv_callbacks");
        super.new(name);
    endfunction

    // tasks that would be overriden
    virtual task pre_transmit(pcie_dll_dllp_seq_item req = null);  endtask
    virtual task post_transmit(pcie_dll_dllp_seq_item req = null); endtask
endclass