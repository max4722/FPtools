#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#Tidy_Parameters=/sfc
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <CommMG.au3>
#include <String.au3>
Opt('MustDeclareVars', 1)

Global $seq = 0

Func _BCC4($s)
	If $s == '' Then Return ''
	Local $bcc = 0
	Local $i
	For $i = 1 To StringLen($s) / 2
		$bcc += Dec(StringMid($s, 2 * $i - 1, 2))
	Next
	Local $bcch = Hex($bcc, 4)
	Local $res = ''
	For $i = 1 To 4
		$res = $res & '3' & StringMid($bcch, $i, 1)
	Next
	Return $res
EndFunc   ;==>_BCC4
Func _ClosePort($flag = False)
	_CommClosePort($flag)
EndFunc   ;==>_ClosePort
Func _DLog($s)
	ConsoleWrite($s)
	;GUICtrlSetData($myedit, $s, 1)
EndFunc   ;==>_DLog
Func _GetBCC($s)
	If $s == '' Then Return ''
	Return StringLeft(StringRight($s, 10), 8)
EndFunc   ;==>_GetBCC
Func _GetBody($s)
	If $s == '' Then Return ''
	Return StringTrimLeft(StringTrimRight($s, 26), 2)
EndFunc   ;==>_GetBody
Func _GetCmd($s)
	If $s == '' Then Return ''
	Return Dec(StringTrimLeft(StringLeft($s, 6), 4))
EndFunc   ;==>_GetCmd
Func _GetData($s)
	If $s == '' Then Return ''
	Return _HexToString(StringTrimLeft($s, 6))
EndFunc   ;==>_GetData
Func _GetInRng($s, $a, $b, $expr = '(.*)')
	If $s == '' Then Return ''
	Local $ss = $a & $expr & $b
	Local $res = StringRegExp($s, $ss, 3)
	Local $statusRaw
	If @error <> 0 Then
		_DLog('ERROR: StringRegExp error ' & $res & @CRLF)
		Exit
	EndIf
	If UBound($res) > 0 Then
		$statusRaw = $res[0]
	Else
		$statusRaw = $res
	EndIf
	Return $statusRaw
EndFunc   ;==>_GetInRng
Func _GetLen($s)
	If $s == '' Then Return 0
	Return Dec(StringLeft($s, 2)) - 32
EndFunc   ;==>_GetLen
Func _GetSeq($s)
	If $s == '' Then Return 0
	Return Dec(StringTrimLeft(StringLeft($s, 4), 2)) - 32
EndFunc   ;==>_GetSeq
Func _GetStatus($s)
	If $s == '' Then Return ''
	Return StringTrimRight(StringRight($s, 24), 12)
EndFunc   ;==>_GetStatus
Func _incSeq($i)
	$i += 1
	If $i > 95 Then $i = 0
	Return $i
EndFunc   ;==>_incSeq
Func _MakeString($cmd, $data = '', $seq = 0)
	If $cmd == 0 Then Return ''
	Dim $bcchex[4]
	Local $databcc = 0
	$seq += 32
	Local $i
	For $i = 1 To StringLen($data)
		$databcc += Dec(_StringToHex(StringMid($data, $i, 1)))
	Next
	Local $len = StringLen($data) + 4 + 32
	Local $bcc = $len + $seq + $cmd + $databcc + 5;
	Local $ss = Hex($bcc, 4)
	For $i = 1 To 4
		$bcchex[$i - 1] = Hex(48 + Dec(StringMid($ss, $i, 1)), 2)
	Next
	Local $s0x01 = _HexToString('01')
	Local $s0x03 = _HexToString('03')
	Local $s0x05 = _HexToString('05')
	Local $lenStr = _HexToString(Hex($len, 2))
	Local $seqStr = _HexToString(Hex($seq, 2))
	Local $cmdStr = _HexToString(Hex($cmd, 2))
	Local $bccStr = _HexToString($bcchex[0] & $bcchex[1] & $bcchex[2] & $bcchex[3]) ; '30313F3D'
	$ss = $s0x01 & $lenStr & $seqStr & $cmdStr & $data & $s0x05 & $bccStr & $s0x03
	Return $ss
EndFunc   ;==>_MakeString
Func _OpenPort($port = 1, $bps = 19200)
	Local $errstr = ''
	_CommSetPort($port, $errstr, $bps)
	If @error <> 0 Then
		Return $errstr
	EndIf
	Return 0
EndFunc   ;==>_OpenPort
Func _ReceiveAll($timeout = 1000)
	Local $rstr = ''
	Local $rstr_old = ''
	Local $num
	Local $diff
	Local $byte
	Local $s
	Local $lenS
	Do
		Local $begin = TimerInit()
		Do
			$num = _CommGetInputCount()
			$diff = TimerDiff($begin)
		Until $num > 0 Or $diff > $timeout
		;_Dlog('$diff = ' & $diff & @CRLF)
		If $diff > $timeout And $num == 0 Then
			_DLog('Timeout' & @CRLF)
			ExitLoop
		EndIf
		$rstr_old = $rstr
		For $i = 1 To $num
			$byte = _CommReadByte()
			If $byte == 21 Then
				_DLog('NAK!' & @CRLF)
				Return ''
			ElseIf $byte = 22 Then
				_DLog('SYN' & @CRLF)
				ContinueLoop
			EndIf
			$rstr &= StringRight(Hex($byte, 2), 2)
		Next
		$s = StringMid($rstr, 3, 2)
		$lenS = Dec($s) - 32
	Until StringLen($rstr) == 2 * ($lenS + 6)
	Return $rstr
EndFunc   ;==>_ReceiveAll
Func _SendCMD($c, $d = '')
	$seq = _incSeq($seq)
	If $c == 0 Then Return ''
	Local $str = _MakeString($c, $d, $seq)
	Local $res = _CommSendString($str, 1)
	Return $res
EndFunc   ;==>_SendCMD
Func _StatFormat($s)
	If $s == '' Then Return ''
	Local $status = ''
	Local $i
	For $i = 0 To 5
		$status = $status & Hex(Dec(StringMid($s, 2 * $i + 1, 2)) - Dec('80'), 2) & ' '
	Next
	Return $status
EndFunc   ;==>_StatFormat
Func _Validate($s)
	If $s == '' Then Return ''
	If StringLen($s) < 34 Then Return ''
	If StringLeft($s, 2) <> '01' Or StringRight($s, 2) <> '03' Then Return ''
	If StringLeft(StringRight($s, 12), 2) <> '05' Then Return ''
	If StringLeft(StringRight($s, 26), 2) <> '04' Then Return ''
	Return $s
EndFunc   ;==>_Validate
