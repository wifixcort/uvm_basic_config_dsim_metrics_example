`include "uvm_macros.svh"
import uvm_pkg::*;

// `include "../testbench/interface.sv"

class test_basic extends uvm_test;// se debe pasar como parametro en la linea de comandos
  //-timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog +define+S50 +define+VERBOSE +define+VCS  -debug_access+all -cm line+tgl+assert +plusarg_save +UVM_TESTNAME=test_basic

  `uvm_component_utils(test_basic)
 
  function new (string name="test_basic", uvm_component parent=null);// padre por defecto "null", pero se puede especificar otro
    super.new (name, parent);
  endfunction : new
  
  virtual arb_intf intf;//instancia interfaz virtual
  arb_env env;  //instancia ambiente
  
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    
      uvm_config_db #(virtual arb_intf)::set (null, "uvm_test_top", "VIRTUAL_INTERFACE", intf);

    //Revisar que la interfaz esté disponible
    if(uvm_config_db #(virtual arb_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
        `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
      end
      
    env  = arb_env::type_id::create ("env", this);//creación del ambiente

    //"setear"  la interza para que esté disponible 
    // uvm_test_top.* da acceso a todas las interfaces, se puede especificar a cual
    // se desea agregar "visibilidad": uvm_test_top.env . pero esto hace que solo esta
    //interfaz esté visible
    // Solo soporta un parametro, si requiere acceso a màs de una interfaz se debe si o si
    // agrear ".*"
    // La otra opción es hacer un "set" para cada interfaz, pero es màs trabajo
    uvm_config_db #(virtual arb_intf)::set (null, "uvm_test_top.*", "VIRTUAL_INTERFACE", intf);
      
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW);
    print();
    
  endfunction : end_of_elaboration_phase

  gen_item_seq seq;// Llamada a Sequence

  virtual task run_phase(uvm_phase phase);

    phase.raise_objection (this);

    seq = gen_item_seq::type_id::create("seq");// Se crea mediante la fabrica
    
    seq.randomize();//Randomizacion
    seq.start(env.arb_seqr);//Se conecta al sequencer
    
    phase.drop_objection (this);
  endtask

endclass
