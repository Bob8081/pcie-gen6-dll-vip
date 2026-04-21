// ---- pcie_dll_feature_seq ----
// Generates Feature Request Traffic for the PCIe Link.
// Used to stress test the Feature Exchange state machine by 
// sending multiple consecutive DLLP_FEATURE_REQ packets.

class pcie_dll_feature_seq extends pcie_dll_base_seq;

  // ---- UVM Factory Registration ----
  `uvm_object_utils(pcie_dll_feature_seq)

  // ---- Sequence Configuration ----
  // Number of Feature Request packets to generate (Default is 5000)
  int unsigned req_count = 5000;

  // ---- Constructor ----
  function new (string name = "pcie_dll_feature_seq");
    super.new(name);
  endfunction

  // ---- Main Body Task ----
  virtual task body();
    pcie_dll_dllp_seq_item feature_transaction;

    `uvm_info("SEQ", $sformatf("Starting Feature Request Traffic (%0d packets)...", req_count), UVM_LOW)

    // ---- Traffic Generation Loop ----
    repeat (req_count) begin
      feature_transaction = pcie_dll_dllp_seq_item::type_id::create("feature_transaction");
      
      start_item(feature_transaction);

      // Randomize the item and constrain the state to trigger FEATURE_REQ
      if (!feature_transaction.randomize() with { 
            current_state == DL_FEATURE_EXCH; 
          }) begin
        `uvm_fatal("SEQ_ITEM", "Feature Request Randomization Failed!")
      end

      finish_item(feature_transaction);
    end

    `uvm_info("SEQ", "Feature Request Traffic Complete.", UVM_LOW)

  endtask

endclass : pcie_dll_feature_seq