class pcie_dll_DL_INIT_FC1 extends pcie_dll_base_state;

 

    pcie_dll_init1_seq init1_seq;

    //for monitoring the recieved sequence of DLLPS
    int counter;
    pcie_dll_dllp_seq_item dllp_item_rx;


    `uvm_object_utils(pcie_dll_DL_INIT_FC1)

    function new(string name = "pcie_dll_DL_INIT_FC1");
        super.new(name);
    endfunction 

    task start_state(pcie_dll_state_mgr manager);
        `uvm_info("STATE", "Entered DL_INIT_FC1 state", UVM_LOW)
        counter = 0;

        init1_seq = pcie_dll_init1_seq::type_id::create("init1_seq");

        fork begin
        init1_seq.start(manager.dllp_sequencer);
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
                    if (dllp_item_rx.dllp_type == DLLP_INITFC1_P)
                    counter++;
                    `uvm_info("STATE", $sformatf("Received expected FC1 DLLP POSTED, count: %0d", counter), UVM_LOW)
                end
                else if(counter==1)
                begin
                    if (dllp_item_rx.dllp_type == DLLP_INITFC1_NP)
                    begin
                        counter++;
                        `uvm_info("STATE", $sformatf("Received expected FC1 DLLP NON-POSTED, count: %0d", counter), UVM_LOW)
                    end
                    else if (dllp_item_rx.dllp_type == DLLP_INITFC1_P)
                    begin
                        `uvm_info("STATE", $sformatf("Received duplicated FC1 DLLP POSTED, count: %0d", counter), UVM_LOW)
                    end
                    else 
                    begin
                        counter=0;
                        `uvm_info("STATE", $sformatf("Received unexpected DLLP, resetting counter, count: %0d", counter), UVM_LOW)
                    end
                end
                else if (counter==2) 
                begin
                    if (dllp_item_rx.dllp_type == DLLP_INITFC1_CPL)
                    begin
                        counter++;
                        `uvm_info("STATE", $sformatf("Received expected FC1 DLLP COMPLETION, count: %0d", counter), UVM_LOW)
                    end
                    else if (dllp_item_rx.dllp_type == DLLP_INITFC1_NP)
                    begin
                        `uvm_info("STATE", $sformatf("Received duplicated FC1 DLLP NON-POSTED, count: %0d", counter), UVM_LOW)
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
        next_state = DL_INIT_FC2;
        manager.change_state(next_state); 
    endtask

endclass : pcie_dll_DL_INIT_FC1