
class pcie_dll_tx_drv_cb_dl_feature_exch extends pcie_dll_tx_drv_cb_base;
  `uvm_object_utils(pcie_dll_tx_drv_cb_dl_feature_exch)

  function new(string name = "pcie_dll_tx_drv_cb_dl_feature_exch");
    super.new(name);
  endfunction

  virtual task pre_transmit(pcie_dll_dllp_seq_item req = null);
  // make sute that we have the LSB to be 00, 01, 10, 11,
  // don't make any changes
    
  endtask
endclass
