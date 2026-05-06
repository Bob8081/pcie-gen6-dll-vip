
class pcie_dll_tx_drv_cb_invalid_dllp extends pcie_dll_tx_drv_cb_base;
  `uvm_object_utils(pcie_dll_tx_drv_cb_invalid_dllp)

  function new(string name = "pcie_dll_tx_drv_cb_invalid_dllp");
    super.new(name);
  endfunction

  virtual task pre_transmit(pcie_dll_dllp_seq_item req = null);

  endtask
endclass
