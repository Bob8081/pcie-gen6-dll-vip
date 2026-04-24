class pcie_dll_DL_INIT_FC2 extends pcie_dll_base_state;

   

    pcie_dll_init2_seq init2_seq;
    //for monitoring the recieved sequence of DLLPs
    int counter;
    pcie_dll_dllp_seq_item dllp_item_rx;

    `uvm_object_utils(pcie_dll_DL_INIT_FC2)

    
    function new(string name = "pcie_dll_DL_INIT_FC2");
        super.new(name);
    endfunction 

    task start_state(pcie_dll_state_mgr manager);
        `uvm_info("STATE", "Entered DL_INIT_FC2 state", UVM_LOW)
         counter = 0;

        init2_seq = pcie_dll_init2_seq::type_id::create("init2_seq");

        fork begin

        init2_seq.start(manager.dllp_sequencer);
        end

        begin
        forever begin 
            if (counter == 3) begin
                break;
            end

            else begin
                manager.dllp_fifo.get(dllp_item_rx);
                if(counter==0)
                begin
                    if (dllp_item_rx.dllp_type == DLLP_INITFC2_P)
                    counter++;
                    `uvm_info("STATE", $sformatf("Received expected FC2 DLLP POSTED, count: %0d", counter), UVM_LOW)
                end
                else if(counter==1)
                begin
                    if (dllp_item_rx.dllp_type == DLLP_INITFC2_NP)
                    begin
                        counter++;
                        `uvm_info("STATE", $sformatf("Received expected FC2 DLLP NON-POSTED, count: %0d", counter), UVM_LOW)
                    end
                    else if (dllp_item_rx.dllp_type == DLLP_INITFC2_P)
                    begin
                        `uvm_info("STATE", $sformatf("Received duplicated FC2 DLLP POSTED, count: %0d", counter), UVM_LOW)
                    end
                    else 
                    begin
                        counter=0;
                        `uvm_info("STATE", $sformatf("Received unexpected DLLP, resetting counter, count: %0d", counter), UVM_LOW)
                    end
                end
                else if (counter==2) 
                begin
                    if (dllp_item_rx.dllp_type == DLLP_INITFC2_CPL)
                    begin
                        counter++;
                        `uvm_info("STATE", $sformatf("Received expected FC2 DLLP COMPLETION, count: %0d", counter), UVM_LOW)
                    end
                    else if (dllp_item_rx.dllp_type == DLLP_INITFC2_NP)
                    begin
                        `uvm_info("STATE", $sformatf("Received duplicated FC2 DLLP NON-POSTED, count: %0d", counter), UVM_LOW)
                    end
                    else
                    begin
                        counter=0;
                        `uvm_info("STATE", $sformatf("Received unexpected DLLP, resetting counter, count: %0d", counter), UVM_LOW)
                    end
                end
                    
            
                end
            end
        end
    join_any

    //TODO : here let the recieving thread only decide the transition to the next state don't make it join_any
        
        next_state = DL_ACTIVE;
        manager.change_state(next_state); 
    endtask

endclass : pcie_dll_DL_INIT_FC2