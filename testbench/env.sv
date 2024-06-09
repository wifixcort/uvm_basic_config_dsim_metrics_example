`include "uvm_macros.svh"
import uvm_pkg::*;

class arb_env extends uvm_env;

  `uvm_component_utils(arb_env)

  function new (string name = "fifo_env", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual arb_intf intf;
  arb_driver arb_drv; //Driver
  uvm_sequencer #(arb_item)	arb_seqr;//Secuencer
  //arb_item <-tipo de transacción a recibir
  

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(uvm_config_db #(virtual arb_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    
    arb_drv = arb_driver::type_id::create ("arb_drv", this);//Fabrica creando arb_drv
    
    arb_seqr = uvm_sequencer#(arb_item)::type_id::create("arb_seqr", this);//Fabrica creando el sequencer
    
    
    //uvm_config_db #(virtual fifo_intf)::set (null, "uvm_test_top.*", "VIRTUAL_INTERFACE", intf);    
      
    uvm_report_info(get_full_name(),"End_of_build_phase", UVM_LOW);
    print();

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    arb_drv.seq_item_port.connect(arb_seqr.seq_item_export);//Conexión del driver con el sequencer
    //El driver tiene un puerto de nombre "seq_item_port" y el sequencer uno de nombre "seq_item_export"
    //Estos son puertos definidos por la clase, no se pueden cambiar
  endfunction

endclass