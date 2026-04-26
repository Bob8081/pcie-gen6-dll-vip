class pcie_dll_dllp_seq_item extends pcie_dll_base_seq_item;

  // DLCMSM state — drives which DLLP types are legal for this transaction
  rand pcie_dlcmsm_state_e  current_state;

  // internal signals
  rand pcie_dllp_type_e     dllp_type;
  bit  [15:0]               crc;
  bit  [23:0]               dllp_payload;

  // initFC signals
  rand bit [1:0]            hdr_scale;
  rand bit [1:0]            data_scale;
  rand bit [7:0]            hdr_FC;
  rand bit [11:0]           data_FC;

  // feature request signals
  rand bit [22:0]           feature_support;
  rand bit                  feature_ack;

  // protocol signal
  bit  [47:0]               dllp;
  rand int unsigned         delay;

  // registration
  `uvm_object_utils_begin(pcie_dll_dllp_seq_item)
    `uvm_field_enum(pcie_dlcmsm_state_e, current_state, UVM_ALL_ON)
    `uvm_field_enum(pcie_dllp_type_e, dllp_type, UVM_ALL_ON)
    `uvm_field_int(crc, UVM_ALL_ON)
    `uvm_field_int(dllp_payload, UVM_ALL_ON)
    `uvm_field_int(hdr_scale, UVM_ALL_ON)
    `uvm_field_int(data_scale, UVM_ALL_ON)
    `uvm_field_int(hdr_FC, UVM_ALL_ON)
    `uvm_field_int(data_FC, UVM_ALL_ON)
    `uvm_field_int(feature_support, UVM_ALL_ON)
    `uvm_field_int(feature_ack, UVM_ALL_ON)
    `uvm_field_int(delay, UVM_ALL_ON)
  `uvm_object_utils_end

  // construction
  function new(string name = "pcie_dll_dllp_seq_item");
    super.new(name);
  endfunction


  constraint delay_constr {
    delay dist {0:=90, 10:=9, 20:=1};
  } // constraint of delay

  // Restrict legal DLLP types to those handled by this item
  constraint dllp_type_constr {
    dllp_type inside {DLLP_FEATURE_REQ,
      DLLP_INITFC1_P, DLLP_INITFC1_NP, DLLP_INITFC1_CPL,
      DLLP_INITFC2_P, DLLP_INITFC2_NP, DLLP_INITFC2_CPL};
  }

  // Bind DLLP type to the active DLCMSM state
  constraint state_type_constr {
    if (current_state == DL_FEATURE_EXCH) {
      dllp_type == DLLP_FEATURE_REQ;
    } else if (current_state == DL_INIT_FC1) {
      dllp_type dist {
        DLLP_INITFC1_P   := 60,
        DLLP_INITFC1_NP  := 20,
        DLLP_INITFC1_CPL := 20
      };
    } else if (current_state == DL_INIT_FC2) {
      dllp_type dist {
        DLLP_INITFC2_P   := 60,
        DLLP_INITFC2_NP  := 20,
        DLLP_INITFC2_CPL := 20
      };
    }
  }

  // Build dllp_payload from the typed sub-fields, then assemble the full wire word.
  function void post_randomize();
    // Assemble payload from typed sub-fields
    if (dllp_type == DLLP_FEATURE_REQ) begin
      dllp_payload = {feature_ack, feature_support};
    end else begin // InitFC1 / InitFC2
      dllp_payload = {hdr_scale, hdr_FC, data_scale, data_FC};
    end

    // Compute CRC on the 4 wire-ordered data bytes directly.
    crc  = pcie_dll_pkg::crc16_generator::calculate_dllp_crc(pack_data());
    // Assemble the 48-bit wire word
    dllp = pack();

  endfunction

  // Returns the 4 pre-CRC bytes in wire order (byte 0 at [7:0]).
  function bit [31:0] pack_data();
    return {dllp_payload[7:0], dllp_payload[15:8], dllp_payload[23:16], dllp_type[7:0]};
  endfunction


  function bit [47:0] pack();
    // Byte 0 (dllp_type) at LSB, CRC at MSB
    return {crc, dllp_payload, dllp_type};
  endfunction

  // Monitor calls this after reconstructing the wire word from lp_data/pl_data.
  function void unpack(bit [47:0] raw);
    dllp         = raw;
    dllp_type    = pcie_dllp_type_e'(raw[7:0]);
    dllp_payload = raw[31:8];
    crc          = raw[47:32];

    // Expand payload sub-fields based on decoded type
    if (dllp_type == DLLP_FEATURE_REQ) begin
      feature_ack     = dllp_payload[23];
      feature_support = dllp_payload[22:0];
    end else begin // InitFC1 / InitFC2
      hdr_scale  = dllp_payload[23:22];
      hdr_FC     = dllp_payload[21:14];
      data_scale = dllp_payload[13:12];
      data_FC    = dllp_payload[11:0];
    end
  endfunction

  // Verifies the unpacked CRC against the computed CRC for the unpacked payload.
  // Can be used by monitors or scoreboards to check data integrity.
  function bit verify_crc();
    return (crc == pcie_dll_pkg::crc16_generator::calculate_dllp_crc(pack_data()));
  endfunction

endclass : pcie_dll_dllp_seq_item