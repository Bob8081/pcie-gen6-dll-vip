class pcie_dll_tx_mon extends uvm_monitor;

  pcie_dll_role_e role;

  `uvm_component_utils(pcie_dll_tx_mon)

  function new(string name = "pcie_dll_tx_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : pcie_dll_tx_mon
