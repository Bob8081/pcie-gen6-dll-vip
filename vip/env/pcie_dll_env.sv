class pcie_dll_env extends uvm_env;

  pcie_dll_env_cfg cfg;
  pcie_dll_role_e  role;
  pcie_dll_agent   agent;

  `uvm_component_utils(pcie_dll_env)

  function new(string name = "pcie_dll_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    

    agent = pcie_dll_agent::type_id::create("agent", this);

    //TODO:add the scoreboard and coverage collector here in the next stage
    
  endfunction 
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

endclass : pcie_dll_env
