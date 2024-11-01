// change verbosity level of entire project with command line: +access+r +UVM_VERBOSITY=UVM_HIGH
// or
// change verbosity level of a single class/component: see code

`include "uvm_macros.svh"
import uvm_pkg::*;
 
//////////////////////////////////////////////////
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
 
  
  task run();
    `uvm_info("DRV1", "Executed Driver1 Code", UVM_HIGH);
    `uvm_info("DRV2", "Executed Driver2 Code", UVM_HIGH);
  endtask
  
endclass
 
//////////////////////////////////////////////////
 
class env extends uvm_env;
  `uvm_component_utils(env)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
  
  
  task run();
    `uvm_info("ENV1", "Executed ENV1 Code", UVM_HIGH);
    `uvm_info("ENV2", "Executed ENV2 Code", UVM_HIGH);
  endtask
  
endclass
////////////////////
 
 
module tb;
  
 driver drv;
 env e;
  
  
 initial begin
   drv = new("DRV", null);
   e   = new("ENV", null);
  // e.set_report_verbosity_level(UVM_HIGH);
   drv.run();
   e.run();
    
  end
  
  
endmodule
