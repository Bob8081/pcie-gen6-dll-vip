class pcie_dll_env_cfg extends pcie_cfg_base;


  // Reporting and coverage controls
  bit               enable_coverage;
  bit               verbose_scoreboard;
  uvm_verbosity     log_level;

  pcie_dll_hw_cfg hw_cfg;
  pcie_dll_agent_cfg ep_cfg;
  pcie_dll_agent_cfg rc_cfg;



  `uvm_object_utils_begin(pcie_dll_env_cfg)
    `uvm_field_int(enable_coverage, UVM_DEFAULT)
    `uvm_field_int(verbose_scoreboard, UVM_DEFAULT)
    `uvm_field_enum(uvm_verbosity, log_level, UVM_DEFAULT)
    `uvm_field_object(hw_cfg, UVM_DEFAULT)
    `uvm_field_object(ep_cfg, UVM_DEFAULT)
    `uvm_field_object(rc_cfg, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "pcie_dll_env_cfg");
    super.new(name);
    hw_cfg = pcie_dll_hw_cfg::type_id::create("hw_cfg");
    ep_cfg = pcie_dll_agent_cfg::type_id::create("ep_cfg");
    rc_cfg = pcie_dll_agent_cfg::type_id::create("rc_cfg");
    set_defaults();

  endfunction

  function void set_defaults();
    enable_coverage       = 1'b1;
    verbose_scoreboard    = 1'b0;
    log_level             = UVM_MEDIUM;

    hw_cfg.set_defaults();
    ep_cfg.set_defaults();
    rc_cfg.set_defaults();

  endfunction

  function bit validate(ref string validation_error_msg = "");

    string validation_msg = "";
    bit ok = 1;

    if (!hw_cfg.validate(validation_msg)) begin
    validation_error_msg += $sformatf("hw_cfg invalid: %s \n", validation_msg);
    ok = 0;
    end

    if (!ep_cfg.validate(validation_msg)) begin
    validation_error_msg += $sformatf("ep_cfg invalid: %s \n", validation_msg);
    ok = 0;
    end

    if (!rc_cfg.validate(validation_msg)) begin
    validation_error_msg += $sformatf("rc_cfg invalid: %s \n", validation_msg);
    ok = 0;
    end

    if (ok)      validation_error_msg = "pcie_dll_env_cfg is valid";

    return ok;


  endfunction

  // Central helper to publish cfg through hierarchy using uvm_config_db.
  static function void set_cfg( uvm_component    cntxt,
                                string           inst_name,
                                pcie_dll_env_cfg cfg,
                                string           field_name = "cfg"
                                );

  uvm_config_db#(pcie_dll_env_cfg)::set(cntxt, inst_name, field_name, cfg);
  cfg.summary(); // print the contents of the config for debugging purposes
  endfunction

  // Central helper to retrieve cfg. returns 0 on miss and optionally reports.
  static function bit get_cfg(uvm_component       cntxt,          
                              string              inst_name,
                              ref pcie_dll_env_cfg cfg,
                              string              field_name,
                              bit                 required
                              );

    bit ok;
    string validation_msg;

    ok = uvm_config_db#(pcie_dll_env_cfg)::get(cntxt, inst_name, field_name, cfg);
    
    if (!ok && required) begin
      `uvm_error("CFG_MISSING",
      $sformatf("Missing %s for %s", field_name, cntxt.get_full_name()))
    end

    if (ok) begin
      if (!cfg.validate(validation_msg)) begin
        `uvm_fatal("CFG_VLD_ERR", $sformatf("Extracted config of type %s for %s is invalid! Reason: %s",
                   cfg.get_type_name(), cntxt.get_full_name(), validation_msg))
        return 0; 
      end
      else begin
        `uvm_info("CFG_VALID", $sformatf("Extracted config of type %s for %s is valid.",
                   cfg.get_type_name(), cntxt.get_full_name()), UVM_LOW)
      end
    end
    return ok;
  endfunction

  function string summary();
    return $sformatf(
      "pcie_dll_env_cfg: \n  enable_coverage=%0b \n  verbose_scoreboard=%0b \n  log_level=%s \n  hw_cfg=%s \n  ep_cfg=%s \n  rc_cfg=%s",
      enable_coverage, verbose_scoreboard, log_level.name(), hw_cfg.summary(), ep_cfg.summary(), rc_cfg.summary()
    );
  endfunction

endclass : pcie_dll_env_cfg
