virtual class pcie_cfg_base extends uvm_object;

    function new(string name = "pcie_cfg_base");
        super.new(name);
    endfunction 

    pure virtual function void set_defaults(); 

    pure virtual function bit validate(ref string validation_error_msg); 

    pure virtual function string summary(); 

    function void post_randomize();
        string msg;
        if (!validate(msg)) begin
            `uvm_fatal("CFG_RAND_ERR", $sformatf("Randomized object of type %s is invalid: %s", this.get_type_name(), validation_msg))
        end
    endfunction

endclass : pcie_cfg_base