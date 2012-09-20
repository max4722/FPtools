#include-once

Global Const $FLAG_REG_0 = 0x00000000
Global Const $FLAG_REG_1 = 0x01000000
Global Const $FLAG_REG_2 = 0x02000000
Global Const $FLAG_REG_3 = 0x03000000
Global Const $FLAG_REG_4 = 0x04000000
Global Const $FLAG_REG_5 = 0x05000000
Global Const $FLAG_REG_6 = 0x06000000
Global Const $FLAG_REG_7 = 0x07000000
;~ #cs
;$FLAG_REG_0
Global Const $FLAG_EXIT_RWflash = 				$FLAG_REG_0 + 0x00000001 ;1
Global Const $FLAG_EXIT_GUI = 					$FLAG_REG_0 + 0x00000002 ;2
Global Const $FLAG_READ_FLASH = 				$FLAG_REG_0 + 0x00000004 ;3
Global Const $FLAG_SERVICE = 					$FLAG_REG_0 + 0x00000008 ;4
Global Const $FLAG_WRITE_FLASH = 				$FLAG_REG_0 + 0x00000010 ;5
Global Const $FLAG_ERASE_FLASH = 				$FLAG_REG_0 + 0x00000020 ;6
Global Const $FLAG_GET_FISC_INFO = 				$FLAG_REG_0 + 0x00000040 ;7
Global Const $FLAG_PERIOD_MODE = 				$FLAG_REG_0 + 0x00000080 ;8
Global Const $FLAG_TIME_SET = 					$FLAG_REG_0 + 0x00000100 ;9
Global Const $FLAG_TIME_GET = 					$FLAG_REG_0 + 0x00000200 ;10
Global Const $FLAG_TIME_GET_PC = 				$FLAG_REG_0 + 0x00000400 ;11
Global Const $FLAG_TIME_GET_FACT_N = 			$FLAG_REG_0 + 0x00000800 ;12
Global Const $FLAG_FISC_GET_VAT_N = 			$FLAG_REG_0 + 0x00001000 ;13
Global Const $FLAG_FISC_GET_FISC_N = 			$FLAG_REG_0 + 0x00002000 ;14
Global Const $FLAG_FISC_CHECK_OPEN = 			$FLAG_REG_0 + 0x00004000 ;15
Global Const $FLAG_FISC_SET_FACT_N = 			$FLAG_REG_0 + 0x00008000 ;16
Global Const $FLAG_FISC_SET_VAT_N = 			$FLAG_REG_0 + 0x00010000 ;17
Global Const $FLAG_FISC_SET_FISC_N = 			$FLAG_REG_0 + 0x00020000 ;18
Global Const $FLAG_FISC_SET_VER = 				$FLAG_REG_0 + 0x00040000 ;19
Global Const $FLAG_FISCALIZE = 					$FLAG_REG_0 + 0x00080000 ;20
Global Const $FLAG_FISC_SET_TAX = 				$FLAG_REG_0 + 0x00100000 ;21
Global Const $FLAG_FISC_CLEAN_N_SET = 			$FLAG_REG_0 + 0x00200000 ;22
Global Const $FLAG_FISC_GET_STATUS = 			$FLAG_REG_0 + 0x00400000 ;23
Global Const $FLAG_STATUS_EXIT = 				$FLAG_REG_0 + 0x00800000 ;24
;$FLAG_REG_1
Global Const $FLAG_SERVICE_INPUT = 				$FLAG_REG_1 + 0x00000001 ;1
Global Const $FLAG_SERVICE_ENABLED = 			$FLAG_REG_1 + 0x00000002 ;2
Global Const $FLAG_SERVICE_DISABLED = 			$FLAG_REG_1 + 0x00000004 ;3
Global Const $FLAG_FISC_CHECK_CLOSE = 			$FLAG_REG_1 + 0x00000008 ;4
Global Const $FLAG_PR_SINGLE_MODE = 			$FLAG_REG_1 + 0x00000010 ;5
Global Const $FLAG_PERIOD_MODE_FUNC = 			$FLAG_REG_1 + 0x00000020 ;6
Global Const $FLAG_ALLCTRL = 					$FLAG_REG_1 + 0x00000040 ;7
Global Const $FLAG_ALLCTRL_DISABLE = 			$FLAG_REG_1 + 0x00000080 ;8
Global Const $FLAG_ALLCTRL_ENABLE = 			$FLAG_REG_1 + 0x00000100 ;9
Global Const $FLAG_PR_MAKE_NUM = 				$FLAG_REG_1 + 0x00000200 ;10
Global Const $FLAG_PR_MAKE_DATE = 				$FLAG_REG_1 + 0x00000400 ;11
Global Const $FLAG_PR_SINGLE_MODE_FUNC = 		$FLAG_REG_1 + 0x00000800 ;12
Global Const $FLAG_PRINT_DIAG = 				$FLAG_REG_1 + 0x00001000 ;13
Global Const $FLAG_PRINT_X = 					$FLAG_REG_1 + 0x00002000 ;14
Global Const $FLAG_PRINT_Z = 					$FLAG_REG_1 + 0x00004000 ;15
Global Const $FLAG_PRINT_CUT = 					$FLAG_REG_1 + 0x00008000 ;16
Global Const $FLAG_IND_SHOW_TIME = 				$FLAG_REG_1 + 0x00010000 ;17
Global Const $FLAG_FP_MODEL_MODE_SET = 			$FLAG_REG_1 + 0x00020000 ;18
Global Const $FLAG_FP_MODEL_STRING_GET_FULL = 	$FLAG_REG_1 + 0x00040000 ;19
Global Const $FLAG_FP_MODEL_STRING_GET = 		$FLAG_REG_1 + 0x00080000 ;20
Global Const $FLAG_CASH_IN = 					$FLAG_REG_1 + 0x00100000 ;21
Global Const $FLAG_CASH_OUT = 					$FLAG_REG_1 + 0x00200000 ;22
Global Const $FLAG_MISC_EDIT_REFRESH = 			$FLAG_REG_1 + 0x00400000 ;23
Global Const $FLAG_MISC_EXIT = 					$FLAG_REG_1 + 0x00800000 ;24
;$FLAG_REG_2
Global Const $FLAG_HF_EXIT = 					$FLAG_REG_2 + 0x00000001 ;1
Global Const $FLAG_HF_OPEN = 					$FLAG_REG_2 + 0x00000002 ;2
Global Const $FLAG_HF_WRITE = 					$FLAG_REG_2 + 0x00000004 ;3
Global Const $FLAG_HF_SAVE = 					$FLAG_REG_2 + 0x00000008 ;4
Global Const $FLAG_HF_READ = 					$FLAG_REG_2 + 0x00000010 ;5
Global Const $FLAG_HF_EDIT = 					$FLAG_REG_2 + 0x00000020 ;6
Global Const $FLAG_HF_EDIT_REFRESH = 			$FLAG_REG_2 + 0x00000040 ;7
Global Const $FLAG_HF_EDIT_STORE = 				$FLAG_REG_2 + 0x00000080 ;8
Global Const $FLAG_MISC_OPEN = 					$FLAG_REG_2 + 0x00000100 ;9
Global Const $FLAG_MISC_EDIT = 					$FLAG_REG_2 + 0x00000200 ;10
Global Const $FLAG_EXIT_MISC_OPEN = 			$FLAG_REG_2 + 0x00000400 ;11
Global Const $FLAG_TIME_AUTO_UPDATE_MODE = 		$FLAG_REG_2 + 0x00000800 ;12
Global Const $FLAG_TIME_AUTO_UPDATE_MODE_FUNC = $FLAG_REG_2 + 0x00001000 ;13
Global Const $FLAG_MISC_EDIT_STORE = 			$FLAG_REG_2 + 0x00002000 ;14
Global Const $FLAG_MISC_SAVE = 					$FLAG_REG_2 + 0x00004000 ;15
Global Const $FLAG_SEND_CMD_W_RET = 			$FLAG_REG_2 + 0x00008000 ;16
Global Const $FLAG_LOGO_ENABLE = 				$FLAG_REG_2 + 0x00010000 ;17
Global Const $FLAG_LOGO_DISABLE = 				$FLAG_REG_2 + 0x00020000 ;18
Global Const $FLAG_FISC_CHECK_TOTAL = 			$FLAG_REG_2 + 0x00040000 ;19
Global Const $FLAG_SELL_EXIT = 					$FLAG_REG_2 + 0x00080000 ;20
Global Const $FLAG_SELL_TOOL = 					$FLAG_REG_2 + 0x00100000 ;21
;~ #ce

Global Const $REP_NUM = 1
Global Const $REP_DATE = 2
Global Const $REP_ZERO = 3
Global Const $REP_N_CHECKS = 4
Global Const $REP_N_SELLS = 5
Global Const $REP_N_RETURNS = 6
Global Const $REP_A = 7
Global Const $REP_B = 8
Global Const $REP_V = 9
Global Const $REP_G = 10
Global Const $REP_D = 11
Global Const $REP_A_R = 12
Global Const $REP_B_R = 13
Global Const $REP_V_R = 14
Global Const $REP_G_R = 15
Global Const $REP_D_R = 16
Global Const $REP_A_TAX = 17
Global Const $REP_B_TAX = 18
Global Const $REP_V_TAX = 19
Global Const $REP_G_TAX = 20
Global Const $REP_A_R_TAX = 21
Global Const $REP_B_R_TAX = 22
Global Const $REP_V_R_TAX = 23
Global Const $REP_G_R_TAX = 24
Global Const $REP_FOOTER = 25
Global Const $REP_CHECKSUM = 26
Global Const $REP_CHECKSUM_CALC = 27

Global Const $FLASH_ADR_Z = Dec('00A00')
Global Const $CONNECT_B_T = 'Connect'
Global Const $CONNECT_B_T2 = 'Disconnect'
Global Const $ALL_BYTES_MIN = 1
Global Const $ALL_BYTES_MAX = 320 * 1024
Global Const $START_ADDR_MIN = 0
Global Const $START_ADDR_MAX = $ALL_BYTES_MAX - 1
Global Const $START_ADDR_DEFAULT = $START_ADDR_MIN
Global Const $END_ADDR_MIN = 0
Global Const $END_ADDR_MAX = $ALL_BYTES_MAX - 1
Global Const $END_ADDR_DEFAULT = $END_ADDR_MAX
Global Const $ALL_BYTES_DEFAULT = $END_ADDR_DEFAULT - $START_ADDR_DEFAULT + 1
Global Const $BLOCK_SIZE_MIN = 1
Global Const $BLOCK_SIZE_MAX = 64
Global Const $BLOCK_SIZE_DEFAULT = $BLOCK_SIZE_MAX
Global Const $MAX_SL = 20
Global Const $MAX_CL = 50
Global Const $PR_NUM_MIN = 1
Global Const $PR_NUM_MAX = 2540
Global Const $PR_NUM_S_DEFAULT = $PR_NUM_MIN
Global Const $PR_NUM_F_DEFAULT = $PR_NUM_MAX
Global Const $X0 = 10
Global Const $Y0 = 5
Global Const $S_X = 30
Global Const $S_Y = 60
Global Const $SP_X = 10
Global Const $SP_Y = 10
Global Const $DelayCheckRange = 50
Global Const $DelayPCtimeGet = 500
Global Const $FP_MODEL_MODE_MIN = 0
Global Const $FP_MODEL_MODE_MAX = 1
Global Const $FP_MODEL_MODE_DEFAULT = 0
Global Const $CASH_IO_MIN = 0
Global Const $CASH_IO_MAX = 999999999.99
Global Const $CASH_IO_DEFAULT = $CASH_IO_MIN
Global Const $MAX_REP = 2540
Global Const $MISC_START_REP_ADDR = 2560
Global Const $MISC_READ_BYTE_COUNT = 128

Global Const $PAID_TYPE_CASH = 'P'
Global Const $PAID_TYPE_CREDIT = 'N'
Global Const $PAID_TYPE_CHECK = 'C'
Global Const $PAID_TYPE_CARD = 'D'