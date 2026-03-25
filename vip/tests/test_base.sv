class pcie_dll_test_base extends uvm_test;

  pcie_dll_env_cfg cfg;
  pcie_dll_env     env_rc;
  pcie_dll_env     env_ep;

  `uvm_component_utils(pcie_dll_test_base)

  function new(string name = "pcie_dll_test_base", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    string validation_error_msg;
    int    tb_nbytes;
    pcie_link_width_e tb_link_width;
    pcie_speed_mode_e tb_speed_mode;

    super.build_phase(phase);

    cfg = pcie_dll_env_cfg::type_id::create("cfg");
    cfg.set_defaults();

    // Read testbench-level parameters from config_db and apply to cfg.
    if (uvm_config_db#(int)::get(this, "", "tb_nbytes", tb_nbytes)) begin
      cfg.nbytes = tb_nbytes;
      `uvm_info("CFG", $sformatf("Loaded nbytes=%0d from config_db", tb_nbytes), UVM_LOW)
    end
    if (uvm_config_db#(pcie_link_width_e)::get(this, "", "tb_link_width", tb_link_width)) begin
      cfg.link_width = tb_link_width;
      `uvm_info("CFG", $sformatf("Loaded link_width=%0d from config_db", tb_link_width), UVM_LOW)
    end
    if (uvm_config_db#(pcie_speed_mode_e)::get(this, "", "tb_speed_mode", tb_speed_mode)) begin
      cfg.speed_mode = tb_speed_mode;
      `uvm_info("CFG", $sformatf("Loaded speed_mode=%0d from config_db", tb_speed_mode), UVM_LOW)
    end

    if (!cfg.validate(validation_error_msg)) begin
      `uvm_fatal("CFG_INVALID", validation_error_msg)
    end

    // Publish shared cfg to both environments
    pcie_dll_env_cfg::set_cfg(this, "env_rc*", cfg);
    pcie_dll_env_cfg::set_cfg(this, "env_ep*", cfg);

    // Set role per-instance
    uvm_config_db#(pcie_dll_role_e)::set(this, "env_rc*", "role", ROLE_RC);
    uvm_config_db#(pcie_dll_role_e)::set(this, "env_ep*", "role", ROLE_EP);

    env_rc = pcie_dll_env::type_id::create("env_rc", this);
    env_ep = pcie_dll_env::type_id::create("env_ep", this);

    `uvm_info("CFG", $sformatf("Applied cfg: %s", cfg.summary()), UVM_LOW)
  endfunction

endclass : pcie_dll_test_base
