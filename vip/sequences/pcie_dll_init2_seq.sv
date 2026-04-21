// ---- pcie_dll_init2_seq ----
// Generates InitFC2 Traffic for Link Initialization.
// Operates in 3 phased loops (P-heavy, NP-heavy, CPL-heavy) 
// to stress test the DUT while keeping Credit values constant
// across the entire initialization phase as per PCIe Spec.

class pcie_dll_init2_seq extends pcie_dll_base_seq;

  // ---- UVM Factory Registration ----
  `uvm_object_utils(pcie_dll_init2_seq)

  // ---- Sequence Configuration & State Variables ----
  // number of iterations
  rand int unsigned req_count;

  // Constant Credit values for the duration of this sequence (InitFC Rule)
  rand bit [1:0]     seq_hdr_scale;
  rand bit [1:0]     seq_data_scale;
  rand bit [7:0]     seq_hdr_FC;
  rand bit [11:0]    seq_data_FC;

  // ---- Constructor ----
  function new (string name = "pcie_dll_init2_seq");
    super.new(name);
  endfunction

  // ---- Main Body Task ----
  virtual task body();
    pcie_dll_dllp_seq_item init2_transaction;

    `uvm_info("SEQ", "Starting InitFC2 Phased Traffic Generation...", UVM_LOW)

    // Randomize sequence-level variables (Phase sizes and Constant Credits for all items)
    if (!this.randomize() with { 
          req_count   inside {[1:2000]};
        }) begin
      `uvm_fatal("SEQ", "Sequence Randomization Failed!")
    end

    repeat (req_count) begin
      // ---- Phase 1: P-Heavy Traffic (96% P, 2% NP, 2% CPL) ----
      init2_transaction = pcie_dll_dllp_seq_item::type_id::create("init2_transaction"); 

      start_item(init2_transaction);

      if (!init2_transaction.randomize() with { 
            current_state == DL_INIT_FC2; 
            
            dllp_type dist { 
              DLLP_INITFC2_P   := 96, 
              DLLP_INITFC2_NP  := 2, 
              DLLP_INITFC2_CPL := 2 
            }; 
            
            // Keep credits constant across all packets
            hdr_scale    == seq_hdr_scale;
            data_scale   == seq_data_scale;
            hdr_FC       == seq_hdr_FC;
            data_FC      == seq_data_FC; 
          }) begin
        `uvm_fatal("SEQ_ITEM", "Phase 1: Item Randomization Failed!")
      end

      finish_item(init2_transaction);

      // ---- Phase 2: NP-Heavy Traffic (2% P, 96% NP, 2% CPL) ----
      init2_transaction = pcie_dll_dllp_seq_item::type_id::create("init2_transaction");

      start_item(init2_transaction);

      if (!init2_transaction.randomize() with { 
            current_state == DL_INIT_FC2; 
            
            dllp_type dist { 
              DLLP_INITFC2_P   := 2, 
              DLLP_INITFC2_NP  := 96, 
              DLLP_INITFC2_CPL := 2 
            };
            
            // Keep credits constant across all packets
            hdr_scale    == seq_hdr_scale;
            data_scale   == seq_data_scale;
            hdr_FC       == seq_hdr_FC;
            data_FC      == seq_data_FC; 
          }) begin
        `uvm_fatal("SEQ_ITEM", "Phase 2: Item Randomization Failed!")
      end

      finish_item(init2_transaction);

      // ---- Phase 3: CPL-Heavy Traffic (2% P, 2% NP, 96% CPL) ----
      init2_transaction = pcie_dll_dllp_seq_item::type_id::create("init2_transaction");

      start_item(init2_transaction);

      if (!init2_transaction.randomize() with { 
            current_state == DL_INIT_FC2; 
            
            dllp_type dist { 
              DLLP_INITFC2_P   := 2, 
              DLLP_INITFC2_NP  := 2, 
              DLLP_INITFC2_CPL := 96 
            }; 
            
            // Keep credits constant across all packets
            hdr_scale    == seq_hdr_scale;
            data_scale   == seq_data_scale;
            hdr_FC       == seq_hdr_FC;
            data_FC      == seq_data_FC; 
          }) begin
        `uvm_fatal("SEQ_ITEM", "Phase 3: Item Randomization Failed!")
      end

      finish_item(init2_transaction);
    end

    `uvm_info("SEQ", "InitFC2 Phased Traffic Generation Complete.", UVM_LOW)

  endtask

endclass : pcie_dll_init2_seq