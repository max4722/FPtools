#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=bin\FPtools.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#Tidy_Parameters=/sfc
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <3530Ser.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <Array.au3>
Opt('MustDeclareVars', 1)
#region ConstsVars
Global Const $FLAG_EXIT_RWflash = 0x1 ;1
Global Const $FLAG_EXIT_GUI = 0x2 ;2
Global Const $FLAG_READ_FLASH = 0x4 ;4
Global Const $FLAG_SERVICE = 0x8 ;8
Global Const $FLAG_WRITE_FLASH = 0x10 ;16
Global Const $FLAG_ERASE_FLASH = 0x20 ;32
Global Const $FLAG_GET_FISC_INFO = 0x40 ;64
Global Const $FLAG_PERIOD_MODE = 0x80 ;128
Global Const $FLAG_TIME_SET = 0x100 ;256
Global Const $FLAG_TIME_GET = 0x200 ;512
Global Const $FLAG_TIME_GET_PC = 0x400 ;1024
Global Const $FLAG_TIME_GET_FACT_N = 0x800 ;2048
Global Const $FLAG_FISC_GET_VAT_N = 0x1000 ;4096
Global Const $FLAG_FISC_GET_FISC_N = 0x2000 ;8192
Global Const $FLAG_FISC_REFRESH = 0x4000 ;16384
Global Const $FLAG_FISC_SET_FACT_N = 0x8000 ;32768
Global Const $FLAG_FISC_SET_VAT_N = 0x10000 ;65536
Global Const $FLAG_FISC_SET_FISC_N = 0x20000 ;131072
Global Const $FLAG_FISC_SET_VER = 0x40000 ;262144
Global Const $FLAG_FISCALIZE = 0x80000 ;524288
Global Const $FLAG_FISC_SET_TAX = 0x100000 ;1048576
Global Const $FLAG_FISC_CLEAN_N_SET = 0x200000 ;2097152
Global Const $FLAG_FISC_GET_STATUS = 0x400000 ;4194304
Global Const $FLAG_STATUS_EXIT = 0x800000 ;8388608
Global Const $FLAG_HF_EXIT = 0x1000000 ;16777216
Global Const $FLAG_HF_OPEN = 0x2000000 ;33554432
Global Const $FLAG_HF_WRITE = 0x4000000 ;67108864
Global Const $FLAG_HF_SAVE = 0x8000000 ;134217728
Global Const $FLAG_HF_READ = 0x10000000 ;268435456
Global Const $FLAG_HF_EDIT = 0x20000000 ;536870912
Global Const $FLAG_HF_EDIT_REFRESH = 0x40000000 ;1073741824
Global Const $FLAG_HF_EDIT_STORE = 0x80000000 ;2147483648

Global Const $FLAG_SERVICE_INPUT = 0x1
Global Const $FLAG_SERVICE_ENABLED = 0x2
Global Const $FLAG_SERVICE_DISABLED = 0x4
Global Const $FLAG_FISC_FISCALIZE_TYPE = 0x8
Global Const $FLAG_PR_SINGLE_MODE = 0x10
Global Const $FLAG_PERIOD_MODE_FUNC = 0x20
Global Const $FLAG_ALLCTRL = 0x40
Global Const $FLAG_ALLCTRL_DISABLE = 0x80
Global Const $FLAG_ALLCTRL_ENABLE = 0x100
Global Const $FLAG_PR_MAKE_NUM = 0x200
Global Const $FLAG_PR_MAKE_DATE = 0x400
Global Const $FLAG_PR_SINGLE_MODE_FUNC = 0x800
Global Const $FLAG_PRINT_DIAG = 0x1000
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
Dim $guiState[2] = [0, 0]
Global $FactNI, $FiscNI, $VatNI
Global $_main, $_stat, $_hf
Global $readFlashB, $writeFlashB, $stopReadFlashB, $eraseFlashB, $setVerB, $cleanNsetB, $HFreadNsaveB, $HFopenNwriteB, $PortN, $PortConB, $PortSpeed
Global $startAdrI, $endAdrI, $TaxRateAI, $TaxRateBI, $TaxRateVI, $TaxRateGI, $bdI, $allBytesI, $percI, $EldI, $LeftI, $curBPSI
Global $SetFactNB, $SetVatNB, $SetFiscNB, $TaxRateAChB, $TaxRateBChB, $TaxRateVChB, $TaxRateGChB, $FiscRefreshB, $FiscalizeB, $SetTaxRatesB
Global $timeDT, $timeSetB, $timeGetB, $timePCgetB, $getStatusB, $textE, $HFeditE, $HFeditB, $HFopenB, $HFsaveB, $HFreadB, $HFwriteB
Global $serviceChB, $RefiscChB, $periodfDT, $periodsDT, $periodfI, $periodsI, $periodFormNumCB, $periodFormDateCB, $PRmakeB, $PRsingleChB
Global $FactNL, $VatNL, $FiscNL, $startAdrL, $endAdrL, $bdL, $allBytesL, $percL, $EldL, $LeftL, $curBPSL, $PrintDiagB
Global $DTstyle = 'dd-MM-yy HH:mm:ss'
Global $DTstyleDate = 'dd-MM-yy'
Global $portState = 0
Global $startAdr = $START_ADDR_DEFAULT
Global $endAdr = $END_ADDR_DEFAULT
Global $blockSize = $BLOCK_SIZE_DEFAULT
Global $maxFFcounter = 5
Global $allBytes = $ALL_BYTES_DEFAULT
Global $maxFailTry = 10
Global $seq = 0
Global $SLmax = 0, $CLmax = 0
Global $PRnumS = $PR_NUM_S_DEFAULT
Global $PRnumF = $PR_NUM_F_DEFAULT
Global $FactN, $FiscN, $VatN, $TaxRateA, $TaxRateB, $TaxRateV, $TaxRateG
Global $statusBytes
Dim $HFstr[8]
Dim $serviceList[$MAX_SL], $CtrlList[$MAX_CL]
#endregion ConstsVars
_GUIprepair()
_StartMainLoop()
_GUIdel()

Func _AllCtrlDisable()
	_FlagOn($FLAG_ALLCTRL_DISABLE, 1)
	_FlagOff($FLAG_ALLCTRL, 1)
	For $i = 1 To $CLmax
		GUICtrlSetState($CtrlList[$i - 1], $GUI_DISABLE)
	Next
	_FlagOff($FLAG_ALLCTRL_DISABLE, 1)
EndFunc   ;==>_AllCtrlDisable
Func _AllCtrlEnable()
	_FlagOn($FLAG_ALLCTRL_ENABLE, 1)
	_FlagOn($FLAG_ALLCTRL, 1)
	For $i = 1 To $CLmax
		GUICtrlSetState($CtrlList[$i - 1], $GUI_ENABLE)
	Next
	_FlagOff($FLAG_ALLCTRL_ENABLE, 1)
EndFunc   ;==>_AllCtrlEnable
Func _checkGUImsg()
	Local $msg, $m, $h, $retVal, $res
	$msg = GUIGetMsg(1)
	$m = $msg[0]
	$h = $msg[1]
	If $h = $_main Then
		Select
			Case $m = $GUI_EVENT_CLOSE
				_DLog('Closing...' & @CRLF)
				_FlagOn($FLAG_EXIT_GUI)
				_FlagOn($FLAG_EXIT_RWflash)
			Case $m = $readFlashB
				_AllCtrlDisable()
				GUICtrlSetState($stopReadFlashB, $GUI_ENABLE)
				$retVal = _FlashReadNsave()
				_AllCtrlEnable()
				GUICtrlSetState($stopReadFlashB, $GUI_DISABLE)
			Case $m = $writeFlashB
				$res = _Warn('All data will be lost!' & @CRLF & 'Continue?', $h)
				If $res Then
					_AllCtrlDisable()
					GUICtrlSetState($stopReadFlashB, $GUI_ENABLE)
					$retVal = _FlashOpenNwrite()
					_AllCtrlEnable()
					GUICtrlSetState($stopReadFlashB, $GUI_DISABLE)
				EndIf
			Case $m = $eraseFlashB
				$res = _Warn('All data will be lost!' & @CRLF & 'Continue?', $h)
				If $res Then
					_AllCtrlDisable()
					$retVal = _FlashErase()
					_AllCtrlEnable()
				EndIf
			Case $m = $HFreadNsaveB
				$res = _HFread()
				If $res Then
					_DLog('_checkGUImsg(): _HFread() = ' & $res & @CRLF)
				Else
					$res = _HFsave($h)
					If $res Then _DLog('_checkGUImsg(): _HFsave() = ' & $res & @CRLF)
				EndIf
			Case $m = $HFopenNwriteB
				$res = _HFopen($h)
				If $res Then
					_DLog('_checkGUImsg(): _HFopen() = ' & $res & @CRLF)
				Else
					$res = _HFwrite()
					If $res Then _DLog('_checkGUImsg(): _HFwrite() = ' & $res & @CRLF)
				EndIf
			Case $m = $stopReadFlashB
				_FlagOn($FLAG_EXIT_RWflash)
				GUICtrlSetState($stopReadFlashB, $GUI_DISABLE)
			Case $m = $PortConB
				If _Flag($FLAG_READ_FLASH) = 0 Then
					$retVal = _Port()
				EndIf
			Case $m = $timeSetB
				$retVal = _FPtimeSet()
			Case $m = $timeGetB
				$retVal = _FPtimeGet()
			Case $m = $timePCgetB
				$retVal = _PCtimeGet()
			Case $m = $FiscRefreshB
				$retVal = _FiscRefresh()
			Case $m = $SetFactNB
				$retVal = _SetFactN($h)
			Case $m = $SetFiscNB
				$retVal = _SetFiscN($h)
			Case $m = $SetVatNB
				$retVal = _SetVatN($h)
			Case $m = $setVerB
				$retVal = _SetVer()
			Case $m = $FiscalizeB
				$retVal = _Fiscalize($h)
			Case $m = $SetTaxRatesB
				$retVal = _SetTaxRates($h)
			Case $m = $cleanNsetB
				$retVal = _CleanNSet($h)
			Case $m = $getStatusB
				_GetStatusB()
			Case $m = $HFeditB
				_HFedit()
			Case $m = $serviceChB
				If _Flag($FLAG_SERVICE) = 0 And GUICtrlRead($m) = $GUI_CHECKED Then
					$res = _ServiceInput($h)
					If $res = 0 Then
						_ServiceEnable()
					Else
						_DLog('_checkGUImsg(): Service password do not match' & @CRLF)
						GUICtrlSetState($m, $GUI_UNCHECKED)
					EndIf
				ElseIf _Flag($FLAG_SERVICE) And GUICtrlRead($m) = $GUI_UNCHECKED Then
					_ServiceDisable()
				EndIf
			Case $m = $periodFormDateCB
				If _Flag($FLAG_PERIOD_MODE) And GUICtrlRead($m) = $GUI_CHECKED Then
					_PRmodeSet(0)
				EndIf
			Case $m = $periodFormNumCB
				If _Flag($FLAG_PERIOD_MODE) = 0 And GUICtrlRead($m) = $GUI_CHECKED Then
					_PRmodeSet(1)
				EndIf
			Case $m = $PRmakeB
				If _PRmodeGet() Then
					_PRmakeNum()
				Else
					_PRmakeDate()
				EndIf
			Case $m = $PRsingleChB
				_DLog('_checkGUImsg(): _PRsingleModeGet() = ' & _PRsingleModeGet() & @CRLF)
				If _PRsingleModeGet() = 0 And GUICtrlRead($m) = $GUI_CHECKED Then
					_PRsingleModeSet(1)
					_DLog('_checkGUImsg(): _PRsingleModeGet() = ' & _PRsingleModeGet() & @CRLF)
				ElseIf _PRsingleModeGet() And GUICtrlRead($m) = $GUI_UNCHECKED Then
					_PRsingleModeSet(0)
				EndIf
			Case $m = $PrintDiagB
				$retVal = _PrintDiag()
		EndSelect
	ElseIf $h = $_stat Then
		Select
			Case $m = $GUI_EVENT_CLOSE
				_FlagOn($FLAG_STATUS_EXIT)
		EndSelect
	ElseIf $h = $_hf Then
		Select
			Case $m = $GUI_EVENT_CLOSE
				_FlagOn($FLAG_HF_EXIT)
		EndSelect
		Select
			Case $m = $HFopenB
				$res = _HFopen($h)
				If $res Then
					_DLog('_checkGUImsg(): _HFopen() = ' & $res & @CRLF)
				EndIf
			Case $m = $HFsaveB
				$res = _HFsave($h)
				If $res Then
					_DLog('_checkGUImsg(): _HFsave() = ' & $res & @CRLF)
				EndIf
			Case $m = $HFreadB
				$res = _HFread()
				If $res Then
					_DLog('_checkGUImsg(): _HFread() = ' & $res & @CRLF)
				EndIf
			Case $m = $HFwriteB
				$res = _HFwrite()
				If $res Then
					_DLog('_checkGUImsg(): _HFwrite() = ' & $res & @CRLF)
				EndIf
		EndSelect
	EndIf
	;Return $guiState
EndFunc   ;==>_checkGUImsg
Func _CheckInput($var, $min, $max, $defv)
	If $var = '' Or $var > $max Or $var < $min Then
		Return $defv
	Else
		Return $var
	EndIf
EndFunc   ;==>_CheckInput
Func _CheckRange()
	Local $i
	;_DLog('$allBytes=' & $allBytes & ' GUICtrlRead($allBytesI)=' & GUICtrlRead($allBytesI) & @CRLF)
	$allBytes = GUICtrlRead($allBytesI)
	$i = _CheckInput($allBytes, $ALL_BYTES_MIN, $ALL_BYTES_MAX, $ALL_BYTES_DEFAULT)
	If $i <> $allBytes Then
		_DLog('Not correct $allBytes, setting to default value' & @CRLF)
		$allBytes = $i
		GUICtrlSetData($allBytesI, $allBytes)
	EndIf
	$startAdr = GUICtrlRead($startAdrI)
	$i = _CheckInput($startAdr, $START_ADDR_MIN, $START_ADDR_MAX, $START_ADDR_DEFAULT)
	If $i <> $startAdr Then
		_DLog('Not correct $startAdr, setting to default value' & @CRLF)
		$startAdr = $i
		GUICtrlSetData($startAdrI, $startAdr)
	EndIf
	$endAdr = GUICtrlRead($endAdrI)
	$i = _CheckInput($endAdr, $END_ADDR_MIN, $END_ADDR_MAX, $END_ADDR_DEFAULT)
	If $i <> $endAdr Then
		_DLog('Not correct $endAdr, setting to default value' & @CRLF)
		$endAdr = $i
		GUICtrlSetData($endAdrI, $endAdr)
	EndIf
	If $endAdr < $startAdr Then
		_DLog('$endAdr < $startAdr, $endAdr setting to max value' & @CRLF)
		$endAdr = $END_ADDR_MAX
		GUICtrlSetData($endAdrI, $endAdr)
	EndIf
	If $endAdr - $startAdr + 1 <> $allBytes Then
		_DLog('Not correct $allBytes, $endAdr - $startAdr + 1 <> $allBytes. Corrected.' & @CRLF)
		;$allBytes = $endAdr - $startAdr + 1
		$endAdr = $allBytes + $startAdr - 1
		;GUICtrlSetData($allBytesI, $allBytes)
		GUICtrlSetData($endAdrI, $endAdr)
	EndIf
	$PRnumS = GUICtrlRead($periodsI)
	$i = _CheckInput($PRnumS, $PR_NUM_MIN, $PR_NUM_MAX, $PR_NUM_S_DEFAULT)
	If $i <> $PRnumS Then
		_DLog('Not correct $PRnumS, setting to default value' & @CRLF)
		$PRnumS = $i
		GUICtrlSetData($periodsI, $PRnumS)
	EndIf
	$PRnumF = GUICtrlRead($periodfI)
	$i = _CheckInput($PRnumF, $PR_NUM_MIN, $PR_NUM_MAX, $PR_NUM_F_DEFAULT)
	If $i <> $PRnumF Then
		_DLog('Not correct $PRnumF, setting to default value' & @CRLF)
		$PRnumF = $i
		GUICtrlSetData($periodfI, $PRnumF)
	EndIf
	If $PRnumF < $PRnumS Then
		_DLog('$PRnumF < $PRnumS, $PRnumF setting to $PRnumS' & @CRLF)
		$PRnumF = $PRnumS
		GUICtrlSetData($periodfI, $PRnumF)
	EndIf
EndFunc   ;==>_CheckRange
Func _CleanNSet($mainHndl)
	Local $retVal
	_FlagOn($FLAG_FISC_CLEAN_N_SET)
	_DLog('_CleanNSet(): Starting _FlashErase()... ' & @CRLF)
	$retVal = _FlashErase()
	_DLog('_CleanNSet(): Exit _FlashErase() = ' & $retVal & @CRLF)
	If $retVal Then Return 1
	_DLog('_CleanNSet(): Starting _FPtimeSet()... ' & @CRLF)
	$retVal = _FPtimeSet()
	_DLog('_CleanNSet(): Exit _FPtimeSet() = ' & $retVal & @CRLF)
	If $retVal Then Return 1
	_DLog('_CleanNSet(): Starting _SetVer()... ' & @CRLF)
	$retVal = _SetVer()
	_DLog('_CleanNSet(): Exit _SetVer() = ' & $retVal & @CRLF)
	If $retVal Then Return 1
	_DLog('_CleanNSet(): Starting _SetFactN()... ' & @CRLF)
	$retVal = _SetFactN($mainHndl)
	_DLog('_CleanNSet(): Exit _SetFactN() = ' & $retVal & @CRLF)
	If $retVal Then Return 1
	_DLog('_CleanNSet(): Starting _SetVatN()... ' & @CRLF)
	$retVal = _SetVatN($mainHndl)
	_DLog('_CleanNSet(): Exit _SetVatN() = ' & $retVal & @CRLF)
	If $retVal Then Return 1
	_DLog('_CleanNSet(): Starting _SetFiscN()... ' & @CRLF)
	$retVal = _SetFiscN($mainHndl)
	_DLog('_CleanNSet(): Exit _SetFiscN() = ' & $retVal & @CRLF)
	If $retVal Then Return 1
	_DLog('_CleanNSet(): Starting _SetTaxRates()... ' & @CRLF)
	$retVal = _SetTaxRates($mainHndl)
	_DLog('_CleanNSet(): Exit _SetTaxRates() = ' & $retVal & @CRLF)
	If $retVal Then Return 1
	GUICtrlSetState($RefiscChB, $GUI_UNCHECKED)
	_DLog('_CleanNSet(): Starting _Fiscalize()... ' & @CRLF)
	$retVal = _Fiscalize($mainHndl)
	_DLog('_CleanNSet(): Exit _Fiscalize() = ' & $retVal & @CRLF)
	If $retVal Then Return 1
	_FlagOff($FLAG_FISC_CLEAN_N_SET)
	Return 0
EndFunc   ;==>_CleanNSet
Func _CtrlListAdd($h)
	If $CLmax < $MAX_CL Then
		$CtrlList[$CLmax] = $h
		$CLmax += 1
	EndIf
EndFunc   ;==>_CtrlListAdd
Func _Fiscalize($mainHndl)
	Local $i, $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_Fiscalize(): No response from printer' & @CRLF)
		Return 1
	EndIf
	$i = GUICtrlRead($FactNI)
	If StringLen($i) <> 10 Or Not StringIsDigit(StringRight($i, 8)) Then
		_DLog('_Fiscalize(): Not valid factory number ' & $i & @CRLF)
		_Info('Error factory number', $mainHndl)
		Return 1
	EndIf
	_FlagOn($FLAG_FISCALIZE)
	$retVal = 0
	If GUICtrlRead($RefiscChB) = $GUI_CHECKED Then
		$dd = '0000,' & $i & ',' & GUICtrlRead($VatNI) & ',0'
	Else
		$dd = '0000,' & $i
	EndIf
	_DLog('_Fiscalize(): $dd = ' & $dd & @CRLF)
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(72, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_Fiscalize(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	If $data = 'P' Then _DLog('_Fiscalize(): OK' & @CRLF)
	If StringIsDigit($data) Then
		_DLog('_Fiscalize(): Failure, ' & $data & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_FISCALIZE)
	Return $retVal
EndFunc   ;==>_Fiscalize
Func _FiscRefresh()
	Local $retVal
	_FlagOn($FLAG_FISC_REFRESH)
	$retVal = _GetFiscInfo()
	_FlagOff($FLAG_FISC_REFRESH)
	Return $retVal
EndFunc   ;==>_FiscRefresh
Func _Flag($f, $i = 0)
	Local $r
	$r = BitAND($guiState[$i], $f)
	If $r Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_Flag
Func _FlagOff($f, $i = 0)
	If _Flag($f, $i) Then $guiState[$i] -= $f
EndFunc   ;==>_FlagOff
Func _FlagOn($f, $i = 0)
	$guiState[$i] = BitOR($guiState[$i], $f)
EndFunc   ;==>_FlagOn
Func _FlashErase()
	Local $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_FlashErase(): No response from printer' & @CRLF)
		Return 1
	EndIf
	Local $beg = TimerInit()
	_FlagOn($FLAG_ERASE_FLASH)
	$retVal = 0
	$dd = ''
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(130, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_FlashErase(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	If $data = 'P' Then _DLog('_FlashErase(): OK' & @CRLF)
	If $data = 'F' Then
		_DLog('_FlashErase(): Failure' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_ERASE_FLASH)
	Return $retVal
EndFunc   ;==>_FlashErase
Func _FlashOpenNwrite()
	Local $filename, $errStatus, $file, $FFcounter, $beg, $oldT, $retVal, $maxk, $bs, $dd, $failTry, $res, $rrRaw, $rr, $data, $timerD, $fileSize, $adr
	GUISetState(@SW_DISABLE, $_main)
	$filename = FileOpenDialog('Open flash memory as', StringRight($FactN, 7), 'Binary (*.bin)|All (*.*)')
	$errStatus = @error
	GUISetState(@SW_ENABLE, $_main)
	GUISetState(@SW_HIDE, $_main)
	GUISetState(@SW_SHOW, $_main)
	If $errStatus Then
		_DLog('_FlashOpenNwrite(): file not selected' & @CRLF)
		Return 1
	EndIf
	If StringRight($filename, 4) <> '.bin' Then
		$filename &= '.bin'
	EndIf
	_DLog('_FlashOpenNwrite(): $filename = ' & $filename & @CRLF)
	$file = FileOpen($filename)
	If $file = -1 Then
		_DLog('_FlashOpenNwrite(): FileOpen()' & @CRLF)
		Return 1
	EndIf
	If _TestConnect() = '' Then
		_DLog('_FlashOpenNwrite(): No response from printer' & @CRLF)
		Return 1
	EndIf
	$FFcounter = 0
	$beg = TimerInit()
	$oldT = 0
	_FlagOn($FLAG_WRITE_FLASH)
	$retVal = 0
	$fileSize = FileGetSize($filename)
	If $allBytes > $fileSize Then
		GUICtrlSetData($allBytesI, $fileSize)
		_CheckRange()
	EndIf
	$maxk = Floor($allBytes / $blockSize)
	For $k = 0 To $maxk
		_checkGUImsg()
		If _Flag($FLAG_EXIT_RWflash) Then
			_FlagOff($FLAG_EXIT_RWflash)
			_DLog('_FlashOpenNwrite(): Reading aborted' & @CRLF)
			ExitLoop
		EndIf
		$bs = $blockSize
		If $allBytes - $k * $blockSize < 64 Then $bs = $allBytes - $k * $blockSize
		If $bs = 0 Then ExitLoop
		$adr = $startAdr + $k * $blockSize
		FileSetPos($file, $adr, 0)
		$dd = FileRead($file, $bs)
		$dd = Hex(Int($adr)) & ',' & $bs & ',' & _StringToHex($dd)
		$failTry = 0
		Do
			$seq = _incSeq($seq)
			$res = _SendCMD(135, $dd, $seq)
			$rrRaw = _ReceiveAll()
			$rr = _Validate($rrRaw)
			$data = _GetData(_GetBody($rr))
			If $data = '' Then $failTry += 1
		Until $data <> '' Or $failTry > $maxFailTry
		If $failTry > $maxFailTry Then
			_DLog('_FlashOpenNwrite(): No response while writing data' & @CRLF)
			$retVal = 1
			ExitLoop
		EndIf
		$timerD = TimerDiff($beg)
		If Int($timerD / 1000) <> $oldT Then
			$oldT = Int($timerD / 1000)
			_GetStatistics($k * $blockSize + $bs, $timerD)
		EndIf
	Next
	_DLog(_StringRepeat('-', 20) & @CRLF)
	_DLog(_GetStatistics(FileGetSize($filename), TimerDiff($beg)) & @CRLF)
	FileClose($file)
	_DLog('_FlashOpenNwrite():writing completed' & @CRLF)
	_FlagOff($FLAG_WRITE_FLASH)
	Return $retVal
EndFunc   ;==>_FlashOpenNwrite
Func _FlashReadNsave()
	Local $filename, $errStatus, $file, $FFcounter, $beg, $oldT, $retVal, $maxk, $bs, $dd, $failTry, $res, $rrRaw, $rr, $data, $timerD, $fileSize
	GUISetState(@SW_DISABLE, $_main)
	$filename = FileSaveDialog('Save flash memory as', '', 'Binary (*.bin)|All (*.*)', 16, StringRight($FactN, 7))
	$errStatus = @error
	GUISetState(@SW_ENABLE, $_main)
	GUISetState(@SW_HIDE, $_main)
	GUISetState(@SW_SHOW, $_main)
	If $errStatus Then
		_DLog('_FlashReadNsave(): file not selected' & @CRLF)
		Return 1
	EndIf
	If StringRight($filename, 4) <> '.bin' Then
		$filename &= '.bin'
	EndIf
	_DLog('_FlashReadNsave(): $filename = ' & $filename & @CRLF)
	$file = FileOpen($filename, 2)
	If $file = -1 Then
		_DLog('_FlashReadNsave(): FileOpen()' & @CRLF)
		Return 1
	EndIf
	If _TestConnect() = '' Then
		_DLog('_FlashReadNsave(): No response from printer' & @CRLF)
		Return 1
	EndIf
	$FFcounter = 0
	$beg = TimerInit()
	$oldT = 0
	_FlagOn($FLAG_READ_FLASH)
	$retVal = 0
	$maxk = Floor($allBytes / $blockSize)
	For $k = 0 To $maxk
		_checkGUImsg()
		If _Flag($FLAG_EXIT_RWflash) Then
			_FlagOff($FLAG_EXIT_RWflash)
			_DLog('_FlashReadNsave(): Reading aborted' & @CRLF)
			ExitLoop
		EndIf
		$bs = $blockSize
		If $allBytes - $k * $blockSize < 64 Then $bs = $allBytes - $k * $blockSize
		If $bs = 0 Then ExitLoop
		$dd = Hex(Int($startAdr + $k * $blockSize), 5) & ',' & $bs
		$failTry = 0
		Do
			$seq = _incSeq($seq)
			$res = _SendCMD(116, $dd, $seq)
			$rrRaw = _ReceiveAll()
			$rr = _Validate($rrRaw)
			$data = _GetData(_GetBody($rr))
			If $data = '' Then $failTry += 1
		Until $data <> '' Or $failTry > $maxFailTry
		If $failTry > $maxFailTry Then
			_DLog('_FlashReadNsave(): No response while reading data' & @CRLF)
			$retVal = 1
			ExitLoop
		EndIf
		If $startAdr + $blockSize * $k >= $FLASH_ADR_Z And StringCompare($data, _StringRepeat('FF', $blockSize)) = 0 Then
			$FFcounter += 1
			If $FFcounter > $maxFFcounter Then ExitLoop
		EndIf
		FileWrite($file, _HexToString($data))
		$timerD = TimerDiff($beg)
		If Int($timerD / 1000) <> $oldT Then
			$oldT = Int($timerD / 1000)
			_GetStatistics($k * $blockSize + $bs, $timerD)
		EndIf
	Next
	_DLog(_StringRepeat('-', 20) & @CRLF)
	$fileSize = FileGetSize($filename)
	If $allBytes <> $fileSize Then
		GUICtrlSetData($allBytesI, $fileSize)
		_CheckRange()
	EndIf
	_DLog(_GetStatistics($fileSize, TimerDiff($beg)) & @CRLF)
	FileClose($file)
	_DLog('_FlashReadNsave(): Reading completed (' & $FFcounter & ')' & @CRLF)
	_FlagOff($FLAG_READ_FLASH)
	Return $retVal
EndFunc   ;==>_FlashReadNsave
Func _FPtimeGet()
	Local $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_FPtimeGet(): No response from printer' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_TIME_GET)
	$retVal = 0
	$dd = ''
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(62, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $data = '' Then $failTry += 1
	Until $data <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_FPtimeGet(): No response while reading data' & @CRLF)
		$retVal = 1
	Else
		$data = '20' & StringMid($data, 7, 2) & '/' & StringMid($data, 4, 2) & '/' & StringLeft($data, 2) & StringRight($data, 9)
		GUICtrlSetData($timeDT, $data)
	EndIf
	_FlagOff($FLAG_TIME_GET)
	Return $retVal
EndFunc   ;==>_FPtimeGet
Func _FPtimeSet()
	Local $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_FPtimeSet(): No response from printer' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_TIME_SET)
	$retVal = 0
	$dd = GUICtrlRead($timeDT)
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(61, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_FPtimeSet(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_TIME_SET)
	Return $retVal
EndFunc   ;==>_FPtimeSet
Func _GetFiscInfo()
	Local $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data, $i, $j
	If _TestConnect() = '' Then
		_DLog('_GetFiscInfo(): No response from printer' & @CRLF)
		Return 1
	EndIf
	Local $beg = TimerInit()
	$retVal = 0
	_FlagOn($FLAG_GET_FISC_INFO)
	$dd = '1'
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(90, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_GetFiscInfo(): No response while reading data' & @CRLF)
		_FlagOff($FLAG_GET_FISC_INFO)
		Return 1
	EndIf
	$FactN = StringLeft(StringTrimLeft($data, 36), 10)
	$FiscN = StringRight($data, 10)
	$dd = ''
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(99, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_GetFiscInfo(): No response while reading data' & @CRLF)
		_FlagOff($FLAG_GET_FISC_INFO)
		Return 1
	EndIf
	$VatN = StringTrimRight($data, 2)
	$dd = ''
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(97, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_GetFiscInfo(): No response while reading data' & @CRLF)
		_FlagOff($FLAG_GET_FISC_INFO)
		Return 1
	EndIf
	$i = StringSplit($data, ',')
	If $i[0] Then
		$TaxRateA = $i[1]
		$TaxRateB = $i[2]
		$TaxRateV = $i[3]
		$TaxRateG = $i[4]
		$j = GUICtrlRead($TaxRateAI)
		If $j <> $TaxRateA Then
			GUICtrlSetData($TaxRateAI, $TaxRateA)
			_DLog('$TaxRateAI corrected.' & @CRLF)
		EndIf
		If $j <> $TaxRateB Then
			GUICtrlSetData($TaxRateBI, $TaxRateB)
			_DLog('$TaxRateBI corrected.' & @CRLF)
		EndIf
		If $j <> $TaxRateV Then
			GUICtrlSetData($TaxRateVI, $TaxRateV)
			_DLog('$TaxRateVI corrected.' & @CRLF)
		EndIf
		If $j <> $TaxRateG Then
			GUICtrlSetData($TaxRateGI, $TaxRateG)
			_DLog('$TaxRateGI corrected.' & @CRLF)
		EndIf
	Else
		_DLog('Tax rates read error' & @CRLF)
		$retVal = 1
	EndIf
	GUICtrlSetState($TaxRateAChB, $GUI_CHECKED)
	GUICtrlSetState($TaxRateBChB, $GUI_CHECKED)
	GUICtrlSetState($TaxRateVChB, $GUI_CHECKED)
	GUICtrlSetState($TaxRateGChB, $GUI_CHECKED)
	_DLog('$FactN=' & $FactN & ' $VatN=' & $VatN & ' $FiscN=' & $FiscN & ' $TaxRateA=' & $TaxRateA & ' $TaxRateB=' & $TaxRateB & ' $TaxRateV=' & $TaxRateV & ' $TaxRateG=' & $TaxRateG & @CRLF)
	$i = GUICtrlRead($FactNI)
	If $i <> $FactN Then
		GUICtrlSetData($FactNI, $FactN)
		_DLog('$FactNI corrected.' & @CRLF)
	EndIf
	$i = GUICtrlRead($FiscNI)
	If $i <> $FiscN Then
		GUICtrlSetData($FiscNI, $FiscN)
		_DLog('$FiscNI corrected.' & @CRLF)
	EndIf
	$i = GUICtrlRead($VatNI)
	If $i <> $VatN Then
		GUICtrlSetData($VatNI, $VatN)
		_DLog('$VatNI corrected.' & @CRLF)
	EndIf
	_FlagOff($FLAG_GET_FISC_INFO)
	Return $retVal
EndFunc   ;==>_GetFiscInfo
Func _GetStatistics($bd, $t)
	Local $secEld, $curBPS, $minEld, $secLeft, $minLeft, $perc, $s, $minstr
	$secEld = $t / 1000
	$curBPS = $bd / $secEld
	$minEld = Int($secEld / 60)
	$secEld = $secEld - 60 * $minEld
	$secLeft = ($allBytes - $bd) / $curBPS
	$minLeft = Int($secLeft / 60)
	$secLeft = $secLeft - 60 * $minLeft
	$perc = 100 * $bd / $allBytes
	$s = $bd & ' of ' & $allBytes & ' bytes done (' & Int($perc) & '%), time elipsed: ' & $minEld & ' min ' & _
			Int($secEld) & ' sec, left: ' & $minLeft & ' min ' & Int($secLeft) & ' sec (' & Int(8 * $curBPS) & ' bps)'
	GUICtrlSetData($bdI, $bd)
	GUICtrlSetData($allBytesI, $allBytes)
	GUICtrlSetData($percI, Int($perc))
	$minstr = ''
	If $minEld Then $minstr = $minEld & 'm '
	GUICtrlSetData($EldI, $minstr & Int($secEld) & 's')
	$minstr = ''
	If $minLeft Then $minstr = $minLeft & 'm '
	GUICtrlSetData($LeftI, $minstr & Int($secLeft) & 's')
	GUICtrlSetData($curBPSI, Int(8 * $curBPS))
	Return $s
EndFunc   ;==>_GetStatistics
Func _GetStatusB()
	Local $sdat, $s
	Dim $st[6][8]
	If $statusBytes = '' Or StringLen($statusBytes) <> 6 Then
		_DLog('_GetStatus(): Not correct length (' & StringLen($statusBytes) & ') of $statusBytes' & @CRLF)
		Return 1
	EndIf
	;_DLog('Status: ' & _StringToHex($res) & @CRLF)
	_FlagOn($FLAG_FISC_GET_STATUS)
	$sdat = _StringToHex($statusBytes)
	For $i = 0 To 5
		For $j = 0 To 7
			$st[$i][$j] = 0
			If BitAND(Dec(StringMid($sdat, 2 * $i + 1, 2)), 2 ^ $j) Then $st[$i][$j] = 1
		Next
	Next
	$s = @CRLF & '���� S0 � ����� ����������' & @CRLF
	;If $st[0][7] Then $s &= '0.7 = ' & $st[0][7] & '	������' & @CRLF
	;If $st[0][6] Then $s &= '0.6 = ' & $st[0][6] & ' 	������' & @CRLF
	If $st[0][5] Then $s &= '0.5 = ' & $st[0][5] & '	����� ������ � ���� ��� ��������������� ������ ����� ���������� ���� �� �����, ������������� �������� �#�.' & @CRLF
	If $st[0][4] Then $s &= '0.4 = ' & $st[0][4] & '#	�������� ����������� ���������� ����������' & @CRLF
	If $st[0][3] Then $s &= '0.3 = ' & $st[0][3] & '   	����������� �������' & @CRLF
	If $st[0][2] Then $s &= '0.2 = ' & $st[0][2] & '	���� � ����� �� ���� ����������� � ������� ���������� ���������� ��������� RAM' & @CRLF
	If $st[0][1] Then $s &= '0.1 = ' & $st[0][1] & '#	��� ���������� ������� �������' & @CRLF
	If $st[0][0] Then $s &= '0.0 = ' & $st[0][0] & '#	���������� ������ �������� �������������� ������' & @CRLF
	$s &= @CRLF & '���� S1 � ����� ����������' & @CRLF
	;If $st[1][7] Then $s &= '1.7 = ' & $st[1][7] & '	������' & @CRLF
	;If $st[1][6] Then $s &= '1.6 = ' & $st[1][6] & '	������' & @CRLF
	If $st[1][5] Then $s &= '1.5 = ' & $st[1][5] & '	������� ������ ��������' & @CRLF
	If $st[1][4] Then $s &= '1.4 = ' & $st[1][4] & '#	���������� ����������� ������ ���� ��������� (RAM) ��� ��������� � ��������� ���������' & @CRLF
	;If $st[1][3] Then $s &= '1.3 = ' & $st[1][3] & '# 	������' & @CRLF
	If $st[1][2] Then $s &= '1.2 = ' & $st[1][2] & '#	��������� ��������� ��������� ����������� ������' & @CRLF
	If $st[1][1] Then $s &= '1.1 = ' & $st[1][1] & ' #	����������� ������� �� ��������� ��� �������� ����������� ������ ��������' & @CRLF
	If $st[1][0] Then $s &= '1.0 = ' & $st[1][0] & ' 	��� ���������� ������� ��������� ������������ �������� ������������ � ��������� 1.1 ���� ��� ����������� ���������, �� �� ��� �������� �� ����� ���� ���������' & @CRLF
	$s &= @CRLF & '���� S2 � ����� ����������' & @CRLF
	;If $st[2][7] Then $s &= '2.7 = ' & $st[2][7] & '	������' & @CRLF
	If $st[2][6] Then $s &= '2.6 = ' & $st[2][6] & ' 	�� ������������' & @CRLF
	If $st[2][5] Then $s &= '2.5 = ' & $st[2][5] & '	������ ������������ ���' & @CRLF
	If $st[2][4] Then $s &= '2.4 = ' & $st[2][4] & '	������������� (�� ��� �� �����������) ����������� �����' & @CRLF
	If $st[2][3] Then $s &= '2.3 = ' & $st[2][3] & '  	������ ���������� ���' & @CRLF
	If $st[2][2] Then $s &= '2.2 = ' & $st[2][2] & '	��� ����������� �����' & @CRLF
	If $st[2][1] Then $s &= '2.1 = ' & $st[2][1] & '	������������� (�� ��� �� �����������) ������� ��� ����������� �����' & @CRLF
	If $st[2][0] Then $s &= '2.0 = ' & $st[2][0] & ' 	����������� ������� ��� ����������� �����' & @CRLF
	$s &= @CRLF & '���� S3 � ��������� ��������������' & @CRLF
	;If $st[3][7] Then $s &= '3.7 = ' & $st[3][7] & '	������' & @CRLF
	$s &= '3.6 = ' & $st[3][6] & ' 	������������� Sw7 � ����������� ����� �� ����������� �����' & @CRLF
	$s &= '3.5 = ' & $st[3][5] & ' 	������������� Sw6 � ������� (������� ������� 1251)' & @CRLF
	$s &= '3.4 = ' & $st[3][4] & ' 	������������� Sw5 � ������� �������� ��� ������� ������ �� ������ DOS/Windows 1251' & @CRLF
	$s &= '3.3 = ' & $st[3][3] & ' 	������������� Sw4 � ����� ����������� �������' & @CRLF
	$s &= '3.2 = ' & $st[3][2] & ' 	������������� Sw3 � �������������� ������� ����' & @CRLF
	$s &= '3.1 = ' & $st[3][1] & ' 	������������� Sw2 � �������� ����������������� �����' & @CRLF
	$s &= '3.0 = ' & $st[3][0] & ' 	������������� Sw1 - �������� ����������������� �����' & @CRLF
	$s &= @CRLF & '���� S4:	���������� ������' & @CRLF
	;If $st[4][7] Then $s &= '4.7 = ' & $st[4][7] & '	������' & @CRLF
	;If $st[4][6] Then $s &= '4.6 = ' & $st[4][6] & ' 	������' & @CRLF
	If $st[4][5] Then $s &= '4.5 = ' & $st[4][5] & '	���� ��� ��������������� ������ ����� ���������� ���� �� �����, ������������� �������� �*� � ������ 4 ��� 5' & @CRLF
	If $st[4][4] Then $s &= '4.4 = ' & $st[4][4] & ' *	���������� ������ �����������' & @CRLF
	If $st[4][3] Then $s &= '4.3 = ' & $st[4][3] & '  	� ���������� ������ ���� ����� �� ������� ���� ��� 50 Z-�������' & @CRLF
	If $st[4][2] Then $s &= '4.2 = ' & $st[4][2] & ' 	��� ������ ���������� ������' & @CRLF
	;If $st[4][1] Then $s &= '4.1 = ' & $st[4][1] & ' 	�� ������������' & @CRLF
	If $st[4][0] Then $s &= '4.0 = ' & $st[4][0] & ' *	�������� ������ ��� ������ � ���������� ������' & @CRLF
	$s &= @CRLF & '���� S5:	���������� ������' & @CRLF
	;If $st[5][7] Then $s &= '5.7 = ' & $st[5][7] & '	������' & @CRLF
	;If $st[5][6] Then$s &= '5.6 = ' & $st[5][6] & ' 	������' & @CRLF
	If $st[5][5] Then $s &= '5.5 = ' & $st[5][5] & ' 	���������� � ��������� ����� �����������������' & @CRLF
	If $st[5][4] Then $s &= '5.4 = ' & $st[5][4] & '	��������� ������ ����������' & @CRLF
	If $st[5][3] Then $s &= '5.3 = ' & $st[5][3] & '  	���������� ���������������' & @CRLF
	;If $st[5][2] Then $s &= '5.2 = ' & $st[5][2] & ' *	�� ������������' & @CRLF
	If $st[5][1] Then $s &= '5.1 = ' & $st[5][1] & ' 	���������� ������ ��������������' & @CRLF
	If $st[5][0] Then $s &= '5.0 = ' & $st[5][0] & ' *	���������� ������ ����������� � ����� Read Only.' & @CRLF
	$s &= @CRLF
	_DLog($s)
	GUISetState(@SW_DISABLE)
	GUISwitch($_stat)
	GUISetState(@SW_SHOW)
	GUICtrlSetData($textE, $s)
	Do
		_checkGUImsg()
	Until _Flag($FLAG_STATUS_EXIT)
	_FlagOff($FLAG_STATUS_EXIT)
	GUISetState(@SW_HIDE)
	GUISwitch($_main)
	GUISetState(@SW_HIDE)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_ENABLE)
	_FlagOff($FLAG_FISC_GET_STATUS)
	Return 0
EndFunc   ;==>_GetStatusB
Func _GUIdel()
	_FlagOff($FLAG_EXIT_GUI)
	GUIDelete()
	Return 0
EndFunc   ;==>_GUIdel
Func _GUIprepair()
	Local $s, $s1
	Local Const $DTM_SETFORMAT_ = 0x1032
	#region $_stat
	$_stat = GUICreate('Status', 400, 300)
	$textE = GUICtrlCreateEdit('', 0, 0, 400, 300)
	#endregion $_stat
	#region $_hf
	$_hf = GUICreate('Edit HF', 300 - 20, 230 - 30)
	GUISwitch($_hf)
	$HFeditE = GUICtrlCreateEdit('', 5, 5, 290 - 20, 160 - 30, $ES_WANTRETURN)
	GUICtrlSetFont(-1, 9, Default, Default, 'Courier New')
	$HFreadB = GUICtrlCreateButton('Read', 10, 175 - 30, 50, 20, 0)
	$HFwriteB = GUICtrlCreateButton('Write', 10, 205 - 30, 50, 20, 0)
	$HFopenB = GUICtrlCreateButton('Open', 70, 175 - 30, 50, 20, 0)
	$HFsaveB = GUICtrlCreateButton('Save', 70, 205 - 30, 50, 20, 0)
	#endregion $_hf
	#region $_main
	$_main = GUICreate('FPtools', 367, 361)
	GUISwitch($_main)
	#region GUICtrlCreate
	$FactNL = GUICtrlCreateLabel('Factory number:', 10, 5, 80, 20)
	$FactNI = GUICtrlCreateInput('', 10, 20, 80, 20)
	$SetFactNB = GUICtrlCreateButton('Set', 55, 45, 35, 20, 0)
	$VatNL = GUICtrlCreateLabel('VAT number:', 100, 5, 80, 20)
	$VatNI = GUICtrlCreateInput('', 100, 20, 80, 20)
	$SetVatNB = GUICtrlCreateButton('Set', 145, 45, 35, 20, 0)
	$FiscNL = GUICtrlCreateLabel('Fiscal number:', 190, 5, 80, 20)
	$FiscNI = GUICtrlCreateInput('', 190, 20, 80, 20)
	$SetFiscNB = GUICtrlCreateButton('Set', 235, 45, 35, 20, 0)
	$FiscRefreshB = GUICtrlCreateButton('Refresh', 310, 20, 50, 20)
	$RefiscChB = GUICtrlCreateCheckbox('RE', 275, 45, 36, 20)
	$FiscalizeB = GUICtrlCreateButton('Fiscalize', 310, 45, 50, 20)
	$startAdrL = GUICtrlCreateLabel('start adr:', 10, 65, 50, 20)
	$endAdrL = GUICtrlCreateLabel('end adr:', 70, 65, 50, 20)
	$startAdrI = GUICtrlCreateInput('', 10, 80, 50, 20)
	$endAdrI = GUICtrlCreateInput('', 70, 80, 50, 20)
	$TaxRateAChB = GUICtrlCreateCheckbox('A ', 130, 65, 35, 15)
	$TaxRateAI = GUICtrlCreateInput('', 130, 80, 35, 20)
	$TaxRateBChB = GUICtrlCreateCheckbox('� ', 175, 65, 35, 15)
	$TaxRateBI = GUICtrlCreateInput('', 175, 80, 35, 20)
	$TaxRateVChB = GUICtrlCreateCheckbox('� ', 220, 65, 35, 15)
	$TaxRateVI = GUICtrlCreateInput('', 220, 80, 35, 20)
	$TaxRateGChB = GUICtrlCreateCheckbox('� ', 265, 65, 35, 15)
	$TaxRateGI = GUICtrlCreateInput('', 265, 80, 35, 20)
	$SetTaxRatesB = GUICtrlCreateButton('Set taxes', 310, 80, 50, 20)
	$bdL = GUICtrlCreateLabel('byte done:', 10, 105, 50, 20)
	$allBytesL = GUICtrlCreateLabel('byte total:', 70, 105, 50, 20)
	$percL = GUICtrlCreateLabel('% done:', 130, 105, 50, 20)
	$EldL = GUICtrlCreateLabel('elpsd time:', 190, 105, 50, 20)
	$LeftL = GUICtrlCreateLabel('time left:', 250, 105, 50, 20)
	$curBPSL = GUICtrlCreateLabel('avrg bps:', 310, 105, 50, 20)
	$bdI = GUICtrlCreateInput('', 10, 120, 50, 20)
	$allBytesI = GUICtrlCreateInput('', 70, 120, 50, 20)
	$percI = GUICtrlCreateInput('', 130, 120, 50, 20)
	$EldI = GUICtrlCreateInput('', 190, 120, 50, 20)
	$LeftI = GUICtrlCreateInput('', 250, 120, 50, 20)
	$curBPSI = GUICtrlCreateInput('', 310, 120, 50, 20)
	$readFlashB = GUICtrlCreateButton('Read', 10, 150, 50, 20)
	$stopReadFlashB = GUICtrlCreateButton('Stop', 10, 180, 50, 20)
	$writeFlashB = GUICtrlCreateButton('Write', 70, 150, 50, 20)
	$eraseFlashB = GUICtrlCreateButton('Erase', 70, 180, 50, 20)
	$getStatusB = GUICtrlCreateButton('Status', 10, 210, 50, 20)
	$setVerB = GUICtrlCreateButton('Set ver', 70, 210, 50, 20)
	$cleanNsetB = GUICtrlCreateButton('Clean+Set', 70, 240, 50, 20)
	GUICtrlSetFont(-1, 7)
	$HFreadNsaveB = GUICtrlCreateButton('ReadSave', 130, 150, 50, 20)
	GUICtrlSetFont(-1, 7)
	$HFopenNwriteB = GUICtrlCreateButton('OpenWrite', 130, 180, 50, 20)
	GUICtrlSetFont(-1, 7)
	$HFeditB = GUICtrlCreateButton('Edit HF', 130, 210, 50, 20)
	$timeDT = GUICtrlCreateDate('', 190, 150, 110, 20, $DTS_UPDOWN)
	$timeSetB = GUICtrlCreateButton('Set', 190, 180, 50, 20)
	$timeGetB = GUICtrlCreateButton('Get', 250, 180, 50, 20)
	$timePCgetB = GUICtrlCreateButton('<<', 310, 150, 20, 20)
	$periodsDT = GUICtrlCreateDate('', 190, 210, 110, 20, $DTS_UPDOWN)
	$periodfDT = GUICtrlCreateDate('', 190, 240, 110, 20, $DTS_UPDOWN)
	$periodsI = GUICtrlCreateInput('', 190, 210, 110, 20)
	$periodfI = GUICtrlCreateInput('', 190, 240, 110, 20)
	$periodFormDateCB = GUICtrlCreateRadio('date', 190, 260, 50, 20)
	$periodFormNumCB = GUICtrlCreateRadio('num', 250, 260, 50, 20)
	$PRmakeB = GUICtrlCreateButton('PR', 310, 210, 50, 20)
	$PRsingleChB = GUICtrlCreateCheckbox('Single', 310, 240, 50, 20)
	$PortN = GUICtrlCreateCombo('', 10, 330, 70, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$PortSpeed = GUICtrlCreateCombo('', 90, 330, 70, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$PortConB = GUICtrlCreateButton('Connect', 170, 330, 60, 20)
	$serviceChB = GUICtrlCreateCheckbox('Service', 240, 330, 60, 20)
	$PrintDiagB = GUICtrlCreateButton('Diag', 310, 330, 50, 20)
	#endregion GUICtrlCreate
	#region _CtrlListAdd
	_CtrlListAdd($SetFactNB)
	_CtrlListAdd($SetVatNB)
	_CtrlListAdd($SetFiscNB)
	_CtrlListAdd($FiscRefreshB)
	_CtrlListAdd($FiscalizeB)
	_CtrlListAdd($RefiscChB)
	_CtrlListAdd($readFlashB)
	_CtrlListAdd($stopReadFlashB)
	_CtrlListAdd($writeFlashB)
	_CtrlListAdd($eraseFlashB)
	_CtrlListAdd($setVerB)
	_CtrlListAdd($cleanNsetB)
	_CtrlListAdd($HFreadNsaveB)
	_CtrlListAdd($HFopenNwriteB)
	_CtrlListAdd($HFeditB)
	_CtrlListAdd($startAdrI)
	_CtrlListAdd($endAdrI)
	_CtrlListAdd($TaxRateAChB)
	_CtrlListAdd($TaxRateAI)
	_CtrlListAdd($TaxRateBChB)
	_CtrlListAdd($TaxRateBI)
	_CtrlListAdd($TaxRateVChB)
	_CtrlListAdd($TaxRateVI)
	_CtrlListAdd($TaxRateGChB)
	_CtrlListAdd($TaxRateGI)
	_CtrlListAdd($SetTaxRatesB)
	_CtrlListAdd($allBytesI)
	_CtrlListAdd($timeDT)
	_CtrlListAdd($timeSetB)
	_CtrlListAdd($timeGetB)
	_CtrlListAdd($timePCgetB)
	_CtrlListAdd($periodFormDateCB)
	_CtrlListAdd($periodFormNumCB)
	_CtrlListAdd($periodsDT)
	_CtrlListAdd($periodfDT)
	_CtrlListAdd($periodsI)
	_CtrlListAdd($periodfI)
	_CtrlListAdd($PRsingleChB)
	_CtrlListAdd($PRmakeB)
	_CtrlListAdd($PortConB)
	_CtrlListAdd($PrintDiagB)
	#endregion _CtrlListAdd
	#region GUICtrlSetData
	$s = _CommListPorts(1)
	$s1 = _StringExplode($s, '|')
	GUICtrlSetData($PortN, $s, $s1[0])
	GUICtrlSetData($PortSpeed, '9600|19200|57600|115200', '19200')
	GUICtrlSetData($startAdrI, $startAdr)
	GUICtrlSetData($endAdrI, $endAdr)
	GUICtrlSetData($allBytesI, $allBytes)
	GUICtrlSetData($periodsI, $PRnumS)
	GUICtrlSetData($periodfI, $PRnumF)
	#endregion GUICtrlSetData
	#region GUICtrlSetStyle
	GUICtrlSetStyle($VatNI, $ES_NUMBER)
	GUICtrlSetStyle($FiscNI, $ES_NUMBER)
	GUICtrlSetStyle($startAdrI, $ES_NUMBER)
	GUICtrlSetStyle($endAdrI, $ES_NUMBER)
	GUICtrlSetStyle($bdI, $ES_NUMBER)
	GUICtrlSetStyle($allBytesI, $ES_NUMBER)
	GUICtrlSetStyle($percI, $ES_NUMBER)
	GUICtrlSetStyle($curBPSI, $ES_NUMBER)
	#endregion GUICtrlSetStyle
	#region GUICtrlSendMsg
	GUICtrlSendMsg($timeDT, $DTM_SETFORMAT_, 0, $DTstyle)
	GUICtrlSendMsg($periodsDT, $DTM_SETFORMAT_, 0, $DTstyleDate)
	GUICtrlSendMsg($periodfDT, $DTM_SETFORMAT_, 0, $DTstyleDate)
	#endregion GUICtrlSendMsg
	_AllCtrlDisable()
	#region GUICtrlSetState
	GUICtrlSetState($PortConB, $GUI_ENABLE)
	GUICtrlSetState($bdI, $GUI_DISABLE)
	GUICtrlSetState($percI, $GUI_DISABLE)
	GUICtrlSetState($EldI, $GUI_DISABLE)
	GUICtrlSetState($LeftI, $GUI_DISABLE)
	GUICtrlSetState($curBPSI, $GUI_DISABLE)
	GUICtrlSetState($periodFormDateCB, $GUI_CHECKED)
	#endregion GUICtrlSetState
	#region _ServiceListAdd
	_ServiceListAdd($writeFlashB)
	_ServiceListAdd($eraseFlashB)
	_ServiceListAdd($cleanNsetB)
	_ServiceListAdd($setVerB)
	_ServiceListAdd($SetFactNB)
	#endregion _ServiceListAdd
	_ServiceDisable()
	_PRmodeSet(0)
	GUISetState()
	GUICtrlSetState($PortConB, $GUI_FOCUS)
	#endregion $_main
	Return 0
EndFunc   ;==>_GUIprepair
Func _HFedit()
	_FlagOn($FLAG_HF_EDIT)
	GUISetState(@SW_DISABLE)
	GUISwitch($_hf)
	GUISetState(@SW_SHOW)
	Do
		_checkGUImsg()
	Until _Flag($FLAG_HF_EXIT)
	_FlagOff($FLAG_HF_EXIT)
	GUISetState(@SW_HIDE)
	GUISwitch($_main)
	GUISetState(@SW_HIDE)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_ENABLE)
	_FlagOff($FLAG_HF_EDIT)
EndFunc   ;==>_HFedit
Func _HFeditRefresh()
	Local $s, $cr
	_FlagOn($FLAG_HF_EDIT_REFRESH)
	$s = ''
	$cr = @CRLF
	For $i = 0 To 7
		If $i = 7 Then $cr = ''
		$s &= $HFstr[$i] & $cr
	Next
	_FlagOff($FLAG_HF_EDIT_REFRESH)
	GUICtrlSetData($HFeditE, $s)
	Return $s
EndFunc   ;==>_HFeditRefresh
Func _HFeditStore()
	Local $res, $s
	_FlagOn($FLAG_HF_EDIT_STORE)
	$res = GUICtrlRead($HFeditE)
	$s = StringSplit($res, @CRLF, 1)
	;_ArrayDisplay($s)
	For $i = 0 To 7
		If Int($s[0]) > $i Then
			$HFstr[$i] = $s[$i + 1]
		Else
			$HFstr[$i] = ''
		EndIf
	Next
	_FlagOff($FLAG_HF_EDIT_STORE)
	Return $s
EndFunc   ;==>_HFeditStore
Func _HFopen($mainHndl)
	Local $errStatus, $retVal, $k, $ss, $snum
	GUISetState(@SW_DISABLE, $mainHndl)
	Local $filename = FileOpenDialog('Open header/footer as', '', 'Binary (*.FPH)|Text (*.txt)|All (*.*)')
	$errStatus = @error
	GUISetState(@SW_ENABLE, $mainHndl)
	GUISetState(@SW_HIDE, $mainHndl)
	GUISetState(@SW_SHOW, $mainHndl)
	If $errStatus Then
		_DLog('_HFopen(): file not selected' & @CRLF)
		Return 1
	EndIf
	If StringRight($filename, 4) <> '.FPH' And StringRight($filename, 4) <> '.txt' Then
		$filename &= '.FPH'
	EndIf
	_DLog('_HFopen(): $filename = ' & $filename & @CRLF)
	Local $file = FileOpen($filename)
	If $file = -1 Then
		_DLog('_HFopen(): FileOpen() error' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_HF_OPEN)
	$retVal = 0
	$k = 0
	Dim $HFs[8]
	For $i = 0 To 7
		$HFs[$i] = ''
	Next
	Do
		$ss = FileReadLine($file)
		If @error = -1 Then ExitLoop
		If $ss = '' Then ContinueLoop
		$snum = StringLeft($ss, 1)
		If $snum < 0 Or $snum > 7 Or StringMid($ss, 2, 1) <> ',' Then
			_DLog('_HFopen(): Syntax error' & @CRLF)
			$retVal = 1
			ExitLoop
		EndIf
		$HFs[$snum] = StringTrimLeft($ss, 2)
		$k += 1
		If $k > 7 Then
			_DLog('_HFopen(): Max line number reached' & @CRLF)
			ExitLoop
		EndIf
	Until 0
	FileClose($file)
	If $retVal = 0 Then
		$HFstr = $HFs
		_HFeditRefresh()
	EndIf
	_FlagOff($FLAG_HF_OPEN)
	Return $retVal
EndFunc   ;==>_HFopen
Func _HFread()
	Local $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_HFread(): No response from printer' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_HF_READ)
	$retVal = 0
	Dim $HFs[8]
	For $k = 0 To 7
		$dd = 'I' & $k
		$failTry = 0
		Do
			$seq = _incSeq($seq)
			$res = _SendCMD(43, $dd, $seq)
			$rrRaw = _ReceiveAll()
			$rr = _Validate($rrRaw)
			$data = _GetData(_GetBody($rr))
			;_DLog('$seq=' & $seq & ' $data=' & $data & @CRLF)
			If $rr = '' Then $failTry += 1
		Until $rr <> '' Or $failTry > $maxFailTry
		If $failTry > $maxFailTry Then
			_DLog('_HFread(): No response while reading data' & @CRLF)
			$retVal = 1
			ExitLoop
		EndIf
		$HFs[$k] = $data
	Next
	If $retVal = 0 Then
		$HFstr = $HFs
		_HFeditRefresh()
	EndIf
	_FlagOff($FLAG_HF_READ)
	Return $retVal
EndFunc   ;==>_HFread
Func _HFsave($mainHndl)
	Local $errStatus, $retVal, $res, $filename
	GUISetState(@SW_DISABLE, $mainHndl)
	$filename = FileSaveDialog('Save header/footer as', '', 'Binary (*.FPH)|Text (*.txt)|All (*.*)', 16, StringRight($FactN, 7))
	$errStatus = @error
	GUISetState(@SW_ENABLE, $mainHndl)
	GUISetState(@SW_HIDE, $mainHndl)
	GUISetState(@SW_SHOW, $mainHndl)
	If $errStatus Then
		_DLog('_HFsave(): file not selected' & @CRLF)
		Return 1
	EndIf
	If StringRight($filename, 4) <> '.FPH' And StringRight($filename, 4) <> '.txt' Then
		$filename &= '.FPH'
	EndIf
	_DLog('_HFsave(): $filename = ' & $filename & @CRLF)
	Local $file = FileOpen($filename, 2)
	If $file = -1 Then
		_DLog('_HFsave(): FileOpen()' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_HF_SAVE)
	_HFeditStore()
	$retVal = 0
	For $k = 0 To 7
		$res = FileWriteLine($file, $k & ',' & $HFstr[$k])
		If $res = 0 Then
			$retVal = 2
			_DLog('_HFsave(): FileWriteLine()' & @CRLF)
			ExitLoop
		EndIf
	Next
	FileClose($file)
	_FlagOff($FLAG_HF_SAVE)
	Return $retVal
EndFunc   ;==>_HFsave
Func _HFwrite()
	Local $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_HFwrite(): No response from printer' & @CRLF)
		Return 1
	EndIf
	Local $beg = TimerInit()
	_FlagOn($FLAG_HF_WRITE)
	_HFeditStore()
	$retVal = 0
	For $i = 0 To 7
		$dd = $i & $HFstr[$i]
		_DLog('_HFwrite(): dd = ' & $dd & @CRLF)
		$failTry = 0
		Do
			$seq = _incSeq($seq)
			$res = _SendCMD(43, $dd, $seq)
			$rrRaw = _ReceiveAll()
			$rr = _Validate($rrRaw)
			$data = _GetData(_GetBody($rr))
			_DLog('_HFwrite(): data = ' & $data & @CRLF)
			If $rr = '' Then $failTry += 1
		Until $rr <> '' Or $failTry > $maxFailTry
		If $failTry > $maxFailTry Then
			_DLog('_HFwrite(): No response while writing data' & @CRLF)
			$retVal = 1
			ExitLoop
		EndIf
	Next
	_FlagOff($FLAG_HF_WRITE)
	Return $retVal
EndFunc   ;==>_HFwrite
Func _incSeq($i)
	$i += 1
	If $i > 95 Then $i = 0
	Return $i
EndFunc   ;==>_incSeq
Func _Info($s, $mainHndl)
	Local $r, $res
	GUISetState(@SW_DISABLE, $mainHndl)
	$r = MsgBox(4096 + 48, 'Info', $s)
	_DLog('_Info(): $r=' & $r & @CRLF)
	$res = 0
	If $r = 6 Then $res = 1
	GUISetState(@SW_ENABLE, $mainHndl)
	GUISetState(@SW_HIDE, $mainHndl)
	GUISetState(@SW_SHOW, $mainHndl)
	Return $res
EndFunc   ;==>_Info
Func _PCtimeGet()
	Local $data
	_FlagOn($FLAG_TIME_GET_PC)
	$data = @YEAR & '/' & @MON & '/' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	GUICtrlSetData($timeDT, $data)
	_FlagOff($FLAG_TIME_GET_PC)
	Return 0
EndFunc   ;==>_PCtimeGet
Func _Port()
	Local $p, $sp, $err, $i
	If $portState Then
		_ClosePort()
		_AllCtrlDisable()
		GUICtrlSetData($PortConB, $CONNECT_B_T)
		GUICtrlSetState($PortConB, $GUI_ENABLE)
		GUICtrlSetState($PortSpeed, $GUI_ENABLE)
		GUICtrlSetState($PortN, $GUI_ENABLE)
		$portState = 0
	Else
		$p = StringTrimLeft(GUICtrlRead($PortN), 3)
		$sp = GUICtrlRead($PortSpeed)
		$err = _OpenPort($p, $sp)
		If $err Then
			_DLog('_Port(): OpenPort() ' & $err & @CRLF)
			Return 1
		EndIf
		$i = _GetFiscInfo()
		If $i Then
			_DLog('_Port(): _GetFiscInfo() = ' & $i & @CRLF)
			Return 1
		EndIf
		_AllCtrlEnable()
		GUICtrlSetData($PortConB, $CONNECT_B_T2)
		GUICtrlSetState($PortSpeed, $GUI_DISABLE)
		GUICtrlSetState($PortN, $GUI_DISABLE)
		$portState = 1
	EndIf
	Return 0
EndFunc   ;==>_Port
Func _PrintDiag()
	Local $retVal, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_PrintDiag(): No response from printer' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_PRINT_DIAG, 1)
	$retVal = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(71, '', $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_PrintDiag(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_PRINT_DIAG, 1)
	Return $retVal
EndFunc
Func _PRmakeDate()
	Local $retVal, $ds, $df, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_PRmakeDate(): No response from printer' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_PR_MAKE_DATE, 1)
	$retVal = 0
	$ds = GUICtrlRead($periodsDT)
	$df = GUICtrlRead($periodfDT)
	$dd = '0000,' & StringReplace(StringLeft($ds, 8), '-', '') & ',' & StringReplace(StringLeft($df, 8), '-', '')
	_DLog('_PRmakeDate(): $dd = ' & $dd & @CRLF)
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(79, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_PRmakeDate(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_PR_MAKE_DATE, 1)
	Return $retVal
EndFunc   ;==>_PRmakeDate
Func _PRmakeNum()
	Local $retVal, $ds, $df, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_PRmakeNum(): No response from printer' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_PR_MAKE_NUM, 1)
	$retVal = 0
	$ds = GUICtrlRead($periodsI)
	$df = GUICtrlRead($periodfI)
	$dd = '0000,' & $ds & ',' & $df
	_DLog('_PRmakeNum(): $dd = ' & $dd & @CRLF)
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(95, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_PRmakeNum(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_PR_MAKE_NUM, 1)
	Return $retVal
EndFunc   ;==>_PRmakeNum
Func _PRmodeGet()
	Return _Flag($FLAG_PERIOD_MODE)
EndFunc   ;==>_PRmodeGet
Func _PRmodeSet($m)
	_FlagOn($FLAG_PERIOD_MODE_FUNC, 1)
	If $m Then
		GUICtrlSetState($periodsI, $GUI_SHOW)
		GUICtrlSetState($periodfI, $GUI_SHOW)
		GUICtrlSetState($periodsDT, $GUI_HIDE)
		GUICtrlSetState($periodfDT, $GUI_HIDE)
		_FlagOn($FLAG_PERIOD_MODE)
	Else
		GUICtrlSetState($periodsDT, $GUI_SHOW)
		GUICtrlSetState($periodfDT, $GUI_SHOW)
		GUICtrlSetState($periodsI, $GUI_HIDE)
		GUICtrlSetState($periodfI, $GUI_HIDE)
		_FlagOff($FLAG_PERIOD_MODE)
	EndIf
	_FlagOff($FLAG_PERIOD_MODE_FUNC, 1)
EndFunc   ;==>_PRmodeSet
Func _PRsingleModeGet()
	Return _Flag($FLAG_PR_SINGLE_MODE, 1)
EndFunc   ;==>_PRsingleModeGet
Func _PRsingleModeSet($m)
	_FlagOn($FLAG_PR_SINGLE_MODE_FUNC, 1)
	If $m Then
		GUICtrlSetData($periodfI, $PRnumS)
		;GUICtrlSetData($periodfDT, $)
		GUICtrlSetState($periodfI, $GUI_DISABLE)
		GUICtrlSetState($periodfDT, $GUI_DISABLE)
		_FlagOn($FLAG_PR_SINGLE_MODE, 1)
	Else
		GUICtrlSetState($periodfI, $GUI_ENABLE)
		GUICtrlSetState($periodfDT, $GUI_ENABLE)
		_FlagOff($FLAG_PR_SINGLE_MODE, 1)
	EndIf
	_FlagOff($FLAG_PR_SINGLE_MODE_FUNC, 1)
EndFunc   ;==>_PRsingleModeSet
Func _ServiceDisable()
	_FlagOn($FLAG_SERVICE_DISABLED, 1)
	_FlagOff($FLAG_SERVICE)
	For $i = 1 To $SLmax
		GUICtrlSetState($serviceList[$i - 1], $GUI_HIDE)
	Next
	_FlagOff($FLAG_SERVICE_DISABLED, 1)
EndFunc   ;==>_ServiceDisable
Func _ServiceEnable()
	_FlagOn($FLAG_SERVICE_ENABLED, 1)
	_FlagOn($FLAG_SERVICE)
	For $i = 1 To $SLmax
		GUICtrlSetState($serviceList[$i - 1], $GUI_SHOW)
	Next
	_FlagOff($FLAG_SERVICE_ENABLED, 1)
EndFunc   ;==>_ServiceEnable
Func _ServiceInput($mainHndl)
	Local $pas, $res
	_FlagOn($FLAG_SERVICE_INPUT, 1)
	GUISetState(@SW_DISABLE, $mainHndl)
	$pas = InputBox('Service mode', 'Enter service password', '', '#', 160, 110)
	$res = 0
	If $pas <> '75296' Then $res = 1
	GUISetState(@SW_ENABLE, $mainHndl)
	GUISetState(@SW_HIDE, $mainHndl)
	GUISetState(@SW_SHOW, $mainHndl)
	Return $res
	_FlagOff($FLAG_SERVICE_INPUT, 1)
EndFunc   ;==>_ServiceInput
Func _ServiceListAdd($h)
	If $SLmax < $MAX_SL Then
		$serviceList[$SLmax] = $h
		$SLmax += 1
	EndIf
EndFunc   ;==>_ServiceListAdd
Func _SetFactN($mainHndl)
	Local $i, $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_SetFactN(): No response from printer' & @CRLF)
		Return 1
	EndIf
	$i = GUICtrlRead($FactNI)
	If StringLen($i) <> 10 Or Not StringIsDigit(StringRight($i, 8)) Then
		_DLog('_SetFactN(): Not valid factory number ' & $i & @CRLF)
		_Info('Error factory number', $mainHndl)
		Return 1
	EndIf
	_FlagOn($FLAG_FISC_SET_FACT_N)
	$retVal = 0
	$dd = '2,' & $i
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(91, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_SetFactN(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	If $data = 'P' Then _DLog('_SetFactN(): OK' & @CRLF)
	If $data = 'F' Then
		_DLog('_SetFactN(): Failure' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_FISC_SET_FACT_N)
	Return $retVal
EndFunc   ;==>_SetFactN
Func _SetFiscN($mainHndl)
	Local $i, $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_SetFiscN(): No response from printer' & @CRLF)
		Return 1
	EndIf
	$i = GUICtrlRead($FiscNI)
	If StringLen($i) <> 10 Or Not StringIsDigit($i) Then
		_DLog('_SetFiscN(): Not valid fiscal number ' & $i & @CRLF)
		_Info('Error fisc number', $mainHndl)
		Return 1
	EndIf
	_FlagOn($FLAG_FISC_SET_FISC_N)
	$retVal = 0
	$dd = $i
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(92, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_SetFiscN(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	If $data = 'P' Then _DLog('_SetFiscN(): OK' & @CRLF)
	If $data = 'F' Then
		_DLog('_SetFiscN(): Failure' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_FISC_SET_FISC_N)
	Return $retVal
EndFunc   ;==>_SetFiscN
Func _SetTaxRates($mainHndl)
	Local $iA, $iB, $iV, $iG, $retVal, $jA, $jB, $jV, $jG, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_SetTaxRates(): No response from printer' & @CRLF)
		Return 1
	EndIf
	$iA = GUICtrlRead($TaxRateAI)
	$iB = GUICtrlRead($TaxRateBI)
	$iV = GUICtrlRead($TaxRateVI)
	$iG = GUICtrlRead($TaxRateGI)
	_DLog('$A=' & $iA & ' $B=' & $iB & ' $V=' & $iV & ' $G=' & $iG & @CRLF)
	If $iA < 0 Or $iA > 99.99 Or _
			$iB < 0 Or $iB > 99.99 Or _
			$iV < 0 Or $iV > 99.99 Or _
			$iG < 0 Or $iG > 99.99 Then
		_DLog('_SetTaxRates(): Not valid tax rate number' & @CRLF)
		_Info('Error tax rate number', $mainHndl)
		Return 1
	EndIf
	_FlagOn($FLAG_FISC_SET_TAX)
	$retVal = 0
	$jA = 0
	$jB = 0
	$jV = 0
	$jG = 0
	If GUICtrlRead($TaxRateAChB) = $GUI_CHECKED Then $jA = 1
	If GUICtrlRead($TaxRateBChB) = $GUI_CHECKED Then $jB = 1
	If GUICtrlRead($TaxRateVChB) = $GUI_CHECKED Then $jV = 1
	If GUICtrlRead($TaxRateGChB) = $GUI_CHECKED Then $jG = 1
	$dd = '0000,2,' & $jA & $jB & $jV & $jG & ',' & $iA & ',' & $iB & ',' & $iV & ',' & $iG
	_DLog('dd=' & $dd & @CRLF)
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(83, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_SetTaxRates(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	_DLog('$data=' & $data & @CRLF)
	_FlagOff($FLAG_FISC_SET_TAX)
	Return $retVal
EndFunc   ;==>_SetTaxRates
Func _SetVatN($mainHndl)
	Local $i, $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_SetVatN(): No response from printer' & @CRLF)
		Return 1
	EndIf
	$i = GUICtrlRead($VatNI)
	If StringLen($i) <> 12 Then
		_DLog('_SetVatN(): Not valid VAT number ' & $i & @CRLF)
		_Info('Error number', $mainHndl)
		Return 1
	EndIf
	_FlagOn($FLAG_FISC_SET_FISC_N)
	$retVal = 0
	$dd = $i & ',0'
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(98, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_SetVatN(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	If $data = 'P' Then _DLog('_SetVatN(): OK' & @CRLF)
	If $data = 'F' Then
		_DLog('_SetVatN(): Failure' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_FISC_SET_FISC_N)
	Return $retVal
EndFunc   ;==>_SetVatN
Func _SetVer()
	Local $retVal, $dd, $failTry, $res, $rrRaw, $rr, $data
	If _TestConnect() = '' Then
		_DLog('_SetVer(): No response from printer' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_FISC_SET_VER)
	$retVal = 0
	$dd = ''
	$failTry = 0
	Do
		$seq = _incSeq($seq)
		$res = _SendCMD(131, $dd, $seq)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('_SetVer(): No response while reading data' & @CRLF)
		$retVal = 1
	EndIf
	If $data = 'P' Then _DLog('_SetVer(): OK' & @CRLF)
	If $data = 'F' Then
		_DLog('_SetVer(): Failure' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_FISC_SET_VER)
	Return $retVal
EndFunc   ;==>_SetVer
Func _StartMainLoop()
	Local $loopTimer, $oldTime, $Time
	$loopTimer = TimerInit()
	$oldTime = 0
	While Not _Flag($FLAG_EXIT_GUI)
		_checkGUImsg()
		$Time = TimerDiff($loopTimer)
		If Int($Time / 500) <> $oldTime Then
			$oldTime = Int($Time / 500)
			_CheckRange()
			If Not $portState Then _PCtimeGet()
		EndIf
	WEnd
	Return 0
EndFunc   ;==>_StartMainLoop
Func _TestConnect()
	Local $res, $rrRaw, $rr, $data
	$res = _SendCMD(74, 'W', $seq)
	$rrRaw = _ReceiveAll()
	$rr = _Validate($rrRaw)
	$data = _GetData(_GetBody($rr))
	If StringLen($data) = 6 Then $statusBytes = $data
	Return $data
EndFunc   ;==>_TestConnect
Func _Warn($s, $mainHndl)
	Local $r, $res
	GUISetState(@SW_DISABLE, $mainHndl)
	$r = MsgBox(4096 + 256 + 16 + 4, 'Warning!', $s)
	_DLog('_Warn(): $r=' & $r & @CRLF)
	$res = 0
	If $r = 6 Then $res = 1
	GUISetState(@SW_ENABLE, $mainHndl)
	GUISetState(@SW_HIDE, $mainHndl)
	GUISetState(@SW_SHOW, $mainHndl)
	Return $res
EndFunc   ;==>_Warn