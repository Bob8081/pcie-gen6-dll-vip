class pcie_dll_state_mgr extends uvm_component;

  pcie_dll_role_e role;

  `uvm_component_utils(pcie_dll_state_mgr)

  function new(string name = "pcie_dll_state_mgr", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : pcie_dll_state_mgr
