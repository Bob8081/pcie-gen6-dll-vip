
class pcie_dll_rx_mon extends uvm_monitor;

  uvm_analysis_port #(pcie_dll_base_seq_item) mon_rx_ap; //to send the observed transactions to the state manager for processing and state transition control
  
  pcie_dll_role_e role;

  virtual pcie_lpif_if vif;

  pcie_dll_base_seq_item base_seq;
  pcie_dll_tlp_seq_item tlp_item;
  pcie_dll_dllp_seq_item dllp_item; 

  `uvm_component_utils(pcie_dll_rx_mon)

  function new(string name = "pcie_dll_rx_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_rx_ap = new("mon_rx_ap", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      
      

      @(posedge vif.lclk);
      if(vif.rst_n)begin
        if ((!(vif.pl_dlpstart >= vif.pl_dlpend) ) &  (vif.pl_valid == 'b111_111) )begin
          dllp_item = pcie_dll_dllp_seq_item::type_id::create("dllp_item");
          dllp_item.unpack(vif.pl_data[47:0]); 
          mon_rx_ap.write(dllp_item);
          `uvm_info("MON", $sformatf("Observed DLLP: %h", dllp_item.dllp), UVM_LOW)
        end
      end
        // if (vif.pl_tlpstart > vif.pl_tlpend)begin
        //   tlp_item = pcie_dll_tlp_seq_item::type_id::create("tlp_item");
        //   tlp_item.tlp=vif.pl_data[vif.pl_tlpstart * 8 : (vif.pl_tlpend + 1) * 8];
        //   mon_rx_ap.write(tlp_item);
        //   `uvm_info("MON", $sformatf("Observed TLP: %h", tlp_item.tlp), UVM_LOW)
        // end
    end
  endtask 


endclass : pcie_dll_rx_mon
