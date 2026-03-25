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

  typedef enum int unsigned {
    PCIE_GEN1 = 1,
    PCIE_GEN2 = 2,
    PCIE_GEN3 = 3,
    PCIE_GEN4 = 4,
    PCIE_GEN5 = 5
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

  typedef enum int unsigned {
    DLLP_ACK,
    DLLP_NAK,
    DLLP_INITFC1_P,
    DLLP_INITFC1_NP,
    DLLP_INITFC1_CPL,
    DLLP_INITFC2_P,
    DLLP_INITFC2_NP,
    DLLP_INITFC2_CPL,
    DLLP_UPDATEFC_P,
    DLLP_UPDATEFC_NP,
    DLLP_UPDATEFC_CPL,
    DLLP_PWR_MGMT
  } pcie_dllp_type_e;

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

  `include "sequences/pcie_dll_base_vseq.sv"
  `include "sequences/rc_vseqs.sv"
  `include "sequences/ep_vseqs.sv"

  `include "coverage/coverage.sv"

  `include "tests/test_base.sv"
  `include "tests/test_dlcmsm_fc_init.sv"

endpackage : pcie_dll_pkg
