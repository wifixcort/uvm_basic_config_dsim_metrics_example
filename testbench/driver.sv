`include "uvm_macros.svh"
import uvm_pkg::*;

//Aqui está combinado, pero podrian estar separados
class arb_item extends uvm_sequence_item;//Tipo de item a utilizar para pasar al sequencer

  //Add a sequence item definition
  
  `uvm_object_utils_begin(arb_item)
  
  `uvm_object_utils_end

  function new(string name = "arb_item");
    super.new(name);
  endfunction
endclass

class gen_item_seq extends uvm_sequence;
  `uvm_object_utils(gen_item_seq)
  function new(string name="gen_item_seq");
    super.new(name);
  endfunction

  rand int num; 	// Config total number of items to be sent

  constraint c1 { num inside {[2:5]}; }//Constrain para numero de interaciones

  virtual task body();
    arb_item f_item = arb_item::type_id::create("f_item");//Tipo de item que se crea arriba
    for (int i = 0; i < num; i ++) begin
      start_item(f_item);// ---------------> Start
      f_item.randomize();// ---------------> Randomize
    	`uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
    	f_item.print();
      finish_item(f_item);// ---------------> Finish
      //`uvm_do(f_item);//este es un macro que hace los tres pasos de una
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass

//Cuando se extiende también se le puede decir que tipo de item puede manejar
class arb_driver extends uvm_driver #(arb_item);

  `uvm_component_utils (arb_driver)
   function new (string name = "fifo_driver", uvm_component parent = null);
     super.new (name, parent);
   endfunction

   virtual arb_intf intf;

   virtual function void build_phase (uvm_phase phase);
     super.build_phase (phase);
     if(uvm_config_db #(virtual arb_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
       `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
     end
   endfunction
   
   virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      arb_item f_item;
      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(f_item);
      //Drive tasks here
      //Drive tasks here
      seq_item_port.item_done();//Jala todo lo que tenga la secuencia
    end
  endtask         
  
endclass
