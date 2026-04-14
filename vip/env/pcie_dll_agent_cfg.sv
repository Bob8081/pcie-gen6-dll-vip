//class for test-specific PCIe DLL environment configuration
class pcie_dll_agent_cfg extends pcie_cfg_base;


    // Data Link Feature Settings (Scaled Flow Control Supported)
    rand bit               scaled_fc_supported;

    // Agent activity control
    rand bit               is_active; 


    // Feature enables
    rand bit               enable_replay; // Ack Nack
    rand bit               enable_flow_control; // Flow control DLLPs
    rand bit               enable_pwr_mgmt; // Power management DLLPs
    rand bit               enable_lcrc_checking; // Whether to check LCRC in received TLPs

   
    // Timing and behavior knobs
    rand int unsigned      ack_max_latency;
    rand int unsigned      replay_timer_cycles;
    rand int unsigned      in_flight_replay_depth;
    rand int unsigned      dllp_latency;


    // Common constraints for randomized cfg objects.
    constraint legal_ranges_c {
    ack_max_latency inside {[1:1024]};
    replay_timer_cycles inside {[4:65535]};
    in_flight_replay_depth inside {[1:4096]};
    dllp_latency inside {[0:1024]};
    }

    
    `uvm_object_utils_begin(pcie_dll_agent_cfg)
        `uvm_field_int(scaled_fc_supported, UVM_DEFAULT)
        `uvm_field_int(is_active, UVM_DEFAULT)
        `uvm_field_int(enable_replay, UVM_DEFAULT)
        `uvm_field_int(enable_flow_control, UVM_DEFAULT)
        `uvm_field_int(enable_pwr_mgmt, UVM_DEFAULT)
        `uvm_field_int(enable_lcrc_checking, UVM_DEFAULT)
        `uvm_field_int(ack_max_latency, UVM_DEFAULT)
        `uvm_field_int(replay_timer_cycles, UVM_DEFAULT)
        `uvm_field_int(in_flight_replay_depth, UVM_DEFAULT)
        `uvm_field_int(dllp_latency, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "pcie_dll_agent_cfg");
        super.new(name);
        set_defaults();
    endfunction

    function void set_defaults();

        scaled_fc_supported = 1'b0;

        is_active            = 1'b1;

        enable_replay         = 1'b1;
        enable_flow_control   = 1'b1;
        enable_pwr_mgmt       = 1'b0;
        enable_lcrc_checking  = 1'b1;

        ack_max_latency       = 16;
        replay_timer_cycles   = 256;
        in_flight_replay_depth = 64;
        dllp_latency          = 4;

    endfunction


    function bit validate(ref string validation_error_msg);
        validation_error_msg = "";

        if (!(ack_max_latency inside {[1:1024]})) begin
            validation_error_msg = "ack_max_latency must be in [1..1024]";
            return 0;
        end

        if (!(replay_timer_cycles inside {[4:65535]})) begin
            validation_error_msg = "replay_timer_cycles must be in [4..65535]";
            return 0;
        end

        if (!(in_flight_replay_depth inside {[1:4096]})) begin
            validation_error_msg = "in_flight_replay_depth must be in [1..4096]";
            return 0;
        end


        if (!(dllp_latency inside {[0:1024]})) begin
            validation_error_msg = "dllp_latency must be in [0..1024]";
            return 0;
        end

        return 1;
    endfunction

    static function void set_cfg(
        uvm_component    cntxt,
        string           inst_name, 
        pcie_dll_agent_cfg cfg,
        string           field_name = "agent_cfg"
    );
        uvm_config_db#(pcie_dll_agent_cfg)::set(cntxt, inst_name, field_name, cfg);
    endfunction

    static function bit get_cfg(
        uvm_component       cntxt,
        string              inst_name,
        ref pcie_dll_agent_cfg cfg,
        string              field_name = "agent_cfg",
        bit                 required = 1
    );

        bit ok;
        string validation_err;

        ok = uvm_config_db#(pcie_dll_agent_cfg)::get(cntxt, inst_name, field_name, cfg);

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
            "scaled_fc_supported=%b is_active=%b enable_replay=%b enable_flow_control=%b enable_pwr_mgmt=%b enable_lcrc_checking=%b ack_max_latency=%0d replay_timer_cycles=%0d in_flight_replay_depth=%0d dllp_latency=%0d",
            scaled_fc_supported, is_active, enable_replay, enable_flow_control, enable_pwr_mgmt, enable_lcrc_checking, ack_max_latency, replay_timer_cycles, in_flight_replay_depth, dllp_latency
        );
    endfunction

endclass : pcie_dll_agent_cfg