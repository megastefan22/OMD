/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_10(char*, char *);
extern void execute_340(char*, char *);
extern void execute_647(char*, char *);
extern void execute_300(char*, char *);
extern void execute_301(char*, char *);
extern void execute_304(char*, char *);
extern void execute_307(char*, char *);
extern void execute_310(char*, char *);
extern void execute_311(char*, char *);
extern void execute_312(char*, char *);
extern void execute_313(char*, char *);
extern void execute_314(char*, char *);
extern void execute_319(char*, char *);
extern void execute_320(char*, char *);
extern void execute_327(char*, char *);
extern void execute_338(char*, char *);
extern void execute_339(char*, char *);
extern void execute_30(char*, char *);
extern void execute_31(char*, char *);
extern void execute_32(char*, char *);
extern void execute_33(char*, char *);
extern void execute_34(char*, char *);
extern void execute_35(char*, char *);
extern void execute_100(char*, char *);
extern void execute_101(char*, char *);
extern void execute_121(char*, char *);
extern void execute_122(char*, char *);
extern void execute_142(char*, char *);
extern void execute_143(char*, char *);
extern void execute_163(char*, char *);
extern void execute_164(char*, char *);
extern void execute_184(char*, char *);
extern void execute_185(char*, char *);
extern void execute_205(char*, char *);
extern void execute_206(char*, char *);
extern void execute_226(char*, char *);
extern void execute_227(char*, char *);
extern void execute_247(char*, char *);
extern void execute_248(char*, char *);
extern void execute_271(char*, char *);
extern void execute_272(char*, char *);
extern void execute_273(char*, char *);
extern void execute_274(char*, char *);
extern void execute_275(char*, char *);
extern void execute_276(char*, char *);
extern void execute_277(char*, char *);
extern void execute_278(char*, char *);
extern void execute_295(char*, char *);
extern void execute_296(char*, char *);
extern void execute_37(char*, char *);
extern void execute_39(char*, char *);
extern void execute_41(char*, char *);
extern void execute_43(char*, char *);
extern void execute_45(char*, char *);
extern void execute_47(char*, char *);
extern void execute_49(char*, char *);
extern void execute_51(char*, char *);
extern void execute_53(char*, char *);
extern void execute_55(char*, char *);
extern void execute_57(char*, char *);
extern void execute_59(char*, char *);
extern void execute_61(char*, char *);
extern void execute_63(char*, char *);
extern void execute_65(char*, char *);
extern void execute_67(char*, char *);
extern void execute_69(char*, char *);
extern void execute_103(char*, char *);
extern void execute_104(char*, char *);
extern void execute_105(char*, char *);
extern void execute_106(char*, char *);
extern void execute_107(char*, char *);
extern void execute_108(char*, char *);
extern void execute_109(char*, char *);
extern void execute_110(char*, char *);
extern void execute_111(char*, char *);
extern void execute_112(char*, char *);
extern void execute_113(char*, char *);
extern void execute_114(char*, char *);
extern void execute_115(char*, char *);
extern void execute_116(char*, char *);
extern void execute_117(char*, char *);
extern void execute_118(char*, char *);
extern void execute_119(char*, char *);
extern void execute_120(char*, char *);
extern void execute_269(char*, char *);
extern void execute_270(char*, char *);
extern void execute_280(char*, char *);
extern void execute_298(char*, char *);
extern void execute_299(char*, char *);
extern void execute_303(char*, char *);
extern void execute_306(char*, char *);
extern void execute_309(char*, char *);
extern void execute_316(char*, char *);
extern void execute_318(char*, char *);
extern void execute_322(char*, char *);
extern void execute_324(char*, char *);
extern void execute_329(char*, char *);
extern void execute_331(char*, char *);
extern void execute_342(char*, char *);
extern void execute_343(char*, char *);
extern void execute_344(char*, char *);
extern void execute_345(char*, char *);
extern void execute_346(char*, char *);
extern void execute_347(char*, char *);
extern void execute_348(char*, char *);
extern void execute_349(char*, char *);
extern void execute_624(char*, char *);
extern void execute_625(char*, char *);
extern void execute_634(char*, char *);
extern void execute_635(char*, char *);
extern void execute_638(char*, char *);
extern void execute_645(char*, char *);
extern void execute_646(char*, char *);
extern void execute_627(char*, char *);
extern void execute_633(char*, char *);
extern void execute_642(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[118] = {(funcp)execute_10, (funcp)execute_340, (funcp)execute_647, (funcp)execute_300, (funcp)execute_301, (funcp)execute_304, (funcp)execute_307, (funcp)execute_310, (funcp)execute_311, (funcp)execute_312, (funcp)execute_313, (funcp)execute_314, (funcp)execute_319, (funcp)execute_320, (funcp)execute_327, (funcp)execute_338, (funcp)execute_339, (funcp)execute_30, (funcp)execute_31, (funcp)execute_32, (funcp)execute_33, (funcp)execute_34, (funcp)execute_35, (funcp)execute_100, (funcp)execute_101, (funcp)execute_121, (funcp)execute_122, (funcp)execute_142, (funcp)execute_143, (funcp)execute_163, (funcp)execute_164, (funcp)execute_184, (funcp)execute_185, (funcp)execute_205, (funcp)execute_206, (funcp)execute_226, (funcp)execute_227, (funcp)execute_247, (funcp)execute_248, (funcp)execute_271, (funcp)execute_272, (funcp)execute_273, (funcp)execute_274, (funcp)execute_275, (funcp)execute_276, (funcp)execute_277, (funcp)execute_278, (funcp)execute_295, (funcp)execute_296, (funcp)execute_37, (funcp)execute_39, (funcp)execute_41, (funcp)execute_43, (funcp)execute_45, (funcp)execute_47, (funcp)execute_49, (funcp)execute_51, (funcp)execute_53, (funcp)execute_55, (funcp)execute_57, (funcp)execute_59, (funcp)execute_61, (funcp)execute_63, (funcp)execute_65, (funcp)execute_67, (funcp)execute_69, (funcp)execute_103, (funcp)execute_104, (funcp)execute_105, (funcp)execute_106, (funcp)execute_107, (funcp)execute_108, (funcp)execute_109, (funcp)execute_110, (funcp)execute_111, (funcp)execute_112, (funcp)execute_113, (funcp)execute_114, (funcp)execute_115, (funcp)execute_116, (funcp)execute_117, (funcp)execute_118, (funcp)execute_119, (funcp)execute_120, (funcp)execute_269, (funcp)execute_270, (funcp)execute_280, (funcp)execute_298, (funcp)execute_299, (funcp)execute_303, (funcp)execute_306, (funcp)execute_309, (funcp)execute_316, (funcp)execute_318, (funcp)execute_322, (funcp)execute_324, (funcp)execute_329, (funcp)execute_331, (funcp)execute_342, (funcp)execute_343, (funcp)execute_344, (funcp)execute_345, (funcp)execute_346, (funcp)execute_347, (funcp)execute_348, (funcp)execute_349, (funcp)execute_624, (funcp)execute_625, (funcp)execute_634, (funcp)execute_635, (funcp)execute_638, (funcp)execute_645, (funcp)execute_646, (funcp)execute_627, (funcp)execute_633, (funcp)execute_642, (funcp)transaction_0, (funcp)vhdl_transfunc_eventcallback};
const int NumRelocateId= 118;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/tb_encrypt_behav/xsim.reloc",  (void **)funcTab, 118);
	iki_vhdl_file_variable_register(dp + 541552);
	iki_vhdl_file_variable_register(dp + 541608);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/tb_encrypt_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/tb_encrypt_behav/xsim.reloc");

	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/tb_encrypt_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/tb_encrypt_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/tb_encrypt_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
