package spi_agent_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  `include "spi_seq_item.svh"
  `include "spi_agent_config.svh"
  `include "spi_driver.svh"
  `include "spi_coverage_monitor.svh"
  `include "spi_monitor.svh"
  typedef uvm_sequencer#(spi_seq_item) spi_sequencer;
  `include "spi_agent.svh"
  
  endpackage: spi_agent_pkg
  