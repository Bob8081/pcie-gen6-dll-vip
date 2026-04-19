
class pcie_dll_tx_drv extends uvm_driver #(pcie_dll_base_seq_item);

    //Declaration
    pcie_dll_role_e role;
    virtual pcie_lpif_if vif;
    pcie_dll_base_seq_item req;
    pcie_dll_dllp_seq_item dllp_txn;
    pcie_dll_tlp_seq_item tlp_txn;
    bit txn_type;

  `uvm_component_utils(pcie_dll_tx_drv)

    //construction
    function new(string name = "pcie_dll_tx_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    //build
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);   
        if(!uvm_config_db#(virtual pcie_lpif_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not found in configuration database")
        end 
    endfunction

    //connection
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

    endfunction


    if ($cast(dllp_txn, req)) begin
    // Successfully cast to dllp_txn
        `uvm_info("CAST", "Successfully cast to DLLP", UVM_LOW);
        txn_type =1;
        end 

    else if ($cast(tllp_txn, req)) begin
        // Successfully cast to tllp_txn
        `uvm_info("CAST", "Successfully cast to TLLP", UVM_LOW)
        txn_type =0;
        end 
    else begin
    // Both casts failed
    `uvm_fatal("CAST_FAIL", "Fatal Error: req is neither DLLP nor TLLP!")
        end


  task run_phase(uvm_phase phase);

        forever begin
            seq_item_port.get_next_item(req);

            if (txn_type==1) begin
                vif.cb_drv.lp_irdy    <= 1'b1;            // Data Link layer ready to send
                vif.cb_drv.lp_data     <= dllp_txn.lp_data;  // Data Payload
                vif.cb_drv.lp_valid     <= 'b111_111;      // 1 valid bit per byte

                vif.cb_drv.lp_dlpstart     <= 'b0;  // the start byte of the data link layer 
                vif.cb_drv.lp_dlpend       <= 'b1001; //'b1001   // the start byte of the data link
                vif.cb_drv.lp_irdy    <= 1'b0;            // Data Link layer ready to send
                
            end

            // else begin
            //    
            // end

         // Tx Path (DLL -> PHY) : "lp_" signals
            // vif.cb_drv.lp_irdy     <= 1'b1;            // Data Link layer ready to send
            // vif.cb_drv.lp_data     <= req.lp_data;  // Data Payload
            // vif.cb_drv.lp_valid     <= 'b111_111;      // 1 valid bit per byte
        //count nbit and get valid  
            //vif.cb_drv.lp_state_req     <= 3'b001;     // Power/Link state request

            // Framing Flags (1 bit per byte for variable-length packets)
            // vif.cb_drv.lp_tlpstart     <= req.lp_tlpstart; //the first byte of the transaction layer 
            // vif.cb_drv.lp_tlpend     <= req.lp_tlpend;     //the end byte of the transaction layer
            // vif.cb_drv.lp_dlpstart     <= req.lp_dlpstart;  // the start byte of the data link layer 
            // vif.cb_drv.lp_dlpend     <= req.lp_dlpend;    // the start byte of the data link


            seq_item_port.item_done();
        end
    endtask



endclass : pcie_dll_tx_drv
