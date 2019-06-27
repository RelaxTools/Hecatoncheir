VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Registry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----------------------------------------------------------------------------------------------------
'
' [Hecatoncheir] v1
'
' Copyright (c) 2019 Yasuhiro Watanabe
' https://github.com/RelaxTools/Hecatoncheir
' author:relaxtools@opensquare.net
'
' The MIT License (MIT)
'
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in all
' copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.
'
'-----------------------------------------------------------------------------------------------------
' ���̃N���X�� Static�N���X(Attribute VB_PredeclaredId = True) �ł��B
'-----------------------------------------------------------------------------------------------------
' �ˑ����W���[��
'   �Ȃ�
'-----------------------------------------------------------------------------------------------------
' 2018-12-16 Ver.1.0.0 �V�K�쐬
'-----------------------------------------------------------------------------------------------------
Option Explicit
'--------------------------------------------------------------
'���W�X�g���ǂݍ���
'--------------------------------------------------------------
Public Function GetSetting(ByVal Section As String, ByVal key As String, Optional ByVal Default As String = "") As String
    GetSetting = VBA.GetSetting(Title, Section, key, Default)
End Function
'--------------------------------------------------------------
'���W�X�g����������
'--------------------------------------------------------------
Public Sub SaveSetting(ByVal Section As String, ByVal key As String, ByVal Value As String)
    VBA.SaveSetting Title, Section, key, Value
End Sub
'--------------------------------------------------------------
'���W�X�g���폜
'--------------------------------------------------------------
Public Sub DeleteSetting(ByVal Section As String, Optional ByVal key As String = "")
    If Len(key) = 0 Then
        VBA.DeleteSetting Title, Section
    Else
        VBA.DeleteSetting Title, Section, key
    End If
End Sub
'--------------------------------------------------------------
' ���W�X�g����Export
' UTF-16 LE �ɂă��W�X�g���̓��e���o�͂���B
'--------------------------------------------------------------
Public Sub Export()

    Dim strDat As String
    Const C_FF As Byte = &HFF
    Const C_FE As Byte = &HFE
    Dim FileName As Variant
    Dim strReg As String
    Dim key As String
    
    Dim Reg, Locator, Service, SubKey, RegName, RegType
    Dim i As Long, j As Long, buf As String, RegData As String
    
    Dim fp As Integer
    
'    SetMyDocument
    
    FileName = Application.GetSaveAsFilename(InitialFileName:=Title & ".reg", fileFilter:="�o�^�t�@�C��,*.reg")
    If FileName = False Then
        Exit Sub
    End If
    
    On Error GoTo err_Handle

    strReg = "HKEY_CURRENT_USER\Software\VB and VBA Program Settings\" & Title

    Set Locator = CreateObject("WbemScripting.SWbemLocator")
    Set Service = Locator.ConnectServer(vbNullString, "root\default")
    Set Reg = Service.Get("StdRegProv")
    
    Const HKEY_CURRENT_USER = &H80000001
    
    Const ROOT = "HKEY_CURRENT_USER\"
    key = "Software\VB and VBA Program Settings\" & Title
    
    Reg.EnumKey HKEY_CURRENT_USER, key, SubKey
    
    fp = FreeFile()
    Open FileName For Output As fp
    Close fp
    
    fp = FreeFile()
    Open FileName For Binary As fp
    
    Dim strBuf() As Byte
    
    Put fp, , C_FF
    Put fp, , C_FE
    
    strBuf = "Windows Registry Editor Version 5.00" & vbCrLf & vbCrLf
    Put fp, , strBuf
    
    strBuf = "[" & ROOT & key & "]" & vbCrLf
    Put fp, , strBuf
    
    For i = 0 To UBound(SubKey)
        
        Reg.EnumValues HKEY_CURRENT_USER, key & "\" & SubKey(i), RegName, RegType
            
        strBuf = vbCrLf & "[" & ROOT & key & "\" & SubKey(i) & "]" & vbCrLf
        Put fp, , strBuf
        
        For j = 0 To UBound(RegName)
        
            Select Case RegType(j)
                Case 1
                    Reg.GetStringValue HKEY_CURRENT_USER, key & "\" & SubKey(i), RegName(j), RegData
                Case Else
                    Reg.GetMultiStringValue HKEY_CURRENT_USER, key & "\" & SubKey(i), RegName(j), RegData
                
            End Select
        
            strDat = Replace(RegData, "\", "\\")
            strDat = Replace(strDat, """", "\""")
            
            strBuf = """" & RegName(j) & """=""" & strDat & """" & vbCrLf
            
            Put fp, , strBuf
        
        Next j
        
    Next i
    strBuf = vbCrLf
    Put fp, , strBuf
    Close fp
    
    Set Reg = Nothing
    Set Service = Nothing
    Set Locator = Nothing
    
    Message.Information "�o�^�t�@�C����ۑ����܂����B\n�ڍs��œo�^�t�@�C�������s����ƃ��W�X�g���ɔ��f����܂��B"
    Exit Sub

err_Handle:
    Message.Information "�o�^�t�@�C���̕ۑ��Ɏ��s���܂����B"
End Sub
'--------------------------------------------------------------
'�A�v���P�[�V�������擾
'--------------------------------------------------------------
Private Property Get Title() As String
    Title = ThisWorkbook.BuiltinDocumentProperties("Title").Value
End Property

