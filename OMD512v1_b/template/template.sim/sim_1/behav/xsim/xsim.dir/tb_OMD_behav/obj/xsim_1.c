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
extern void execute_625(char*, char *);
extern void execute_624(char*, char *);
extern void execute_301(char*, char *);
extern void execute_306(char*, char *);
extern void execute_309(char*, char *);
extern void execute_316(char*, char *);
extern void execute_317(char*, char *);
extern void execute_31(char*, char *);
extern void execute_32(char*, char *);
extern void execute_33(char*, char *);
extern void execute_34(char*, char *);
extern void execute_35(char*, char *);
extern void execute_36(char*, char *);
extern void execute_101(char*, char *);
extern void execute_102(char*, char *);
extern void execute_122(char*, char *);
extern void execute_123(char*, char *);
extern void execute_143(char*, char *);
extern void execute_144(char*, char *);
extern void execute_164(char*, char *);
extern void execute_165(char*, char *);
extern void execute_185(char*, char *);
extern void execute_186(char*, char *);
extern void execute_206(char*, char *);
extern void execute_207(char*, char *);
extern void execute_227(char*, char *);
extern void execute_228(char*, char *);
extern void execute_248(char*, char *);
extern void execute_249(char*, char *);
extern void execute_272(char*, char *);
extern void execute_273(char*, char *);
extern void execute_274(char*, char *);
extern void execute_275(char*, char *);
extern void execute_276(char*, char *);
extern void execute_277(char*, char *);
extern void execute_278(char*, char *);
extern void execute_279(char*, char *);
extern void execute_296(char*, char *);
extern void execute_297(char*, char *);
extern void execute_38(char*, char *);
extern void execute_40(char*, char *);
extern void execute_42(char*, char *);
extern void execute_44(char*, char *);
extern void execute_46(char*, char *);
extern void execute_48(char*, char *);
extern void execute_50(char*, char *);
extern void execute_52(char*, char *);
extern void execute_54(char*, char *);
extern void execute_56(char*, char *);
extern void execute_58(char*, char *);
extern void execute_60(char*, char *);
extern void execute_62(char*, char *);
extern void execute_64(char*, char *);
extern void execute_66(char*, char *);
extern void execute_68(char*, char *);
extern void execute_70(char*, char *);
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
extern void execute_121(char*, char *);
extern void execute_270(char*, char *);
extern void execute_271(char*, char *);
extern void execute_281(char*, char *);
extern void execute_299(char*, char *);
extern void execute_300(char*, char *);
extern void execute_303(char*, char *);
extern void execute_305(char*, char *);
extern void execute_308(char*, char *);
extern void execute_311(char*, char *);
extern void execute_313(char*, char *);
extern void execute_319(char*, char *);
extern void execute_320(char*, char *);
extern void execute_321(char*, char *);
extern void execute_322(char*, char *);
extern void execute_323(char*, char *);
extern void execute_324(char*, char *);
extern void execute_325(char*, char *);
extern void execute_326(char*, char *);
extern void execute_601(char*, char *);
extern void execute_602(char*, char *);
extern void execute_611(char*, char *);
extern void execute_612(char*, char *);
extern void execute_615(char*, char *);
extern void execute_622(char*, char *);
extern void execute_623(char*, char *);
extern void execute_610(char*, char *);
extern void execute_614(char*, char *);
extern void execute_619(char*, char *);
extern void execute_621(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[106] = {(funcp)execute_10, (funcp)execute_625, (funcp)execute_624, (funcp)execute_301, (funcp)execute_306, (funcp)execute_309, (funcp)execute_316, (funcp)execute_317, (funcp)execute_31, (funcp)execute_32, (funcp)execute_33, (funcp)execute_34, (funcp)execute_35, (funcp)execute_36, (funcp)execute_101, (funcp)execute_102, (funcp)execute_122, (funcp)execute_123, (funcp)execute_143, (funcp)execute_144, (funcp)execute_164, (funcp)execute_165, (funcp)execute_185, (funcp)execute_186, (funcp)execute_206, (funcp)execute_207, (funcp)execute_227, (funcp)execute_228, (funcp)execute_248, (funcp)execute_249, (funcp)execute_272, (funcp)execute_273, (funcp)execute_274, (funcp)execute_275, (funcp)execute_276, (funcp)execute_277, (funcp)execute_278, (funcp)execute_279, (funcp)execute_296, (funcp)execute_297, (funcp)execute_38, (funcp)execute_40, (funcp)execute_42, (funcp)execute_44, (funcp)execute_46, (funcp)execute_48, (funcp)execute_50, (funcp)execute_52, (funcp)execute_54, (funcp)execute_56, (funcp)execute_58, (funcp)execute_60, (funcp)execute_62, (funcp)execute_64, (funcp)execute_66, (funcp)execute_68, (funcp)execute_70, (funcp)execute_104, (funcp)execute_105, (funcp)execute_106, (funcp)execute_107, (funcp)execute_108, (funcp)execute_109, (funcp)execute_110, (funcp)execute_111, (funcp)execute_112, (funcp)execute_113, (funcp)execute_114, (funcp)execute_115, (funcp)execute_116, (funcp)execute_117, (funcp)execute_118, (funcp)execute_119, (funcp)execute_120, (funcp)execute_121, (funcp)execute_270, (funcp)execute_271, (funcp)execute_281, (funcp)execute_299, (funcp)execute_300, (funcp)execute_303, (funcp)execute_305, (funcp)execute_308, (funcp)execute_311, (funcp)execute_313, (funcp)execute_319, (funcp)execute_320, (funcp)execute_321, (funcp)execute_322, (funcp)execute_323, (funcp)execute_324, (funcp)execute_325, (funcp)execute_326, (funcp)execute_601, (funcp)execute_602, (funcp)execute_611, (funcp)execute_612, (funcp)execute_615, (funcp)execute_622, (funcp)execute_623, (funcp)execute_610, (funcp)execute_614, (funcp)execute_619, (funcp)execute_621, (funcp)transaction_0, (funcp)vhdl_transfunc_eventcallback};
const int NumRelocateId= 106;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/tb_OMD_behav/xsim.reloc",  (void **)funcTab, 106);
	iki_vhdl_file_variable_register(dp + 510960);
	iki_vhdl_file_variable_register(dp + 511016);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/tb_OMD_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/tb_OMD_behav/xsim.reloc");

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
    iki_set_sv_type_file_path_name("xsim.dir/tb_OMD_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/tb_OMD_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/tb_OMD_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
