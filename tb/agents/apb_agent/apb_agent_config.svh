class apb_agent_config extends uvm_object;
  
  // UVM Factory Registration Macro
  `uvm_object_utils(apb_agent_config)
  
  // BFM Virtual Interfaces
  apb_driver_bfm_param drv_bfm;
  apb_monitor_bfm_param mon_bfm;
    
  //------------------------------------------
  // Data Members
  //------------------------------------------
  uvm_active_passive_enum active = UVM_ACTIVE;
  bit has_coverage_monitor = 1;
  
  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "apb_agent_config");
  
endclass: apb_agent_config

function apb_agent_config::new(string name = "apb_agent_config");
  super.new(name);
endfunction: new

