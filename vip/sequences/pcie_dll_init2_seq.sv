class pcie_dll_init2_seq extends pcie_dll_base_seq;

// registeration 
`uvm_object_utils(pcie_dll_init2_seq)

// construction
function new (string name = "pcie_dll_init2_seq");
super.new(name);
endfunction

// generate a sequence of sequence items
virtual task body ();
pcie_dll_dllp_seq_item init2_transaction ; // handle


repeat (5) begin
init2_transaction= pcie_dll_dllp_seq_item::type_id::create ("init2_transaction"); // instance in factory 

start_item (init2_transaction);

// randomization
if (! init2_transaction.randomize() with {
      current_state == DL_INIT_FC2;
      
      // Pull credits from config based on DLLP type (role agnostic, as cfg is role-specific)
      if (dllp_type == DLLP_INITFC2_P) {
        hdr_scale == cfg.init_fc_hdr_scale_p;   hdr_FC == cfg.init_fc_hdr_p;
        data_scale == cfg.init_fc_data_scale_p; data_FC == cfg.init_fc_data_p;
      } else if (dllp_type == DLLP_INITFC2_NP) {
        hdr_scale == cfg.init_fc_hdr_scale_np;   hdr_FC == cfg.init_fc_hdr_np;
        data_scale == cfg.init_fc_data_scale_np; data_FC == cfg.init_fc_data_np;
      } else if (dllp_type == DLLP_INITFC2_CPL) {
        hdr_scale == cfg.init_fc_hdr_scale_cpl;   hdr_FC == cfg.init_fc_hdr_cpl;
        data_scale == cfg.init_fc_data_scale_cpl; data_FC == cfg.init_fc_data_cpl;
      }
    } ) // current state = init two state.
  `uvm_fatal ("FATAL", $sformatf("RANDOMIZATION FAILED !!"));

finish_item (init2_transaction);

end

endtask

endclass : pcie_dll_init2_seq 