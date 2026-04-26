class pcie_dll_base_seq extends uvm_sequence #(pcie_dll_base_seq_item);

  // registeration
  `uvm_object_utils(pcie_dll_base_seq)

  pcie_dll_env_cfg cfg;
  pcie_dll_role_e  role;

  //construction
  function new(string name = "pcie_dll_base_seq");
    super.new(name);
  endfunction

  virtual task pre_start();
    super.pre_start();
    if (!uvm_config_db#(pcie_dll_env_cfg)::get(get_sequencer(), "", "cfg", cfg)) begin
      `uvm_fatal("NO_CFG", "No pcie_dll_env_cfg found for sequence in uvm_config_db")
    end
    if (!uvm_config_db#(pcie_dll_role_e)::get(get_sequencer(), "", "role", role)) begin
      `uvm_fatal("NO_ROLE", "No pcie_dll_role_e found for sequence in uvm_config_db")
    end
  endtask

endclass : pcie_dll_base_seq
