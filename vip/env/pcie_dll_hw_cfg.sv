//class for PCIe DLL environment hardware configuration
class pcie_dll_hw_cfg extends pcie_cfg_base;

  // Link configuration 
  rand pcie_link_width_e link_width;
  rand pcie_speed_mode_e speed_mode;
  rand int unsigned      nbytes;


  // Common constraints for randomized cfg objects.
  constraint hw_geometry_c {
    nbytes inside {4, 8, 16, 32, 64};

    (link_width == PCIE_LINK_X1)  -> nbytes == 4;
    (link_width == PCIE_LINK_X2)  -> nbytes == 8;
    (link_width == PCIE_LINK_X4)  -> nbytes == 16;
    (link_width == PCIE_LINK_X8)  -> nbytes == 32;
    (link_width == PCIE_LINK_X16) -> nbytes == 64;
  }


  `uvm_object_utils_begin(pcie_dll_hw_cfg)
      `uvm_field_enum(pcie_link_width_e, link_width, UVM_DEFAULT)
      `uvm_field_enum(pcie_speed_mode_e, speed_mode, UVM_DEFAULT)
      `uvm_field_int(nbytes, UVM_DEFAULT)
  `uvm_object_utils_end


  function new(string name = "pcie_dll_hw_cfg");

    super.new(name);
    set_defaults(); // setting default values upon creation

  endfunction


  function void set_defaults();

    link_width            = PCIE_LINK_X16;
    speed_mode            = PCIE_GEN5;
    nbytes                = 64;

  endfunction



  //validation function of variables to be called when extracting the configuration at the build phase 
  //still to be fully implemented
  function bit validate(ref string validation_error_msg);

    validation_error_msg = "";

    if (!(nbytes inside {4, 8, 16, 32, 64})) begin
      validation_error_msg = "nbytes must be one of {4,8,16,32,64}";
      return 0;
    end


    if (link_width == PCIE_LINK_X16 && nbytes != 64) begin
      validation_error_msg = "link_width PCIE_LINK_X16 requires nbytes=64";
      return 0;
    end

    return 1;

  endfunction



  static function void set_cfg(
      uvm_component    cntxt,
      string           inst_name,
      pcie_dll_hw_cfg cfg,
      string           field_name = "hw_cfg"
    );

    uvm_config_db#(pcie_dll_hw_cfg)::set(cntxt, inst_name, field_name, cfg);

  endfunction



  //get configuration function checks for the validation too
  static function bit get_cfg(
      uvm_component       cntxt,
      string              inst_name,
      ref pcie_dll_hw_cfg cfg,
      string              field_name = "hw_cfg",
      bit                 required = 1
    );

    bit ok;
    string validation_err;

    ok = uvm_config_db#(pcie_dll_hw_cfg)::get(cntxt, inst_name, field_name, cfg);

    if (!ok && required) begin
      `uvm_error("CFG_MISSING",
        $sformatf("Missing %s for %s", field_name, cntxt.get_full_name()))
    end

    //validating when getting the object from the database
    if (ok) begin
      if (!cfg.validate(validation_err)) begin
        `uvm_fatal("CFG_VLD_ERR", $sformatf("Extracted config of type %s for %s is invalid! Reason: %s",
                   this.get_type_name(), cntxt.get_full_name(), validation_err))
        return 0; 
      end
    end

    return ok;

  endfunction



  function string summary();
    return $sformatf(
      "link=%0d speed=Gen%0d nbytes=%0d",
      link_width, speed_mode, nbytes
    );
  endfunction

endclass : pcie_dll_hw_cfg   