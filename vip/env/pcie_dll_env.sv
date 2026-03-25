class pcie_dll_env extends uvm_env;

  pcie_dll_env_cfg cfg;
  pcie_dll_role_e  role;

  `uvm_component_utils(pcie_dll_env)

  function new(string name = "pcie_dll_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : pcie_dll_env
