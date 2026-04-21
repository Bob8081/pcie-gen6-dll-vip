package pcie_dll_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Protocol enums and shared typedefs
  typedef enum int unsigned {
    PCIE_LINK_X1  = 1,
    PCIE_LINK_X2  = 2,
    PCIE_LINK_X4  = 4,
    PCIE_LINK_X8  = 8,
    PCIE_LINK_X16 = 16
  } pcie_link_width_e;

  // Values are in MT/s
  typedef enum int unsigned {
    PCIE_GEN1 =  2500,  //  2.5 GT/s
    PCIE_GEN2 =  5000,  //  5   GT/s
    PCIE_GEN3 =  8000,  //  8   GT/s
    PCIE_GEN4 = 16000,  // 16   GT/s
    PCIE_GEN5 = 32000   // 32   GT/s
  } pcie_speed_mode_e;

  // typedef enum int unsigned {
  //   TLP_MRD,
  //   TLP_MWR,
  //   TLP_CPLD,
  //   TLP_MSG,
  //   TLP_OTHER
  // } pcie_tlp_type_e;

  typedef enum bit {
    ROLE_RC = 1'b0,
    ROLE_EP = 1'b1
  } pcie_dll_role_e;

  typedef enum bit [7:0] {
    DLLP_ACK          = 8'h00,  // 0000_0000
    DLLP_NAK          = 8'h10,  // 0001_0000
    DLLP_FEATURE_REQ  = 8'h02,  // 0000_0010  (DL Feature Exchange)
    DLLP_INITFC1_P    = 8'h40,  // 0100_0000  (VC0)
    DLLP_INITFC1_NP   = 8'h50,  // 0101_0000  (VC0)
    DLLP_INITFC1_CPL  = 8'h60,  // 0110_0000  (VC0)
  DLLP_INITFC2_P    = 8'hC0,  // 1100_0000  (VC0)
    DLLP_INITFC2_NP   = 8'hD0,  // 1101_0000  (VC0)
    DLLP_INITFC2_CPL  = 8'hE0,  // 1110_0000  (VC0)
    DLLP_UPDATEFC_P   = 8'h80,  // 1000_0000  (VC0)
    DLLP_UPDATEFC_NP  = 8'h90,  // 1001_0000  (VC0)
    DLLP_UPDATEFC_CPL = 8'hA0   // 1010_0000  (VC0)
  } pcie_dllp_type_e;

  // DLCMSM state enum — models the Data Link Control & Management State Machine.
  // DL_INIT is split into its two FC-init sub-phases.
  typedef enum bit [2:0] {
    DL_INACTIVE        = 3'b000,  // link not yet up; no DLLP traffic permitted
    DL_FEATURE_EXCH    = 3'b001,  // DL Feature Exchange handshake
    DL_INIT_FC1        = 3'b010,  // advertising initial credits (InitFC1 round)
    DL_INIT_FC2        = 3'b011,  // confirming received credits (InitFC2 round)
    DL_ACTIVE          = 3'b100   // link fully active; all DLL traffic permitted
  } pcie_dlcmsm_state_e;

  // Included class files
  `include "transactions/tlp_txn.sv"
  `include "transactions/dllp_txn.sv"

  `include "env/pcie_dll_env_cfg.sv"

  `include "agents/pcie_dll_state_mgr.sv"
  `include "agents/pcie_dll_seqr.sv"
  `include "agents/pcie_dll_tx_drv.sv"
  `include "agents/pcie_dll_tx_mon.sv"
  `include "agents/pcie_dll_rx_mon.sv"

  `include "scoreboards/common_checks.sv"
  `include "scoreboards/pcie_dll_scoreboard.sv"

  `include "env/pcie_dll_env.sv"

  `include "sequences/rc_vseqs.sv"
  `include "sequences/ep_vseqs.sv"


  `include "crc/crc_generator.sv"

  `include "sequences/pcie_dll_base_seq.sv"
  `include "sequences/pcie_dll_feature_seq.sv"
  `include "sequences/pcie_dll_init1_seq.sv"
  `include "sequences/pcie_dll_init2_seq.sv"
  `include "sequences/pcie_dll_tlp_seq.sv"

  `include "transactions/pcie_dll_base_seq_item.sv"
  `include "transactions/pcie_dll_dllp_seq_item.sv"
  `include "transactions/pcie_dll_tlp_seq_item.sv"

  `include "coverage/pcie_dll_coverage.sv"

  `include "tests/test_base.sv"
  `include "tests/test_dlcmsm_fc_init.sv"

endpackage : pcie_dll_pkg
