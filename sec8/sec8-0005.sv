////////////////////////
/*
SEQ_ARB_FIFO (DEF) first in first out ..priority won't work
SEQ_ARB_WEIGHTED  
SEQ_ARB_RANDOM  strictly random
SEQ_ARB_STRICT_FIFO    support pri
SEQ_ARB_STRICT_RANDOM  support pri
SEQ_ARB_USER
 
*/
//////////////////////////////////////////////////////
 
`include "uvm_macros.svh"
import uvm_pkg::*;
 
class transaction extends uvm_sequence_item;
  rand bit [3:0] a;
  rand bit [3:0] b;
       bit [4:0] y;
 
 
  function new(input string inst = "transaction");
  super.new(inst);
  endfunction
 
`uvm_object_utils_begin(transaction)
  `uvm_field_int(a,UVM_DEFAULT)
  `uvm_field_int(b,UVM_DEFAULT)
  `uvm_field_int(y,UVM_DEFAULT)
`uvm_object_utils_end
 
endclass
//////////////////////////////////////////////////////
 
class sequence1 extends uvm_sequence#(transaction);
  `uvm_object_utils(sequence1)
 
transaction trans;
 
  function new(input string inst = "seq1");
  super.new(inst);
  endfunction
 
 virtual task body();
    trans = transaction::type_id::create("trans");
   `uvm_info("SEQ1", "SEQ1 Started" , UVM_NONE); 
    start_item(trans);
    trans.randomize();
    finish_item(trans);
   `uvm_info("SEQ1", "SEQ1 Ended" , UVM_NONE); 
endtask
  
  
  
endclass
////////////////////////////////////////////////////////////////
 
 
class sequence2 extends uvm_sequence#(transaction);
  `uvm_object_utils(sequence2)
 
transaction trans;
 
  function new(input string inst = "seq2");
  super.new(inst);
  endfunction
 
  
  virtual task body();
    trans = transaction::type_id::create("trans");
    `uvm_info("SEQ2", "SEQ2 Started" , UVM_NONE); 
    start_item(trans);
    trans.randomize();
    finish_item(trans);
    `uvm_info("SEQ2", "SEQ2 Ended" , UVM_NONE); 
  endtask
  
  
endclass
 
 
////////////////////////////////////////////////////////////////////
 
class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)
 
transaction t;
virtual adder_if aif;
 
function new(input string inst = "DRV", uvm_component c);
super.new(inst,c);
endfunction
 
  virtual function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
  	t = transaction::type_id::create("TRANS");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(t);
    seq_item_port.item_done();
    end    
  endtask
 
 
endclass
 
///////////////////////////////////////////////////////////
 
class agent extends uvm_agent;
`uvm_component_utils(agent)
 
function new(input string inst = "AGENT", uvm_component c);
super.new(inst,c);
endfunction
 
driver d;
uvm_sequencer #(transaction) seq;
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
d = driver::type_id::create("DRV",this);
seq = uvm_sequencer #(transaction)::type_id::create("seq",this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d.seq_item_port.connect(seq.seq_item_export);
endfunction
endclass
 
/////////////////////////////////////////////////////////////////////////
 
class env extends uvm_env;
`uvm_component_utils(env)
 
function new(input string inst = "ENV", uvm_component c);
super.new(inst,c);
endfunction
 
agent a;
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  a = agent::type_id::create("AGENT",this);
endfunction
 
endclass
 
///////////////////////////////////////////////////////////////
 
class test extends uvm_test;
`uvm_component_utils(test)
 
function new(input string inst = "TEST", uvm_component c);
super.new(inst,c);
endfunction
 
sequence1 s1;
sequence2 s2;  
env e;
 
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("ENV",this);
    s1 = sequence1::type_id::create("s1");
    s2 = sequence2::type_id::create("s2");  
    endfunction
 
    virtual task run_phase(uvm_phase phase);
 
    phase.raise_objection(this);
      
      // e.a.seq.set_arbitration(UVM_SEQ_ARB_STRICT_RANDOM);  UVM_SEQ_ARB_FIFO 
    fork  
      s2.start(e.a.seq);
      s1.start(e.a.seq);
    join 
      
    phase.drop_objection(this);
    endtask
  
  
endclass
 
////////////////////////////////////////////////////////
module ram_tb;
 
 
initial begin
  run_test("test");
end
 
endmodule
 
