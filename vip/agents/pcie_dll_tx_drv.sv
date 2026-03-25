class pcie_dll_tx_drv extends uvm_driver #(pcie_dll_dllp_txn);

  pcie_dll_role_e role;

  `uvm_component_utils(pcie_dll_tx_drv)

  function new(string name = "pcie_dll_tx_drv", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : pcie_dll_tx_drv
