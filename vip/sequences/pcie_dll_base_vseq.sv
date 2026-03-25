class pcie_dll_base_vseq extends uvm_sequence #(pcie_dll_dllp_txn);

  `uvm_object_utils(pcie_dll_base_vseq)

  function new(string name = "pcie_dll_base_vseq");
    super.new(name);
  endfunction

endclass : pcie_dll_base_vseq
