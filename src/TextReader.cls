VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TextReader"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
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
' �ˑ����W���[��
'   IReader.cls
'-----------------------------------------------------------------------------------------------------
' 2018-12-06 Ver.1.0.0 �V�K�쐬 �e�L�X�g�t�@�C���N���X
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements IConstructor
Implements IReader
Implements ICursor

Private fp As Integer
Private mOpen As Boolean

'�v���p�e�B�ێ�
Private mFileName As String
Private mNewLineCode As NewLineCodeConstants
Private mEncode As EncodeConstants

Private mBuf As Variant
Private mIndex As Long
'--------------------------------------------------------------
' �R���X�g���N�^
'--------------------------------------------------------------
Private Function IConstructor_Instancing(Args As Collection) As Object

    If Args.Count = 0 Then
        Exit Function
    End If
    
    'Default
    mNewLineCode = NewLineCodeConstants.CRLF
    mEncode = EncodeConstants.CP932
    
    If Args.Count >= 1 Then
        mFileName = Args(1)
    End If
    
    If Args.Count >= 2 Then
        mNewLineCode = Args(2)
    End If
    
    If Args.Count >= 3 Then
        mEncode = Args(3)
    End If
    
    
    Set IConstructor_Instancing = Me

    
    If Not FileIO.FileExists(mFileName) Then
        Message.Throw 1, Me, "IConstructor_Instancing", "�t�@�C��({0})�����݂��܂���B", mFileName
    End If

    '�e�L�X�g�t�@�C���̈ꊇ�ǂݍ���
    mBuf = BulkRead()
    If IsArray(mBuf) Then
        ICursor_MoveFirst
    End If

End Function
'--------------------------------------------------------------
' �e�L�X�g�t�@�C���̈ꊇ�ǂݍ���
'--------------------------------------------------------------
Private Function BulkRead() As Variant
    
    Dim buffer() As Byte
    Dim strBuf As String
    Dim lngSize As Long

    fp = FreeFile
    Open mFileName For Binary As fp
    mOpen = True
    
    lngSize = VBA.LOF(fp)
    
    If lngSize <> 0 Then

        ReDim buffer(0 To lngSize - 1)
    
        Get fp, , buffer()
        
        Select Case mEncode
            
            Case EncodeConstants.CP932
                
                strBuf = StrConv(buffer, vbUnicode)
            
            Case EncodeConstants.UTF8
            
                'BOM������ꍇ��菜��
                If StartWith(buffer, &HEF, &HBB, &HBF) Then
                    strBuf = Convert.FromUTF8(MidB$(buffer, 4))
                Else
                    strBuf = Convert.FromUTF8(buffer)
                End If
        
            Case EncodeConstants.UTF16LE
                
                'BOM������ꍇ��菜��
                If StartWith(buffer, &HFF, &HFE) Then
                    strBuf = MidB$(buffer, 3)
                Else
                    strBuf = buffer
                End If
        
        End Select
        
        Select Case mNewLineCode
            Case NewLineCodeConstants.CRLF
                
                BulkRead = Split(strBuf, vbCrLf)
            
            Case NewLineCodeConstants.LF
                
                BulkRead = Split(strBuf, vbLf)
        
            Case NewLineCodeConstants.None
                
                BulkRead = strBuf
        
        End Select

    Else
        BulkRead = Empty
    End If
    
    Close fp
    mOpen = False
        
End Function
'--------------------------------------------------------------
' BOM�`�F�b�N
'--------------------------------------------------------------
Private Function StartWith(bytBuf, ParamArray Args() As Variant) As Boolean

    Dim v As Variant
    Dim i As Long
    
    i = 0
    For Each v In Args
            
        If i > UBound(bytBuf) Then
            StartWith = False
            Exit Function
        End If
        
        If Not bytBuf(i) = v Then
            StartWith = False
            Exit Function
        End If
        i = i + 1
    Next

    StartWith = True

End Function
'--------------------------------------------------------------
' �ꊇ�ǂݍ��݃��\�b�h
'--------------------------------------------------------------
Private Function IReader_ReadAll() As Variant

    IReader_ReadAll = mBuf

End Function
Private Sub Class_Terminate()

    On Error Resume Next

    '�J���Ă���ꍇ�ɂ̓N���[�Y
    If mOpen Then
        Close fp
    End If

End Sub
'--------------------------------------------------------------
' ICursor �C���^�[�t�F�[�X���擾
'--------------------------------------------------------------
Public Property Get GetCursor() As ICursor
    Set GetCursor = Me
End Property
'------------------------------------------------------
' �I������
'------------------------------------------------------
Private Property Get ICursor_Eof() As Boolean
    If IsEmpty(mBuf) Then
        ICursor_Eof = True
    Else
        ICursor_Eof = UBound(mBuf) < mIndex
    End If
End Property
'------------------------------------------------------
' ���݂̍s�擾
'------------------------------------------------------
Private Property Get ICursor_Item(Optional ByVal opt As Variant) As Variant
    If ICursor_Eof Then
        ICursor_Item = mBuf(UBound(mBuf))
    Else
        ICursor_Item = mBuf(mIndex)
    End If
End Property
'------------------------------------------------------
' �O�̍s�擾
'------------------------------------------------------
Private Property Get ICursor_PreviousItem(Optional ByVal opt As Variant) As Variant
    If ICursor_Eof Then
        ICursor_PreviousItem = mBuf(UBound(mBuf))
    Else
        ICursor_PreviousItem = mBuf(mIndex - 1)
    End If
End Property
'------------------------------------------------------
' �ŏ��̍s�Ɉړ�
'------------------------------------------------------
Private Sub ICursor_MoveFirst()
    If IsEmpty(mBuf) Then
        mIndex = 0
    Else
        mIndex = LBound(mBuf)
    End If
End Sub
'------------------------------------------------------
' ���s�擾
'------------------------------------------------------
Private Sub ICursor_MoveNext()
    mIndex = mIndex + 1
End Sub
