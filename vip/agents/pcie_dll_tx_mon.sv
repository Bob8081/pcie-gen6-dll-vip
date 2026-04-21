
class pcie_dll_tx_mon extends uvm_monitor;

  uvm_analysis_port #(pcie_dll_base_seq_item) mon_tx_ap; //to send the observed transactions to the state manager for processing and state transition control
  
  pcie_dll_role_e role;

  virtual pcie_lpif_if vif;

  pcie_dll_base_seq_item base_seq;
  pcie_dll_tlp_seq_item tlp_item;
  pcie_dll_dllp_seq_item dllp_item; 

  `uvm_component_utils(pcie_dll_tx_mon)

  function new(string name = "pcie_dll_tx_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_tx_ap = new("mon_tx_ap", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      
      

      @(posedge vif.lclk);
      if(vif.rst_n)begin
        if ((!(vif.lp_dlpstart >= vif.lp_dlpend) ) & (vif.lp_irdy==1'b1) & (vif.lp_valid == 'b111_111) & (vif.pl_trdy == 1'b1))begin
          dllp_item = pcie_dll_dllp_seq_item::type_id::create("dllp_item");
          dllp_item.unpack(vif.lp_data[47:0]);
          mon_tx_ap.write(dllp_item);
          `uvm_info("MON", $sformatf("Observed DLLP: %h", dllp_item.dllp), UVM_LOW)
        end
      end
        // if (vif.lp_tlpstart > vif.lp_tlpend)begin
        //   tlp_item = pcie_dll_tlp_seq_item::type_id::create("tlp_item");
        //   tlp_item.tlp=vif.lp_data[vif.lp_tlpstart * 8 : (vif.lp_tlpend + 1) * 8];
        //   mon_tx_ap.write(tlp_item);
        //   `uvm_info("MON", $sformatf("Observed TLP: %h", tlp_item.tlp), UVM_LOW)
        // end
    end
  endtask 


endclass : pcie_dll_tx_mon
