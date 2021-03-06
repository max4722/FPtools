#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=bin\FPtools.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#Tidy_Parameters=/sfc
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include '3530Ser.au3'
#include 'Const.au3'
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

Dim $guiState[8] = [0, 0, 0, 0, 0, 0, 0, 0]
Global $FactNI, $FiscNI, $VatNI
Global $_main, $_stat, $_hf, $_misc
Global $readFlashB, $writeFlashB, $stopReadFlashB, $eraseFlashB, $setVerB, $cleanNsetB, $HFreadNsaveB, $HFopenNwriteB, $PortN, $PortConB, $PortSpeed
Global $startAdrI, $endAdrI, $TaxRateAI, $TaxRateBI, $TaxRateVI, $TaxRateGI, $bdI, $allBytesI, $percI, $EldI, $LeftI, $curBPSI
Global $SetFactNB, $SetVatNB, $SetFiscNB, $TaxRateAChB, $TaxRateBChB, $TaxRateVChB, $TaxRateGChB, $FiscRefreshB, $FiscalizeB, $SetTaxRatesB
Global $timeDT, $timeSetB, $timeGetB, $timePCgetB, $getStatusB, $textE, $HFeditE, $HFeditB, $HFopenB, $HFsaveB, $HFreadB, $HFwriteB
Global $serviceChB, $RefiscChB, $periodfDT, $periodsDT, $periodfI, $periodsI, $periodFormNumCB, $periodFormDateCB, $PRmakeB, $PRsingleChB
Global $FactNL, $VatNL, $FiscNL, $startAdrL, $endAdrL, $bdL, $allBytesL, $percL, $EldL, $LeftL, $curBPSL, $PrintDiagB, $PrintXB, $PrintZB
Global $HFPrintDiagB, $PrintCutB, $FPmodel, $CashInB, $CashOutB, $CashInI, $CashOutI, $MiscOpenB, $MiscSaveB, $MiscEditE, $MiscB
Global $timeAutoUpdateModeChB, $MiscStopB, $VatModeChB, $LogoEnableB, $LogoDisableB, $FPpasswordI, $sellB, $_sell, $fiscOpenB, $fiscTotalB
Global $fiscCloseB, $CashDriverB, $CashDriverI
Global $DTstyle = 'dd-MM-yy HH:mm:ss'
Global $DTstyleDate = 'dd-MM-yy'
Global $portState = 0
Global $startAdr = $START_ADDR_DEFAULT
Global $endAdr = $END_ADDR_DEFAULT
Global $blockSize = $BLOCK_SIZE_DEFAULT
Global $maxFFcounter = 5
Global $allBytes = $ALL_BYTES_DEFAULT
Global $maxFailTry = 10
Global $SLmax = 0, $CLmax = 0
Global $PRnumS = $PR_NUM_S_DEFAULT
Global $PRnumF = $PR_NUM_F_DEFAULT
Global $FactN, $FiscN, $VatN, $TaxRateA, $TaxRateB, $TaxRateV, $TaxRateG, $FPmodelMode, $CashIn, $CashOut
Global $timeAutoUpdateMode = 0
Global $statusBytes
Global $FPpassword = '0000'
Global $FlagDebug = 0
Dim $HFstr[8]
Dim $serviceList[$MAX_SL], $CtrlList[$MAX_CL]
Dim $FPModelStrM[$FP_MODEL_MODE_MAX + 1] = ['FP3530T', 'Ekselio']
Dim $RepMas[$MAX_REP]
#endregion ConstsVars
_GUIprepair()
_StartMainLoop()
_GUIdel()

Func _AllCtrlDisable()
	_FlagOn($FLAG_ALLCTRL_DISABLE)
	_FlagOff($FLAG_ALLCTRL)
	For $i = 1 To $CLmax
		GUICtrlSetState($CtrlList[$i - 1], $GUI_DISABLE)
	Next
	_FlagOff($FLAG_ALLCTRL_DISABLE)
EndFunc   ;==>_AllCtrlDisable
Func _AllCtrlEnable()
	_FlagOn($FLAG_ALLCTRL_ENABLE)
	_FlagOn($FLAG_ALLCTRL)
	For $i = 1 To $CLmax
		GUICtrlSetState($CtrlList[$i - 1], $GUI_ENABLE)
	Next
	_FlagOff($FLAG_ALLCTRL_ENABLE)
EndFunc   ;==>_AllCtrlEnable
Func _CashDriverOpen()
	Local $retVal, $dd, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_CASH_DRIVER_OPEN)
	$dd = GUICtrlRead($CashDriverI)
	$retVal = _SendCMDwRet(106, $dd, $data)
	GUICtrlSetData($CashDriverI, '')
	_FlagOff($FLAG_CASH_DRIVER_OPEN)
	Return $retVal
EndFunc
Func _CashIn()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_CASH_IN)
	$retVal = _SendCMDwRet(70, $CashIn, $data)
	_FlagOff($FLAG_CASH_IN)
	Return $retVal
EndFunc   ;==>_CashIn
Func _CashOut()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_CASH_OUT)
	$retVal = _SendCMDwRet(70, -$CashOut, $data)
	_FlagOff($FLAG_CASH_OUT)
	Return $retVal
EndFunc   ;==>_CashOut
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
				$retVal = _GetFiscInfo()
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
			Case $m = $PrintXB
				$retVal = _PrintX()
			Case $m = $PrintZB
				$retVal = _PrintZ()
			Case $m = $PrintCutB
				$retVal = _PrintCut()
			Case $m = $CashInB
				$retVal = _CashIn()
			Case $m = $CashOutB
				$retVal = _CashOut()
			Case $m = $MiscB
				_MiscEdit()
			Case $m = $timeAutoUpdateModeChB
				_DLog('_checkGUImsg(): _TimeAutoUpdateModeGet() = ' & _TimeAutoUpdateModeGet() & @CRLF)
				If _TimeAutoUpdateModeGet() = 0 And GUICtrlRead($m) = $GUI_CHECKED Then
					_TimeAutoUpdateModeSet(1)
					_DLog('_checkGUImsg(): _TimeAutoUpdateModeGet() = ' & _TimeAutoUpdateModeGet() & @CRLF)
				ElseIf _TimeAutoUpdateModeGet() And GUICtrlRead($m) = $GUI_UNCHECKED Then
					_TimeAutoUpdateModeSet(0)
				EndIf
			Case $m = $sellB
				_SellTools()
			Case $m = $CashDriverB
				_CashDriverOpen()
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
			Case $m = $HFopenB
				$res = _HFopen($h)
				If $res Then
				EndIf
			Case $m = $HFsaveB
				$res = _HFsave($h)
				If $res Then
				EndIf
			Case $m = $HFreadB
				$res = _HFread()
				If $res Then
				EndIf
			Case $m = $HFwriteB
				$res = _HFwrite()
				If $res Then
				EndIf
			Case $m = $HFPrintDiagB
				_PrintDiag()
			Case $m = $LogoEnableB
				_LogoEnable()
			Case $m = $LogoDisableB
				_LogoDisable()
		EndSelect
	ElseIf $h = $_sell Then
		Select
			Case $m = $GUI_EVENT_CLOSE
				_FlagOn($FLAG_SELL_EXIT)
			Case $m = $fiscOpenB
				$res = _FiscCheckOpen()
			Case $m = $fiscTotalB
				$res = _FiscCheckTotal()
			Case $m = $fiscCloseB
				$res = _FiscCheckClose()
		EndSelect
	ElseIf $h = $_misc Then
		Select
			Case $m = $GUI_EVENT_CLOSE
				_FlagOn($FLAG_MISC_EXIT)
			Case $m = $MiscOpenB
				_AllCtrlDisable()
				GUICtrlSetState($MiscStopB, $GUI_ENABLE)
				$res = _MiscOpen($h)
				If $res Then
					_DLog('_checkGUImsg(): _MiscOpen() = ' & $res & @CRLF)
				EndIf
				_AllCtrlEnable()
				GUICtrlSetState($MiscStopB, $GUI_DISABLE)
			Case $m = $MiscSaveB
				$res = _MiscSave($h)
				If $res Then
					_DLog('_checkGUImsg(): _MiscSave() = ' & $res & @CRLF)
				EndIf
			Case $m = $MiscStopB
				_FlagOn($FLAG_EXIT_MISC_OPEN)
				GUICtrlSetState($MiscStopB, $GUI_DISABLE)
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
	Local $i, $data
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
		$endAdr = $allBytes + $startAdr - 1
		GUICtrlSetData($endAdrI, $endAdr)
	EndIf
	$PRnumS = GUICtrlRead($periodsI)
	$i = _CheckInput($PRnumS, $PR_NUM_MIN, $PR_NUM_MAX, $PR_NUM_S_DEFAULT)
	If $i <> $PRnumS Then
		_DLog('Not correct $PRnumS, setting to default value' & @CRLF)
		$PRnumS = $i
		GUICtrlSetData($periodsI, $PRnumS)
	EndIf
	If _PRsingleModeGet() Then
		GUICtrlSetData($periodfI, $PRnumS)
		$data = GUICtrlRead($periodsDT)
		$data = '20' & StringMid($data, 7, 2) & '/' & StringMid($data, 4, 2) & '/' & StringLeft($data, 2); & StringRight($data, 9)
		GUICtrlSetData($periodfDT, $data)
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
	$CashIn = GUICtrlRead($CashInI)
	$i = _CheckInput($CashIn, $CASH_IO_MIN, $CASH_IO_MAX, $CASH_IO_DEFAULT)
	If $i <> $CashIn Then
		_DLog('Not correct $CashIn, setting to default value' & @CRLF)
		$CashIn = $i
		GUICtrlSetData($CashInI, $CashIn)
	EndIf
	$CashOut = GUICtrlRead($CashOutI)
	$i = _CheckInput($CashOut, $CASH_IO_MIN, $CASH_IO_MAX, $CASH_IO_DEFAULT)
	If $i <> $CashOut Then
		_DLog('Not correct $CashOut, setting to default value' & @CRLF)
		$CashOut = $i
		GUICtrlSetData($CashOutI, $CashOut)
	EndIf
	$FPpassword = GUICtrlRead($FPpasswordI)
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
		_DLog('$CLmax = ' & $CLmax & @CRLF)
	Else
		_DLog('$CtrlList[] max size ' & $MAX_CL & ' reached!' & @CRLF)
	EndIf
EndFunc   ;==>_CtrlListAdd
Func _Fiscalize($mainHndl)
	Local $i, $retVal, $dd, $data
	If _TestConnect() = '' Then Return 1
	$i = GUICtrlRead($FactNI)
	If StringLen($i) <> 10 Or Not StringIsDigit(StringRight($i, 8)) Then
		_DLog('_Fiscalize(): Not valid factory number ' & $i & @CRLF)
		_Info('Error factory number', $mainHndl)
		Return 1
	EndIf
	_FlagOn($FLAG_FISCALIZE)
	If GUICtrlRead($RefiscChB) = $GUI_CHECKED Then
		$dd = $FPpassword & ',' & $i & ',' & GUICtrlRead($VatNI) & ',' & _GetVatMode()
	Else
		$dd = $FPpassword & ',' & $i
	EndIf
	_DLog('_Fiscalize(): $dd = ' & $dd & @CRLF)
	$retVal = _SendCMDwRet(72, $dd, $data)
	If $data = 'P' Then _DLog('_Fiscalize(): OK' & @CRLF)
	If StringIsDigit($data) Then
		_DLog('_Fiscalize(): Failure, ' & $data & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_FISCALIZE)
	Return $retVal
EndFunc   ;==>_Fiscalize
Func _FiscCheckClose()
	Local $retVal, $data = ''
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_FISC_CHECK_CLOSE)
	$retVal = _SendCMDwRet(56, '', $data)
	_DLog('_FiscCkeckClose(): $data = ' & $data & @CRLF)
	_FlagOff($FLAG_FISC_CHECK_CLOSE)
	Return $retVal
EndFunc
Func _FiscCheckOpen()
	Local $retVal, $data = ''
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_FISC_CHECK_OPEN)
	$retVal = _SendCMDwRet(48, '1,' & $FPpassword & ',1,I', $data)
	_DLog('_FiscCkeckOpen(): $data = ' & $data & @CRLF)
	_FlagOff($FLAG_FISC_CHECK_OPEN)
	Return $retVal
EndFunc
Func _FiscCheckTotal($paid = '', $paidType = $PAID_TYPE_CASH, $txt = '')
	Local $retVal, $dd = '', $data = ''
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_FISC_CHECK_TOTAL)
	If $paid <> '' And Number($paid) <> 0 Then
		$dd = $txt & _HexToString('09') & $paidType & $paid
	EndIf
	$retVal = _SendCMDwRet(53, $dd, $data)
	_DLog('_FiscCkeckTotal(): $data = ' & $data & @CRLF)
	_FlagOff($FLAG_FISC_CHECK_TOTAL)
	Return $retVal
EndFunc
Func _Flag($f)
	Local $r, $i = 0
	$i = BitShift(BitAND($f, 0xFF000000), 6 * 4)
	$f = BitAND($f, 0x00FFFFFF)
	$r = BitAND($guiState[$i], $f)
	If $r Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_Flag
Func _FlagOff($f)
	Local $i
	If $FlagDebug Then _DLog('FlagOff(' & Hex($f, 8))
	$i = BitShift(BitAND($f, 0xFF000000), 6 * 4)
	If $FlagDebug Then _DLog('): r=' & Hex($i, 8))
	If $i < 0 Or $i > 7 Then
		_DLog('Out of range!' & @CRLF)
		Exit
	EndIf
	$f = BitAND($f, 0x00FFFFFF)
	If $FlagDebug Then _DLog(',f=' & Hex($f, 8))
	$guiState[$i] = BitAND($guiState[$i], BitNOT($f))
	If $FlagDebug Then _DLog('. [' & Hex($guiState[0], 8) & ';' & Hex($guiState[1], 8) & ';' & Hex($guiState[2], 8) & ']' & @CRLF)
EndFunc   ;==>_FlagOff
Func _FlagOn($f)
	Local $i = 0
	If $FlagDebug Then _DLog('FlagOn (' & Hex($f, 8))
	$i = BitShift(BitAND($f, 0xFF000000), 6 * 4)
	If $FlagDebug Then _DLog('): r=' & Hex($i, 8))
	If $i < 0 Or $i > 7 Then
		_DLog('Out of range!' & @CRLF)
		Exit
	EndIf
	$f = BitAND($f, 0x00FFFFFF)
	If $FlagDebug Then _DLog(',f=' & Hex($f, 8))
	$guiState[$i] = BitOR($guiState[$i], $f)
	If $FlagDebug Then _DLog('. [' & Hex($guiState[0], 8) & ';' & Hex($guiState[1], 8) & ';' & Hex($guiState[2], 8) & ']' & @CRLF)
EndFunc   ;==>_FlagOn
Func _FlashErase()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_ERASE_FLASH)
	$retVal = _SendCMDwRet(130, '', $data)
	If $data = 'P' Then _DLog('_FlashErase(): OK' & @CRLF)
	If $data = 'F' Then
		_DLog('_FlashErase(): Failure' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_ERASE_FLASH)
	Return $retVal
EndFunc   ;==>_FlashErase
Func _FlashOpenNwrite()
	Local $filename, $errStatus, $file, $beg, $oldT, $retVal, $maxk, $bs, $dd, $data, $timerD, $fileSize, $adr
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
	If _TestConnect() = '' Then Return 1
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
		$retVal = _SendCMDwRet(135, $dd, $data)
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
	Local $filename, $errStatus, $file, $FFcounter, $beg, $oldT, $retVal, $maxk, $bs, $dd, $data, $timerD, $fileSize
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
	If _TestConnect() = '' Then Return 1
	$beg = TimerInit()
	$oldT = 0
	_FlagOn($FLAG_READ_FLASH)
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
		$retVal = _SendCMDwRet(116, $dd, $data)
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
Func _FPmodelModeGet()
	Return $FPmodelMode
EndFunc   ;==>_FPmodelModeGet
Func _FPmodelModeSet($m)
	_FlagOn($FLAG_FP_MODEL_MODE_SET)
	$FPmodelMode = _CheckInput($m, $FP_MODEL_MODE_MIN, $FP_MODEL_MODE_MAX, $FP_MODEL_MODE_DEFAULT)
	_FlagOff($FLAG_FP_MODEL_MODE_SET)
EndFunc   ;==>_FPmodelModeSet
Func _FPmodelStringGetFull()
	_FlagOn($FLAG_FP_MODEL_STRING_GET_FULL)
	Local $i, $str
	$str = ''
	For $i = $FP_MODEL_MODE_MIN To $FP_MODEL_MODE_MAX
		$str = $str & $FPModelStrM[$i] & '|'
	Next
	_FlagOff($FLAG_FP_MODEL_STRING_GET_FULL)
	Return StringTrimRight($str, 1)
EndFunc   ;==>_FPmodelStringGetFull
Func _FPmodelStringGet($m)
	_FlagOn($FLAG_FP_MODEL_STRING_GET)
	Local $i
	$i = _CheckInput($m, $FP_MODEL_MODE_MIN, $FP_MODEL_MODE_MAX, $FP_MODEL_MODE_DEFAULT)
	_FlagOff($FLAG_FP_MODEL_STRING_GET)
	Return $FPModelStrM[$i]
EndFunc   ;==>_FPmodelStringGet
Func _FPtimeGet()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_TIME_GET)
	$retVal = _SendCMDwRet(62, '', $data)
	If $retVal = 0 Then
		$data = '20' & StringMid($data, 7, 2) & '/' & StringMid($data, 4, 2) & '/' & StringLeft($data, 2) & StringRight($data, 9)
		GUICtrlSetData($timeDT, $data)
	EndIf
	_FlagOff($FLAG_TIME_GET)
	Return $retVal
EndFunc   ;==>_FPtimeGet
Func _FPtimeSet()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_TIME_SET)
	$retVal = _SendCMDwRet(61, GUICtrlRead($timeDT), $data)
	_FlagOff($FLAG_TIME_SET)
	Return $retVal
EndFunc   ;==>_FPtimeSet
Func _GetFiscInfo()
	Local $retVal, $data, $i, $j, $m
	If _TestConnect() = '' Then Return 1
	Local $beg = TimerInit()
	_FlagOn($FLAG_GET_FISC_INFO)
	$retVal = _SendCMDwRet(90, '1', $data)
	If $retVal Then
		_FlagOff($FLAG_GET_FISC_INFO)
		Return $retVal
	EndIf
	$m = _FPmodelModeGet()
	Select
		Case $m = 0
			$FactN = StringLeft(StringTrimLeft($data, 36), 10)
		Case $m = 1
			$FactN = StringLeft(StringTrimLeft($data, 43), 10)
	EndSelect
	$FiscN = StringRight($data, 10)
	$retVal = _SendCMDwRet(99, '', $data)
	If $retVal Then
		_FlagOff($FLAG_GET_FISC_INFO)
		Return $retVal
	EndIf
	$VatN = StringTrimRight($data, 2)
	_SetVatMode(StringRight($data, 1))
	$retVal = _SendCMDwRet(97, '', $data)
	If $retVal Then
		_FlagOff($FLAG_GET_FISC_INFO)
		Return $retVal
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
	_DLog('$FactN=' & $FactN & ' $VatN=' & $VatN & ',' & _GetVatMode() & ' $FiscN=' & $FiscN & ' $TaxRateA=' & $TaxRateA & ' $TaxRateB=' & $TaxRateB & ' $TaxRateV=' & $TaxRateV & ' $TaxRateG=' & $TaxRateG & @CRLF)
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
Func _GetVatMode()
	Local $retVal
	If GUICtrlRead($VatModeChB) = $GUI_CHECKED Then
		$retVal = 1
	Else
		$retVal = 0
	EndIf
	Return $retVal
EndFunc   ;==>_GetVatMode
Func _GUIdel()
	_FlagOff($FLAG_EXIT_GUI)
	GUIDelete()
	Return 0
EndFunc   ;==>_GUIdel
Func _GUIprepair()
	Local $s, $s1
	Local Const $DTM_SETFORMAT_ = 0x1032
	Local Const $OFFSET_X = 600
	Local Const $OFFSET_Y = 400
	#region $_misc
	$_misc = GUICreate('Misc', 300 + $OFFSET_X, 230 + $OFFSET_Y)
	GUISwitch($_misc)
	#region GUICtrlCreate
	$MiscEditE = GUICtrlCreateEdit('', 5, 5, 290 + $OFFSET_X, 160 + $OFFSET_Y, $ES_WANTRETURN + $WS_VSCROLL + $ES_AUTOVSCROLL + $WS_HSCROLL)
	GUICtrlSetFont(-1, 9, Default, Default, 'Courier New')
	$MiscOpenB = GUICtrlCreateButton('Open', 5, 175 + $OFFSET_Y, 50, 20, 0)
	$MiscSaveB = GUICtrlCreateButton('Save', 5, 205 + $OFFSET_Y, 50, 20, 0)
	$MiscStopB = GUICtrlCreateButton('Stop', 60, 175 + $OFFSET_Y, 50, 20, 0)
	#endregion GUICtrlCreate
	#region GUICtrlSetState
	GUICtrlSetState($MiscStopB, $GUI_DISABLE)
	#endregion GUICtrlSetState
	#endregion $_misc
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
	$HFPrintDiagB = GUICtrlCreateButton('Diag', 130, 175 - 30, 50, 20, 0)
	$LogoEnableB = GUICtrlCreateButton('Logo On', 130, 205 - 30, 50, 20, 0)
	$LogoDisableB = GUICtrlCreateButton('Logo Off', 190, 205 - 30, 50, 20, 0)
	#endregion $_hf
	#region $_sell
	$_sell = GUICreate('Sell', 300 - 20, 230 - 30)
	$fiscOpenB = GUICtrlCreateButton('Open', 10, 10, 50, 20, 0)
	$fiscTotalB = GUICtrlCreateButton('Total', 10, 40, 50, 20, 0)
	$fiscCloseB = GUICtrlCreateButton('Close', 10, 70, 50, 20, 0)
	GUISwitch($_sell)
	#endregion
	#region $_main
	$_main = GUICreate('FPtools', 367, 421)
	GUISwitch($_main)
	#region GUICtrlCreate
	$FactNL = GUICtrlCreateLabel('Factory number:', 10, 5, 80, 20)
	$FactNI = GUICtrlCreateInput('', 10, 20, 80, 20)
	$SetFactNB = GUICtrlCreateButton('Set', 55, 45, 35, 20, 0)
	$VatNL = GUICtrlCreateLabel('VAT number:', 100, 5, 80, 20)
	$VatNI = GUICtrlCreateInput('', 100, 20, 80, 20)
	$VatModeChB = GUICtrlCreateCheckbox('ID', 100, 45, 36, 20)
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
	$cleanNsetB = GUICtrlCreateButton('Clean+Set', 70, 300, 50, 20)
	GUICtrlSetFont(-1, 7)
	$HFreadNsaveB = GUICtrlCreateButton('ReadSave', 130, 150, 50, 20)
	GUICtrlSetFont(-1, 7)
	$HFopenNwriteB = GUICtrlCreateButton('OpenWrite', 130, 180, 50, 20)
	GUICtrlSetFont(-1, 7)
	$HFeditB = GUICtrlCreateButton('Edit HF', 130, 210, 50, 20)
	$MiscB = GUICtrlCreateButton('Misc', 130, 240, 50, 20)
	$sellB = GUICtrlCreateButton('Sell', 130, 270, 50, 20)
	$timeDT = GUICtrlCreateDate('', 190, 150, 110, 20, $DTS_UPDOWN)
	$timeSetB = GUICtrlCreateButton('Set', 190, 180, 50, 20)
	$timeGetB = GUICtrlCreateButton('Get', 250, 180, 50, 20)
	$timePCgetB = GUICtrlCreateButton('<<', 310, 150, 20, 20)
	$timeAutoUpdateModeChB = GUICtrlCreateCheckbox('timeAU', 310, 180, 55, 20)
	$periodsDT = GUICtrlCreateDate('', 190, 210, 110, 20, $DTS_UPDOWN)
	$periodfDT = GUICtrlCreateDate('', 190, 240, 110, 20, $DTS_UPDOWN)
	$periodsI = GUICtrlCreateInput('', 190, 210, 110, 20)
	$periodfI = GUICtrlCreateInput('', 190, 240, 110, 20)
	$periodFormDateCB = GUICtrlCreateRadio('date', 190, 260, 50, 20)
	$periodFormNumCB = GUICtrlCreateRadio('num', 250, 260, 50, 20)
	$PRmakeB = GUICtrlCreateButton('PR', 310, 210, 50, 20)
	$PRsingleChB = GUICtrlCreateCheckbox('Single', 310, 240, 50, 20)
	$PortN = GUICtrlCreateCombo('', 10, 390, 70, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$PortSpeed = GUICtrlCreateCombo('', 90, 390, 70, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$PortConB = GUICtrlCreateButton('Connect', 170, 390, 60, 20)
	$PrintDiagB = GUICtrlCreateButton('Diag', 310, 330, 50, 20)
	$CashDriverB = GUICtrlCreateButton('CashDrw', 250, 360, 50, 20)
	$CashDriverI = GUICtrlCreateInput('', 310, 360, 50, 20)
	$serviceChB = GUICtrlCreateCheckbox('Service', 240, 390, 60, 20)
	$FPpasswordI = GUICtrlCreateInput('', 310, 390, 50, 20)
	$PrintCutB = GUICtrlCreateButton('Cut', 310, 300, 50, 20)
	$CashInB = GUICtrlCreateButton('+Cash', 10, 240, 30, 20)
	$CashInI = GUICtrlCreateInput('', 50, 240, 70, 20)
	$CashOutB = GUICtrlCreateButton('-Cash', 10, 270, 30, 20)
	$CashOutI = GUICtrlCreateInput('', 50, 270, 70, 20)
	$PrintXB = GUICtrlCreateButton('X', 10, 300, 50, 20)
	$PrintZB = GUICtrlCreateButton('Z', 10, 330, 50, 20)
	$FPmodel = GUICtrlCreateCombo('', 10, 360, 70, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
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
	_CtrlListAdd($PrintXB)
	_CtrlListAdd($PrintZB)
	_CtrlListAdd($PrintCutB)
	_CtrlListAdd($CashInB)
	_CtrlListAdd($CashOutB)
	_CtrlListAdd($CashInI)
	_CtrlListAdd($CashOutI)
	_CtrlListAdd($VatModeChB)
	_CtrlListAdd($FPpasswordI)
	_CtrlListAdd($sellB)
	_CtrlListAdd($CashDriverB)
	_CtrlListAdd($CashDriverI)
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
	GUICtrlSetData($FPpasswordI, $FPpassword)
	_FPmodelModeSet(0)
	GUICtrlSetData($FPmodel, _FPmodelStringGetFull(), _FPmodelStringGet(_FPmodelModeGet()))
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
	GUICtrlSetState($VatModeChB, $GUI_UNCHECKED)
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
	Local $data, $retVal = 0
	Dim $HFs[8]
	If _TestConnectMsg('_HFread()') Then Return 1
	_FlagOn($FLAG_HF_READ)
	For $k = 0 To 7
		$retVal = _SendCMDwRet(43, 'I' & $k, $data)
		If $retVal Then ExitLoop
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
	Local $data, $retVal = 0
	If _TestConnectMsg('_HFwrite()') Then Return 1
	_FlagOn($FLAG_HF_WRITE)
	_HFeditStore()
	For $i = 0 To 7
		$retVal = _SendCMDwRet(43, $i & $HFstr[$i], $data)
		If $retVal Then ExitLoop
	Next
	_FlagOff($FLAG_HF_WRITE)
	Return $retVal
EndFunc   ;==>_HFwrite
Func _IndShowTime()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_IND_SHOW_TIME)
	$retVal = _SendCMDwRet(63, '', $data)
	_FlagOff($FLAG_IND_SHOW_TIME)
	Return $retVal
EndFunc   ;==>_IndShowTime
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
Func _LogoEnable()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_LOGO_ENABLE)
	$retVal = _SendCMDwRet(43, 'L1', $data)
	_FlagOff($FLAG_LOGO_ENABLE)
	Return $retVal
EndFunc
Func _LogoDisable()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_LOGO_DISABLE)
	$retVal = _SendCMDwRet(43, 'L0', $data)
	_FlagOff($FLAG_LOGO_DISABLE)
	Return $retVal
EndFunc
Func _MiscEdit()
	_FlagOn($FLAG_MISC_EDIT)
	GUISetState(@SW_DISABLE)
	GUISwitch($_misc)
	GUISetState(@SW_SHOW)
	Do
		_checkGUImsg()
	Until _Flag($FLAG_MISC_EXIT)
	_FlagOff($FLAG_MISC_EXIT)
	GUISetState(@SW_HIDE)
	GUISwitch($_main)
	GUISetState(@SW_HIDE)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_ENABLE)
	_FlagOff($FLAG_MISC_EDIT)
EndFunc   ;==>_MiscEdit
Func _MiscEditRefresh()
	Local $s, $cr
	_FlagOn($FLAG_MISC_EDIT_REFRESH)
	$s = ''
	$cr = @CRLF
	For $i = 0 To $MAX_REP - 1
		If $i = $MAX_REP - 1 Or $RepMas[$i] = '' Then $cr = ''
		If $RepMas[$i] = '' Then ExitLoop
		$s &= $RepMas[$i] & $cr
	Next
	_FlagOff($FLAG_MISC_EDIT_REFRESH)
	GUICtrlSetData($MiscEditE, $s)
	Return $s
EndFunc   ;==>_MiscEditRefresh
Func _MiscEditStore()
	Local $res, $s
	_FlagOn($FLAG_MISC_EDIT_STORE)
	$res = GUICtrlRead($MiscEditE)
	$s = StringSplit($res, @CRLF, 1)
	;_ArrayDisplay($s)
	For $i = 0 To $MAX_REP - 1
		If Int($s[0]) > $i Then
			$RepMas[$i] = $s[$i + 1]
		Else
			$RepMas[$i] = ''
		EndIf
	Next
	_FlagOff($FLAG_MISC_EDIT_STORE)
	Return $s
EndFunc   ;==>_MiscEditStore
Func _MiscGet($s, $adr)
	Local $retVal, $DTstr, $yeari, $moni, $dayi, $houri, $mini, $seci, $DTm[6], $sum
	Select
		Case $adr = $REP_NUM
			$retVal = Dec(StringMid($s, 1, 4)) + 1
		Case $adr = $REP_DATE
			$DTstr = StringMid($s, 5, 8)
			$DTm[0] = Dec(StringMid($DTstr, 1, 2))
			$DTm[1] = Dec(StringMid($DTstr, 3, 2))
			$DTm[2] = Dec(StringMid($DTstr, 5, 2))
			$DTm[3] = Dec(StringMid($DTstr, 7, 2))
			$yeari = BitShift(BitAND($DTm[0], 126), 1)
			$moni = BitShift(BitAND($DTm[0], 1), -3) + BitShift(BitAND($DTm[1], 224), 5)
			$dayi = BitAND($DTm[1], 31)
			$houri = BitShift(BitAND($DTm[2], 248), 3)
			$mini = BitShift(BitAND($DTm[2], 7), -3) + BitShift(BitAND($DTm[3], 224), 5)
			$seci = BitShift(BitAND($DTm[3], 31), -1) + BitShift(BitAND($DTm[0], 128), 7)
			$retVal = $dayi & ',' & $moni & ',' & $yeari & ',' & $houri & ',' & $mini & ',' & $seci
		Case $adr = $REP_ZERO
			$retVal = Dec(StringMid($s, 13, 2))
		Case $adr = $REP_N_CHECKS
			$retVal = Dec(StringMid($s, 15, 6))
		Case $adr = $REP_N_SELLS
			$retVal = Dec(StringMid($s, 21, 4))
		Case $adr = $REP_N_RETURNS
			$retVal = Dec(StringMid($s, 25, 4))
		Case $adr = $REP_A
			$retVal = Dec(StringMid($s, 29, 12)) / 100
		Case $adr = $REP_B
			$retVal = Dec(StringMid($s, 41, 12)) / 100
		Case $adr = $REP_V
			$retVal = Dec(StringMid($s, 53, 12)) / 100
		Case $adr = $REP_G
			$retVal = Dec(StringMid($s, 65, 12)) / 100
		Case $adr = $REP_D
			$retVal = Dec(StringMid($s, 77, 12)) / 100
		Case $adr = $REP_A_R
			$retVal = Dec(StringMid($s, 89, 12)) / 100
		Case $adr = $REP_B_R
			$retVal = Dec(StringMid($s, 101, 12)) / 100
		Case $adr = $REP_V_R
			$retVal = Dec(StringMid($s, 113, 12)) / 100
		Case $adr = $REP_G_R
			$retVal = Dec(StringMid($s, 125, 12)) / 100
		Case $adr = $REP_D_R
			$retVal = Dec(StringMid($s, 137, 12)) / 100
		Case $adr = $REP_A_TAX
			$retVal = Dec(StringMid($s, 149, 12)) / 100
		Case $adr = $REP_B_TAX
			$retVal = Dec(StringMid($s, 161, 12)) / 100
		Case $adr = $REP_V_TAX
			$retVal = Dec(StringMid($s, 173, 12)) / 100
		Case $adr = $REP_G_TAX
			$retVal = Dec(StringMid($s, 185, 12)) / 100
		Case $adr = $REP_A_R_TAX
			$retVal = Dec(StringMid($s, 197, 12)) / 100
		Case $adr = $REP_B_R_TAX
			$retVal = Dec(StringMid($s, 209, 12)) / 100
		Case $adr = $REP_V_R_TAX
			$retVal = Dec(StringMid($s, 221, 12)) / 100
		Case $adr = $REP_G_R_TAX
			$retVal = Dec(StringMid($s, 233, 12)) / 100
		Case $adr = $REP_FOOTER
			$retVal = StringMid($s, 245, 10)
		Case $adr = $REP_CHECKSUM
			$retVal = StringMid($s, 255, 2)
		Case $adr = $REP_CHECKSUM_CALC
			$sum = 0
			For $i = 1 To 127
				$sum += Dec(StringMid($s, $i * 2 - 1, 2))
			Next
			$retVal = StringRight(Hex($sum), 2)
	EndSelect
	Return $retVal
EndFunc   ;==>_MiscGet
Func _MiscOpen($mainHndl)
	Local $errStatus, $retVal, $k, $ss, $snum, $sf, $CHKS, $CHKS_C, $err_msg, $rnum
	GUISetState(@SW_DISABLE, $mainHndl)
	Local $filename = FileOpenDialog('Open bin as', '', 'Binary (*.bin)|All (*.*)')
	$errStatus = @error
	GUISetState(@SW_ENABLE, $mainHndl)
	GUISetState(@SW_HIDE, $mainHndl)
	GUISetState(@SW_SHOW, $mainHndl)
	If $errStatus Then
		_DLog('_MiscOpen(): file not selected' & @CRLF)
		Return 1
	EndIf
	If StringRight($filename, 4) <> '.bin' Then
		$filename &= '.bin'
	EndIf
	_DLog('_MiscOpen(): $filename = ' & $filename & @CRLF)
	Local $file = FileOpen($filename)
	If $file = -1 Then
		_DLog('_MiscOpen(): FileOpen() error' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_MISC_OPEN)
	$retVal = 0
	$k = 0
	Dim $RepM[$MAX_REP]
	For $i = 0 To $MAX_REP - 1
		$RepM[$i] = ''
	Next
	Do
		_checkGUImsg()
		If _Flag($FLAG_EXIT_MISC_OPEN) Then
			_FlagOff($FLAG_EXIT_MISC_OPEN)
			_DLog('_MiscOpen(): Reading aborted' & @CRLF)
			ExitLoop
		EndIf
		FileSetPos($file, $MISC_START_REP_ADDR + $k * $MISC_READ_BYTE_COUNT, 0)
		If @error = -1 Then ExitLoop
		$ss = _StringToHex(FileRead($file, $MISC_READ_BYTE_COUNT))
		$CHKS = _MiscGet($ss, $REP_CHECKSUM)
		$CHKS_C = _MiscGet($ss, $REP_CHECKSUM_CALC)
		$err_msg = ''
		$rnum = _MiscGet($ss, $REP_NUM)
		If $CHKS <> $CHKS_C Then $err_msg = ' !!!CHECHSUM NOT CORRECT!!!'
		$sf = $rnum & '(' & HEX($rnum - 1, 4) & '@' & HEX(2560 + 128 * ($rnum - 1), 5) & '),' & _MiscGet($ss, $REP_DATE) & ',' _
				 & _MiscGet($ss, $REP_ZERO) & ',' & _MiscGet($ss, $REP_N_CHECKS) & ',' & _MiscGet($ss, $REP_N_SELLS) & ',' _
				 & _MiscGet($ss, $REP_N_RETURNS) & ',' & _MiscGet($ss, $REP_A) & ',' & _MiscGet($ss, $REP_B) & ',' & _MiscGet($ss, $REP_V) & ',' _
				 & _MiscGet($ss, $REP_G) & ',' & _MiscGet($ss, $REP_D) & ',' & _MiscGet($ss, $REP_A_R) & ',' & _MiscGet($ss, $REP_B_R) & ',' _
				 & _MiscGet($ss, $REP_V_R) & ',' & _MiscGet($ss, $REP_G_R) & ',' & _MiscGet($ss, $REP_D_R) & ',' & _MiscGet($ss, $REP_A_TAX) & ',' _
				 & _MiscGet($ss, $REP_B_TAX) & ',' & _MiscGet($ss, $REP_V_TAX) & ',' & _MiscGet($ss, $REP_G_TAX) & ',' _
				 & _MiscGet($ss, $REP_A_R_TAX) & ',' & _MiscGet($ss, $REP_B_R_TAX) & ',' & _MiscGet($ss, $REP_V_R_TAX) & ',' _
				 & _MiscGet($ss, $REP_G_R_TAX) & ',' & _MiscGet($ss, $REP_FOOTER) & ',' & $CHKS & ',' & $CHKS_C & $err_msg
		If $sf < 0 Or $sf > $MAX_REP Then
			_DLog('_MiscOpen(): Report record not valid' & @CRLF)
			ExitLoop
		EndIf
		$RepM[$k] = $sf
		$k += 1
		If $k >= $MAX_REP Then
			_DLog('_MiscOpen(): Max reached' & @CRLF)
			ExitLoop
		EndIf
	Until 0
	FileClose($file)
	If $retVal = 0 Then
		$RepMas = $RepM
		_MiscEditRefresh()
	EndIf
	_FlagOff($FLAG_MISC_OPEN)
	Return $retVal
EndFunc   ;==>_MiscOpen
Func _MiscSave($mainHndl)
	Local $errStatus, $retVal, $res, $filename
	GUISetState(@SW_DISABLE, $mainHndl)
	$filename = FileSaveDialog('Save data as', '', 'Coma-separated text (*.txt)|All (*.*)', 16, StringRight($FactN, 7))
	$errStatus = @error
	GUISetState(@SW_ENABLE, $mainHndl)
	GUISetState(@SW_HIDE, $mainHndl)
	GUISetState(@SW_SHOW, $mainHndl)
	If $errStatus Then
		_DLog('_MiscSave(): file not selected' & @CRLF)
		Return 1
	EndIf
	If StringRight($filename, 4) <> '.txt' Then
		$filename &= '.txt'
	EndIf
	_DLog('_MiscSave(): $filename = ' & $filename & @CRLF)
	Local $file = FileOpen($filename, 2)
	If $file = -1 Then
		_DLog('_MiscSave(): FileOpen()' & @CRLF)
		Return 1
	EndIf
	_FlagOn($FLAG_MISC_SAVE)
	_MiscEditStore()
	$retVal = 0
	For $k = 0 To $MAX_REP - 1
		$res = FileWriteLine($file, $RepMas[$k])
		If $RepMas[$k] = '' Then
			_DLog('_MiscSave(): ended' & @CRLF)
			ExitLoop
		EndIf
		If $res = 0 Then
			$retVal = 2
			_DLog('_MiscSave(): FileWriteLine()' & @CRLF)
			ExitLoop
		EndIf
	Next
	FileClose($file)
	_FlagOff($FLAG_MISC_SAVE)
	Return $retVal
EndFunc   ;==>_MiscSave
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
		_ClosePort(True)
		_AllCtrlDisable()
		GUICtrlSetData($PortConB, $CONNECT_B_T)
		GUICtrlSetState($PortConB, $GUI_ENABLE)
		GUICtrlSetState($PortSpeed, $GUI_ENABLE)
		GUICtrlSetState($PortN, $GUI_ENABLE)
		GUICtrlSetState($FPmodel, $GUI_ENABLE)
		$portState = 0
	Else
		$p = StringTrimLeft(GUICtrlRead($PortN), 3)
		$sp = GUICtrlRead($PortSpeed)
		$err = _OpenPort($p, $sp)
		If $err Then
			_DLog('_Port(): OpenPort() ' & $err & @CRLF)
			Return 1
		EndIf
		_FPmodelModeSet(_ArraySearch($FPModelStrM, GUICtrlRead($FPmodel)))
		$i = _GetFiscInfo()
		If $i Then
			_DLog('_Port(): _GetFiscInfo() = ' & $i & @CRLF)
			Return 1
		EndIf
		_AllCtrlEnable()
		GUICtrlSetData($PortConB, $CONNECT_B_T2)
		GUICtrlSetState($PortSpeed, $GUI_DISABLE)
		GUICtrlSetState($PortN, $GUI_DISABLE)
		GUICtrlSetState($FPmodel, $GUI_DISABLE)
		$portState = 1
	EndIf
	Return 0
EndFunc   ;==>_Port
Func _PrintCut()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_PRINT_CUT)
	$retVal = _SendCMDwRet(45, '', $data)
	_FlagOff($FLAG_PRINT_CUT)
	Return $retVal
EndFunc   ;==>_PrintCut
Func _PrintDiag()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_PRINT_DIAG)
	$retVal = _SendCMDwRet(71, '', $data)
	_FlagOff($FLAG_PRINT_DIAG)
	Return $retVal
EndFunc   ;==>_PrintDiag
Func _PrintX()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_PRINT_X)
	$retVal = _SendCMDwRet(69, $FPpassword & ',2', $data)
	_FlagOff($FLAG_PRINT_X)
	Return $retVal
EndFunc   ;==>_PrintX
Func _PrintZ()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_PRINT_Z)
	$retVal = _SendCMDwRet(69, $FPpassword & ',0', $data)
	_FlagOff($FLAG_PRINT_Z)
	Return $retVal
EndFunc   ;==>_PrintZ
Func _PRmakeDate()
	Local $retVal, $ds, $df, $dd, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_PR_MAKE_DATE)
	$ds = GUICtrlRead($periodsDT)
	$df = GUICtrlRead($periodfDT)
	$dd = $FPpassword & ',' & StringReplace(StringLeft($ds, 8), '-', '') & ',' & StringReplace(StringLeft($df, 8), '-', '')
	$retVal = _SendCMDwRet(79, $dd, $data)
	_FlagOff($FLAG_PR_MAKE_DATE)
	Return $retVal
EndFunc   ;==>_PRmakeDate
Func _PRmakeNum()
	Local $retVal, $ds, $df, $dd, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_PR_MAKE_NUM)
	$ds = GUICtrlRead($periodsI)
	$df = GUICtrlRead($periodfI)
	$dd = $FPpassword & ',' & $ds & ',' & $df
	$retVal = _SendCMDwRet(95, $dd, $data)
	_FlagOff($FLAG_PR_MAKE_NUM)
	Return $retVal
EndFunc   ;==>_PRmakeNum
Func _PRmodeGet()
	Return _Flag($FLAG_PERIOD_MODE)
EndFunc   ;==>_PRmodeGet
Func _PRmodeSet($m)
	_FlagOn($FLAG_PERIOD_MODE_FUNC)
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
	_FlagOff($FLAG_PERIOD_MODE_FUNC)
EndFunc   ;==>_PRmodeSet
Func _PRsingleModeGet()
	Return _Flag($FLAG_PR_SINGLE_MODE)
EndFunc   ;==>_PRsingleModeGet
Func _PRsingleModeSet($m)
	_FlagOn($FLAG_PR_SINGLE_MODE_FUNC)
	If $m Then
		GUICtrlSetState($periodfI, $GUI_DISABLE)
		GUICtrlSetState($periodfDT, $GUI_DISABLE)
		_FlagOn($FLAG_PR_SINGLE_MODE)
	Else
		GUICtrlSetState($periodfI, $GUI_ENABLE)
		GUICtrlSetState($periodfDT, $GUI_ENABLE)
		_FlagOff($FLAG_PR_SINGLE_MODE)
	EndIf
	_FlagOff($FLAG_PR_SINGLE_MODE_FUNC)
EndFunc   ;==>_PRsingleModeSet
Func _SellTools()
	_FlagOn($FLAG_SELL_TOOL)
	GUISetState(@SW_DISABLE)
	GUISwitch($_sell)
	GUISetState(@SW_SHOW)
	Do
		_checkGUImsg()
	Until _Flag($FLAG_SELL_EXIT)
	_FlagOff($FLAG_SELL_EXIT)
	GUISetState(@SW_HIDE)
	GUISwitch($_main)
	GUISetState(@SW_HIDE)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_ENABLE)
	_FlagOff($FLAG_SELL_TOOL)
EndFunc
Func _SendCMDwRet($c, $d, ByRef $data)
	Local $failTry = 0, $res, $rrRaw, $rr, $retVal = 0
	_FlagOn($FLAG_SEND_CMD_W_RET)
	Do
		$res = _SendCMD($c, $d)
		$rrRaw = _ReceiveAll()
		$rr = _Validate($rrRaw)
		$data = _GetData(_GetBody($rr))
		If $rr = '' Then $failTry += 1
	Until $rr <> '' Or $failTry > $maxFailTry
	If $failTry > $maxFailTry Then
		_DLog('No response while writing data' & @CRLF)
		$retVal = 1
	EndIf
	_FlagOff($FLAG_SEND_CMD_W_RET)
	Return $retVal
EndFunc   ;==>_SendCMDwRet
Func _ServiceDisable()
	_FlagOn($FLAG_SERVICE_DISABLED)
	_FlagOff($FLAG_SERVICE)
	For $i = 1 To $SLmax
		GUICtrlSetState($serviceList[$i - 1], $GUI_HIDE)
	Next
	_FlagOff($FLAG_SERVICE_DISABLED)
EndFunc   ;==>_ServiceDisable
Func _ServiceEnable()
	_FlagOn($FLAG_SERVICE_ENABLED)
	_FlagOn($FLAG_SERVICE)
	For $i = 1 To $SLmax
		GUICtrlSetState($serviceList[$i - 1], $GUI_SHOW)
	Next
	_FlagOff($FLAG_SERVICE_ENABLED)
EndFunc   ;==>_ServiceEnable
Func _ServiceInput($mainHndl)
	Local $pas, $res
	_FlagOn($FLAG_SERVICE_INPUT)
	GUISetState(@SW_DISABLE, $mainHndl)
	$pas = InputBox('Service mode', 'Enter service password', '', '#', 160, 110)
	$res = 0
	If $pas <> '75296' Then $res = 1
	GUISetState(@SW_ENABLE, $mainHndl)
	GUISetState(@SW_HIDE, $mainHndl)
	GUISetState(@SW_SHOW, $mainHndl)
	_FlagOff($FLAG_SERVICE_INPUT)
	Return $res
EndFunc   ;==>_ServiceInput
Func _ServiceListAdd($h)
	If $SLmax < $MAX_SL Then
		$serviceList[$SLmax] = $h
		$SLmax += 1
		_DLog('$SLmax = ' & $SLmax & @CRLF)
	Else
		_DLog('$serviceList[] max size ' & $MAX_SL & ' reached!' & @CRLF)
	EndIf
EndFunc   ;==>_ServiceListAdd
Func _SetFactN($mainHndl)
	Local $i, $retVal, $data
	If _TestConnect() = '' Then Return 1
	$i = GUICtrlRead($FactNI)
	If StringLen($i) <> 10 Or Not StringIsDigit(StringRight($i, 8)) Then
		_DLog('_SetFactN(): Not valid factory number ' & $i & @CRLF)
		_Info('Error factory number', $mainHndl)
		Return 1
	EndIf
	_FlagOn($FLAG_FISC_SET_FACT_N)
	$retVal = _SendCMDwRet(91, '2,' & $i, $data)
	Select
		Case $data = 'P'
			_DLog('_SetFactN(): OK' & @CRLF)
		Case $data = 'F'
			_DLog('_SetFactN(): Failure' & @CRLF)
			$retVal = 1
	EndSelect
	_FlagOff($FLAG_FISC_SET_FACT_N)
	Return $retVal
EndFunc   ;==>_SetFactN
Func _SetFiscN($mainHndl)
	Local $i, $retVal, $data
	If _TestConnect() = '' Then Return 1
	$i = GUICtrlRead($FiscNI)
	If StringLen($i) <> 10 Or Not StringIsDigit($i) Then
		_DLog('_SetFiscN(): Not valid fiscal number ' & $i & @CRLF)
		_Info('Error fisc number', $mainHndl)
		Return 1
	EndIf
	_FlagOn($FLAG_FISC_SET_FISC_N)
	$retVal = _SendCMDwRet(92, $i, $data)
	Select
		Case $data = 'P'
			_DLog('_SetFiscN(): OK' & @CRLF)
		Case $data = 'F'
			_DLog('_SetFiscN(): Failure' & @CRLF)
			$retVal = 1
	EndSelect
	_FlagOff($FLAG_FISC_SET_FISC_N)
	Return $retVal
EndFunc   ;==>_SetFiscN
Func _SetTaxRates($mainHndl)
	Local $iA, $iB, $iV, $iG, $retVal, $jA, $jB, $jV, $jG, $dd, $data
	If _TestConnect() = '' Then Return 1
	$iA = GUICtrlRead($TaxRateAI)
	$iB = GUICtrlRead($TaxRateBI)
	$iV = GUICtrlRead($TaxRateVI)
	$iG = GUICtrlRead($TaxRateGI)
	If $iA < 0 Or $iA > 99.99 Or _
			$iB < 0 Or $iB > 99.99 Or _
			$iV < 0 Or $iV > 99.99 Or _
			$iG < 0 Or $iG > 99.99 Then
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
	$dd = $FPpassword & ',2,' & $jA & $jB & $jV & $jG & ',' & $iA & ',' & $iB & ',' & $iV & ',' & $iG
	$retVal = _SendCMDwRet(83, $dd, $data)
	_FlagOff($FLAG_FISC_SET_TAX)
	Return $retVal
EndFunc   ;==>_SetTaxRates
Func _SetVatMode($m)
	If $m = 1 Then
		GUICtrlSetState($VatModeChB, $GUI_CHECKED)
	Else
		GUICtrlSetState($VatModeChB, $GUI_UNCHECKED)
	EndIf
EndFunc   ;==>_SetVatMode
Func _SetVatN($mainHndl)
	Local $i, $retVal, $data
	If _TestConnect() = '' Then Return 1
	$i = GUICtrlRead($VatNI)
	If StringLen($i) <> 12 Then
		_Info('Error number', $mainHndl)
		Return 1
	EndIf
	_FlagOn($FLAG_FISC_SET_FISC_N)
	$retVal = _SendCMDwRet(98, $i & ',' & _GetVatMode(), $data)
	Select
		Case $data = 'P'
			_DLog('_SetVatN(): OK' & @CRLF)
		Case $data = 'F'
			_DLog('_SetVatN(): Failure' & @CRLF)
			$retVal = 1
	EndSelect
	_FlagOff($FLAG_FISC_SET_FISC_N)
	Return $retVal
EndFunc   ;==>_SetVatN
Func _SetVer()
	Local $retVal, $data
	If _TestConnect() = '' Then Return 1
	_FlagOn($FLAG_FISC_SET_VER)
	$retVal = _SendCMDwRet(131, '', $data)
	Select
		Case $data = 'P'
			_DLog('_SetVer(): OK' & @CRLF)
		Case $data = 'F'
			_DLog('_SetVer(): Failure' & @CRLF)
			$retVal = 1
	EndSelect
	_FlagOff($FLAG_FISC_SET_VER)
	Return $retVal
EndFunc   ;==>_SetVer
Func _StartMainLoop()
	Local $loopTimer, $Time, $TimeDivPCtimeGet, $TimeDivCheckRange, $oldTimePCtimeGet, $oldTimeCheckRange
	$loopTimer = TimerInit()
	$oldTimePCtimeGet = 0
	$oldTimeCheckRange = 0
	While Not _Flag($FLAG_EXIT_GUI)
		_checkGUImsg()
		$Time = TimerDiff($loopTimer)
		$TimeDivPCtimeGet = Int($Time / $DelayPCtimeGet)
		$TimeDivCheckRange = Int($Time / $DelayCheckRange)
		If $TimeDivCheckRange <> $oldTimeCheckRange Then
			$oldTimeCheckRange = $TimeDivCheckRange
			_CheckRange()
		EndIf
		If $TimeDivPCtimeGet <> $oldTimePCtimeGet Then
			$oldTimePCtimeGet = $TimeDivPCtimeGet
			If _TimeAutoUpdateModeGet() Then
				If Not $portState Then
					_PCtimeGet()
				Else
					_IndShowTime()
				EndIf
			EndIf
		EndIf
	WEnd
	Return 0
EndFunc   ;==>_StartMainLoop
Func _TestConnect()
	Local $res, $rrRaw, $rr, $data
	$res = _SendCMD(74, 'W')
	$rrRaw = _ReceiveAll()
	$rr = _Validate($rrRaw)
	$data = _GetData(_GetBody($rr))
	If StringLen($data) = 6 Then $statusBytes = $data
	If $data = '' Then _DLog('No response from printer' & @CRLF)
	Return $data
EndFunc   ;==>_TestConnect
Func _TestConnectMsg($msg)
	If _TestConnect() = '' Then
		_DLog($msg & ': No response from printer' & @CRLF)
		Return 1
	EndIf
	Return 0
EndFunc   ;==>_TestConnectMsg
Func _TimeAutoUpdateModeGet()
	Return _Flag($FLAG_TIME_AUTO_UPDATE_MODE)
EndFunc   ;==>_TimeAutoUpdateModeGet
Func _TimeAutoUpdateModeSet($m)
	_FlagOn($FLAG_TIME_AUTO_UPDATE_MODE_FUNC)
	If $m Then
		_FlagOn($FLAG_TIME_AUTO_UPDATE_MODE)
	Else
		_FlagOff($FLAG_TIME_AUTO_UPDATE_MODE)
	EndIf
	_FlagOff($FLAG_TIME_AUTO_UPDATE_MODE_FUNC)
EndFunc   ;==>_TimeAutoUpdateModeSet
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
