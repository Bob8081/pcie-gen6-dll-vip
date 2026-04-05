//state manager class to handle all the states in the Data Link Layer
class pcie_dll_state_mgr extends uvm_component;
    `uvm_component_utils(pcie_dll_state_mgr);
  
    pcie_dll_role_e role;

    uvm_analysis_imp #(dllp_item, pcie_dll_state_mgr) dllp_export; //connected to the monitor on the agent level

    pcie_dll_sequencer#(dllp_item) dllp_sequencer; //to be a handle to the sequencer of the agent to be able to send from the state manager if needed, and to be able to pass it to the states if needed


    uvm_tlm_fifo#(dllp_item) dllp_fifo; //for dllp-only storage 
    

    pcie_dll_state current_state; //handle for the current state to track the state and to be accesed by the testbench


    function new(string name = "pcie_dll_state_mgr", uvm_component parent = null);
        super.new(name, parent);
        dllp_fifo = new("dllp_fifo", this);
        dllp_export = new("dllp_export", this);
    endfunction

    function void write (dllp_item item);
            dllp_fifo.try_put(item); //non-blocking becuse the write is a function , to avoid compiling error
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

   
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
   
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        change_state("dl_inactive_state"); //start with the inactive state, and the state will decide when to change to other states
    endfunction


    virtual task change_state(string state_name);
        //create temporary object to contain the new state, and to check if the factory can create the state ordered before changing the current state handle
        uvm_object obj;
        obj = factory.create_object_by_name(state_name, get_full_name(), state_name);

        if (obj == null) begin
        `uvm_fatal("STATE_ERR", $sformatf("Factory failed to create state: '%s'. check for typos and make sure the class has `uvm_object_utils", state_name))
        end

        //for debugging purposes, to track state changes in the log
        `uvm_info("STATE_CTRL", $sformatf("Changing state from %s to %s", (current_state != null) ? current_state.get_full_name() : "None"   , state_name), UVM_LOW)
        
        //crate the new state and check if it extends the correct base class
        if(!$cast(current_state, obj))begin
            `uvm_fatal("STATE_ERR", $sformatf("Failed to cast object '%s' to pcie_dll_state. make sure it extends the correct base class", state_name))
        end  

        //pass the satate manager handle to the state created to let it access the state manager and its methods and properties
        current_state.enter_state(this); 

    endtask

    virtual task send_to_driver(dllp_item packet); //to be used in case of the state decides what to send next 
        send_single_dllp_seq tx_seq;
        tx_seq = send_single_dllp_seq::type_id::create("tx_seq");
        tx_seq.item_to_send = packet;
        tx_seq.start(dllp_sequencer); 
    endtask

    
endclass