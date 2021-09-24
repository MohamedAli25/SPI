class spi_agent_config extends uvm_object;
  
  // UVM Factory Registration Macro
  `uvm_object_utils(spi_agent_config)
  
  // BFM Virtual Interfaces
  spi_driver_bfm_param drv_bfm;
  spi_monitor_bfm_param mon_bfm;
    
  //------------------------------------------
  // Data Members
  //------------------------------------------
  uvm_active_passive_enum active = UVM_ACTIVE;
  bit has_coverage_monitor = 1;
  
  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "spi_agent_config");
  
endclass: spi_agent_config

function spi_agent_config::new(string name = "spi_agent_config");
  super.new(name);
endfunction: new

