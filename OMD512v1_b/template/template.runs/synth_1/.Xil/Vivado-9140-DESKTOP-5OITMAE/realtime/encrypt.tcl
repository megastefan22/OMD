# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_resetSystemStats
    rt::HARTNDb_startSystemStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "D:/Projects/2019/OMD/template/template.runs/synth_1/.Xil/Vivado-9140-DESKTOP-5OITMAE/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xcku5p-ffvb676-2-e
    source $::env(HRT_TCL_PATH)/rtSynthParallelPrep.tcl
     file delete -force synth_hints.os

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common_vhdl.tcl
    set rt::defaultWorkLibName xil_defaultlib

    set rt::useElabCache false
    if {$rt::useElabCache == false} {
      rt::read_vhdl -lib xil_defaultlib {
      D:/Projects/2019/OMD/template/template.srcs/sources_1/new/blake512.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/g_function_1.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/mux2_1.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/new/mux2_1_1024.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/new/mux2_1_512.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/new/omd_controller.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/perm.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/new/ram256x512.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v00.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v01.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v02.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v03.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v04.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v05.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v06.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v07.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v08.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v09.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v10.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v11.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v12.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v13.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v14.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/reg_64_v15.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/new/reg_en_1024.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/new/reg_en_512.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/imports/new/round_f_controller.vhd
      D:/Projects/2019/OMD/template/template.srcs/sources_1/new/encrypt.vhd
    }
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification false
    set rt::top encrypt
    rt::set_parameter enableIncremental true
    set rt::reportTiming false
    rt::set_parameter elaborateOnly false
    rt::set_parameter elaborateRtl false
    rt::set_parameter eliminateRedundantBitOperator true
    rt::set_parameter elaborateRtlOnlyFlow false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter ramStyle auto
    rt::set_parameter merge_flipflops true
# MODE: 
    rt::set_parameter webTalkPath {D:/Projects/2019/OMD/template/template.cache/wt}
    rt::set_parameter enableSplitFlowPath "D:/Projects/2019/OMD/template/template.runs/synth_1/.Xil/Vivado-9140-DESKTOP-5OITMAE/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
        $rt::db readXRFFile
      rt::run_synthesis -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    rt::HARTNDb_reportJobStats "Synthesis Optimization Runtime"
    rt::HARTNDb_stopSystemStats
    if { $rt::flowresult == 1 } { return -code error }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }

    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}