class spi_agent extends uvm_component;

  // UVM Factory Registration Macro
  `uvm_component_utils(spi_agent)

  //------------------------------------------
  // Data Members
  //------------------------------------------
  spi_agent_config spi_agent_config_h;
    
  //------------------------------------------
  // Component Members
  //------------------------------------------
  uvm_analysis_port #(spi_seq_item) ap;
  spi_monitor   spi_monitor_h;
  spi_sequencer spi_sequencer_h;
  spi_driver    spi_driver_h;
  
  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "spi_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass: spi_agent
  
  
function spi_agent::new(string name = "spi_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void spi_agent::build_phase(uvm_phase phase);
  if(!uvm_config_db#(spi_agent_config)::get(this, "", "spi_agent_config_h", spi_agent_config_h)) begin
    `uvm_fatal(this.get_name(), "Cannot get spi Agent configuration from uvm_config_db");
  end
  ap = new("ap", this);

  spi_monitor_h = spi_monitor::type_id::create("spi_monitor_h", this);
  spi_monitor_h.spi_agent_config_h = spi_agent_config_h;

  if(spi_agent_config_h.active == UVM_ACTIVE) begin
    spi_sequencer_h = spi_sequencer::type_id::create("spi_sequencer_h", this);

    spi_driver_h = spi_driver::type_id::create("spi_driver_h", this);
    spi_driver_h.spi_agent_config_h = spi_agent_config_h;
  end

  if(spi_agent_config_h.has_coverage_monitor) begin
    spi_coverage_monitor_h = spi_coverage_monitor::type_id::create("spi_coverage_monitor_h", this);
  end
endfunction: build_phase

function void spi_agent::connect_phase(uvm_phase phase);
  spi_monitor_h.ap.connect(ap);
  
  if(spi_agent_config_h.active == UVM_ACTIVE) begin
    spi_driver_h.seq_item_port.connect(spi_sequencer_h.seq_item_export);
  end

  if(spi_agent_config_h.has_coverage_monitor) begin 
    spi_monitor_h.ap.connect(spi_coverage_monitor_h.analysis_export);
  end
endfunction: connect_phase
  