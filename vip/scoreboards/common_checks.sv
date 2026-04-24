class pcie_dll_common_checks extends uvm_object;
  //TODO : add checks for timing violation in initfc packets in recieving and transmitting
  //TODO : predict and check for current state
  `uvm_object_utils(pcie_dll_common_checks)

  function new(string name = "pcie_dll_common_checks");
    super.new(name);
  endfunction

endclass : pcie_dll_common_checks
