VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Logger"
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
'   Lang.cls
'   Registry.cls
'-----------------------------------------------------------------------------------------------------
' 2019-03-15 Ver.1.0.0 �V�K�쐬
'-----------------------------------------------------------------------------------------------------
Option Explicit

#If Win64 Then
    Private Declare PtrSafe Function GetTickCount Lib "kernel32" Alias "GetTickCount64" () As LongPtr
#Else
    Private Declare PtrSafe Function GetTickCount Lib "kernel32" () As Long
#End If
Private Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal ms As LongPtr)

'�X�^�b�N
Private colStack As New Collection

'�t�@�C���ԍ�
Private fp As Integer

'���O�^�C�v
Public Enum LogType
    DebugWindow = 1
    Logfile
    All
End Enum

'���O���x��
Public Enum LogLevel
    Trace = 0
    Info = 1
    Warn = 2
    Fatal = 3
    None = 4
End Enum

Private mLevel As LogLevel
Private mLogType As Long
Private mlngHistory As Long
Private mLevelStr As Variant
Private mLang As Object
Private mFSO As Object

'����T�|�[�g
Public Property Set LangSupport(v As Object)
    Set mLang = v
End Property

'--------------------------------------------------------------
'�@Class_Initialize
'--------------------------------------------------------------
Private Sub Class_Initialize()

    Set mFSO = CreateObject("Scripting.FileSystemObject")
    
    fp = 225

    mLevelStr = Array("Trace", "Info", "Warn", "Fatal", "None")
    
    '�K��̃��O���x��
    mLevel = GetSetting(Title, "Log", "Level", LogLevel.Info)
    
    '���O�o�͐�
    mLogType = CLng(GetSetting(Title, "Log", "LogType", LogType.Logfile))
    
    '�q�X�g����
    mlngHistory = CLng(GetSetting(Title, "Log", "History", 5))

    If mLogType And LogType.Logfile Then
        Call OpenLog
    End If

End Sub
'--------------------------------------------------------------
'�@Class_Terminate
'--------------------------------------------------------------
Private Sub Class_Terminate()
    On Error Resume Next
    Close fp
    Set mFSO = Nothing
End Sub
'--------------------------------------------------------------
'�@�g���[�X���O
'--------------------------------------------------------------
Public Sub LogTrace(Message As String, ParamArray p())
    ReportLog LogLevel.Trace, PlaceHolder(Message, p)
End Sub
'--------------------------------------------------------------
'�@��񃍃O
'--------------------------------------------------------------
Public Sub LogInfo(Message As String, ParamArray p())
    ReportLog LogLevel.Info, PlaceHolder(Message, p)
End Sub
'--------------------------------------------------------------
'�@���[�j���O���O
'--------------------------------------------------------------
Public Sub LogWarn(Message As String, ParamArray p())
    ReportLog LogLevel.Warn, PlaceHolder(Message, p)
End Sub
'--------------------------------------------------------------
'�@�G���[���O
'--------------------------------------------------------------
Public Sub LogFatal(Message As String, ParamArray p())

    Dim lngErr As Long
    Dim strDesc As String

    lngErr = Err.Number
    strDesc = Err.Description
    
    ReportLog LogLevel.Fatal, "Fatal Error (" & PlaceHolder(Message, p) & ")"
    Me.LogFlash
    
    Err.Number = lngErr
    Err.Description = strDesc
    
End Sub
'--------------------------------------------------------------
'�@�J�n���O
'--------------------------------------------------------------
Public Sub LogBegin(lvl As LogLevel, Message As String, ParamArray p())
    
    If colStack Is Nothing Then
        Set colStack = New Collection
    End If
    
    ReportLog lvl, "[" & colStack.Count + 1 & "]" & PlaceHolder(Message, p) & ",BEGIN"

    colStack.Add GetTickCount

End Sub
'--------------------------------------------------------------
'�@�I�����O
'--------------------------------------------------------------
Public Sub LogFinish(lvl As LogLevel, Message As String, ParamArray p())
    
    Dim t As LongPtr

    If colStack Is Nothing Then
        t = 0
    Else
        If colStack.Count = 0 Then
            t = 0
        Else
            t = colStack.Item(colStack.Count)
            colStack.Remove colStack.Count
        End If
    End If
    
    If t = 0 Then
        ReportLog lvl, PlaceHolder(Message, p) & ",FINISH,[?]ms"
    Else
        t = GetTickCount - t
        ReportLog lvl, "[" & colStack.Count + 1 & "]" & PlaceHolder(Message, p) & ",FINISH,[" & t & "]ms"
    End If
    Me.LogFlash
    
End Sub
'--------------------------------------------------------------
'�@���O�̃t���b�V��
'--------------------------------------------------------------
Public Sub LogFlash()
    Call OpenLog
End Sub
'--------------------------------------------------------------
'�@���O���x���̐ݒ�
'--------------------------------------------------------------
Public Property Let Level(ByVal l As LogLevel)
    mLevel = l
End Property
'���O�o��
Private Sub ReportLog(ByVal l As LogLevel, ByVal strMsg As String)

    Dim strLog As String
    Dim lngRetry As Long
    
    On Error GoTo e

    If l >= mLevel Then
        strLog = Title & "," & Format$(Now, "yyyy-mm-dd,hh:nn:ss") & "." & getMSec & "," & mLevelStr(l) & "," & strMsg
        If mLogType And LogType.DebugWindow Then
            Debug.Print strLog
        End If
        If mLogType And LogType.Logfile Then
            Print #fp, strLog
        End If
    End If
    
    Exit Sub
e:
    If Err.Number = 52 Then '�t�@�C�����܂��͔ԍ����s���ł��B
        Call OpenLog
        lngRetry = lngRetry + 1
        Sleep 500
        If lngRetry > 10 Then
            MsgBox "Logger Failed(" & Err.Description & ")", vbCritical
        Else
            Resume
        End If
    End If
End Sub
'���Ԃ̎擾(ms)
Private Function getMSec() As String

    Dim dblTimer As Double

    dblTimer = CDbl(Timer)
    getMSec = Format$((dblTimer - Fix(dblTimer)) * 1000, "000")

End Function
'���O�̃I�[�v��
Private Sub OpenLog()

    Dim strFile As String
    Dim strLogFolder As String
    Dim i As Long

    On Error Resume Next
    Close fp

    On Error GoTo e

    '���O�t�H���_�쐬
    strLogFolder = AppDataFolder

    Dim col As Collection
    Dim objFolder As Object
    Dim objFile As Object

    Set col = New Collection

    '���O�t�H���_�� Collection �ɒǉ�
    Set objFolder = mFSO.GetFolder(strLogFolder)
    For Each objFile In objFolder.files
    
        For i = 1 To col.Count
            If col(i) >= objFile.Name Then
                col.Add objFile.Name, , i
                GoTo pass
            End If
        Next
        col.Add objFile.Name
pass:
    Next

    Dim v As Variant

    '�t�H���_���̏����ɏ�������
    i = col.Count
    For Each v In col

        If i > mlngHistory Then
            Kill strLogFolder & "\" & v
        End If
        i = i - 1
    Next

    Set col = Nothing
    Set objFolder = Nothing

    strFile = mFSO.BuildPath(strLogFolder, Format(Now, "yyyymmdd") & ".log")
    Open strFile For Append As fp
    
    Exit Sub
e:
    Debug.Print "Logger File Open Error " & Err.Description
End Sub
'--------------------------------------------------------------
'�@�A�v���P�[�V�����t�H���_�擾
'--------------------------------------------------------------
Private Property Get AppDataFolder() As String

    On Error Resume Next
    
    Dim strFolder As String
    
    AppDataFolder = ""
    
    With mFSO
    
        strFolder = .BuildPath(CreateObject("Wscript.Shell").SpecialFolders("AppData"), Title & "\Log")
        
        If .FolderExists(strFolder) Then
        Else
            CreateFolder strFolder
        End If
        
        AppDataFolder = .BuildPath(strFolder, "\")
        
    End With

End Property
'--------------------------------------------------------------
'  �t�H���_�̍쐬�i�ċA�j
'--------------------------------------------------------------
Private Sub CreateFolder(ByVal strPath As String)

    With mFSO
    
        If .FolderExists(strPath) Then
            Exit Sub
        End If
    
        Call CreateFolder(.GetParentFolderName(strPath))
        
        .CreateFolder strPath
    
    End With

End Sub
'----------------------------------------------------------------------------------
'�v���[�X�z���_�ϊ�
'----------------------------------------------------------------------------------
Private Function PlaceHolder(ByVal strMsg As String, ByVal p As Variant) As String

    '�|��
    If Not mLang Is Nothing Then
        strMsg = mLang.Trunslate(strMsg)
    Else
        strMsg = Escape(strMsg)
    End If

    If UBound(p) >= 0 Then
        Dim i As Long
        For i = 0 To UBound(p)
            strMsg = Replace(strMsg, "{" & CStr(i) & "}", p(i))
        Next
    End If

    PlaceHolder = strMsg

End Function
'�A�v���P�[�V�������擾
Private Property Get Title() As String
    Title = ThisWorkbook.BuiltinDocumentProperties("Title").Value
End Property
'�@������̃G�X�P�[�v
Private Function Escape(ByVal v As String) As String

    v = Replace(v, "\\", "\")
    v = Replace(v, "\n", vbLf)
    v = Replace(v, "\r", vbCr)
    v = Replace(v, "\t", vbTab)
    
    Escape = v
    
End Function

