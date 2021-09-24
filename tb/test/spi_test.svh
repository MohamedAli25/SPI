class spi_test extends uvm_test;

  // UVM Factory Registration Macro
  `uvm_component_utils(spi_test)

  //------------------------------------------
  // Component Members
  //------------------------------------------
  spi_env spi_env_h;

  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "spi_test", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass: spi_test

function spi_test::new(string name = "spi_test", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void spi_test::build_phase(uvm_phase phase);
  // env configuration
  spi_env_config spi_env_config_h = spi_env_config::type_id::create("spi_env_config_h");

  // spi & apb configuration objects creation
  spi_agent_config spi_agent_config_h = spi_agent_config::type_id::create("spi_agent_config_h");
  apb_agent_config apb_agent_config_h = apb_agent_config::type_id::create("apb_agent_config_h");

  //setting the spi_agent conifgurations and needed handles
  if (!uvm_config_db #(spi_driver_bfm_param) ::get(this, "", "spi_driver_bfm", spi_agent_config_h.spi_driver_bfm_h)) begin
    `uvm_fatal(get_type_name(), "Cannot get() BFM interface spi_driver_bfm_h from uvm_config_db")
  end
  if (!uvm_config_db #(spi_monitor_bfm_param)::get(this, "", "spi_monitor_bfm", spi_agent_config_h.spi_monitor_bfm_h)) begin
    `uvm_fatal(get_type_name(), "Cannot get() BFM interface spi_monitor_bfm_h from uvm_config_db")
  end
  
  spi_env_config_h.spi_agent_config_h = spi_agent_config_h;

  //setting the apb_agent conifgurations and needed handles
  if (!uvm_config_db #(apb_driver_bfm_param) ::get(this, "", "apb_driver_bfm", apb_agent_config_h.apb_driver_bfm_h)) begin
    `uvm_fatal(get_type_name(), "Cannot get() BFM interface apb_driver_bfm_h from uvm_config_db")
  end
  if (!uvm_config_db #(apb_monitor_bfm_param)::get(this, "", "apb_monitor_bfm", apb_agent_config_h.apb_monitor_bfm_h)) begin
    `uvm_fatal(get_type_name(), "Cannot get() BFM interface apb_monitor_bfm_h from uvm_config_db")
  end
  
  spi_env_config_h.apb_agent_config_h = apb_agent_config_h;

  // Add the spi & apb agent configuration objects so the sequences can access them
  uvm_config_db #(spi_agent_config)::set(null, "spi_seq", "spi_agent_config_h", spi_agent_config_h);
  uvm_config_db #(apb_agent_config)::set(null, "apb_seq", "apb_agent_config_h", apb_agent_config_h);

  // Add the ENV configuration object so the ENV can access it
  uvm_config_db #(spi_env_config)::set(this, "spi_env_h", "spi_env_config_h", spi_env_config_h);

  spi_env_h = spi_env::type_id::create("spi_env_h", this);
endfunction: build_phase

task spi_test::run_phase(uvm_phase phase);
  string arguments_value = "base_vseq";
  string used_vsequences[$];
  base_vseq vseq;
  uvm_object temp;

  uvm_cmdline_processor cmdline_proc = uvm_cmdline_processor::get_inst();

  phase.raise_objection(this, "spi_test");

  // get a string from the commandline arguments
  cmdline_proc.get_arg_value("+VSEQ=", arguments_value);
  uvm_split_string(arguments_value, ",", used_vsequences);

  foreach (used_vsequences[i]) begin
    `uvm_info(get_type_name(), {"starting vseq:", used_vsequences[i]}, UVM_MEDIUM)

    temp = factory.create_object_by_name( used_vsequences[i], get_full_name(), used_vsequences[i]);
    if(!$cast(vseq,temp)) begin
      `uvm_fatal(get_type_name(), "Provided virtual sequence name in command line can't be cast to base_vseq")
    end

    // assigning the secquencers handles
    vseq.spi_sequencer_h = spi_env_h.spi_agent_h.spi_sequencer_h;
    vseq.apb_sequencer_h = spi_env_h.apb_agent_h.apb_sequencer_h;
    vseq.start(null);
  end

  phase.drop_objection(this, "spi_test");   
endtask: run_phase